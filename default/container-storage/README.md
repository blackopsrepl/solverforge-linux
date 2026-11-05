# Removable SSD container storage (vigilance)

INTERZONE UUID: `5eefa1ea-548d-4a96-bef5-e0c2f78e964b`.

| Physical store on USB SSD | Podman path (bind mount, not symlink) |
| --- | --- |
| `/srv/lab/containers/system` | `/var/lib/containers/storage` |
| `/srv/lab/containers/user-pvd` | `/home/pvd/.local/share/containers/storage` |

Keep Podman's canonical paths: existing container databases, volume paths, service definitions and overlay metadata refer to them. Bind mounts relocate physical storage without unsupported database rewrites.

## Migration

Run from the framework checkout with INTERZONE mounted. A live preliminary `rsync -aHAXx --numeric-ids` to the two destinations reduces downtime but is not a consistent backup.

```sh
sudo bin/solverforge-container-storage-migrate pvd
```

The migration refuses active CI job containers, stops only container services, does a final sync and checksum verification, protects the empty NVMe mountpoints with the immutable flag, mounts the SSD copies, installs durable mount/service wiring and restarts the previously running container services. It preserves ownership, ACLs, extended attributes and hardlinks. Previously stopped unmanaged application containers remain stopped. Service-owned stacks may recreate their containers through their existing deployment entrypoints.

Original stores remain as `storage.nvme-before-usb` until service and volume verification is complete. Remove only those exact migration-owned originals after verification to reclaim NVMe space. An interrupted migration must be inspected before retrying: do not blindly overwrite either copy.

## Missing or disconnected USB disk

- Both INTERZONE mounts and container bind mounts use `nofail`; their absence must not make desktop boot depend on USB availability. Device discovery timeout is five seconds.
- Rootful services require the storage mount, bind their lifecycle to it and run a filesystem-UUID guard. Rootless service pre-start guards verify the same SSD-backed mount.
- The underlying empty NVMe mountpoints are immutable: Podman cannot silently create a replacement store when the disk is absent, including when invoked as root.
- Abrupt disconnection still interrupts container I/O. This is not hot-unplug protection for databases: stop container services before unplugging the SSD.
- Garbage collection skips unavailable stores instead of creating or pruning an NVMe fallback.

After reconnecting:

```sh
sudo /usr/local/libexec/solverforge-container-storage-online pvd
```

This mounts the stores, verifies their device identity and starts the configured Forgejo, mail, search, runner, Heimdall and Hoppscotch services. Independently managed containers can then be started by their own deployment entrypoints. No global desktop or Hermes gateway restart is needed.

To temporarily remove a bind mount for maintenance, stop its consumers first. The empty underlying directory must retain its immutable flag. Never remove that protection merely to make Podman work without the SSD.

## Verification

Use `findmnt -T <canonical-store> -o SOURCE,UUID,FSTYPE` to prove placement. `podman info` continues to show the canonical graphRoot; filesystem allocation must belong to INTERZONE. Compare volume names and pre-migration running-container names, then inspect their actual service health. Exercise an absent-store guard in a private mount namespace, never by unmounting the user's live SSD.
