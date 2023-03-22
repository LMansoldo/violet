import Config

config :openai,
  api_key: "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", # find it at https://platform.openai.com/account/api-keys
  http_options: [recv_timeout: 30_000] # optional, passed to [HTTPoison.Request](https://hexdocs.pm/httpoison/HTTPoison.Request.html) options
