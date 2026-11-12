# Sway layout investigation

## Resolve the implementation layer

- Search both upstream and maintained forks before claiming a feature has never been implemented. Read the actual map/insertion code, not only README marketing.
- Inspect `nwg-piotr/autotiling` when IPC-driven aspect-ratio splitting is authorized. Its handler queries a fresh tree; an event container is not a complete parent-linked tree.
- Inspect `CreitinGameplays/swayfx-enhanced` for a native dwindle precedent. Its `sway/tree/view.c` insertion path splits the target sibling by pending width/height and uses cursor position for before/after placement. Its `sway/commands/dwindle.c` exposes the native toggle. Recheck current source and license before reuse; this is fork code, not a plugin for stock Sway.
- Keep preserved split orientations distinct from dynamically recomputed orientations. Walking ancestors and reorienting them on focus does not implement preservation, even if the final tree looks like a spiral.
- Distinguish a built/tested binary from an installed and active compositor. A config reload cannot load changed compositor machine code into the running process. Explain activation requirements before proposing a binary change.

## Read the command semantics before probing

For Sway 1.10.1, verified from source and isolated execution:

- `split horizontal|vertical` acts on the targeted leaf and can wrap it; `splith`/`splitv` are standalone command aliases, not arguments to `split`.
- `layout splith|splitv` operates on the targeted container's **parent**, including when criteria specify `con_id`. Success does not prove the named container's own layout changed; read back the exact tree node.
- `default_orientation` accepts `horizontal|vertical|auto`, not `splith|splitv`.
- i3ipc event payload containers can have `parent=None`. Query `get_tree()` and resolve the relevant ID when ancestor relationships are needed.
- i3ipc can prefer inherited `I3SOCK` over `SWAYSOCK`. Pass `Connection(socket_path=...)` explicitly in isolated tests rather than relying on environment precedence.

## Isolate a compositor test

1. Create a mode-0700 runtime directory beneath the configured scratch root. Start headless Sway with a minimal dedicated config, no desktop includes/autostarts, and a supported renderer such as `pixman`.
2. Explicitly remove inherited `I3SOCK`/`SWAYSOCK` from the compositor environment. Discover the newly created socket only inside that runtime directory. Pass that exact socket to every IPC client and helper; set test clients' `WAYLAND_DISPLAY` to the private display.
3. Reject config errors before interpreting results. Use controlled client configs so close-confirmation dialogs and decorations do not masquerade as layout failures.
4. Test minimal contracts first: first window fills the workspace; next window halves the focused box on the required axis; new window takes the required side; unrelated siblings retain their geometry. Then cover retargeted focus, portrait outputs, close, resize, floating windows, and rapid arrival.
5. Read back IDs, rectangles, layouts, and focus from the private compositor. Keep immutable expected values captured before the action. Never resync a reference model from the candidate's result during assertion retries.
6. Terminate only the exact subprocesses this test created, using retained process handles. Never use broad `pkill -f` patterns that can match the invoking shell or another compositor. Clean up only the explicit private runtime root.

These are investigation mechanics, not authorization to build or deploy a custom compositor or a guarantee of full behavioral parity.
