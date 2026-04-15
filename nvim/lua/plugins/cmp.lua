local M = {}

local ui = require("utils.ui")
local pack = require("commands.pack")

function M.setup()
	pack.add({ "nvim-cmp", "cmp-nvim-lsp", "cmp-buffer", "cmp-path", "luasnip", "cmp_luasnip" })

	local cmp = require("cmp")
	local luasnip = require("luasnip")

	cmp.setup({
		window = {
			completion = {
				border = ui.border("CmpBorder"),
				winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
			},
			documentation = {
				border = ui.border("CmpDocBorder"),
			},
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			{
				name = "buffer",
				option = {
					keyword_length = 4,
					get_bufnrs = function()
						return { vim.api.nvim_get_current_buf() }
					end,
				},
			},
		}),
	})
end

return M
