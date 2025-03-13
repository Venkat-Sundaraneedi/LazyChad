return {
  "epwalsh/obsidian.nvim",
  lazy = false,
  version = "*", -- recommended, use latest release instead of latest commit
  -- lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",

    -- { "echasnovski/mini.pick", version = false },
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
        completion = {
          nvim_cmp = true, -- Enable completion via nvim-cmp
        },
      },
      -- {
      -- 	name = "work",
      -- 	path = "~/vaults/work",
      -- },
    },

    notes_subdir = "notes",

    -- levels defined by "vim.log.levels.*".
    log_level = vim.log.levels.INFO,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "notes/dailies",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = false,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    new_notes_location = "notes_subdir",
    mappings = {},
  },
  keys = {
    -- Core functionality
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[N]ew Obsidian Note" },
    { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "[O]pen/Search Notes" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "[B]acklinks" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "[T]emplate Insert" },

    -- Navigation
    { "<leader>og", "<cmd>ObsidianFollowLink<cr>", desc = "Follow [G]oto Link" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "[D]aily Note (Today)" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "[Y]esterday's Note" },

    -- Links & Relationships
    { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "[L]ink to Note" },
    { "<leader>oL", "<cmd>ObsidianLinkNew<cr>", desc = "[L]ink & Create New" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "[R]ename Note & Links" },

    -- Advanced Features
    { "<leader>op", "<cmd>ObsidianPreview<cr>", desc = "[P]review Note" },
    { "<leader>oc", "<cmd>ObsidianCheck<cr>", desc = "[C]heck/Uncheck Box" },
    { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "[S]witch Recent Notes" },

    -- Workspace Management
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "[W]orkspace Management" },
    { "<leader>oW", "<cmd>ObsidianWorkspaceAdd<cr>", desc = "Add to [W]orkspace" },
  },
}
