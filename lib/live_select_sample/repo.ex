defmodule LiveSelectSample.Repo do
  use Ecto.Repo,
    otp_app: :live_select_sample,
    adapter: Ecto.Adapters.Postgres
end
