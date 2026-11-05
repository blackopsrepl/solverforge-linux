#!/usr/bin/python3
"""Exercise fail-closed policy and real logrotate on disposable logs, not containers."""
import importlib.machinery
import importlib.util
import json
import os
from pathlib import Path
import sqlite3
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

    def test_runner_active_recent_stale_and_quiet(self):
        with tempfile.TemporaryDirectory(prefix='runner-policy-', dir=os.environ['TMPDIR']) as tmp:
            path = Path(tmp) / 'forgejo.db'
            now = int(time.time())
            with sqlite3.connect(path) as db:
                db.executescript('CREATE TABLE action_runner (id INTEGER,name TEXT,deleted INTEGER,last_online INTEGER);'
                                 'CREATE TABLE action_task (id INTEGER,runner_id INTEGER,started INTEGER,stopped INTEGER,updated INTEGER);')
                db.execute('INSERT INTO action_runner VALUES (1,?,NULL,?)', ('rust-runner', now))
                db.execute('INSERT INTO action_task VALUES (10,1,?,0,?)', (now - 1800, now))
            self.assertFalse(maintenance.runner_idle(str(path), 'rust-runner', now)[0])
            with sqlite3.connect(path) as db:
                db.execute('UPDATE action_task SET stopped=?,updated=?', (now - 10, now - 10))
            self.assertFalse(maintenance.runner_idle(str(path), 'rust-runner', now)[0])
            with sqlite3.connect(path) as db:
                db.execute('UPDATE action_task SET stopped=?,updated=?', (now - 1000, now - 1000))
            self.assertTrue(maintenance.runner_idle(str(path), 'rust-runner', now)[0])
            with sqlite3.connect(path) as db:
                db.execute('UPDATE action_runner SET last_online=?', (now - 1000,))
            self.assertFalse(maintenance.runner_idle(str(path), 'rust-runner', now)[0])
            self.assertFalse(maintenance.runner_idle(None, 'rust-runner', now)[0])

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
