CREATE TABLE tariff(
   id_tariff INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name_tariff VARCHAR(255) UNIQUE NOT NULL,
   price_tariff NUMERIC(15, 2) NOT NULL CHECK(price_tariff >= 0)
);

CREATE TABLE rule(
   id_rule INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   day_of_week CHAR(7) CHECK(day_of_week ~ '^[01]{7}$'),
   -- Binary representation of the days of the week (e.g., '1111100' for Monday to Friday)
   time_start TIME,
   time_end TIME,
   valid_from DATE,
   valid_to DATE,
   priority SMALLINT,
   id_tariff INT NOT NULL REFERENCES tariff(id_tariff) ON DELETE RESTRICT
    -- Ensure that a tariff cannot be deleted if it is referenced by a rule

);

CREATE TABLE company(
   id_company INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   date_created TIMESTAMPTZ NOT NULL,
   date_deleted TIMESTAMPTZ
);

CREATE TABLE zone(
   id_zone INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name_zone VARCHAR(255)
);

CREATE TABLE location(
   id_location INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name_location VARCHAR(255) NOT NULL,
   longitude DECIMAL(9,6) NOT NULL,
   latitude DECIMAL(9,6) NOT NULL,
   id_zone INT NOT NULL REFERENCES zone(id_zone) ON DELETE RESTRICT
    -- Ensure that a zone cannot be deleted if it is referenced by a location
    -- Zones must be empty before deletion
);

CREATE TABLE tag(
   id_tag INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   tag_name VARCHAR(50) UNIQUE NOT NULL,
   tag_icon VARCHAR(50)
);

CREATE TABLE role(
   id_role INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name_role VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE permission(
   id_permission INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   code_permission VARCHAR(255) UNIQUE NOT NULL,
   description VARCHAR(255) NOT NULL
);

CREATE TABLE company_info(
   id_company_info INTEGER GENERATED ALWAYS AS IDENTITY UNIQUE PRIMARY KEY,
   name_company VARCHAR(255) NOT NULL,
   accounting_email_company VARCHAR(255) NOT NULL,
   contact_email_company VARCHAR(255) NOT NULL,
   postal_adress VARCHAR(255) NOT NULL,
   invoice_adress VARCHAR(255) NOT NULL,
   id_company INT NOT NULL REFERENCES company(id_company) ON DELETE CASCADE
   -- Deleting a company will also delete its associated company_info
);

CREATE TABLE user_(
   id_user INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   date_register_user TIMESTAMPTZ NOT NULL,
   date_deleted_user TIMESTAMPTZ,
   id_role INT NOT NULL REFERENCES role(id_role) ON DELETE RESTRICT
   -- Ensure that a role cannot be deleted if it is referenced by a user
);

CREATE TABLE vehicule(
   id_vehicule INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   model_vehicule VARCHAR(50) NOT NULL,
   active BOOLEAN NOT NULL,
   id_company INT REFERENCES company(id_company) ON DELETE CASCADE
   -- Deleting a company will also delete its associated vehicules
);

CREATE TABLE invoice(
   id_invoice INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   code_invoice VARCHAR(50) NOT NULL,
   date_paid_invoice TIMESTAMPTZ NOT NULL,
   amount_energie DECIMAL(15,4) NOT NULL CHECK(amount_energie >= 0),
   tarrif_price_applied DECIMAL(15,2) NOT NULL CHECK(tarrif_price_applied >= 0),
   tax_included_cost NUMERIC(15, 2) NOT NULL CHECK(tax_included_cost >= 0),
   tax_amount NUMERIC(15, 2) NOT NULL CHECK(tax_amount >= 0),
   tax_excluded_cost NUMERIC(15, 2) NOT NULL CHECK(tax_excluded_cost >= 0),
   is_paid_invoice BOOLEAN NOT NULL,
   date_emited_invoice TIMESTAMPTZ NOT NULL,
   id_company INT DEFAULT 0 REFERENCES company(id_company)  ON DELETE SET DEFAULT,
   id_user INT NOT NULL DEFAULT 0 REFERENCES user_(id_user) ON DELETE SET DEFAULT,
   CHECK(tax_included_cost >= tax_excluded_cost)
   -- Deleting a company will set the id_company of its associated invoices to the default value (0)
   -- Deleting a user will set the id_user of its associated invoices to the default value (0)
);

CREATE TABLE personnal(
   id_personnal INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   first_name VARCHAR(255) NOT NULL,
   last_name VARCHAR(255) NOT NULL,
   password_user VARCHAR(255) NOT NULL,
   email_user VARCHAR(255) UNIQUE NOT NULL,
   postal_adress VARCHAR(255) NOT NULL,
   invoice_adress VARCHAR(255) NOT NULL,
   date_consent_tos TIMESTAMPTZ NOT NULL,
   id_user INT UNIQUE NOT NULL REFERENCES user_(id_user) ON DELETE CASCADE
   -- Deleting a user will also delete its associated personnal record
   -- Personnal data can still be deleted before deleting the associated user
);

CREATE TABLE borne(
   id_borne INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   latitude DECIMAL(9,6) NOT NULL,
   longitude DECIMAL(9,6) NOT NULL,
   state SMALLINT NOT NULL,
   id_location INT NOT NULL REFERENCES location(id_location) ON DELETE CASCADE
   -- Deleting a location will also delete its associated bornes
);

CREATE TABLE badge(
   id_badge INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   badge_code VARCHAR(14) NOT NULL,
   active BOOLEAN NOT NULL,
   id_user INT NOT NULL REFERENCES user_(id_user) ON DELETE CASCADE,
   id_company INT REFERENCES company(id_company) ON DELETE CASCADE
   -- Deleting a user will also delete its associated badges
   -- Deleting a company will also delete its associated badges
);

CREATE TABLE charge_point(
   id_charge_point INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   available_charge_point BOOLEAN NOT NULL,
   power_charge_point DECIMAL(10,4) NOT NULL CHECK(power_charge_point >= 0),
   id_borne INT NOT NULL REFERENCES borne(id_borne) ON DELETE CASCADE
   -- Deleting a borne will also delete its associated charge points
);

CREATE TABLE operation(
   id_operation INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   incident_discovery_date TIMESTAMPTZ NOT NULL,
   start_from TIMESTAMPTZ NOT NULL,
   end_at TIMESTAMPTZ,
   initial_observation VARCHAR(511) NOT NULL,
   operation_description VARCHAR(511),
   end_state SMALLINT,
   id_user INT NOT NULL DEFAULT 0 REFERENCES user_(id_user)  ON DELETE SET DEFAULT,
   id_borne INT NOT NULL DEFAULT 0 REFERENCES borne(id_borne) ON DELETE SET DEFAULT
    -- Deleting a user or borne will set the corresponding foreign key to its default value (0)
);

CREATE TABLE favorite(
   id_favorite INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   date_added TIMESTAMPTZ NOT NULL,
   id_charge_point INT NOT NULL REFERENCES charge_point(id_charge_point) ON DELETE CASCADE,
   id_user INT NOT NULL REFERENCES user_(id_user) ON DELETE CASCADE
   -- Deleting a charge point or user will also delete its associated favorites
);

CREATE TABLE recharge(
   id_recharge INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   id_badge INT REFERENCES badge(id_badge) ON DELETE SET NULL,
   id_charge_point INT REFERENCES charge_point(id_charge_point) ON DELETE SET NULL,
   recharge_quantity DECIMAL(10,4) CHECK(recharge_quantity >= 0),
   recharge_state SMALLINT NOT NULL,
   date_recharge_begin TIMESTAMPTZ NOT NULL,
   date_recharge_end TIMESTAMPTZ,
   price_recharge NUMERIC(15, 2) CHECK(price_recharge >= 0),
   id_vehicule INT REFERENCES vehicule(id_vehicule) ON DELETE SET NULL,
   id_invoice INT REFERENCES invoice(id_invoice) ON DELETE SET NULL
);

CREATE TABLE user_vehicule(
   id_user INT REFERENCES user_(id_user),
   id_vehicule INT REFERENCES vehicule(id_vehicule),
   PRIMARY KEY(id_user, id_vehicule)
);

CREATE TABLE user_company(
   id_user INT REFERENCES user_(id_user),
   id_company INT REFERENCES company(id_company),
   PRIMARY KEY(id_user, id_company)
);

CREATE TABLE rule_zone(
   id_rule INT REFERENCES rule(id_rule),
   id_zone INT REFERENCES zone(id_zone),
   PRIMARY KEY(id_rule, id_zone)
);

CREATE TABLE borne_rule(
   id_rule INT REFERENCES rule(id_rule),
   id_borne INT REFERENCES borne(id_borne),
   PRIMARY KEY(id_rule, id_borne)
);

CREATE TABLE location_tag(
   id_location INT REFERENCES location(id_location),
   id_tag INT REFERENCES tag(id_tag),
   PRIMARY KEY(id_location, id_tag)
);

CREATE TABLE role_permission(
   id_role INT REFERENCES role(id_role),
   id_permission INT REFERENCES permission(id_permission),
   PRIMARY KEY(id_role, id_permission)
);
