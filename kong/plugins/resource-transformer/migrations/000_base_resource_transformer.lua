-- 000_base_resource_transformer.lua
return {
  postgresql = {
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
    down = [[
      DROP TABLE resource_transformer;
    ]]
  },
}