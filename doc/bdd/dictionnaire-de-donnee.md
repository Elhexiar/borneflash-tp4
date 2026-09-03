### Utilisateur : user

| Code               | Désignation                                                          | Type     | Taille | Contrainte                    | MCD | MLD |
| ------------------ | -------------------------------------------------------------------- | -------- | ------ | ----------------------------- | --- | --- |
| id_user            | Identifiant utilisateur                                              | Alphanum | 255    | Obligatoire, Unique, Auto     | X   |     |
| id_personnal       | Identifiant Information Personnelles                                 | Alphanum | 255    |                               | X   |     |
| id_company         | Identifiant optionel d'entreprise                                    | Alphanum | 255    |                               | X   |     |
| date_user_register | Date d'inscription de l'utilisateur                                  | Date     | ---    | Obligatoire, défaut : ce jour | X   |     |
| role               | Role de l'utilisateur, définie ses permission d'accèes               | Alphanum | 255    | Obligatoire                   | X   |     |
| date_deleted_user  | Date de la supprésion de l'utilisateur, ( user supprimé si non nul ) | Date     | ---    |                               | X   |     |

---

---

### Information Personnelles : personnal

| Code          | Désignation                          |   Type   | Taille | Contrainte          | MCD | MLD |
| ------------- | ------------------------------------ | :------: | :----: | ------------------- | --- | --- |
| id_personnal  | Identifiant information personnelles | Alphanum |  255   | Obligatoire, Unique | X   |     |
| first_name    | Prénom Utilisateur                   | Alphanum |  255   | Obligatoire         | X   |     |
| last_name     | Nom de Famille Utilisateur           | Alphanum |  255   | Obligatoire         | X   |     |
| password_user | Mot de Passe de l'utilisateur        | Alphanum |  255   | Obligatoire         | X   |     |
| email_user    | Email Utilis### User                 |

---

---

### Entreprise : company

| Code         | Désignation              |   Type   | Taille | Contrainte          | MCD | MLD |
| ------------ | ------------------------ | :------: | :----: | ------------------- | --- | --- |
| id_company   | Identifiant d'Entreprise | Alphanum |  255   | Obligatoire, Unique |     |     |
| name_company | Nom de l'entreprise      | Alphanum |  255   | Obligatoire, Unique |     |     |

---

---

### Borne

| Code            | Désignation                                                                                                           | Type                     | Taille | Contrainte          | MCD | MLD |
| --------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------ | ------ | ------------------- | --- | --- |
| id_borne        | Identificateur Borne                                                                                                  | Alphanum                 | 255    | Obligatoire, Unique |     |     |
| id_zone         | Identificateur Zone Géographique                                                                                      | Alphanum                 | 255    |                     |     |     |
| available_borne | Disponibilité immédiate d'une borne                                                                                   | Booleen                  | ---    | Obligatoire         |     |     |
| power_borne     | Puissance en kWh d'une borne de recharge                                                                              | Numérique                | 10     | Obligatoire         |     |     |
| state           | Etat d'une borne (ex : 0 ->Désactivé, 1 Active en bonne etat,<br> 2 Active avec disfonctionnement non critique etc..) | Numérique                | 2      | Obligatoire         |     |     |
| latitude        | Latitude de la borne                                                                                                  | Numérique ( Decimal 9,6) | 2      | Obligatoire         |     |     |
| longitude       | Longitude de la borne                                                                                                 | Numérique ( Decimal 9,6) | 2      | Obligatoire         |     |     |

---

---

### Zone Géographique

| Code      | Désignation                 |   Type   | Taille | Contrainte          | MCD | MLD |
| --------- | --------------------------- | :------: | :----: | ------------------- | --- | --- |
| id_zone   | Identifiant de la zone      | Alphanum |  255   | Obligatoire, Unique |     |     |
| name_zone | Nom de la zone géographique | Alphanum |  255   | Obligatoire, Unique |     |     |

---

---

### Vehicule

| Code               | Désignation                                                | Type     | Taille | Contrainte          | MCD | MLD |
| ------------------ | ---------------------------------------------------------- | -------- | ------ | ------------------- | --- | --- |
| id_vehicule        | Identifiant Vehicule                                       | Alphanum | 255    | Obligatoire, Unique |     |     |
| id_user            | Identifiant Utilisateur proprietere                        | Alphanum | 255    | Obligatoire         |     |     |
| id_company         | Identifiant optionnel d'entreprise                         | Alphanum | 255    |                     |     |     |
| model_vehicule     | Modele de vehicule                                         | Alphanum | 255    | Obligatoire         |     |     |
| available_vehicule | Si le vehicule est actuellement utilisé par un utilisateur | Booleen  | ---    | Obligatoire         |     |     |

---

---

### Recharge

| Code                | Désignation                                                  | Type      | Taille | Contrainte          | MCD | MLD |
| ------------------- | ------------------------------------------------------------ | --------- | :----: | ------------------- | --- | --- |
| id_recharge         | Identifiant de Recharge                                      | Alphanum  |  255   | Obligatoire, Unique |     |     |
| id_borne            | Identifiant de la borne sur laquel la recharge<br>a eu lieux | Alphanum  |  255   | Obligatoire         |     |     |
| id_user             | Identifiant de l'utilisateur ayant éfféctuer la recharge     | Alphanum  |  255   | Obligatoire         |     |     |
| id_vehicule         | Identifiant de la voiture concernée                          | Alphanum  |  255   | Obligatoire         |     |     |
| id_facture          | Identifiant de la facture généré                             | Alphanum  |  255   |                     |     |     |
| recharge_quantity   | Quantité de mAh transferer lors d'une recharge               | Numérique |   20   | Obligatoire         |     |     |
| finished_recharge   | Est ce que la recharge s'est terminer                        | Booleen   |  ---   | Obligatoire         |     |     |
| date_recharge_begin | Date de début de la recharge                                 | Date      |  ---   | Obligatoire         |     |     |
| date_recharge_end   | Date de fin de la recharge                                   | Date      |  ---   | Obligatoire         |     |     |
| price_recharge      | Prix de la recharge quand terminé                            | Numérique |  ---   |                     |     |     |

---

---

### Facture

| Code                | Désignation                           | Type      | Taille | Contrainte                     | MCD | MLD |
| ------------------- | ------------------------------------- | --------- | ------ | ------------------------------ | --- | --- |
| id_facture          | Identifiant Facture                   | Alphanum  | 255    | Obligatoire, Unique            |     |     |
| id_user             | Identifiant utilisateur               | Alphanum  | 255    |                                |     |     |
| id_company          | Identifiant Entreprise                | Alphanum  | 255    |                                |     |     |
| amount_energie      | Montant de la d'énèrgie délivré       | Numérique | 10     | Obligatoire                    |     |     |
| amount_invoice      | Montant de la facture a devoir relevé | Numérique | 10     | Obligatoire                    |     |     |
| is_paid_invoice     | Est ce que la Facture a été réglé     | Booleen   | ---    | Obligatoire, default = false   |     |     |
| date_emited_invoice | Date d'émission de la facture         | Date      | ---    | Obligatoire, default = ce jour |     |     |
| date_paid_invoice   | Date de paiement de la facture        | Date      | ---    |                                |     |     |

---

---

### Tariff

| Code         | Désignation              | Type      | Taille | Contrainte          | MCD | MLD |
| ------------ | ------------------------ | --------- | :----: | ------------------- | --- | --- |
| id_tariff    | Identifiant Tariff       | Alphanum  |  255   | Obligatoire, Unique |     |     |
| name_tariff  | Nom de ce type de tarrif | Alphanum  |  255   | Obligatoire         |     |     |
| price_tarrif | Prix a l'Ah appliqué     | Numérique |   10   | Obligatoire         |     |     |

---

---

### Regles de Tarifes

| Code           | Désignation                                                                                                                | Type               | Taille | Contrainte          | MCD | MLD |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------ | :----: | ------------------- | --- | --- |
| id_tariff_rule | Identifiant de la regle de tariff                                                                                          | Alphanum           |  255   | Obligatoire, Unique |     |     |
| tariff_id      | Référence du tariff appliqué, Séparé car il est courant d'avoir des montant réutilisé,<br> Prix standard, Promotion etc... | Alphanum           |  255   | Obligatoire         |     |     |
| borne_id       | Référence de la borne ou la regle s'applique, si null s'applique sur une zone géographique                                 | Alphanum           |  255   |                     |     |     |
| zone_id        | Référence de la borne ou la zone ou la regle s'applique, si null s'applique sur une borne spécifique                       | Alphanum           |  255   |                     |     |     |
| day_of_week    | Pour les jours de la semaine récurent, regle de notation US ( 0 = Dimanche, 6 = Samedi )                                   | Numérique - Entier |   1    |                     |     |     |
| time_start     | A quelle heure le tarrif commence. Si null le tariff s'applique a n'importe quelle heure                                   | Date - Heure       |   8    |                     |     |     |
| time_end       | A quelle heure le tarrif se termine. Si null le tariff s'applique a n'importe quelle heure                                 | Date - Heure       |   8    |                     |     |     |
| valid_from     | A quelle date, le tarrif commence. Si null le tariff s'applique a n'importe quelle date                                    | Date - Jour        |   8    |                     |     |     |
| valid_to       | A quelle heure, le tarrif se termine. Si null le tariff s'applique a n'importe quelle date                                 | Date - Jour        |   8    |                     |     |     |
| Priority       | Si de multiple Tarrif s'applique en meme temps, celui avec la plus grande priorité s'applique                              | Numérique          |   3    |                     |     |     |

---

---

### Opération de Maintenance

| Code                | Désignation                                                                                              | Type     | Taille | Contrainte  | MCD | MLD |
| ------------------- | -------------------------------------------------------------------------------------------------------- | -------- | :----: | ----------- | --- | --- |
| id_operation        | Identifiant de l'opération de maintenance                                                                | Alphanum |  255   | Obligatoire |     |     |
| id_borne            | Identifiant de la borne concerné                                                                         | Alphanum |  255   | Obligatoire |     |     |
| id_operator         | Identifiant de l'opérateur ayant efféctuer la maintenance de la borne                                    | Alphanum |  255   | Obligatoire |     |     |
| start_from          | Date et heure du début de l'opération de maintenance,                                                    | Date     |  255   | Obligatoire |     |     |
| end_at              | Date et heure de la fin de l'opération de maintenance, si null opération toujours en cours ou en attente | Date     |  255   |             |     |     |
| initial_observation | Observation initial ayant mener a la demande de maintenance + eventuel instruction                       | Alphanum |  511   | Obligatoire |     |     |

---

---

### Favorites

| Code        | Désignation             |   Type   | Taille | Contrainte  | MCD | MLD |
| ----------- | ----------------------- | :------: | :----: | ----------- | --- | --- |
| id_favorite | Identifiant Favorit     | Alphanum |  255   | Obligatoire |     |     |
| id_user     | Identifiant Utilisateur | Alphanum |  255   | Obligatoire |     |     |
| id_borne    | Identifiant Borne       | Alphanum |  255   | Obligatoire |     |     |
| date_added  | Date d'ajout            |   Date   |  ---   | Obligatoire |     |     |

---

---
