-- Adds a required name to locations already stored in the database.
ALTER TABLE location
ADD COLUMN IF NOT EXISTS name_location VARCHAR(255) NOT NULL DEFAULT 'Site sans nom';

UPDATE location
SET name_location = CASE
  WHEN latitude = 48.856614 AND longitude = 2.352222 THEN 'Paris Centre'
  WHEN latitude = 45.764043 AND longitude = 4.835659 THEN 'Lyon Part-Dieu'
  ELSE name_location
END;

ALTER TABLE location
ALTER COLUMN name_location DROP DEFAULT;