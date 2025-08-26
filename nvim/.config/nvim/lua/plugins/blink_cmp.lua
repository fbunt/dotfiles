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
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd
                -- Font' Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = { auto_brackets = { enabled = false } },
                menu = {
                    -- Don't automatically show the completion menu
                    auto_show = true,

                    -- nvim-cmp style menu
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },
                list = {
                    selection = {
                        -- When `true`, inserts the completion item
                        -- automatically when selecting it You may want to bind
                        -- a key to the `cancel` command (default <C-e>) when
                        -- using this option, which will both undo the
                        -- selection and hide the completion menu
                        auto_insert = false,
                    },
                },
            },

            -- Default list of enabled providers defined so that you can extend
            -- it elsewhere in your config, without redefining it, due to
            -- `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = {
                        name = "lsp",
                        enabled = true,
                        module = "blink.cmp.sources.lsp",
                        min_keyword_length = 2,
                        -- the higher the number, the higher the priority
                        score_offset = 90,
                    },
                    path = {
                        name = "Path",
                        module = "blink.cmp.sources.path",
                        score_offset = 25,
                        -- Note from original author (linkarzu):
                        -- When typing a path, I would get snippets and text in
                        -- the suggestions, I want those to show only if there
                        -- are no path suggestions
                        fallbacks = { "snippets", "buffer" },
                        min_keyword_length = 2,
                        opts = {
                            trailing_slash = false,
                            label_trailing_slash = true,
                            get_cwd = function(context)
                                return vim.fn.expand(
                                    ("#%d:p:h"):format(context.bufnr)
                                )
                            end,
                            show_hidden_files_by_default = true,
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
