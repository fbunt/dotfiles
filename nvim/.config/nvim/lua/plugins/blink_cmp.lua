--# selene: allow(mixed_table)
return {
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        -- dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = "default",
                ["<S-CR>"] = { "select_and_accept" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                accept = { auto_brackets = { enabled = false } },
                menu = {
                    auto_show = true,
                    draw = {
                        components = {
                            source_name_brackets = {
                                text = function(ctx)
                                    return "[" .. ctx.source_name .. "]"
                                end,
                                highlight = "BlinkCmpSource", -- Use the standard highlight group
                            },
                        },
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 },
                            { "source_name_brackets" },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                list = {
                    selection = {
                        auto_insert = false,
                    },
                },
            },

            -- Default list of enabled providers defined so that you can extend
            -- it elsewhere in your config, without redefining it, due to
            -- `opts_extend`
            sources = {
                default = {
                    "lsp",
                    "path",
                    -- "snippets",
                    "buffer",
                },
                providers = {
                    lsp = {
                        name = "LSP",
                        enabled = true,
                        module = "blink.cmp.sources.lsp",
                        min_keyword_length = 2,
                        -- the higher the number, the higher the priority
                        score_offset = 90,
                        transform_items = function(_, items)
                            local CompletionItemKind =
                                require("blink.cmp.types").CompletionItemKind
                            local kind_idx =
                                require("blink.cmp.types").CompletionItemKind
                            local map = {
                                [kind_idx.Function] = true,
                                [kind_idx.Method] = true,
                                [kind_idx.Constructor] = true,
                            }
                            -- Transform the results for funcs, methods, ctors
                            -- to prevent completion from dropping in the
                            -- function's full signature as a snippet.
                            for _, item in ipairs(items) do
                                -- Check if the item is a Function, Method, or Constructor
                                if map[item.kind] then
                                    -- Force the insertion text to be just the label (the name)
                                    item.insertText = item.label
                                    -- Tell Blink this is now plain text, not a snippet
                                    item.insertTextFormat =
                                        vim.lsp.protocol.InsertTextFormat.PlainText
                                end
                            end

                            -- Drop snippets as well
                            return vim.tbl_filter(function(item)
                                return item.kind ~= CompletionItemKind.Snippet
                            end, items)
                        end,
                    },
                    path = {
                        -- Need to start paths with relative './' or '../' to
                        -- trigger this source
                        name = "Path",
                        module = "blink.cmp.sources.path",
                        score_offset = 30,
                        fallbacks = {},
                        min_keyword_length = 0,
                        opts = {
                            trailing_slash = false,
                            label_trailing_slash = true,
                            show_hidden_files_by_default = true,
                            get_cwd = function(_)
                                return vim.fn.getcwd()
                            end,
                        },
                    },
                    buffer = {
                        name = "Buffer",
                        enabled = true,
                        max_items = 3,
                        module = "blink.cmp.sources.buffer",
                        min_keyword_length = 2,
                        -- the higher the number, the higher the priority
                        score_offset = 15,
                    },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and
            -- significantly better performance You may use a lua
            -- implementation instead by using `implementation = "lua"` or
            -- fallback to the lua implementation, when the Rust fuzzy matcher
            -- is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
}
