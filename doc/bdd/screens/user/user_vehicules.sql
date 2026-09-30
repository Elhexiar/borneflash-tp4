-- SQL query to show all the vehicles of a specific user

SELECT
    personnal.first_name,
    personnal.last_name,
    vehicule.model_vehicule,
    vehicule.active
FROM vehicule
JOIN user_vehicule ON user_vehicule.id_vehicule = vehicule.id_vehicule
JOIN user_ ON user_.id_user = user_vehicule.id_user
JOIN personnal ON personnal.id_user = user_.id_user
WHERE personnal.email_user = 'chloe@sample.test';