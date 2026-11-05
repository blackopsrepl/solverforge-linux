# Container maintenance

This optional feature does not migrate storage, reserve disk, refuse builds,
stop/recreate containers, or restart services. Install it separately from the
main desktop installer after storage provisioning is complete.

## Install

Requirements: local Podman, Python 3, systemd, `findmnt`, and logrotate. Run as
the target desktop user for `--user`; use sudo for `--system`.

```sh
sudo env SOLVERFORGE_PATH="$PWD" bin/solverforge-container-maintenance-install \
  --system --storage-uuid YOUR_FILESYSTEM_UUID --forgejo-auth /path/to/existing/automation-login.json
SOLVERFORGE_PATH="$PWD" bin/solverforge-container-maintenance-install \
  --user --storage-uuid YOUR_FILESYSTEM_UUID
```

Use `--no-enable` while provisioning to install without starting timers. This
leaves preexisting timer enablement unchanged. Normal installation enables
`solverforge-container-gc.timer` (daily, randomized 04:30–05:15) and
`solverforge-container-logs.timer` (hourly, randomized 0–5 minutes), persistently,
in the selected system/user manager. Persistent timers can run immediately on
installation if a scheduled run was missed; finish storage provisioning first.

System configuration is `/etc/solverforge/container-maintenance.json`; user
configuration is `${XDG_CONFIG_HOME:-~/.config}/solverforge/container-maintenance.json`.
The installer preserves existing configuration and changes only explicitly
provided UUID/auth-path values; a first user install inherits the system configuration.
It installs executable copies under `/usr/local/libexec/` or `~/.local/libexec/`
and renders units from tracked templates. Run the installer again after source
updates. No compatibility symlinks are created.

## Removable-storage guard

`storage_uuid` is mandatory. **Before any Podman invocation**, both GC and log
rotation require an exact mountpoint at the canonical graphroot and its
filesystem UUID to match. A parent-mounted filesystem without a graphroot bind
mount is insufficient. Missing/mismatched storage cleanly skips without
initializing a container store. Every subsequent Podman subprocess rechecks the
mount. Default graphroots are `/var/lib/containers/storage` for root and
`~/.local/share/containers/storage` for a user. Override with
`rootful_graphroot` / `rootless_graphroot` only when that is the real Podman
configuration. This guard complements, not replaces, mount/service ordering and
protected empty backing directories: unplugging a filesystem mid-command is
not made safe by a preflight check.

## Retention and safety

- Podman: dangling images older than 7 days only. Tagged images are **never**
  automatically removed. All application containers, including stopped ones,
  volumes and networks are retained. Positively identified old external build
  containers are the sole container-removal exception.
- No `system prune`, `container prune`, `volume prune`, image-prune
  `--external`, or forced image deletion. `image prune -f` suppresses confirmation only; normal engine
  in-use checks remain. There is no tagged-image opt-in in this implementation.
- External build containers: require `podman ps -a --external` state `storage`,
  a matching 64-hex ID in containers/storage `containers.json`, and a matching
  `userdata/buildah.json` state marker with type `buildah 0.0.1` and the same
  `container-id`. Both the **storage creation timestamp** and **builder state
  modification time** must be at least 7 days old. No naming heuristic alone
  qualifies a container. Unknown external application storage is retained.
- Host `/proc` argv inspection skips GC on build/image transfer clients and
  BuildKit/Buildah processes. Candidate IDs referenced by live process cgroups
  are also retained. Restricted process visibility fails closed.
- Before *all* GC, the supported authenticated administrative endpoint
  `GET /api/v1/admin/runners/jobs` must prove no running jobs, assigned jobs, or
  waiting jobs for local runner labels. Empty-label, unassigned waiting jobs
  cannot execute on these local runners and do not block GC. The deployed API
  returns this whole active-job list without pagination; an unexpected schema
  or authorization error fails closed. There are **no Forgejo SQL queries**.
- `forgejo_auth` references an existing mode-0600 JSON credential store with
  `username` / `password`; credentials are read in process, never logged, copied,
  or minted. Basic authentication is allowed only over loopback HTTP or HTTPS,
  and redirects are rejected. Default `forgejo_url` is `http://127.0.0.1:3002`.
- Two idle API observations at least 15 minutes apart are required, recorded
  under the maintenance state directory. An observed active job resets the
  checkpoint. This does not assert continuous idleness between timer runs.
- Before every external-build removal, repeat API/process checks and reload
  external membership and storage age/identity metadata. Use the installed
  supported `podman rm --storage ID`, with **no force or volume flag**. This
  option is accepted by Podman 5.4.2 despite being absent from its help text;
  never infer unsupported behavior solely from missing help output.
- Each configured running DinD additionally requires no running nested Docker
  containers, only expected daemon processes, and no matching runner child
  processes. Conditions are rechecked before every prune. No API/runner error
  is interpreted as idleness.
- Idle DinD: native Docker build-cache retention **7 days**; dangling image
  retention **30 days**. All tagged images are retained, including old runner
  bases and toolchain images. Stopped nested containers and volumes remain.
- Activity checks are observational, not a scheduler lock. A job can arrive
  immediately afterward. Native Docker/Podman in-use protection remains the
  final guard, and no service or runner is paused. A site needing atomic
  scheduler exclusion must add a runner-coordinated maintenance lock before
  broadening retention; do not replace these checks with a blind timer prune.

## Logs

Existing `json-file` / `k8s-file` logs are discovered by inspecting every
registered container, including stopped ones. Only regular, non-symlink log
paths under the graphroot are accepted. A generated exact-path logrotate stanza
lives in `/var/lib/solverforge/container-maintenance/` (system) or
`$XDG_STATE_HOME/solverforge/container-maintenance/` (user, default
`~/.local/state`). This keeps working across bind-mounted storage moves and
container replacement without stale hardcoded IDs.

Hourly rotation uses `size 50M`, three rotations, 14-day archive age,
compression with one-cycle delay, and `copytruncate`. There is **no forced
rotation**. The writer's open inode survives without a restart; copytruncate
has a small unavoidable copy/truncate loss window. Limits are periodic, not a
hard instantaneous disk quota. The first archive of an already-huge log may
exceed 50MiB; a burst may exceed the threshold before the next hourly check.

`containers.conf.d/90-solverforge-log-limits.conf` sets `log_size_max=52428800`
for future file-log containers without changing the current default log driver
(journald). Existing container log settings are not retroactively changed.

System journald is shared by rootful/rootless containers. The system installer
sets 1GiB persistent / 256MiB runtime / 14-day retention / daily file turnover
for the next natural journald startup. The system log service also performs
live `journalctl --rotate --vacuum-size=1G --vacuum-time=14d` each hour: no
journald restart is needed for archived-journal retention. Vacuum affects
archived files only, not a hard cap on the currently active journal. There are
no KeepFree/reserved-space settings. User services do not vacuum shared journals.

## Verify and operate

```sh
python3 tests/container-maintenance.py
shellcheck bin/solverforge-container-maintenance-install
# Inspection only unless --apply is explicitly added:
/usr/local/libexec/solverforge-container-maintenance gc
/usr/local/libexec/solverforge-container-maintenance logs
systemctl list-timers 'solverforge-container-*'
systemctl --user list-timers 'solverforge-container-*'
journalctl -u solverforge-container-gc.service -u solverforge-container-logs.service
journalctl --user -u solverforge-container-gc.service -u solverforge-container-logs.service
```

The user CLI prefers its user configuration when installed, otherwise the
system configuration (the installed units always pass their explicit path).
Dry-run logs generate the stanza and
invoke real logrotate debug, but do not rotate. Tests perform real threshold
rotation on a disposable 51MiB log and verify an already-open writer survives;
they do not create, stop, or delete containers. No automatic GC should be
started while provisioning or migrating storage.
