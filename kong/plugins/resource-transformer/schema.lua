-- schema.lua
local typedefs = require "kong.db.schema.typedefs"

return {
  name = "resource-transformer",
  fields = {
    { consumer = typedefs.no_consumer },
    { run_on = typedefs.run_on_first },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
    }, }, },
  },
}
