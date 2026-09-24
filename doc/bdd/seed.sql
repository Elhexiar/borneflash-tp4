-- Sample data for a database freshly created with schema.sql.
-- CTEs are temporary variables: each RETURNING makes a generated ID available below.
BEGIN;

WITH
-- Access control
admin_role AS (INSERT INTO role (name_role) VALUES ('Admin') RETURNING id_role),
driver_role AS (INSERT INTO role (name_role) VALUES ('Driver') RETURNING id_role),
accountant_role AS (INSERT INTO role (name_role) VALUES ('Accountant') RETURNING id_role),
technician_role AS (INSERT INTO role (name_role) VALUES ('Technician') RETURNING id_role),
operator_role AS (INSERT INTO role (name_role) VALUES ('Operator') RETURNING id_role),

view_invoices AS (INSERT INTO permission (code_permission, description) VALUES ('view_invoices', 'View invoices') RETURNING id_permission),
manage_bornes AS (INSERT INTO permission (code_permission, description) VALUES ('manage_bornes', 'Manage charging stations') RETURNING id_permission),
maintenance AS (INSERT INTO permission (code_permission, description) VALUES ('perform_maintenance', 'Perform maintenance operations') RETURNING id_permission),

admin_bornes AS (INSERT INTO role_permission SELECT admin_role.id_role, manage_bornes.id_permission FROM admin_role, manage_bornes),
driver_invoices AS (INSERT INTO role_permission SELECT driver_role.id_role, view_invoices.id_permission FROM driver_role, view_invoices),
accountant_invoices AS (INSERT INTO role_permission SELECT accountant_role.id_role, view_invoices.id_permission FROM accountant_role, view_invoices),
technician_maintenance AS (INSERT INTO role_permission SELECT technician_role.id_role, maintenance.id_permission FROM technician_role, maintenance),
operator_bornes AS (INSERT INTO role_permission SELECT operator_role.id_role, manage_bornes.id_permission FROM operator_role, manage_bornes),

-- Companies and users
volt_company AS (INSERT INTO company (date_created) VALUES ('2024-01-10 09:00:00+00') RETURNING id_company),
green_company AS (INSERT INTO company (date_created) VALUES ('2024-03-18 10:30:00+00') RETURNING id_company),

volt_info AS (
	INSERT INTO company_info (name_company, accounting_email_company, contact_email_company, postal_adress, invoice_adress, id_company)
	SELECT 'Volt Services', 'accounting@volt.test', 'contact@volt.test',
				 '12 rue de la Charge, 75012 Paris', '12 rue de la Charge, 75012 Paris', id_company
	FROM volt_company
),
green_info AS (
	INSERT INTO company_info (name_company, accounting_email_company, contact_email_company, postal_adress, invoice_adress, id_company)
	SELECT 'Green Fleet', 'billing@green.test', 'contact@green.test',
				 '8 avenue des Energies, 69007 Lyon', '8 avenue des Energies, 69007 Lyon', id_company
	FROM green_company
),

alice AS (INSERT INTO user_ (date_register_user, id_role) SELECT '2024-04-01 08:00:00+00', id_role FROM admin_role RETURNING id_user),
bruno AS (INSERT INTO user_ (date_register_user, id_role) SELECT '2024-04-02 08:00:00+00', id_role FROM driver_role RETURNING id_user),
chloe AS (INSERT INTO user_ (date_register_user, id_role) SELECT '2024-04-03 08:00:00+00', id_role FROM accountant_role RETURNING id_user),
david AS (INSERT INTO user_ (date_register_user, id_role) SELECT '2024-04-04 08:00:00+00', id_role FROM technician_role RETURNING id_user),
emma AS (INSERT INTO user_ (date_register_user, id_role) SELECT '2024-04-05 08:00:00+00', id_role FROM operator_role RETURNING id_user),

alice_info AS (INSERT INTO personnal (first_name,last_name,password_user,email_user,postal_adress,invoice_adress,date_consent_tos,id_user) SELECT 'Alice','Martin','hash_alice','alice@sample.test','1 rue Alpha, Paris','1 rue Alpha, Paris','2024-04-01 08:00:00+00',id_user FROM alice),
bruno_info AS (INSERT INTO personnal (first_name,last_name,password_user,email_user,postal_adress,invoice_adress,date_consent_tos,id_user) SELECT 'Bruno','Durand','hash_bruno','bruno@sample.test','2 rue Beta, Lyon','2 rue Beta, Lyon','2024-04-02 08:00:00+00',id_user FROM bruno),
chloe_info AS (INSERT INTO personnal (first_name,last_name,password_user,email_user,postal_adress,invoice_adress,date_consent_tos,id_user) SELECT 'Chloe','Bernard','hash_chloe','chloe@sample.test','3 rue Gamma, Bordeaux','3 rue Gamma, Bordeaux','2024-04-03 08:00:00+00',id_user FROM chloe),
david_info AS (INSERT INTO personnal (first_name,last_name,password_user,email_user,postal_adress,invoice_adress,date_consent_tos,id_user) SELECT 'David','Petit','hash_david','david@sample.test','4 rue Delta, Lille','4 rue Delta, Lille','2024-04-04 08:00:00+00',id_user FROM david),
emma_info AS (
	INSERT INTO personnal (first_name, last_name, password_user, email_user, postal_adress, invoice_adress, date_consent_tos, id_user)
	SELECT 'Emma', 'Robert', 'hash_emma', 'emma@sample.test',
				 '5 rue Epsilon, Nantes', '5 rue Epsilon, Nantes', '2024-04-05 08:00:00+00', id_user
	FROM emma
),

-- Locations and charging infrastructure
idf AS (INSERT INTO zone (name_zone) VALUES ('Ile-de-France') RETURNING id_zone),
ara AS (INSERT INTO zone (name_zone) VALUES ('Auvergne-Rhone-Alpes') RETURNING id_zone),
paris AS (INSERT INTO location (name_location,longitude,latitude,id_zone) SELECT 'Paris Centre',2.352222,48.856614,id_zone FROM idf RETURNING id_location),
lyon AS (INSERT INTO location (name_location,longitude,latitude,id_zone) SELECT 'Lyon Part-Dieu',4.835659,45.764043,id_zone FROM ara RETURNING id_location),

parking AS (INSERT INTO tag (tag_name,tag_icon) VALUES ('Parking couvert','warehouse') RETURNING id_tag),
restaurant AS (INSERT INTO tag (tag_name,tag_icon) VALUES ('Restaurant','utensils') RETURNING id_tag),

paris_tag AS (INSERT INTO location_tag SELECT paris.id_location,parking.id_tag FROM paris,parking),
lyon_tag AS (INSERT INTO location_tag SELECT lyon.id_location,restaurant.id_tag FROM lyon,restaurant),

paris_borne AS (INSERT INTO borne (latitude,longitude,state,id_location) SELECT 48.856700,2.352300,1,id_location FROM paris RETURNING id_borne),
lyon_borne AS (INSERT INTO borne (latitude,longitude,state,id_location) SELECT 45.764100,4.835700,1,id_location FROM lyon RETURNING id_borne),

paris_point_0 AS (INSERT INTO charge_point (available_charge_point,power_charge_point,id_borne) SELECT TRUE,22,id_borne FROM paris_borne RETURNING id_charge_point),
paris_point_1 AS (INSERT INTO charge_point (available_charge_point,power_charge_point,id_borne) SELECT TRUE,11,id_borne FROM paris_borne RETURNING id_charge_point),
lyon_point_0 AS (INSERT INTO charge_point (available_charge_point,power_charge_point,id_borne) SELECT TRUE,150,id_borne FROM lyon_borne RETURNING id_charge_point),
lyon_point_1 AS (INSERT INTO charge_point (available_charge_point,power_charge_point,id_borne) SELECT TRUE,11,id_borne FROM lyon_borne RETURNING id_charge_point),

-- Vehicles, badges, and ownership
megane AS (INSERT INTO vehicule (model_vehicule,active,id_company) SELECT 'Renault Megane E-Tech',TRUE,id_company FROM volt_company RETURNING id_vehicule),
peugeot AS (INSERT INTO vehicule (model_vehicule,active,id_company) SELECT 'Peugeot e-208',TRUE,id_company FROM green_company RETURNING id_vehicule),
tesla AS (INSERT INTO vehicule (model_vehicule,active) VALUES ('Tesla Model 3',TRUE) RETURNING id_vehicule),

alice_company AS (INSERT INTO user_company SELECT alice.id_user,volt_company.id_company FROM alice,volt_company),
bruno_company AS (INSERT INTO user_company SELECT bruno.id_user,volt_company.id_company FROM bruno,volt_company),
chloe_company AS (INSERT INTO user_company SELECT chloe.id_user,green_company.id_company FROM chloe,green_company),
emma_company AS (INSERT INTO user_company SELECT emma.id_user,green_company.id_company FROM emma,green_company),

bruno_vehicle AS (INSERT INTO user_vehicule SELECT bruno.id_user,megane.id_vehicule FROM bruno,megane),
chloe_vehicle AS (INSERT INTO user_vehicule SELECT chloe.id_user,peugeot.id_vehicule FROM chloe,peugeot),
emma_vehicle AS (INSERT INTO user_vehicule SELECT emma.id_user,tesla.id_vehicule FROM emma,tesla),

bruno_badge AS (INSERT INTO badge (badge_code,active,id_user,id_company) SELECT 'RFID-000000001',TRUE,bruno.id_user,volt_company.id_company FROM bruno,volt_company RETURNING id_badge),
chloe_badge AS (INSERT INTO badge (badge_code,active,id_user,id_company) SELECT 'RFID-000000002',TRUE,chloe.id_user,green_company.id_company FROM chloe,green_company RETURNING id_badge),

-- Tariffs and application rules
day_tariff AS (INSERT INTO tariff (name_tariff,price_tariff) VALUES ('Day rate',0.45) RETURNING id_tariff),
night_tariff AS (INSERT INTO tariff (name_tariff,price_tariff) VALUES ('Night rate',0.30) RETURNING id_tariff),
weekend_tariff AS (INSERT INTO tariff (name_tariff,price_tariff) VALUES ('Weekend rate',0.35) RETURNING id_tariff),

day_rule AS (INSERT INTO rule (day_of_week,time_start,time_end,priority,id_tariff) SELECT '1111100','07:00','22:00',1,id_tariff FROM day_tariff RETURNING id_rule),
night_rule AS (INSERT INTO rule (day_of_week,time_start,time_end,priority,id_tariff) SELECT '1111100','22:00','07:00',2,id_tariff FROM night_tariff RETURNING id_rule),
weekend_rule AS (INSERT INTO rule (day_of_week,priority,id_tariff) SELECT '0000011',1,id_tariff FROM weekend_tariff RETURNING id_rule),

day_zone AS (INSERT INTO rule_zone SELECT day_rule.id_rule,idf.id_zone FROM day_rule,idf),
weekend_zone AS (INSERT INTO rule_zone SELECT weekend_rule.id_rule,ara.id_zone FROM weekend_rule,ara),

night_borne AS (INSERT INTO borne_rule SELECT night_rule.id_rule,paris_borne.id_borne FROM night_rule,paris_borne),

-- Billing, recharges, and maintenance
volt_invoice AS (
	INSERT INTO invoice (code_invoice, date_paid_invoice, amount_energie, tarrif_price_applied,
											 tax_included_cost, tax_amount, tax_excluded_cost, is_paid_invoice,
											 date_emited_invoice, id_company, id_user)
	SELECT 'INV-2024-0001', '2024-06-05 10:00:00+00', 42.5, 0.45,
				 22.95, 3.83, 19.12, TRUE, '2024-06-05 09:00:00+00', volt_company.id_company, bruno.id_user
	FROM volt_company, bruno
	RETURNING id_invoice
),
green_invoice AS (
	INSERT INTO invoice (code_invoice, date_paid_invoice, amount_energie, tarrif_price_applied,
											 tax_included_cost, tax_amount, tax_excluded_cost, is_paid_invoice,
											 date_emited_invoice, id_company, id_user)
	SELECT 'INV-2024-0002', '2024-06-12 11:00:00+00', 30, 0.35,
				 12.60, 2.10, 10.50, TRUE, '2024-06-12 10:00:00+00', green_company.id_company, chloe.id_user
	FROM green_company, chloe
	RETURNING id_invoice
),

bruno_recharge AS (INSERT INTO recharge (id_badge,id_charge_point,recharge_quantity,recharge_state,date_recharge_begin,date_recharge_end,price_recharge,id_vehicule,id_invoice) SELECT bruno_badge.id_badge,paris_point_0.id_charge_point,42.5,1,'2024-06-05 07:30:00+00','2024-06-05 09:15:00+00',19.12,megane.id_vehicule,volt_invoice.id_invoice FROM bruno_badge,paris_point_0,megane,volt_invoice),
chloe_recharge AS (INSERT INTO recharge (id_badge,id_charge_point,recharge_quantity,recharge_state,date_recharge_begin,date_recharge_end,price_recharge,id_vehicule,id_invoice) SELECT chloe_badge.id_badge,lyon_point_0.id_charge_point,30,1,'2024-06-12 08:15:00+00','2024-06-12 08:35:00+00',10.50,peugeot.id_vehicule,green_invoice.id_invoice FROM chloe_badge,lyon_point_0,peugeot,green_invoice),

bruno_favorite AS (INSERT INTO favorite (date_added,id_charge_point,id_user) SELECT '2024-05-01 12:00:00+00',paris_point_0.id_charge_point,bruno.id_user FROM paris_point_0,bruno),
chloe_favorite AS (INSERT INTO favorite (date_added,id_charge_point,id_user) SELECT '2024-05-02 12:00:00+00',lyon_point_0.id_charge_point,chloe.id_user FROM lyon_point_0,chloe),

repair AS (INSERT INTO operation (incident_discovery_date,start_from,end_at,initial_observation,operation_description,end_state,id_user,id_borne) SELECT '2024-07-01 08:00:00+00','2024-07-01 09:00:00+00','2024-07-01 10:30:00+00','Connector lock is slow to release.','Cleaned and tested the connector lock.',1,david.id_user,paris_borne.id_borne FROM david,paris_borne)
SELECT 'Seed data created.' AS result;

COMMIT;