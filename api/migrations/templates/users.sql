CREATE TABLE Users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    dob DATE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    two_factor_auth VARCHAR(255),
    pubkey VARCHAR(32),
    pubkey_updated_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);
