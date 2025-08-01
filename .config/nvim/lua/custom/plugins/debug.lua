return {
	'mfussenegger/nvim-dap',
	dependencies = {
		-- Creates a beautiful debugger UI
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',

		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		'jay-babu/mason-nvim-dap.nvim',

		-- Add your own debuggers here
		'leoluz/nvim-dap-go',
		'mfussenegger/nvim-dap-python',
	},
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'
		local dap_python = require 'dap-python'

		dap_python.setup '/Users/andres/repos/analytics/.venv/bin/python'

		require('mason-nvim-dap').setup {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				-- 'delve',
				'debugpy',
			},
		}

		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set('n', '<leader>dr', dap.continue, { desc = 'Debug: Start/Continue' })
		vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
		vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
		vim.keymap.set('n', '<leader>dt', dap.step_out, { desc = 'Debug: Step Out' })
		vim.keymap.set('n', '<leader>dc', dapui.close, { desc = 'Debug: Close UI' })
		vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
		vim.keymap.set('n', '<leader>dB', function()
			dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end, { desc = 'Debug: Set Breakpoint' })

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup {
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
			controls = {
				icons = {
					pause = '⏸',
					play = '▶',
					step_into = '⏎',
					step_over = '⏭',
					step_out = '⏮',
					step_back = 'b',
					run_last = '▶▶',
					terminate = '⏹',
					disconnect = '⏏',
				},
			},
		}

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set('n', '<leader>dp', dapui.toggle, { desc = 'Debug: See last session result.' })

		dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		dap.listeners.before.event_exited['dapui_config'] = dapui.close

		-- Install golang specific config
		-- require('dap-go').setup()
		-- require('dap-python').setup '/Users/andres/repos/analytics/.venv/bin/python'
	end,
}
