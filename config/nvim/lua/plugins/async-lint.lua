return {
	"dense-analysis/ale",
	config = function()
		-- Configuration goes here.
		local g = vim.g

		g.ale_linters = {
			go = { "golangci-lint" },
         python = { },
		}
      g.ale_fixers = {
        go = { "gofumpt", "golines", "goimports" },
      }

      -- customize error
      g.ale_echo_msg_error_str = 'E'
      g.ale_echo_msg_warning_str = 'W'
      g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
	end,
}
