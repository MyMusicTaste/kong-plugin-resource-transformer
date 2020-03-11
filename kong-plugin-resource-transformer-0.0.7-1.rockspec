package = "kong-plugin-resource-transformer"
version = "0.0.7-1"
supported_platforms = {"linux", "macosx"}
source = {
   url = "git+ssh://github.com/MyMusicTaste/kong-plugin-resource-transformer",
   branch = "kong-1.5.0"
}
description = {
   summary = "> A kong plugin that will analyze the request path and transforms the ids.",
   detailed = "> A kong plugin that will analyze the request path and transforms the ids.",
   homepage = "https://github.com/MyMusicTaste/kong-plugin-resource-transformer",
   license = "MIT"
}
dependencies = {
  "lua >= 5.3"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.resource-transformer.access"] = "kong/plugins/resource-transformer/access.lua",
      ["kong.plugins.resource-transformer.api"] = "kong/plugins/resource-transformer/api.lua",
      ["kong.plugins.resource-transformer.daos"] = "kong/plugins/resource-transformer/daos.lua",
      ["kong.plugins.resource-transformer.handler"] = "kong/plugins/resource-transformer/handler.lua",
      ["kong.plugins.resource-transformer.hooks"] = "kong/plugins/resource-transformer/hooks.lua",
      ["kong.plugins.resource-transformer.migrations.cassandra"] = "kong/plugins/resource-transformer/migrations/cassandra.lua",
      ["kong.plugins.resource-transformer.migrations.postgres"] = "kong/plugins/resource-transformer/migrations/postgres.lua",
      ["kong.plugins.resource-transformer.schema"] = "kong/plugins/resource-transformer/schema.lua"
   },
   install = {
      bin = {}
   }
}
