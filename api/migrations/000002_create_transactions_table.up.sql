CREATE TABLE Transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_id UUID NOT NULL,
    receiver_id UUID NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    generation_time TIMESTAMP NOT NULL,
    verification_time TIMESTAMP NOT NULL DEFAULT NOW(),
    signature VARCHAR(88) UNIQUE NOT NULL,
    sender_tvc VARCHAR(356),
    receiver_tvc VARCHAR(356),
    FOREIGN KEY (sender_id) REFERENCES Users(id) ON DELETE SET NULL,
    FOREIGN KEY (receiver_id) REFERENCES Users(id) ON DELETE SET NULL,
    CHECK (sender_id <> receiver_id)
);

