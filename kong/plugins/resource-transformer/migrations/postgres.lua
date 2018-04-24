-- postgres.lua
return {
  {
    name = "2018-04-24-161700_init_resource_transformer",
    up = [[
      CREATE TABLE IF NOT EXISTS resource_transformer(
        id uuid,
        resource_name text UNIQUE,
        transform_uuid uuid,
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc'),
        PRIMARY KEY (id)
      );

      DO $$
      BEGIN
        IF (SELECT to_regclass('public.resource_transformer_uuid_idx')) IS NULL THEN
          CREATE INDEX resource_transformer_uuid_idx ON resource_transformer(transform_uuid);
        END IF;
      END$$;
    ]],
    down = [[
      DROP TABLE resource_transformer;
    ]]
  }
}