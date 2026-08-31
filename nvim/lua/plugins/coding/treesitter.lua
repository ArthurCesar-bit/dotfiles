return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'master',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- Neovim 0.12 removed the `all = false` option from
    -- vim.treesitter.query.add_predicate/add_directive. nvim-treesitter's
    -- master branch still registers its handlers with it (see that plugin's
    -- lua/nvim-treesitter/query_predicates.lua) and indexes `match[id]` as a
    -- single node -- it now receives a list of nodes instead, so any query
    -- using those predicates blows up with "attempt to call method 'range'
    -- (a nil value)". Most visible via markdown injections, which is what
    -- blink.cmp's documentation window renders.
    --
    -- Re-wrap such handlers to collapse each capture's node list back to one
    -- node. Must run before the plugin loads, hence `init`. Remove this once
    -- nvim-treesitter is migrated to its `main` branch.
    init = function()
      local tsq = require 'vim.treesitter.query'
      for _, fn in ipairs { 'add_predicate', 'add_directive' } do
        local orig = tsq[fn]
        tsq[fn] = function(name, handler, opts)
          if type(opts) == 'table' and opts.all == false then
            local inner = handler
            handler = function(match, ...)
              local one = {}
              for k, v in pairs(match) do
                one[k] = type(v) == 'table' and v[#v] or v
              end
              return inner(one, ...)
            end
          end
          return orig(name, handler, opts)
        end
      end
    end,
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'astro',
        'bash',
        'c',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'editorconfig',
        'gitignore',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'html',
        'java',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'sql',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      -- Install only the parsers listed above; no surprise background installs.
      auto_install = false,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    config = function(_, opts)
      vim.filetype.add {
        pattern = {
          ['config'] = 'dosini', -- better syntax highlighting for config files
        },
      }

      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
