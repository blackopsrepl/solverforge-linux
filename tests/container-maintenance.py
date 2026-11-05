#!/usr/bin/python3
"""Exercise fail-closed policy and real logrotate on disposable logs, not containers."""
import importlib.machinery
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest

ROOT = Path(__file__).resolve().parents[1]
loader = importlib.machinery.SourceFileLoader('maintenance', str(ROOT / 'bin/solverforge-container-maintenance'))
spec = importlib.util.spec_from_loader(loader.name, loader)
assert spec is not None
maintenance = importlib.util.module_from_spec(spec)
loader.exec_module(maintenance)


class RetentionPolicy(unittest.TestCase):
    def test_missing_storage_never_invokes_podman(self):
        with tempfile.TemporaryDirectory(prefix='container-policy-', dir=os.environ['TMPDIR']) as tmp:
            config = Path(tmp) / 'config.json'
            config.write_text(json.dumps({'storage_uuid': '00000000-0000-0000-0000-000000000000',
                                          'rootful_graphroot': tmp, 'rootless_graphroot': tmp}))
            for action in ['gc', 'logs']:
                result = subprocess.run([str(ROOT / 'bin/solverforge-container-maintenance'),
                                         action, '--apply', '--config', str(config)],
                                        check=True, text=True, capture_output=True)
                self.assertIn('Podman was not invoked', result.stdout)
            self.assertEqual(sorted(p.name for p in Path(tmp).iterdir()), ['config.json'])

    def test_jobs_api_safety_policy(self):
        for job in [
            {'id': 1, 'status': 'running', 'task_id': 2, 'runs_on': ['rust']},
            {'id': 1, 'status': 'waiting', 'task_id': 2, 'runs_on': []},
            {'id': 1, 'status': 'waiting', 'task_id': 0, 'runs_on': ['cpp']},
        ]:
            self.assertTrue(maintenance.jobs_busy([job])[0])
        self.assertFalse(maintenance.jobs_busy([])[0])
        self.assertFalse(maintenance.jobs_busy([
            {'id': 1, 'status': 'waiting', 'task_id': 0, 'runs_on': []}])[0])
        with self.assertRaises(ValueError):
            maintenance.jobs_busy([{'status': 'success'}])

    def test_build_retention_requires_positive_marker_and_two_ages(self):
        now = int(time.time())
        cid = 'a' * 64
        external = {'Id': cid, 'State': 'storage'}
        created = maintenance.datetime.fromtimestamp(now - 8 * 86400, maintenance.timezone.utc).isoformat()
        metadata = {'id': cid, 'created': created}
        builder = {'type': 'buildah 0.0.1', 'container-id': cid}
        old = now - 8 * 86400
        self.assertTrue(maintenance.old_build_container(external, metadata, builder, old, now))
        self.assertFalse(maintenance.old_build_container(external, metadata, {}, old, now))
        self.assertFalse(maintenance.old_build_container(external, metadata, builder, now, now))
        self.assertFalse(maintenance.old_build_container(dict(external, State='exited'), metadata, builder, old, now))
        self.assertFalse(maintenance.old_build_container(external, metadata, dict(builder, **{'container-id': 'b' * 64}), old, now))
        recent = maintenance.datetime.fromtimestamp(now - 86400, maintenance.timezone.utc).isoformat()
        self.assertFalse(maintenance.old_build_container(external, dict(metadata, created=recent), builder, old, now))

    def test_real_logrotate_preserves_open_writer_inode(self):
        with tempfile.TemporaryDirectory(prefix='rotation-policy-', dir=os.environ['TMPDIR']) as tmp:
            tmp = Path(tmp)
            log = tmp / 'ctr.log'
            # Real sparse >50MiB disposable log; never force production rotation.
            with log.open('wb') as writer:
                writer.truncate(51 * 1024 * 1024)
            inode = log.stat().st_ino
            config = tmp / 'logrotate.conf'
            config.write_text(maintenance.rotation_config([str(log), str(log)]))
            command = ['/usr/sbin/logrotate', '--state', str(tmp / 'state'), str(config)]
            subprocess.run([command[0], '--debug', *command[1:]], check=True, capture_output=True)
            with log.open('ab') as writer:
                subprocess.run(command, check=True, capture_output=True)
                writer.write(b'writer survives rotation\n')
            self.assertEqual(log.stat().st_ino, inode)
            self.assertEqual(log.read_bytes(), b'writer survives rotation\n')
            self.assertEqual((tmp / 'ctr.log.1').stat().st_size, 51 * 1024 * 1024)
            for bad in ['x\ny', 'x"y', 'x\\y', 'x{y']:
                with self.assertRaises(ValueError):
                    maintenance.rotation_config([bad])


if __name__ == '__main__':
    unittest.main(verbosity=2)
