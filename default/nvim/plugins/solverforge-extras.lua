-- SolverForge — Curated LazyVim extras and editor enhancements
-- These supplement the lazyvim.json extras with editor-level improvements.
return {
  -- Harpoon for fast file bookmarking (also enabled via lazyvim.json extra)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
