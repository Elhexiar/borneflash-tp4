BEGIN;

-- Crée un compte utilisateur, ses données personnelles et son badge.
WITH john_user AS (
    INSERT INTO user_ (date_register_user, id_role)
    SELECT CURRENT_DATE, id_role
    FROM role
    WHERE name_role = 'Driver'
    RETURNING id_user
),
john_personnal AS (
    INSERT INTO personnal (
        first_name, last_name, password_user, email_user,
        postal_adress, invoice_adress, date_consent_tos, id_user
    )
    SELECT 'John', 'Doe', 'John_hash', 'john.doe@example.com',
                 '123 Main St', '456 Elm St', CURRENT_DATE, id_user
    FROM john_user
),
john_badge AS (
    INSERT INTO badge (badge_code, active, id_user)
    SELECT 'John_badge', TRUE, id_user
    FROM john_user
    RETURNING id_badge
)
SELECT id_badge
FROM john_badge;



-- Identifié un utilisateur

SELECT first_name, last_name
FROM personnal
WHERE email_user = 'john.doe@example.com';

-- Crée une nouvelle zone
-- Crée de nouveau point de recharge avec tags

WITH bretagne AS (
    INSERT INTO zone (name_zone)
    VALUES ('Bretagne')
    RETURNING id_zone
),
brest_kfc AS (
    INSERT INTO location (name_location, longitude, latitude, id_zone)
    SELECT 'Brest KFC', -4.469768, 48.416614, id_zone
    FROM bretagne
    RETURNING id_location
),
location_tag_brest_kfc AS (
    INSERT INTO location_tag (id_location, id_tag)
    SELECT brest_kfc.id_location, tag.id_tag
    FROM brest_kfc
    JOIN tag ON tag.tag_name = 'Restaurant'
),
borne_brest_kfc_0 AS (
    INSERT INTO borne (longitude, latitude, state ,id_location)
    SELECT -4.469768, 48.416614, 1, id_location
    FROM brest_kfc
    RETURNING id_borne
),
point_charge_brest_kfc_0 AS (
    INSERT INTO charge_point (available_charge_point, power_charge_point, id_borne)
    SELECT TRUE, 67, id_borne
    FROM borne_brest_kfc_0
    RETURNING id_charge_point
),
-- Fixer un nouveau prix a une borne sans que ses factures soit affécté
-- Appliquer des regles de tarification a une borne selont des criteres definis
standard_tariff AS (
    INSERT INTO tariff (price_tariff, name_tariff)
    VALUES (0.30, 'Standard Tariff')
    RETURNING id_tariff
),
weekend_rule AS (
    INSERT INTO rule (day_of_week, id_tariff)
    SELECT '0000011', id_tariff
    FROM standard_tariff
    RETURNING id_rule
),
weekend_rule_brest AS (
    INSERT INTO borne_rule (id_borne, id_rule)
    SELECT borne_brest_kfc_0.id_borne, weekend_rule.id_rule
    FROM borne_brest_kfc_0, weekend_rule
),
john_badge AS (
    SELECT id_badge
    FROM badge
    WHERE badge_code = 'John_badge'
),
started_recharge AS (
    INSERT INTO recharge (id_badge, id_charge_point, date_recharge_begin, recharge_state)
    SELECT john_badge.id_badge, point_charge_brest_kfc_0.id_charge_point, NOW(), 0
    FROM john_badge, point_charge_brest_kfc_0
    RETURNING id_recharge
)
SELECT id_recharge
FROM started_recharge;

-- Crée une recharge, puis la terminé et regarder son cout
-- Associer un vehicule a une recharge et retrouver l'information plus tard

-- end recharge

WITH active_recharge AS (
    SELECT recharge.id_recharge, tariff.price_tariff
    FROM recharge
    JOIN badge ON badge.id_badge = recharge.id_badge
    JOIN charge_point ON charge_point.id_charge_point = recharge.id_charge_point
    JOIN borne ON borne.id_borne = charge_point.id_borne
    JOIN location ON location.id_location = borne.id_location
    JOIN borne_rule ON borne_rule.id_borne = borne.id_borne
    JOIN rule ON rule.id_rule = borne_rule.id_rule
    JOIN tariff ON tariff.id_tariff = rule.id_tariff
    WHERE badge.badge_code = 'John_badge'
        AND location.name_location = 'Brest KFC'
        AND recharge.recharge_state = 0
    ORDER BY recharge.id_recharge DESC
    LIMIT 1
)

SELECT  recharge.id_recharge, 
        recharge.recharge_state,
        recharge.date_recharge_begin,
        recharge.price_recharge
FROM recharge 
JOIN active_recharge ON active_recharge.id_recharge = recharge.id_recharge
;

UPDATE recharge
SET date_recharge_end = NOW() + INTERVAL '1 HOUR',
        recharge_state = 1,
        recharge_quantity = 150,
        price_recharge = active_recharge.price_tariff * 150
FROM active_recharge
WHERE recharge.id_recharge = active_recharge.id_recharge;

-- Change le véhicule de John en créant une nouvelle association utilisateur-véhicule.
WITH john AS (
    SELECT id_user
    FROM personnal
    WHERE email_user = 'john.doe@example.com'
),
john_vehicle AS (
    INSERT INTO vehicule (model_vehicule, active)
    VALUES ('Nissan Leaf', TRUE)
    RETURNING id_vehicule
)
INSERT INTO user_vehicule (id_user, id_vehicule)
SELECT john.id_user, john_vehicle.id_vehicule
FROM john, john_vehicle;

-- Retrouve la facture de chaque recharge de John.
SELECT invoice.code_invoice, invoice.date_emited_invoice, invoice.tax_included_cost,
       recharge.id_recharge, recharge.recharge_quantity
FROM recharge
JOIN badge ON badge.id_badge = recharge.id_badge
LEFT JOIN invoice ON invoice.id_invoice = recharge.id_invoice
WHERE badge.badge_code = 'John_badge';

-- Retrouve les factures émises pendant le mois courant.
SELECT code_invoice, date_emited_invoice, tax_included_cost, is_paid_invoice
FROM invoice
WHERE date_emited_invoice >= date_trunc('month', CURRENT_DATE)
  AND date_emited_invoice < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month';

-- Retrouve les factures émises au cours des six derniers mois.
SELECT code_invoice, date_emited_invoice, tax_included_cost
FROM invoice
WHERE date_emited_invoice >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY date_emited_invoice DESC;

-- Ajoute le point de charge de Brest KFC aux favoris de John, puis l'affiche.
WITH john AS (
    SELECT id_user
    FROM personnal
    WHERE email_user = 'john.doe@example.com'
),
brest_point AS (
    SELECT charge_point.id_charge_point
    FROM charge_point
    JOIN borne ON borne.id_borne = charge_point.id_borne
    JOIN location ON location.id_location = borne.id_location
    WHERE location.name_location = 'Brest KFC'
    ORDER BY charge_point.id_charge_point
    LIMIT 1
),
new_favorite AS (
    INSERT INTO favorite (date_added, id_charge_point, id_user)
    SELECT NOW(), brest_point.id_charge_point, john.id_user
    FROM john, brest_point
    RETURNING id_favorite, id_charge_point
)
SELECT new_favorite.id_favorite, location.name_location, charge_point.power_charge_point
FROM new_favorite
JOIN charge_point ON charge_point.id_charge_point = new_favorite.id_charge_point
JOIN borne ON borne.id_borne = charge_point.id_borne
JOIN location ON location.id_location = borne.id_location;

-- Calcule l'énergie délivrée et le chiffre d'affaires de chaque point de charge.
SELECT charge_point.id_charge_point, location.name_location,
       COALESCE(SUM(recharge.recharge_quantity) FILTER (WHERE recharge.recharge_state = 1), 0) AS kwh_delivres,
       COALESCE(SUM(recharge.price_recharge) FILTER (WHERE recharge.recharge_state = 1), 0) AS montant_encaisse
FROM charge_point
JOIN borne ON borne.id_borne = charge_point.id_borne
JOIN location ON location.id_location = borne.id_location
LEFT JOIN recharge ON recharge.id_charge_point = charge_point.id_charge_point
GROUP BY charge_point.id_charge_point, location.name_location
ORDER BY location.name_location, charge_point.id_charge_point;

--  id_charge_point | name_location  | kwh_delivres | montant_encaisse                                                                                                      
-- -----------------+----------------+--------------+------------------
--                5 | Brest KFC      |     150.0000 |            45.00
--                1 | Lyon Part-Dieu |      30.0000 |            10.50
--                3 | Lyon Part-Dieu |            0 |                0
--                2 | Paris Centre   |      42.5000 |            19.12
--                4 | Paris Centre   |            0 |                0

-- Liste les bornes dont l'état est différent de 1 (borne active en bon état).
SELECT borne.id_borne, location.name_location, borne.state
FROM borne
JOIN location ON location.id_location = borne.id_location
WHERE borne.state <> 1;

-- Aucune 
--  id_borne | name_location | state                                                                                                                                        
-- ----------+---------------+-------
-- (0 rows)

-- Affiche les tâches affectées au technicien David et les sites concernés.
SELECT operation.id_operation, operation.start_from, operation.end_at,
       operation.initial_observation, location.name_location, borne.id_borne
FROM operation
JOIN personnal ON personnal.id_user = operation.id_user
JOIN borne ON borne.id_borne = operation.id_borne
JOIN location ON location.id_location = borne.id_location
WHERE personnal.email_user = 'david@sample.test'
ORDER BY operation.start_from DESC;

-- Produit le rapport de la dernière intervention réalisée.
SELECT operation.id_operation, operation.incident_discovery_date,
       operation.start_from, operation.end_at, operation.initial_observation,
       operation.operation_description, operation.end_state,
       location.name_location
FROM operation
JOIN borne ON borne.id_borne = operation.id_borne
JOIN location ON location.id_location = borne.id_location
ORDER BY operation.start_from DESC
LIMIT 1;

--  id_operation | incident_discovery_date |       start_from       |         end_at         |        initial_observation         |         operation_description          |end_state | name_location 
-- --------------+-------------------------+------------------------+------------------------+------------------------------------+----------------------------------------+-----------+---------------
--             1 | 2024-07-01 10:00:00+02  | 2024-07-01 11:00:00+02 | 2024-07-01 12:30:00+02 | Connector lock is slow to release. | Cleaned and tested the connector lock. |        1 | Paris Centre

-- Facture la dernière recharge terminée de John à Volt Services.
WITH recharge_to_invoice AS (
    SELECT recharge.id_recharge, recharge.recharge_quantity, recharge.price_recharge,
           john.id_user, company_info.id_company
    FROM recharge
    JOIN badge ON badge.id_badge = recharge.id_badge
    JOIN personnal AS john ON john.id_user = badge.id_user
    JOIN company_info ON company_info.name_company = 'Volt Services'
    WHERE john.email_user = 'john.doe@example.com'
      AND recharge.recharge_state = 1
      AND recharge.id_invoice IS NULL
    ORDER BY recharge.id_recharge DESC
    LIMIT 1
),
new_invoice AS (
    INSERT INTO invoice (
        code_invoice, date_paid_invoice, amount_energie, tarrif_price_applied,
        tax_included_cost, tax_amount, tax_excluded_cost, is_paid_invoice,
        date_emited_invoice, id_company, id_user
    )
    SELECT 'INV-RECHARGE-' || id_recharge, NOW(), recharge_quantity,
           price_recharge / NULLIF(recharge_quantity, 0),
           price_recharge * 1.20, price_recharge * 0.20, price_recharge, FALSE,
           NOW(), id_company, id_user
    FROM recharge_to_invoice
    RETURNING id_invoice
)
UPDATE recharge
SET id_invoice = (SELECT id_invoice FROM new_invoice)
WHERE id_recharge = (SELECT id_recharge FROM recharge_to_invoice);

-- Supprime uniquement les données personnelles de John ; l'utilisateur et ses données de facturation restent conservés.

SELECT id_personnal, first_name, last_name, email_user
FROM personnal
WHERE email_user = 'john.doe@example.com';

DELETE FROM personnal
WHERE email_user = 'john.doe@example.com';

COMMIT;