-- cassandra.lua
return {
  {
    name = "2018-04-24-161700_init_resource_uuid_transformer",
    up =  [[
      CREATE TABLE IF NOT EXISTS resource_uuid_transformer(
        id uuid,
        resource_name text,
        transform_uuid uuid,
        created_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE INDEX IF NOT EXISTS ON resource_uuid_transformer(transform_uuid);

    ]],
    down = [[
      DROP TABLE resource_uuid_transformer;
    ]]
  }
}
