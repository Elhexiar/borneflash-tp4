

SELECT
    personnal.first_name,
    personnal.last_name,
    charge_point.available_charge_point,
    charge_point.power_charge_point,
    location.name_location,
    favorite.date_added

FROM favorite
JOIN personnal ON personnal.id_user = favorite.id_user
JOIN charge_point ON charge_point.id_charge_point = favorite.id_charge_point
JOIN borne ON borne.id_borne = charge_point.id_borne
JOIN location ON location.id_location = borne.id_location
WHERE personnal.email_user = 'chloe@sample.test'
