[mgr]
cwd = { fg = "{{ accent }}", italic = true }

# Hovered
hovered         = { bg = "{{ color8 }}" }
preview_hovered = { bg = "{{ color8 }}" }

# Find
find_keyword  = { fg = "{{ background }}", bg = "{{ accent }}", bold = true }
find_position = { fg = "{{ color6 }}", bg = "{{ color0 }}", bold = true }

# Marker
marker_copied   = { fg = "{{ color2 }}", bg = "{{ color2 }}" }
marker_cut      = { fg = "{{ color1 }}", bg = "{{ color1 }}" }
marker_marked   = { fg = "{{ color5 }}", bg = "{{ color5 }}" }
marker_selected = { fg = "{{ accent }}", bg = "{{ accent }}" }

# Count
count_copied   = { fg = "{{ background }}", bg = "{{ color2 }}" }
count_cut      = { fg = "{{ background }}", bg = "{{ color1 }}" }
count_selected = { fg = "{{ background }}", bg = "{{ accent }}" }

# Border
border_symbol = "│"
border_style  = { fg = "{{ color8 }}" }

[tabs]
active   = { fg = "{{ background }}", bg = "{{ accent }}" }
inactive = { fg = "{{ accent }}", bg = "{{ color0 }}" }

[mode]
normal_main = { fg = "{{ background }}", bg = "{{ accent }}", bold = true }
normal_alt  = { fg = "{{ accent }}", bg = "{{ color0 }}" }

select_main = { fg = "{{ background }}", bg = "{{ color5 }}", bold = true }
select_alt  = { fg = "{{ color5 }}", bg = "{{ color0 }}" }

unset_main  = { fg = "{{ background }}", bg = "{{ color3 }}", bold = true }
unset_alt   = { fg = "{{ color3 }}", bg = "{{ color0 }}" }

[status]
overall   = { fg = "{{ foreground }}", bg = "{{ background }}" }
sep_left  = { open = "", close = "" }
sep_right = { open = "", close = "" }

# Progress
progress_label  = { fg = "{{ foreground }}", bold = true }
progress_normal = { fg = "{{ color4 }}", bg = "{{ color0 }}" }
progress_error  = { fg = "{{ color1 }}", bg = "{{ color0 }}" }

# Permissions
perm_type  = { fg = "{{ color4 }}" }
perm_read  = { fg = "{{ color3 }}" }
perm_write = { fg = "{{ color1 }}" }
perm_exec  = { fg = "{{ accent }}" }
perm_sep   = { fg = "{{ color8 }}" }

[pick]
border   = { fg = "{{ accent }}" }
active   = { fg = "{{ foreground }}", bg = "{{ color8 }}" }
inactive = { fg = "{{ foreground }}" }

[input]
border   = { fg = "{{ accent }}" }
title    = { fg = "{{ accent }}" }
value    = { fg = "{{ color6 }}" }
selected = { bg = "{{ color8 }}" }

[cmp]
border   = { fg = "{{ accent }}" }
active   = { fg = "{{ foreground }}", bg = "{{ color8 }}" }
inactive = { fg = "{{ foreground }}" }

icon_file    = ""
icon_folder  = ""
icon_command = ""

[tasks]
border  = { fg = "{{ accent }}" }
title   = { fg = "{{ accent }}" }
hovered = { fg = "{{ foreground }}", bg = "{{ color8 }}" }

[which]
cols            = 3
mask            = { bg = "{{ background }}" }
cand            = { fg = "{{ color6 }}" }
rest            = { fg = "{{ color4 }}" }
desc            = { fg = "{{ color5 }}" }
separator       = " ➜ "
separator_style = { fg = "{{ color8 }}" }

[confirm]
border  = { fg = "{{ accent }}" }
title   = { fg = "{{ accent }}" }
content = {}
list    = {}
btn_yes = { bg = "{{ color8 }}" }
btn_no  = {}
btn_labels = [ "  [Y]es  ", "  (N)o  " ]

[spot]
border  = { fg = "{{ accent }}" }
title   = { fg = "{{ accent }}" }

[notify]
title_info  = { fg = "{{ color6 }}" }
title_warn  = { fg = "{{ color3 }}" }
title_error = { fg = "{{ color1 }}" }

icon_error = ""
icon_warn = ""
icon_info = ""

[help]
on      = { fg = "{{ accent }}" }
run     = { fg = "{{ color5 }}" }
desc    = { fg = "{{ color6 }}" }
hovered = { bg = "{{ color8 }}" }
footer  = { fg = "{{ foreground }}", bg = "{{ background }}" }

[filetype]

rules = [
	# Images
	{ mime = "image/*", fg = "{{ color3 }}" },

	# Media
	{ mime = "{audio,video}/*", fg = "{{ color5 }}" },

	# Archives
	{ mime = "application/*zip", fg = "{{ color1 }}" },
	{ mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", fg = "{{ color1 }}" },

	# Documents
	{ mime = "application/{pdf,doc,rtf,vnd.*}", fg = "{{ color6 }}" },

	# Special files
	{ name = "*", is = "orphan", bg = "{{ color1 }}" },
	{ name = "*", is = "exec"  , fg = "{{ accent }}" },

	# Fallback
	{ name = "*/", fg = "{{ color7 }}" },
	{ name = "*", fg = "{{ foreground }}" }
]
