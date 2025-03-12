return {
  -- plenary , volt , menu
  {
    "NvChad/NvChad",
    "nvim-lua/plenary.nvim",
    "nvchad/volt",
    "nvchad/menu",
  },

  -- base46
  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  -- nvchad ui
  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require("nvchad")
    end,
  },

  -- minty
  { "nvchad/minty", cmd = { "Huefy", "Shades" } },

  --web-devicons
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   opts = function()
  --     dofile(vim.g.base46_cache .. "devicons")
  --     return { override = require("nvchad.icons.devicons") }
  --   end,
  -- },
  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "≤░èó", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "∩Æ╖", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "ε¡Æ", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
