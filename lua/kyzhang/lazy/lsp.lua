return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",

    {
      "supermaven-inc/supermaven-nvim",
      opts = {
        keymaps = {
          accept_suggestion = "<C-f>",
          clear_suggestion = "<C-x>",
          accept_word = "<C-w>",
        },
        ignore_filetypes = { "bigfile" },
      },
    },
    
    {
      "Saghen/blink.cmp",
      version = "*",
      dependencies = "rafamadriz/friendly-snippets",

      opts = {
        keymap = {
          preset = "default",

          ['<CR>'] = { 'accept', 'fallback' },
          ['<Tab>'] = { 'accept', 'fallback' },
        },

        completion = {
          ghost_text = { enabled = true },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
          menu = { border = "rounded" },
        },
      },
    },
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    require("fidget").setup({})
    require("mason").setup()

    require('mason-lspconfig').setup({
      ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "ruff",
        "neocmake",
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["clangd"] = function()
          require('lspconfig').clangd.setup({
            capabilities = capabilities,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "-j=4",
              "--completion-style=detailed",
              "--function-arg-placeholders",
            },
          })
        end,

        ["pyright"] = function()
          require('lspconfig').pyright.setup({
            capabilities = capabilities,
            settings = {
              pyright = { disableOrganizeImports = true },
              python = { analysis = { ignore = { '*' } } },
            },
          })
        end,

        ["ruff"] = function()
          require('lspconfig').ruff.setup({
            capabilities = capabilities,
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          })
        end,

        lua_ls = function()
          require('lspconfig').lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim', 'love' } },
                workspace = { library = { vim.env.VIMRUNTIME } }
              }
            }
          })
        end
      }
    })

    vim.lsp.inlay_hint.enable(true)
  end
}
