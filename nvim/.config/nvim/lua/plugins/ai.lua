return {
  {
    'olimorris/codecompanion.nvim',
    config = function()
      require('codecompanion').setup({
        strategies = {
          chat = {
            adapter = 'openai'
          }
        },
        extensions = {
          mcphub = {
            callback = 'mcphub.extensions.codecompanion',
            opts = {
              make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true,           -- Show tool results directly in chat buffer
              format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true,                     -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true,           -- Add MCP prompts as /slash commands
            }
          },
        },
        adapters = {
          granite = function()
            return require('codecompanion.adapters').extend('ollama', {
              name = 'granite3', -- Give this adapter a different name to differentiate it from the default ollama adapter
              schema = {
                model = {
                  default = 'granite3-dense:latest',
                }
              },
            })
          end,
          openai = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              env = {
                api_key = 'cmd:pass openai.com/token',
              }
            })
          end
        },
        opts = {
          -- Set debug logging
          log_level = 'DEBUG',
        }
      })
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/mcphub.nvim'
    }
  },
  {
    dir = '~/Documents/repos/ibm/wca.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim'
    },
    config = function()
      require 'wca'.setup({})
    end
  },
  {
    'rcampos2029/GPTModels.nvim',
    branch = 'gemini',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim'
    }

  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',              -- Required for Job and HTTP requests
    },
    build = 'npm install -g mcp-hub@3.3.0', -- Installs required mcp-hub npm module
    config = function()
      require('mcphub').setup({
        -- Required options
        port = 37373,                                            -- Port for MCP Hub server
        config = vim.fn.expand('~/.config/mcp/mcpservers.json'), -- Absolute path to config file
        extensions = {
          mcphub = {
            callback = 'mcphub.extensions.codecompanion',
            opts = {
              make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true,           -- Show tool results directly in chat buffer
              format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true,                     -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true,           -- Add MCP prompts as /slash commands
            },
          }
        },
        -- Optional options
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
        log = {
          level = vim.log.levels.TRACE,
          to_file = true,
          file_path = nil,
          prefix = 'MCPHub'
        },
      })
    end,
    keys = {
      { '<leader>mcp', '<cmd>MCPHub<cr>', desc = 'MCP Hub' }
    }
  }
}
