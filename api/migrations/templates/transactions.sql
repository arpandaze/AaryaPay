CREATE TABLE Transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_id UUID,
    receiver_id UUID,
    amount NUMERIC(15,2) NOT NULL,
    generation_time TIMESTAMP NOT NULL,
    received_time TIMESTAMP NOT NULL,
    verification_time TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (sender_id) REFERENCES Users(id) ON DELETE SET NULL,
    FOREIGN KEY (receiver_id) REFERENCES Users(id) ON DELETE SET NULL,
    CHECK (sender_id <> receiver_id)
);
