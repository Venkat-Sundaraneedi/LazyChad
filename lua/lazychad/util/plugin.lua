local Plugin = require("lazy.core.plugin")

---@class lazychad.util.plugin
local M = {}

---@type string[]
M.core_imports = {}
M.handle_defaults = true

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {
  ["lazychad.plugins.extras.formatting.conform"] = "`conform.nvim` is now the default **LazyChad** formatter.",
  ["lazychad.plugins.extras.linting.nvim-lint"] = "`nvim-lint` is now the default **LazyChad** linter.",
  ["lazychad.plugins.extras.ui.dashboard"] = "`dashboard.nvim` is now the default **LazyChad** starter.",
  ["lazychad.plugins.extras.coding.native_snippets"] = "Native snippets are now the default for **Neovim >= 0.10**",
  ["lazychad.plugins.extras.ui.treesitter-rewrite"] = "Disabled `treesitter-rewrite` extra for now. Not ready yet.",
  ["lazychad.plugins.extras.coding.mini-ai"] = "`mini.ai` is now a core LazyChad plugin (again)",
  ["lazychad.plugins.extras.lazyrc"] = "local spec files are now a lazy.nvim feature",
  ["lazychad.plugins.extras.editor.trouble-v3"] = "Trouble v3 has been merged in main",
  ["lazychad.plugins.extras.lang.python-semshi"] = [[The python-semshi extra has been removed,
  because it's causing too many issues.
  Either use `basedpyright`, or copy the [old extra](https://github.com/LazyChad/LazyChad/blob/c1f5fcf9c7ed2659c9d5ac41b3bb8a93e0a3c6a0/lua/lazychad/plugins/extras/lang/python-semshi.lua#L1) to your own config.
  ]],
}

M.deprecated_modules = {}

---@type table<string, string>
M.renames = {
  ["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
  ["jose-elias-alvarez/null-ls.nvim"] = "nvimtools/none-ls.nvim",
  ["null-ls.nvim"] = "none-ls.nvim",
  ["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
  ["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
  ["markdown.nvim"] = "render-markdown.nvim",
}

function M.save_core()
  if vim.v.vim_did_enter == 1 then
    return
  end
  M.core_imports = vim.deepcopy(require("lazy.core.config").spec.modules)
end

function M.setup()
  M.fix_imports()
  M.fix_renames()
  M.lazy_file()
  table.insert(package.loaders, function(module)
    if M.deprecated_modules[module] then
      LazyChad.warn(
        ("`%s` is no longer included by default in **LazyChad**.\nPlease install the `%s` extra if you still want to use it."):format(
          module,
          M.deprecated_modules[module]
        ),
        { title = "LazyChad" }
      )
      return function() end
    end
  end)
end

function M.extra_idx(name)
  local Config = require("lazy.core.config")
  for i, extra in ipairs(Config.spec.modules) do
    if extra == "lazychad.plugins.extras." .. name then
      return i
    end
  end
end

function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.fix_imports()
  local defaults ---@type table<string, LazyChadDefault>
  Plugin.Spec.import = LazyChad.inject.args(Plugin.Spec.import, function(_, spec)
    if M.handle_defaults and LazyChad.config.json.loaded then
      -- extra disabled by defaults?
      defaults = defaults or LazyChad.config.get_defaults()
      local def = defaults[spec.import]
      if def and def.enabled == false then
        return false
      end
    end
    local dep = M.deprecated_extras[spec and spec.import]
    if dep then
      dep = dep .. "\n" .. "Please remove the extra from `lazychad.json` to hide this warning."
      LazyChad.warn(dep, { title = "LazyChad", once = true, stacktrace = true, stacklevel = 6 })
      return false
    end
  end)
end

function M.fix_renames()
  Plugin.Spec.add = LazyChad.inject.args(Plugin.Spec.add, function(self, plugin)
    if type(plugin) == "table" then
      if M.renames[plugin[1]] then
        LazyChad.warn(
          ("Plugin `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
            plugin[1],
            M.renames[plugin[1]],
            self.importing or "LazyChad"
          ),
          { title = "LazyChad" }
        )
        plugin[1] = M.renames[plugin[1]]
      end
    end
  end)
end

return M
