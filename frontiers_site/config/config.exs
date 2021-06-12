# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :frontiers_site, FrontiersSiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hyadzUBg0sqEXJcE6Bj0ZPjFXUGX9SAvwPbilsWMzFzhlClkuPvj0npiRXdVvK0k",
  render_errors: [view: FrontiersSiteWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FrontiersSite.PubSub,
  live_view: [signing_salt: "v+Y/jOqz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
