if ENV["ALGOLIA_APP_ID"]
  AlgoliaSearch.configuration = {
    application_id: ENV["ALGOLIA_APP_ID"],
    api_key: ENV["ALGOLIA_WRITE_API_KEY"],
    pagination_backend: :kaminari,
  }
end
