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

| Code          | Désignation                                 |   Type   | Taille | Contrainte          | MCD | MLD |
| ------------- | ------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_personnal  | Identifiant information personnelles        | Alphanum |  255   | Obligatoire, Unique | X   |     |
| id_user       | Identifiant utilisateur (FK, relation 1-1)  | Alphanum |  255   | Obligatoire         | X   |     |
| first_name    | Prénom utilisateur                          | Alphanum |  255   | Obligatoire         | X   |     |
| last_name     | Nom de famille utilisateur                  | Alphanum |  255   | Obligatoire         | X   |     |
| password_user | Mot de passe de l'utilisateur               | Alphanum |  255   | Obligatoire         | X   |     |
| email_user    | Email utilisateur, identifiant de connexion | Alphanum |  255   | Obligatoire, Unique | X   | X   |

> Table séparée de `User` pour permettre la suppression réelle des données personnelles (RGPD/CNIL) sans casser l'intégrité des factures/recharges historiques rattachées à `id_user`.

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
| name_company | Nom de l'entreprise      | Alphanum |  255   | Obligatoire, Unique |     |     |

---

## Zone Géographique : `zone`

| Code      | Désignation                 |   Type   | Taille | Contrainte          | MCD | MLD |
| --------- | --------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_zone   | Identifiant de la zone      | Alphanum |  255   | Obligatoire, Unique |     |     |
| name_zone | Nom de la zone géographique | Alphanum |  255   | Obligatoire, Unique |     |     |

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

## Tag de site : `location_tag`

| Code            | Désignation                                                                                    |   Type   | Taille | Contrainte          | MCD | MLD |
| --------------- | ---------------------------------------------------------------------------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_location_tag | Identifiant du tag de service                                                                  | Alphanum |  255   | Obligatoire, Unique |     |     |
| tag_name        | Nom du service/équipement disponible sur le site (ex : "Café", "Toilettes", "Parking couvert") | Alphanum |   50   | Obligatoire         |     |     |
| tag_icon        | Icône représentant le tag                                                                      | Alphanum |   1    |                     |     |     |

> Permet de décrire les services/équipements présents autour d'un site (`Location`), via l'association `Identifier_les_services_autours_d_un_site`.

---

## Borne : `borne`

| Code        | Désignation                                                                                                |          Type           | Taille | Contrainte          | MCD | MLD |
| ----------- | ---------------------------------------------------------------------------------------------------------- | :---------------------: | :----: | ------------------- | --- | --- |
| id_borne    | Identificateur borne                                                                                       |        Alphanum         |  255   | Obligatoire, Unique |     |     |
| id_location | Référence du site auquel appartient la borne                                                               |        Alphanum         |  255   | Obligatoire         |     |     |
| latitude    | Latitude précise de la borne                                                                               | Numérique (Decimal 9,6) |  ---   | Obligatoire         |     |     |
| longitude   | Longitude précise de la borne                                                                              | Numérique (Decimal 9,6) |  ---   | Obligatoire         |     |     |
| state       | État de la borne (ex : 0 -> Désactivée, 1 -> Active en bon état, 2 -> Active avec dysfonctionnement, etc.) |   Numérique - Entier    |   2    | Obligatoire         |     |     |

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

> Un véhicule peut avoir plusieurs utilisateurs, ex : véhicule partagé ; voir `Associer_un_vehicule_a_un_l_utilisateur`.

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
| finished_recharge   | La recharge est-elle terminée                                    |  Booléen  |  ---   | Obligatoire         |     |     |
| date_recharge_begin | Date de début de la recharge                                     |   Date    |  ---   | Obligatoire         |     |     |
| date_recharge_end   | Date de fin de la recharge (nulle tant qu'en cours)              |   Date    |  ---   |                     |     |     |
| price_recharge      | Prix de la recharge une fois terminée                            | Numérique |  ---   | Obligatoire         |     |     |

> L'identité de l'utilisateur (et donc le payeur) se déduit via `id_badge → User [→ Company]`, il n'y a plus de FK directe vers `User`. `id_vehicule` est optionnel : rien n'oblige un utilisateur à enregistrer son véhicule. `id_invoice` est optionnel : une recharge existe avant d'être facturée.

---

## Facture : `invoice`

| Code                | Désignation                                               |   Type    | Taille | Contrainte                    | MCD | MLD |
| ------------------- | --------------------------------------------------------- | :-------: | :----: | ----------------------------- | --- | --- |
| id_invoice          | Identifiant facture                                       | Alphanum  |  255   | Obligatoire, Unique           |     |     |
| code_invoice        | Numéro de facture lisible (affiché au client)             | Alphanum  |   50   | Obligatoire                   |     |     |
| id_user             | Identifiant utilisateur ayant consommé                    | Alphanum  |  255   | Obligatoire                   |     |     |
| id_company          | Identifiant de l'entreprise, si non nul l'entreprise paye | Alphanum  |  255   |                               |     |     |
| amount_energie      | Montant de l'énergie délivrée                             | Numérique |   10   | Obligatoire                   |     |     |
| amount_invoice      | Montant de la facture à devoir régler                     | Numérique |   10   | Obligatoire                   |     |     |
| is_paid_invoice     | La facture a-t-elle été réglée                            |  Booléen  |  ---   | Obligatoire, défaut = false   |     |     |
| date_emited_invoice | Date d'émission de la facture                             |   Date    |  ---   | Obligatoire, défaut = ce jour |     |     |
| date_paid_invoice   | Date de paiement de la facture                            |   Date    |  ---   |                               |     |     |

> `id_user` identifie toujours qui a consommé ; `id_company` (optionnel) identifie qui paye lorsqu'il s'agit d'une facturation groupée à une entreprise. Une facture peut regrouper plusieurs recharges via `Recharge.id_invoice`.

---

## Tariff : `tariff`

| Code         | Désignation             | Type      | Taille | Contrainte          | MCD | MLD |
| ------------ | ----------------------- | --------- | :----: | ------------------- | --- | --- |
| id_tariff    | Identifiant tariff      | Alphanum  |  255   | Obligatoire, Unique |     |     |
| name_tariff  | Nom de ce type de tarif | Alphanum  |  255   | Obligatoire         |     |     |
| price_tariff | Prix au kWh appliqué    | Numérique |   10   | Obligatoire         |     |     |

---

## Règles de Tarifs : `tariff_rule`

| Code           | Désignation                                                                                    | Type               | Taille | Contrainte          | MCD | MLD |
| -------------- | ---------------------------------------------------------------------------------------------- | ------------------ | :----: | ------------------- | --- | --- |
| id_tariff_rule | Identifiant de la règle de tarif                                                               | Alphanum           |  255   | Obligatoire, Unique |     |     |
| day_of_week    | Jour de la semaine récurrent, notation US (0 = Dimanche, 6 = Samedi). Nul = tous les jours     | Numérique - Entier |   1    |                     |     |     |
| time_start     | Heure de début d'application. Nul = pas de restriction horaire                                 | Date - Heure       |   8    |                     |     |     |
| time_end       | Heure de fin d'application. Nul = pas de restriction horaire                                   | Date - Heure       |   8    |                     |     |     |
| valid_from     | Date de début d'application. Nul = pas de restriction de date                                  | Date - Jour        |   8    |                     |     |     |
| valid_to       | Date de fin d'application. Nul = pas de restriction de date                                    | Date - Jour        |   8    |                     |     |     |
| priority       | Priorité de la règle en cas d'application simultanée de plusieurs règles (la plus haute gagne) | Numérique          |   3    |                     |     |     |

> Le lien vers `Tariff`, `Zone` et `Borne` se fait désormais via des associations dédiées (voir ci-dessous).

---

## Opération de Maintenance : `operation`

| Code                  | Désignation                                                                             | Type               | Taille | Contrainte  | MCD | MLD |
| --------------------- | --------------------------------------------------------------------------------------- | ------------------ | :----: | ----------- | --- | --- |
| id_operation          | Identifiant de l'opération de maintenance                                               | Alphanum           |  255   | Obligatoire |     |     |
| id_borne              | Identifiant de la borne concernée                                                       | Alphanum           |  255   | Obligatoire |     |     |
| id_user               | Identifiant de l'opérateur ayant effectué la maintenance                                | Alphanum           |  255   | Obligatoire |     |     |
| start_from            | Date et heure du début de l'opération de maintenance                                    | Date               |  ---   | Obligatoire |     |     |
| end_at                | Date et heure de fin de l'opération, nulle si opération toujours en cours ou en attente | Date               |  ---   |             |     |     |
| initial_observation   | Observation initiale ayant mené à la demande de maintenance + éventuelle instruction    | Alphanum           |  511   | Obligatoire |     |     |
| operation_description | Observation de l'opérateur une fois l'opération effectuée                               | Alphanum           |  511   | Obligatoire |     |     |
| end_state             | État de la borne à l'issue de l'opération                                               | Numérique - Entier |   1    |             |     |     |

> Rattachée au niveau `Borne` (et non `Charge_Point`) : par décision client, une panne d'un seul point de charge affecte la borne entière.

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

### `Associer_un_vehicule_a_un_l_utilisateur`

| Code        | Désignation             | Type     | Taille | Contrainte  |
| ----------- | ----------------------- | -------- | :----: | ----------- |
| id_user     | Identifiant utilisateur | Alphanum |  255   | Obligatoire |
| id_vehicule | Identifiant véhicule    | Alphanum |  255   | Obligatoire |

> Un véhicule peut être associé à plusieurs utilisateurs (ex : véhicule partagé), et un utilisateur à plusieurs véhicules.

### `Associer_un_utilisateur_a_une_Entreprise`

| Code       | Désignation             | Type     | Taille | Contrainte  |
| ---------- | ----------------------- | -------- | :----: | ----------- |
| id_user    | Identifiant utilisateur | Alphanum |  255   | Obligatoire |
| id_company | Identifiant entreprise  | Alphanum |  255   | Obligatoire |

> Un utilisateur peut appartenir à plusieurs entreprises (intérim, temps partiel), une entreprise à plusieurs utilisateurs.

### `Associer_un_role_a_des_permission`

| Code          | Désignation                  | Type     | Taille | Contrainte  |
| ------------- | ---------------------------- | -------- | :----: | ----------- |
| id_role       | Identifiant du rôle          | Alphanum |  255   | Obligatoire |
| id_permission | Identifiant de la permission | Alphanum |  255   | Obligatoire |

> Relie un rôle à l'ensemble des permissions qui lui sont accordées. Voir le tableau d'attribution proposé dans la section `Permission` ci-dessus.

### `Avoir_une_regle_d_application`

| Code           | Désignation                | Type     | Taille | Contrainte  |
| -------------- | -------------------------- | -------- | :----: | ----------- |
| id_tariff      | Identifiant tariff         | Alphanum |  255   | Obligatoire |
| id_tariff_rule | Identifiant règle de tarif | Alphanum |  255   | Obligatoire |

> Relie un tarif (montant) aux règles définissant quand il s'applique.

### `Appliquer_une_regle_celon_une_zone`

| Code           | Désignation                | Type     | Taille | Contrainte  |
| -------------- | -------------------------- | -------- | :----: | ----------- |
| id_tariff_rule | Identifiant règle de tarif | Alphanum |  255   | Obligatoire |
| id_zone        | Identifiant zone           | Alphanum |  255   | Obligatoire |

> Une règle de tarif appliquée à l'échelle d'une zone géographique.

### `Associer_des_tarriff_a_une_borne_spécifique`

| Code           | Désignation                | Type     | Taille | Contrainte  |
| -------------- | -------------------------- | -------- | :----: | ----------- |
| id_tariff_rule | Identifiant règle de tarif | Alphanum |  255   | Obligatoire |
| id_borne       | Identifiant borne          | Alphanum |  255   | Obligatoire |

> Une règle de tarif appliquée à une borne spécifique (surcharge sur une règle de zone si priorité supérieure).

### `Identifier_les_services_autours_d_un_site`

| Code            | Désignation                   | Type     | Taille | Contrainte  |
| --------------- | ----------------------------- | -------- | :----: | ----------- |
| id_location     | Identifiant du site           | Alphanum |  255   | Obligatoire |
| id_location_tag | Identifiant du tag de service | Alphanum |  255   | Obligatoire |

> Décrit les services/équipements disponibles autour d'un site (ex : café, toilettes, parking couvert).

---

## Notes et règles métier non modélisables en MCD/MLD

- **Facture** : au moins un des deux champs `id_user`/`id_company` doit être cohérent avec le badge utilisé lors de la/les recharge(s) associées ; à valider par contrainte applicative ou trigger.
- **Badge d'entreprise** : l'entreprise du badge (`Badge.id_company`) devrait correspondre à une entreprise pour laquelle l'utilisateur travaille actuellement (`Associer_un_utilisateur_a_une_Entreprise`).
- **Suppression de compte (RGPD/CNIL)** : suppression réelle via `DELETE` sur `Personnal` uniquement ; `User` est conservé pour préserver l'intégrité des factures/recharges historiques (obligation de conservation comptable).
- **Système de permissions (RBAC)** : les vérifications d'accès se font via `User → Role → Role_Permission → Permission`, en base de données. Une même permission peut être partagée par plusieurs rôles ; un administrateur peut créer un nouveau rôle et lui attribuer un sous-ensemble de permissions sans modification du code applicatif.
