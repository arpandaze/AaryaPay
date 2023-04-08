CREATE TABLE Favorites(
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    favorite_owner UUID,
    favorite_account UUID,
    date_added TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (favorite_owner) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (favorite_account) REFERENCES Users(id) ON DELETE SET NULL
);
