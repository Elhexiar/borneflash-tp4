# Dictionnaire de données — BorneFlash

## Utilisateur : `user_`

| Code               | Désignation                                                     | Type     | Taille | Contrainte                    | MCD | MLD |
| ------------------ | --------------------------------------------------------------- | -------- | ------ | ----------------------------- | --- | --- |
| id_user            | Identifiant utilisateur                                         | Alphanum | 255    | Obligatoire, Unique, Auto     | X   |     |
| date_register_user | Date d'inscription de l'utilisateur                             | Date     | ---    | Obligatoire, défaut : ce jour | X   |     |
| date_deleted_user  | Date de suppression de l'utilisateur (user supprimé si non nul) | Date     | ---    |                               | X   |     |
| id_role            | Référence du rôle de l'utilisateur (FK vers `Role`)             | Alphanum | 255    | Obligatoire                   | X   |     |

---

## Information Personnelles : `personnal`

| Code             | Désignation                                    |   Type   | Taille | Contrainte          | MCD | MLD |
| ---------------- | ---------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_personnal     | Identifiant information personnelles           | Alphanum |  255   | Obligatoire, Unique | X   |     |
| id_user          | Identifiant utilisateur (FK, relation 1-1)     | Alphanum |  255   | Obligatoire         | X   |     |
| first_name       | Prénom utilisateur                             | Alphanum |  255   | Obligatoire         | X   |     |
| last_name        | Nom de famille utilisateur                     | Alphanum |  255   | Obligatoire         | X   |     |
| password_user    | Mot de passe de l'utilisateur (haché)          | Alphanum |  255   | Obligatoire         | X   |     |
| email_user       | Email utilisateur, identifiant de connexion    | Alphanum |  255   | Obligatoire, Unique | X   | X   |
| postal_adress    | Adresse postale de l'utilisateur               | Alphanum |  255   |                     | X   |     |
| invoice_adress   | Adresse de facturation de l'utilisateur        | Alphanum |  255   |                     | X   |     |
| date_consent_tos | Date d'acceptation des CGU / consentement RGPD |   Date   |  ---   |                     | X   |     |

> Table séparée de `User` pour permettre la suppression réelle des données personnelles (RGPD/CNIL) sans casser l'intégrité des factures/recharges historiques rattachées à `id_user`.
> Le champ `date_consent_tos` permet de prouver l'acceptation des CGU et le consentement au traitement des données, conformément aux exigences de la CNIL.

---

## Information Entreprise : `company_info`

| Code                     | Désignation                                          |   Type   | Taille | Contrainte          | MCD | MLD |
| ------------------------ | ---------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_company_info          | Identifiant des informations d'entreprise            | Alphanum |  255   | Obligatoire, Unique | X   |     |
| id_company               | Identifiant de l'entreprise (FK, relation 1-1)       | Alphanum |  255   | Obligatoire         | X   |     |
| name_company             | Nom de l'entreprise                                  | Alphanum |  255   | Obligatoire, Unique | X   |     |
| accounting_email_company | Email comptable de l'entreprise (réception factures) | Alphanum |  255   |                     | X   |     |
| contact_email_company    | Email de contact de l'entreprise (incidents)         | Alphanum |  255   |                     | X   |     |
| postal_adress            | Adresse postale de l'entreprise                      | Alphanum |  255   |                     | X   |     |
| invoice_adress           | Adresse de facturation de l'entreprise               | Alphanum |  255   |                     | X   |     |

> Table séparée de `Company` pour les mêmes raisons que `Personnal` / `User` : permettre la suppression des données personnelles de l'entreprise sans casser l'intégrité des factures historiques.

---

## Rôle : `role`

| Code      | Désignation                                                         |   Type   | Taille | Contrainte          | MCD | MLD |
| --------- | ------------------------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_role   | Identifiant du rôle                                                 | Alphanum |  255   | Obligatoire, Unique |     |     |
| name_role | Nom du rôle (ex : "Conducteur", "Admin", "Comptable", "Technicien") | Alphanum |  255   | Obligatoire         |     |     |

---

## Permission : `permission`

| Code            | Désignation                                                 |   Type   | Taille | Contrainte          | MCD | MLD |
| --------------- | ----------------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_permission   | Identifiant de la permission                                | Alphanum |  255   | Obligatoire, Unique |     |     |
| code_permission | Code technique de la permission (utilisé par l'application) | Alphanum |  255   | Obligatoire, Unique |     |     |
| description     | Description lisible de ce que permet cette permission       | Alphanum |  255   |                     |     |     |

> Chaque rôle se voit attribuer un ensemble de permissions via l'association `Associer_un_role_a_des_permission`. L'application vérifie les droits d'un utilisateur en remontant `User → Role → Permission`, plutôt que de coder les règles d'accès en dur.

### Proposition de permissions

| code_permission      | description                                                           |
| -------------------- | --------------------------------------------------------------------- |
| view_borne_technical | Voir les données techniques des bornes (état, puissance, maintenance) |
| manage_borne         | Créer, modifier ou retirer une borne / un point de charge             |
| manage_tariff        | Créer ou modifier les tarifs et règles de tarification                |
| view_invoice         | Consulter les factures                                                |
| manage_invoice       | Marquer une facture comme payée, gérer la facturation                 |
| manage_maintenance   | Déclarer ou clôturer une opération de maintenance                     |
| manage_user_access   | Gérer les rôles et accès des collaborateurs                           |
| view_own_recharge    | Voir ses propres recharges et factures (usage conducteur)             |
| manage_own_vehicule  | Gérer ses propres véhicules et badges (usage conducteur)              |

### Proposition d'attribution par rôle

| Rôle       | Permissions associées                                                  |
| ---------- | ---------------------------------------------------------------------- |
| Conducteur | `view_own_recharge`, `manage_own_vehicule`                             |
| Comptable  | `view_invoice`, `manage_invoice`                                       |
| Technicien | `view_borne_technical`, `manage_maintenance`                           |
| Exploitant | `view_invoice`, `manage_invoice`, `manage_borne`, `manage_user_access` |
| Admin      | Toutes les permissions ci-dessus                                       |

> Ces attributions sont des **données** (lignes dans `Associer_un_role_a_des_permission`), pas du code — un nouvel accès collaborateur peut être créé sans modification du code applicatif.

---

## Entreprise : `company`

| Code         | Désignation              |   Type   | Taille | Contrainte          | MCD | MLD |
| ------------ | ------------------------ | :------: | :----: | ------------------- | --- | --- |
| id_company   | Identifiant d'entreprise | Alphanum |  255   | Obligatoire, Unique |     |     |
| date_created | Date de création         |   Date   |  ---   | Obligatoire         |     |     |
| date_deleted | Date de suppression      |   Date   |  ---   |                     |     |     |

> `date_deleted` permet la suppression logique (soft delete) de l'entreprise. Les informations personnelles sont dans `company_info`.

---

## Zone Géographique : `zone`

| Code      | Désignation                 |   Type   | Taille | Contrainte          | MCD | MLD |
| --------- | --------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_zone   | Identifiant de la zone      | Alphanum |  255   | Obligatoire, Unique |     |     |
| name_zone | Nom de la zone géographique | Alphanum |  255   | Obligatoire, Unique |     |     |

> Une zone peut être une région, un département, ou toute subdivision géographique. Le modèle peut évoluer vers une zone auto-référencée (`id_zone_parent`) pour gérer des hiérarchies.

---

## Site / Localisation : `location`

| Code        | Désignation                                                   |          Type           | Taille | Contrainte          | MCD | MLD |
| ----------- | ------------------------------------------------------------- | :---------------------: | :----: | ------------------- | --- | --- |
| id_location | Identifiant du site                                           |        Alphanum         |  255   | Obligatoire, Unique |     |     |
| latitude    | Latitude approximative du site (recherche / affichage carte)  | Numérique (Decimal 9,6) |  ---   | Obligatoire         |     |     |
| longitude   | Longitude approximative du site (recherche / affichage carte) | Numérique (Decimal 9,6) |  ---   | Obligatoire         |     |     |
| id_zone     | Référence de la zone géographique                             |        Alphanum         |  255   |                     |     |     |

> Représente un site (ex : parking) pouvant héberger une ou plusieurs bornes. Coordonnées volontairement moins précises que celles de `Borne` — utilisées pour la recherche/carte grand public (type Google Maps).

---

## Tag de site : `tag`

| Code     | Désignation                                                                                    |   Type   | Taille | Contrainte          | MCD | MLD |
| -------- | ---------------------------------------------------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_tag   | Identifiant du tag de service                                                                  | Alphanum |  255   | Obligatoire, Unique |     |     |
| tag_name | Nom du service/équipement disponible sur le site (ex : "Café", "Toilettes", "Parking couvert") | Alphanum |   50   | Obligatoire         |     |     |
| tag_icon | Icône représentant le tag (emoji ou nom d'icône)                                               | Alphanum |   50   |                     |     |     |

> Permet de décrire les services/équipements présents autour d'un site (`Location`), via l'association `Identifier_les_services_autours_d_un_site`.

---

## Borne : `borne`

| Code        | Désignation                                                                                                |          Type           | Taille | Contrainte          | MCD | MLD |
| ----------- | ---------------------------------------------------------------------------------------------------------- | :---------------------: | :----: | ------------------- | --- | --- |
| id_borne    | Identificateur borne                                                                                       |        Alphanum         |  255   | Obligatoire, Unique |     |     |
| id_location | Référence du site auquel appartient la borne                                                               |        Alphanum         |  255   | Obligatoire         |     |     |
| latitude    | Latitude précise de la borne                                                                               | Numérique (Decimal 9,6) |  ---   | Obligatoire         |     |     |
| longitude   | Longitude précise de la borne                                                                              | Numérique (Decimal 9,6) |  ---   | Obligatoire         |     |     |
| state       | État de la borne (ex : 0 -> Désactivée, 1 -> Active en bon état, 2 -> Active avec dysfonctionnement, etc.) |         Entier          |  ---   | Obligatoire         |     |     |

> Une borne peut posséder plusieurs points de charge (`Charge_Point`). Par décision client, si un seul point de charge dysfonctionne, la borne entière est marquée dysfonctionnelle via `state`, afin d'éviter toute ambiguïté pour l'utilisateur.

---

## Point de charge : `charge_point`

| Code                   | Désignation                                               |   Type    | Taille | Contrainte          | MCD | MLD |
| ---------------------- | --------------------------------------------------------- | :-------: | :----: | ------------------- | --- | --- |
| id_charge_point        | Identifiant du point de charge                            | Alphanum  |  255   | Obligatoire, Unique |     |     |
| id_borne               | Référence de la borne parente                             | Alphanum  |  255   | Obligatoire         |     |     |
| available_charge_point | Disponibilité immédiate du point de charge (occupé/libre) |  Booléen  |  ---   | Obligatoire         |     |     |
| power_charge_point     | Puissance en kW du point de charge                        | Numérique |   10   | Obligatoire         |     |     |

> `available_charge_point` reflète l'occupation en temps réel (charge en cours ou non), indépendamment de l'état de fonctionnement porté par `Borne.state`.

---

## Véhicule : `vehicule`

| Code           | Désignation                                             |   Type   | Taille | Contrainte          | MCD | MLD |
| -------------- | ------------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_vehicule    | Identifiant véhicule                                    | Alphanum |  255   | Obligatoire, Unique |     |     |
| id_company     | Identifiant optionnel d'entreprise (véhicule de flotte) | Alphanum |  255   |                     |     |     |
| model_vehicule | Modèle de véhicule                                      | Alphanum |  255   | Obligatoire         |     |     |
| active         | Le véhicule est-il actif/valide dans le système         | Booléen  |  ---   | Obligatoire         |     |     |

> Un véhicule peut avoir plusieurs utilisateurs, ex : véhicule partagé ; voir `Associer_un_vehicule_a_un_l_utilisateur`. Un véhicule peut être personnel (id_company NULL) ou appartenir à une flotte d'entreprise.

---

## Badge : `badge`

| Code       | Désignation                                                             |   Type   | Taille | Contrainte          | MCD | MLD |
| ---------- | ----------------------------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_badge   | Identifiant du badge                                                    | Alphanum |  255   | Obligatoire, Unique |     |     |
| id_user    | Identifiant de l'utilisateur détenteur du badge                         | Alphanum |  255   | Obligatoire         |     |     |
| id_company | Identifiant de l'entreprise ayant émis le badge (si badge d'entreprise) | Alphanum |  255   |                     |     |     |
| badge_code | Code physique du badge (ex : numéro RFID)                               | Alphanum |   14   | Obligatoire         |     |     |
| active     | Le badge est-il actif (permet la désactivation sans suppression)        | Booléen  |  ---   | Obligatoire         |     |     |

> Un badge personnel a `id_company` vide (facturé à l'utilisateur). Un badge d'entreprise a `id_company` rempli (facturé à l'entreprise). Un même badge n'appartient qu'à une seule entreprise à la fois.

---

## Recharge : `recharge`

| Code                | Désignation                                                      |   Type    | Taille | Contrainte          | MCD | MLD |
| ------------------- | ---------------------------------------------------------------- | :-------: | :----: | ------------------- | --- | --- |
| id_recharge         | Identifiant de recharge                                          | Alphanum  |  255   | Obligatoire, Unique |     |     |
| id_badge            | Identifiant du badge utilisé pour identifier l'utilisateur       | Alphanum  |  255   | Obligatoire         |     |     |
| id_charge_point     | Identifiant du point de charge utilisé                           | Alphanum  |  255   | Obligatoire         |     |     |
| id_vehicule         | Identifiant du véhicule concerné, si renseigné par l'utilisateur | Alphanum  |  255   |                     |     |     |
| id_invoice          | Identifiant de la facture associée, une fois émise               | Alphanum  |  255   |                     |     |     |
| recharge_quantity   | Quantité de kWh transférée lors de la recharge                   | Numérique |   10   | Obligatoire         |     |     |
| recharge_state      | État de la recharge (0 = EN_COURS, 1 = TERMINEE, etc.)           |  Entier   |  ---   | Obligatoire         |     |     |
| date_recharge_begin | Date de début de la recharge                                     |   Date    |  ---   | Obligatoire         |     |     |
| date_recharge_end   | Date de fin de la recharge (nulle tant qu'en cours)              |   Date    |  ---   |                     |     |     |
| price_recharge      | Prix de la recharge une fois terminée                            | Monétaire |  ---   | Obligatoire         |     |     |

> L'identité de l'utilisateur (et donc le payeur) se déduit via `id_badge → User [→ Company]`, il n'y a plus de FK directe vers `User`. `id_vehicule` est optionnel : rien n'oblige un utilisateur à enregistrer son véhicule. `id_invoice` est optionnel : une recharge existe avant d'être facturée.
> `recharge_state` remplace `finished_recharge` pour gérer plusieurs états (EN_COURS, TERMINEE, ANNULEE, ECHEC).

---

## Facture : `invoice`

| Code                 | Désignation                                               |   Type    | Taille | Contrainte                    | MCD | MLD |
| -------------------- | --------------------------------------------------------- | :-------: | :----: | ----------------------------- | --- | --- |
| id_invoice           | Identifiant facture                                       | Alphanum  |  255   | Obligatoire, Unique           |     |     |
| code_invoice         | Numéro de facture lisible (affiché au client)             | Alphanum  |   50   | Obligatoire                   |     |     |
| id_user              | Identifiant utilisateur ayant consommé                    | Alphanum  |  255   | Obligatoire                   |     |     |
| id_company           | Identifiant de l'entreprise, si non nul l'entreprise paye | Alphanum  |  255   |                               |     |     |
| amount_energie       | Montant de l'énergie délivrée                             | Numérique |   10   | Obligatoire                   |     |     |
| tarrif_price_applied | Prix du kWh appliqué au moment de la facturation          | Monétaire |  ---   | Obligatoire                   |     |     |
| tax_included_cost    | Montant TTC de la facture                                 | Monétaire |  ---   | Obligatoire                   |     |     |
| tax_amount           | Montant de la TVA                                         | Monétaire |  ---   | Obligatoire                   |     |     |
| tax_excluded_cost    | Montant HT de la facture                                  | Monétaire |  ---   | Obligatoire                   |     |     |
| is_paid_invoice      | La facture a-t-elle été réglée                            |  Booléen  |  ---   | Obligatoire, défaut = false   |     |     |
| date_emited_invoice  | Date d'émission de la facture                             |   Date    |  ---   | Obligatoire, défaut = ce jour |     |     |
| date_paid_invoice    | Date de paiement de la facture                            |   Date    |  ---   |                               |     |     |

> `id_user` identifie toujours qui a consommé ; `id_company` (optionnel) identifie qui paye lorsqu'il s'agit d'une facturation groupée à une entreprise. Une facture peut regrouper plusieurs recharges via `Recharge.id_invoice`.
> Les montants (`tarrif_price_applied`, `tax_*`) sont **figés** au moment de l'émission pour garantir la justesse des factures historiques.

---

## Tariff : `tariff`

| Code         | Désignation             | Type      | Taille | Contrainte          | MCD | MLD |
| ------------ | ----------------------- | --------- | :----: | ------------------- | --- | --- |
| id_tariff    | Identifiant tariff      | Alphanum  |  255   | Obligatoire, Unique |     |     |
| name_tariff  | Nom de ce type de tarif | Alphanum  |  255   | Obligatoire         |     |     |
| price_tariff | Prix au kWh appliqué    | Numérique |   10   | Obligatoire         |     |     |

---

## Règles de Tarifs : `rule`

| Code        | Désignation                                                                                    | Type               | Taille | Contrainte          | MCD | MLD |
| ----------- | ---------------------------------------------------------------------------------------------- | ------------------ | :----: | ------------------- | --- | --- |
| id_rule     | Identifiant de la règle de tarif                                                               | Alphanum           |  255   | Obligatoire, Unique |     |     |
| id_tariff   | Référence du tarif appliqué par la règle (FK vers `Tariff`)                                    | Alphanum           |  255   | Obligatoire         |     |     |
| day_of_week | Jour de la semaine récurrent, notation US (0 = Dimanche, 6 = Samedi). Nul = tous les jours     | Numérique - Entier |   1    |                     |     |     |
| time_start  | Heure de début d'application. Nul = pas de restriction horaire                                 | Date - Heure       |   8    |                     |     |     |
| time_end    | Heure de fin d'application. Nul = pas de restriction horaire                                   | Date - Heure       |   8    |                     |     |     |
| valid_from  | Date de début d'application. Nul = pas de restriction de date                                  | Date - Jour        |   8    |                     |     |     |
| valid_to    | Date de fin d'application. Nul = pas de restriction de date                                    | Date - Jour        |   8    |                     |     |     |
| priority    | Priorité de la règle en cas d'application simultanée de plusieurs règles (la plus haute gagne) | Numérique          |   3    |                     |     |     |

> Chaque règle référence exactement un `Tariff`. Les liens vers `Zone` et `Borne` se font via des associations dédiées (voir ci-dessous).

---

## Opération de Maintenance : `operation`

| Code                    | Désignation                                                                             | Type               | Taille | Contrainte  | MCD | MLD |
| ----------------------- | --------------------------------------------------------------------------------------- | ------------------ | :----: | ----------- | --- | --- |
| id_operation            | Identifiant de l'opération de maintenance                                               | Alphanum           |  255   | Obligatoire |     |     |
| id_borne                | Identifiant de la borne concernée                                                       | Alphanum           |  255   | Obligatoire |     |     |
| id_user                 | Identifiant de l'opérateur ayant effectué la maintenance                                | Alphanum           |  255   | Obligatoire |     |     |
| incident_discovery_date | Date de découverte de l'incident                                                        | Date               |  ---   |             |     |     |
| start_from              | Date et heure du début de l'opération de maintenance                                    | Date               |  ---   | Obligatoire |     |     |
| end_at                  | Date et heure de fin de l'opération, nulle si opération toujours en cours ou en attente | Date               |  ---   |             |     |     |
| initial_observation     | Observation initiale ayant mené à la demande de maintenance + éventuelle instruction    | Alphanum           |  511   | Obligatoire |     |     |
| operation_description   | Observation de l'opérateur une fois l'opération effectuée                               | Alphanum           |  511   | Obligatoire |     |     |
| end_state               | État de la borne à l'issue de l'opération                                               | Numérique - Entier |   1    |             |     |     |

> Rattachée au niveau `Borne` (et non `Charge_Point`) : par décision client, une panne d'un seul point de charge affecte la borne entière.
> `incident_discovery_date` permet de répondre au brief : "voir ce qui est en panne, depuis quand".

---

## Favoris : `favorite`

| Code            | Désignation                    |   Type   | Taille | Contrainte  | MCD | MLD |
| --------------- | ------------------------------ | :------: | :----: | ----------- | --- | --- |
| id_favorite     | Identifiant favori             | Alphanum |  255   | Obligatoire |     |     |
| id_user         | Identifiant utilisateur        | Alphanum |  255   | Obligatoire |     |     |
| id_charge_point | Identifiant du point de charge | Alphanum |  255   | Obligatoire |     |     |
| date_added      | Date d'ajout                   |   Date   |  ---   | Obligatoire |     |     |

---

## Associations (relations N,N ou porteuses d'attributs)

### `user_vehicule` (Associer_un_vehicule_a_un_utilisateur)

| Code        | Désignation             | Type     | Taille | Contrainte  |
| ----------- | ----------------------- | -------- | :----: | ----------- |
| id_user     | Identifiant utilisateur | Alphanum |  255   | Obligatoire |
| id_vehicule | Identifiant véhicule    | Alphanum |  255   | Obligatoire |

> Un véhicule peut être associé à plusieurs utilisateurs (ex : véhicule partagé), et un utilisateur à plusieurs véhicules.

### `user_company` (Associer_un_utilisateur_a_une_Entreprise)

| Code       | Désignation             | Type     | Taille | Contrainte  |
| ---------- | ----------------------- | -------- | :----: | ----------- |
| id_user    | Identifiant utilisateur | Alphanum |  255   | Obligatoire |
| id_company | Identifiant entreprise  | Alphanum |  255   | Obligatoire |

> Un utilisateur peut appartenir à plusieurs entreprises (intérim, temps partiel), une entreprise à plusieurs utilisateurs.

### `role_permission` (Associer_un_role_a_des_permission)

| Code          | Désignation                  | Type     | Taille | Contrainte  |
| ------------- | ---------------------------- | -------- | :----: | ----------- |
| id_role       | Identifiant du rôle          | Alphanum |  255   | Obligatoire |
| id_permission | Identifiant de la permission | Alphanum |  255   | Obligatoire |

> Relie un rôle à l'ensemble des permissions qui lui sont accordées.

### `rule_zone` (Appliquer_une_regle_celon_une_zone)

| Code    | Désignation       | Type     | Taille | Contrainte  |
| ------- | ----------------- | -------- | :----: | ----------- |
| id_rule | Identifiant règle | Alphanum |  255   | Obligatoire |
| id_zone | Identifiant zone  | Alphanum |  255   | Obligatoire |

> Une règle de tarif appliquée à l'échelle d'une zone géographique.

### `borne_rule` (Associer_des_regles_a_une_borne_spécifique)

| Code     | Désignation       | Type     | Taille | Contrainte  |
| -------- | ----------------- | -------- | :----: | ----------- |
| id_rule  | Identifiant règle | Alphanum |  255   | Obligatoire |
| id_borne | Identifiant borne | Alphanum |  255   | Obligatoire |

> Une règle de tarif appliquée à une borne spécifique (surcharge sur une règle de zone si priorité supérieure).

### `location_tag` (Identifier_les_services_autours_d_un_site)

| Code        | Désignation                   | Type     | Taille | Contrainte  |
| ----------- | ----------------------------- | -------- | :----: | ----------- |
| id_location | Identifiant du site           | Alphanum |  255   | Obligatoire |
| id_tag      | Identifiant du tag de service | Alphanum |  255   | Obligatoire |

> Décrit les services/équipements disponibles autour d'un site (ex : café, toilettes, parking couvert).

---

## Notes et règles métier non modélisables en MCD/MLD

- **Facture** : au moins un des deux champs `id_user`/`id_company` doit être cohérent avec le badge utilisé lors de la/les recharge(s) associées ; à valider par contrainte applicative ou trigger.
- **Badge d'entreprise** : l'entreprise du badge (`Badge.id_company`) devrait correspondre à une entreprise pour laquelle l'utilisateur travaille actuellement (`user_company`).
- **Suppression de compte (RGPD/CNIL)** : suppression réelle via `DELETE` sur `Personnal` uniquement ; `User` est conservé pour préserver l'intégrité des factures/recharges historiques (obligation de conservation comptable).
- **Système de permissions (RBAC)** : les vérifications d'accès se font via `User → Role → role_permission → Permission`, en base de données. Une même permission peut être partagée par plusieurs rôles ; un administrateur peut créer un nouveau rôle et lui attribuer un sous-ensemble de permissions sans modification du code applicatif.
- **Historisation des prix** : les prix appliqués sont figés dans `recharge` (`price_recharge`) et `invoice` (`tarrif_price_applied`). Si le prix du kWh change, les anciennes factures restent justes.

---

---

# Justification des cardinalités — MCD BorneFlash

Pour chaque association du MCD, deux phrases justifient la cardinalité de chaque côté de la relation.

---

## Zone ↔ Location

- **Zone (0,N)** : une zone peut contenir zéro (nouvelle zone sans site encore créé) ou plusieurs sites de recharge.
- **Location (1,1)** : chaque site est rattaché à exactement une zone géographique, indispensable pour appliquer la tarification par zone.

## Company ↔ Company_info

- **Company (0,1)** : une entreprise peut ne plus avoir d'informations descriptives si elles ont été supprimées (ex : fin de contrat, RGPD), tout en gardant son identité technique pour préserver les factures passées.
- **Company_info (1,1)** : une fiche d'informations d'entreprise doit obligatoirement être rattachée à une entreprise existante, elle n'a aucun sens seule.

## Role ↔ User

- **Role (0,N)** : un rôle peut être attribué à zéro (rôle créé mais pas encore utilisé) ou plusieurs utilisateurs.
- **User (1,1)** : chaque utilisateur doit avoir exactement un rôle, nécessaire pour déterminer ses permissions d'accès dès sa création.

## Company ↔ Vehicule

- **Company (0,N)** : une entreprise peut posséder zéro ou plusieurs véhicules de flotte.
- **Vehicule (0,1)** : un véhicule peut appartenir à zéro entreprise (véhicule personnel) ou une seule (véhicule de flotte), jamais plusieurs à la fois.

## Company ↔ Invoice

- **Company (0,N)** : une entreprise peut avoir zéro ou plusieurs factures mises à sa charge.
- **Invoice (0,1)** : une facture peut être payée par zéro entreprise (particulier) ou une seule, jamais partagée entre plusieurs sociétés.

## User ↔ Invoice

- **User (0,N)** : un utilisateur peut avoir zéro (nouveau compte sans consommation) ou plusieurs factures liées à sa consommation.
- **Invoice (1,1)** : chaque facture doit obligatoirement identifier l'utilisateur ayant consommé, même si c'est l'entreprise qui règle.

## User ↔ Personnal

- **User (0,1)** : un utilisateur peut ne plus avoir de données personnelles si elles ont été supprimées à sa demande (conformité CNIL), sans perdre son historique de facturation.
- **Personnal (1,1)** : une fiche d'informations personnelles n'existe que rattachée à un utilisateur précis, elle ne peut exister seule.

## Location ↔ Borne

- **Location (0,N)** : un site peut héberger zéro (site prévu mais pas encore équipé) ou plusieurs bornes physiques.
- **Borne (1,1)** : chaque borne est implantée sur exactement un site, nécessaire pour la localiser sur la carte.

## User ↔ Badge

- **User (0,N)** : un utilisateur peut posséder zéro (compte non encore équipé) ou plusieurs badges (personnel + professionnel).
- **Badge (1,1)** : chaque badge est détenu par exactement un utilisateur, pour identifier qui recharge à la borne.

## Company ↔ Badge

- **Company (0,N)** : une entreprise peut émettre zéro ou plusieurs badges à distribuer à ses salariés.
- **Badge (0,1)** : un badge peut être personnel (zéro entreprise) ou émis par une seule entreprise, jamais partagé entre plusieurs sociétés.

## Borne ↔ Charge_Point

- **Borne (1,N)** : une borne physique possède obligatoirement au moins un point de charge, sinon elle ne sert à rien.
- **Charge_Point (1,1)** : chaque point de charge appartient à exactement une borne, jamais partagé entre plusieurs installations.

## User ↔ Operation

- **User (0,N)** : un technicien peut avoir effectué zéro (nouveau technicien) ou plusieurs opérations de maintenance.
- **Operation (1,1)** : chaque opération est obligatoirement rattachée à l'opérateur qui l'a réalisée, pour la traçabilité exigée par le client.

## Borne ↔ Operation

- **Borne (0,N)** : une borne peut n'avoir jamais eu de panne (zéro opération) ou en avoir connu plusieurs au fil du temps.
- **Operation (1,1)** : chaque opération de maintenance concerne exactement une borne précise, jamais plusieurs à la fois.

## Charge_Point ↔ Favorite

- **Charge_Point (0,N)** : un point de charge peut n'être le favori de personne (zéro) ou être mis en favori par plusieurs utilisateurs.
- **Favorite (1,1)** : chaque entrée de favori désigne exactement un point de charge précis, celui que l'utilisateur veut retrouver facilement.

## User ↔ Favorite

- **User (0,N)** : un utilisateur peut n'avoir aucun favori (zéro) ou en enregistrer plusieurs.
- **Favorite (1,1)** : chaque favori appartient à exactement un utilisateur, pour ne pas mélanger les préférences entre comptes.

## Badge ↔ Recharge

- **Badge (0,N)** : un badge peut n'avoir jamais servi (zéro recharge, badge tout juste créé) ou avoir été utilisé pour plusieurs recharges.
- **Recharge (1,1)** : chaque recharge doit obligatoirement être identifiée par le badge utilisé, pour déterminer qui doit payer.

## Charge_Point ↔ Recharge

- **Charge_Point (0,N)** : un point de charge peut n'avoir jamais servi (zéro) ou avoir hébergé plusieurs sessions de recharge au fil du temps.
- **Recharge (1,1)** : chaque recharge a physiquement lieu sur exactement un point de charge précis.

## Vehicule ↔ Recharge

- **Vehicule (0,N)** : un véhicule enregistré peut n'avoir jamais rechargé chez BorneFlash (zéro) ou avoir été rechargé plusieurs fois.
- **Recharge (0,1)** : une recharge peut ne référencer aucun véhicule si l'utilisateur ne l'a pas enregistré, ou un seul véhicule précis.

## Invoice ↔ Recharge

- **Invoice (1,N)** : une facture doit obligatoirement regrouper au moins une recharge, sinon elle n'a rien à facturer.
- **Recharge (0,1)** : une recharge peut ne pas encore être facturée (créée avant l'émission de la facture) ou être rattachée à une seule facture.

## User ↔ Vehicule (via `user_vehicule`)

- **User (0,N)** : un utilisateur peut posséder ou avoir accès à zéro (aucun véhicule enregistré) ou plusieurs véhicules.
- **Vehicule (0,N)** : un véhicule peut être utilisé par zéro (pas encore associé) ou plusieurs utilisateurs, pour permettre le partage d'un même véhicule.

## User ↔ Company (via `user_company`)

- **User (0,N)** : un utilisateur peut ne travailler pour aucune entreprise (particulier) ou pour plusieurs (intérim, temps partiel).
- **Company (0,N)** : une entreprise peut n'avoir aucun salarié enregistré (zéro) ou en compter plusieurs.

## Tariff ↔ Rule

- **Tariff (1,N)** : un tarif est obligatoirement associé à une ou plusieurs règles qui définissent ses conditions d'application.
- **Rule (1,1)** : chaque règle référence exactement un tarif pour déterminer le prix qu'elle applique durant sa période de validité.

## Rule ↔ Zone (via `rule_zone`)

- **Rule (0,N)** : une règle peut s'appliquer à zéro zone si elle cible plutôt une borne spécifique, ou à plusieurs zones à la fois.
- **Zone (0,N)** : une zone peut n'avoir aucune règle tarifaire spécifique (tarif par défaut) ou en avoir plusieurs (jours différents, horaires différents).

## Rule ↔ Borne (via `borne_rule`)

- **Rule (0,N)** : une règle peut ne cibler aucune borne spécifique si elle s'applique au niveau zone, ou plusieurs bornes précises.
- **Borne (0,N)** : une borne peut n'avoir aucune règle tarifaire dédiée (elle suit alors sa zone) ou en avoir plusieurs pour des créneaux différents.

## Location ↔ Tag (via `location_tag`)

- **Location (0,N)** : un site peut n'avoir aucun service à proximité (zéro tag) ou en cumuler plusieurs (café, toilettes, parking couvert).
- **Tag (0,N)** : un même tag (ex : "Café") peut être associé à zéro ou plusieurs sites différents.

## Role ↔ Permission (via `role_permission`)

- **Role (0,N)** : un rôle peut n'avoir aucune permission attribuée pour l'instant (zéro), ou en cumuler plusieurs.
- **Permission (0,N)** : une même permission peut être accordée à zéro ou plusieurs rôles différents (ex : `view_invoice` pour "Comptable" et "Admin").
