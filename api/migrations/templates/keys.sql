CREATE TABLE keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    value TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    active BOOLEAN NOT NULL DEFAULT FALSE,
    associated_user UUID NOT NULL REFERENCES users(id),
    last_refreshed_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT active_key_per_user UNIQUE (associated_user, active)
);
