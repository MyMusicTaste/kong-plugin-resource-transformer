-- 000_base_resource_transformer.lua
return {
  postgres = {
    up = [[
      CREATE TABLE IF NOT EXISTS "resource_transformer" (
        "id"             UUID      PRIMARY KEY,
        "resource_name"  TEXT      UNIQUE,
        "transform_uuid" UUID,
        "created_at"     TIMESTAMP WITHOUT TIME ZONE
      );

      DO $$
      BEGIN
        CREATE INDEX IF NOT EXISTS "resource_transformer_uuid_idx"
                                ON "resource_transformer" ("transform_uuid");
      EXCEPTION WHEN UNDEFINED_COLUMN THEN
        -- Do nothing, accept existing state
      END$$;
    ]],
  },

  cassandra = {
    up =  [[
      CREATE TABLE IF NOT EXISTS "resource_uuid_transformer"(
        id uuid,
        resource_name text,
        transform_uuid uuid,
        created_at timestamp,
        PRIMARY KEY (id)
      );
      CREATE INDEX IF NOT EXISTS ON resource_uuid_transformer(transform_uuid);
    ]],
  },
}