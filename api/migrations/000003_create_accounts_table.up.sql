CREATE TABLE Accounts (
    id UUID PRIMARY KEY,
    balance NUMERIC(15,2) NOT NULL,
    last_requested TIMESTAMP,
    last_updated TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id) REFERENCES Users(id) ON DELETE CASCADE
);
