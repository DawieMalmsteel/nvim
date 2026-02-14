return {
  'leonardcser/cursortab.nvim',
  -- version = "*",  -- Use latest tagged version for more stability
  build = 'cd server && go build',
  config = function()
    require('cursortab').setup {
      provider = {
        type = 'fim', -- Provider: "inline", "fim", "sweep", "sweepapi", "zeta", "copilot", or "mercuryapi"
        url = 'http://localhost:8000', -- URL of the provider server
        api_key_env = '', -- Env var name for API key (e.g., "OPENAI_API_KEY")
        model = '', -- Model name
        temperature = 0.0, -- Sampling temperature
        max_tokens = 512, -- Max tokens to generate
        top_k = 50, -- Top-k sampling
        completion_timeout = 1000, -- Timeout in ms for completion requests
        max_diff_history_tokens = 512, -- Max tokens for diff history (0 = no limit)
        completion_path = '/v1/completions', -- API endpoint path
        fim_tokens = { -- FIM tokens (for FIM provider)
          prefix = '<|fim_prefix|>',
          suffix = '<|fim_suffix|>',
          middle = '<|fim_middle|>',
        },
        privacy_mode = true, -- Don't send telemetry to provider
      },
    }
  end,
}
