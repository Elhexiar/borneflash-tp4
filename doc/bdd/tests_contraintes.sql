-- Préparation : création d'un tarif valide utilisé par les tests suivants.
INSERT INTO tariff (name_tariff, price_tariff) VALUES('Standard', 10);


-- Test valide : une règle peut référencer le tarif créé.
INSERT INTO rule (day_of_week, id_tariff)
VALUES('1111100', (SELECT id_tariff
FROM tariff
WHERE name_tariff = 'Standard'));

-- Contrainte CHECK : day_of_week ne peut contenir que des 0 et des 1.
INSERT INTO rule (day_of_week, id_tariff)
SELECT 
'1125000', 
id_tariff FROM tariff WHERE name_tariff = 'Standard';
-- Erreur attendue : la nouvelle ligne de la relation « rule » viole la contrainte de vérification « rule_day_of_week_check ».
-- Sortie terminal observée :
-- ERREUR:  la nouvelle ligne de la relation « rule » viole la contrainte de vérification « rule_day_of_week_check »
-- DETAIL:  La ligne en échec contient (5, 1125000, null, null, null, null, null, 4).


-- Contrainte CHECK : day_of_week doit comporter exactement sept caractères.
INSERT INTO rule (day_of_week, id_tariff)
SELECT 
'11001',
id_tariff FROM tariff WHERE name_tariff = 'Standard';
-- Erreur attendue : la nouvelle ligne de la relation « rule » viole la contrainte de vérification « rule_day_of_week_check ».
-- Sortie terminal observée :
-- ERREUR:  la nouvelle ligne de la relation « rule » viole la contrainte de vérification « rule_day_of_week_check »
-- DETAIL:  La ligne en échec contient (6, 11001  , null, null, null, null, null, 4).


-- Contrainte CHECK : un tarif ne peut pas avoir un prix négatif.
INSERT INTO tariff (name_tariff, price_tariff) VALUES ('Tarif negatif', -1);
-- Erreur attendue : la nouvelle ligne de la relation « tariff » viole la contrainte de vérification « tariff_price_tariff_check ».
-- Sortie terminal observée :
-- ERREUR:  la nouvelle ligne de la relation « tariff » viole la contrainte de vérification « tariff_price_tariff_check »
-- DETAIL:  La ligne en échec contient (5, Tarif negatif, -1.00).


-- Contrainte UNIQUE : le nom d'un tarif ne peut exister qu'une seule fois.
INSERT INTO tariff (name_tariff, price_tariff) VALUES ('Standard', 12);
-- Erreur attendue : la valeur d'une clé dupliquée rompt la contrainte unique « tariff_name_tariff_key ».
-- Détail attendu : la clé « (name_tariff)=(Standard) » existe déjà.


-- Contrainte FOREIGN KEY : une règle doit référencer un tarif existant.
INSERT INTO rule (day_of_week, id_tariff) VALUES ('1111100', 999999);
-- Erreur attendue : l'insertion ou la mise à jour sur la table « rule » viole la contrainte de clé étrangère « rule_id_tariff_fkey ».


-- Contrainte CHECK : la puissance d'un point de charge ne peut pas être négative.
INSERT INTO charge_point (available_charge_point, power_charge_point, id_borne)
VALUES (TRUE, -22, (SELECT id_borne FROM borne LIMIT 1));
-- Erreur attendue : la nouvelle ligne de la relation « charge_point » viole la contrainte de vérification « charge_point_power_charge_point_check ».
-- Sortie terminal observée :
-- ERREUR:  la nouvelle ligne de la relation « charge_point » viole la contrainte de vérification « charge_point_power_charge_point_check »
-- DETAIL:  La ligne en échec contient (5, t, -22.0000, 1).


-- Contrainte NOT NULL : un rôle doit avoir un nom.
INSERT INTO role DEFAULT VALUES;
-- Erreur attendue : une valeur NULL viole la contrainte NOT NULL de la colonne « name_role » dans la relation « role ».


-- Contrainte CHECK multi-colonnes : le montant TTC ne peut pas être inférieur au montant HT.
INSERT INTO invoice (
	code_invoice, date_paid_invoice, amount_energie, tarrif_price_applied,
	tax_included_cost, tax_amount, tax_excluded_cost, is_paid_invoice,
	date_emited_invoice, id_company, id_user
)
VALUES (
	'INV-CONSTRAINT-TEST', NOW(), 10, 0.50,
	5, 1, 10, TRUE, NOW(),
	(SELECT id_company FROM company LIMIT 1),
	(SELECT id_user FROM user_ LIMIT 1)
);
-- Erreur attendue : la nouvelle ligne de la relation « invoice » viole la contrainte de vérification « invoice_check ».
-- Sortie terminal observée :
-- ERREUR:  la nouvelle ligne de la relation « invoice » viole la contrainte de vérification « invoice_check »
-- DETAIL:  La ligne en échec contient (3, INV-CONSTRAINT-TEST, 2026-09-24 13:06:47.110694+02, 10.0000, 0.50, 5.00, 1.00, 10.00, t, 2026-09-24 13:06:47.110694+02, 1, 1).