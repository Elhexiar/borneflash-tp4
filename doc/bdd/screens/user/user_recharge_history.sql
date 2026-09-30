-- SQL query to show the recharge history of a specific user

SELECT 
    personnal.first_name,
    personnal.last_name,
    recharge.price_recharge,
    recharge.recharge_quantity,
    recharge.date_recharge_end
FROM recharge
JOIN badge ON badge.id_badge = recharge.id_badge
JOIN user_ ON user_.id_user = badge.id_user
JOIN personnal ON personnal.id_user = user_.id_user
WHERE personnal.email_user = 'chloe@sample.test';