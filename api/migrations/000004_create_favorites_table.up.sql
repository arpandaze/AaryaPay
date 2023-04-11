CREATE TABLE Favorites(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    favorite_owner UUID NOT NULL,
    favorite_account UUID,
    date_added TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (favorite_owner) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (favorite_account) REFERENCES Users(id) ON DELETE SET NULL
);

CREATE INDEX idx_favorites_owner_id ON favorites (favorite_owner);
CREATE INDEX idx_favorites_account_id ON favorites (favorite_account);