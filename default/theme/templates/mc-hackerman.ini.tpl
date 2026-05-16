[skin]
    description = SolverForge Hackerman

[Lines]
    horiz = ─
    vert = │
    lefttop = ┌
    righttop = ┐
    leftbottom = └
    rightbottom = ┘
    topmiddle = ┬
    bottommiddle = ┴
    leftmiddle = ├
    rightmiddle = ┤
    cross = ┼
    dhoriz = ═
    dvert = ║
    dlefttop = ╔
    drighttop = ╗
    dleftbottom = ╚
    drightbottom = ╝
    dtopmiddle = ╤
    dbottommiddle = ╧
    dleftmiddle = ╟
    drightmiddle = ╢

[core]
    _default_ = {{ foreground }};{{ background }}
    selected = {{ background }};{{ accent }}
    marked = {{ color3 }};{{ background }}
    markselect = {{ background }};{{ color3 }}
    gauge = {{ background }};{{ accent }}
    input = {{ foreground }};{{ color0 }}
    inputunchanged = {{ color8 }};{{ color0 }}
    inputmark = {{ accent }};{{ color0 }}
    disabled = {{ color8 }};{{ background }}
    reverse = {{ background }};{{ foreground }}
    commandlinemark = {{ background }};{{ foreground }}
    header = {{ accent }};{{ background }}
    shadow = {{ color8 }};{{ background }}

[dialog]
    _default_ = {{ foreground }};{{ color0 }}
    dfocus = {{ background }};{{ accent }}
    dhotnormal = {{ accent }};
    dhotfocus = {{ background }};{{ accent }}
    dtitle = {{ accent }};

[error]
    _default_ = {{ foreground }};{{ color1 }}
    errdfocus = {{ background }};{{ foreground }}
    errdhotnormal = {{ color3 }};{{ color1 }}
    errdhotfocus = {{ color3 }};{{ foreground }}
    errdtitle = {{ foreground }};{{ color1 }}

[filehighlight]
    directory = {{ color7 }};
    executable = {{ accent }};
    symlink = {{ color6 }};
    hardlink =
    stalelink = {{ color1 }};
    device = {{ color5 }};
    special = {{ color4 }};
    core = {{ color1 }};
    temp = {{ color8 }};
    archive = {{ color3 }};
    doc = {{ color4 }};
    source = {{ color6 }};
    media = {{ color5 }};
    graph = {{ color6 }};
    database = {{ color4 }};

[menu]
    _default_ = {{ foreground }};{{ color0 }}
    menusel = {{ background }};{{ accent }}
    menuhot = {{ accent }};{{ color0 }}
    menuhotsel = {{ background }};{{ accent }}
    menuinactive = {{ color8 }};{{ background }}

[popupmenu]
    _default_ = {{ foreground }};{{ color0 }}
    menusel = {{ background }};{{ accent }}
    menutitle = {{ accent }};{{ color0 }}

[buttonbar]
    hotkey = {{ accent }};{{ background }}
    button = {{ foreground }};{{ color0 }}

[statusbar]
    _default_ = {{ background }};{{ accent }}

[help]
    _default_ = {{ foreground }};{{ color0 }}
    helpitalic = {{ color3 }};{{ color0 }}
    helpbold = {{ accent }};{{ color0 }}
    helplink = {{ background }};{{ accent }}
    helpslink = {{ background }};{{ color6 }}
    helptitle = {{ accent }};{{ color0 }}

[editor]
    _default_ = {{ foreground }};{{ background }}
    editbold = {{ accent }};{{ background }}
    editmarked = {{ background }};{{ foreground }}
    editwhitespace = {{ color8 }};{{ background }}
    editnonprintable = ;{{ background }}
    editlinestate = {{ foreground }};{{ color0 }}
    bookmark = {{ foreground }};{{ color1 }}
    bookmarkfound = {{ background }};{{ accent }}
    editrightmargin = {{ foreground }};{{ color0 }}
    editframe = {{ color8 }};
    editframeactive = {{ accent }};
    editframedrag = {{ foreground }};

[viewer]
    _default_ = {{ foreground }};{{ background }}
    viewbold = {{ accent }};{{ background }}
    viewunderline = {{ color3 }};{{ background }}
    viewselected = {{ background }};{{ accent }}

[diffviewer]
    added = {{ foreground }};{{ color2 }}
    changedline = {{ foreground }};{{ color4 }}
    changednew = {{ accent }};{{ color4 }}
    changed = {{ foreground }};{{ color4 }}
    removed = {{ foreground }};{{ color1 }}
    error = {{ color1 }};

[widget-panel]
    sort-up-char = ↑
    sort-down-char = ↓
    hiddenfiles-show-char = •
    hiddenfiles-hide-char = ○
    history-prev-item-char = ←
    history-next-item-char = →
    history-show-list-char = ↓
    filename-scroll-left-char = «
    filename-scroll-right-char = »

[widget-scrollbar]
    first-vert-char = ↑
    last-vert-char = ↓
    first-horiz-char = «
    last-horiz-char = »
    current-char = ■
    background-char = ▒

[widget-editor]
    window-state-char = ↕
    window-close-char = ×
