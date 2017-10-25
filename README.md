# Telepathy

Telepathy project is intended to show that you can easily get database events from PostgreSQL directly to custom Elixir gen_server.

You can see check out usage examples in the `testapp` folder.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `telepathy` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:telepathy, "~> 0.1.0"}]
    end
    ```

  2. Ensure `telepathy` is started before your application:

    ```elixir
    def application do
      [applications: [:telepathy]]
    end
    ```

