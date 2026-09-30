-- SQL query to show all the locations of a specific zone to the user
SELECT
    location.name_location,
    location.longitude,
    location.latitude,
    zone.name_zone
FROM location
JOIN zone ON zone.id_zone = location.id_zone
WHERE zone.name_zone = 'Ile-de-France';
