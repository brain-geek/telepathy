Code.require_file("spec/espec_phoenix_extend.ex")

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    alias SampleTelepathy.Repo

    # Cleanup
    Repo.delete_all SampleTelepathy.City

    {:shared, hello: :world}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
