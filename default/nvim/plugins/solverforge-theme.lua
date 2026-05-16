-- SolverForge — Hackerman colorscheme with transparent backgrounds
return {
  {
    "bjarneo/hackerman.nvim",
    dependencies = {
      {
        "bjarneo/aether.nvim",
        opts = {
          transparent = true,
          styles = {
            sidebars = "transparent",
            floats = "transparent",
          },
        },
      },
    },
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "hackerman",
    },
  },
}
