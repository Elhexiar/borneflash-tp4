# Exercice 5.2 — Provenance de chaque table du MLD

Rappel des 3 règles de transformation MCD → MLD :

1. **Règle 1** : toute entité devient une table, son identifiant devient la clé primaire.
2. **Règle 2** : une association avec un côté "1,1" (ou "0,1") et l'autre "0,N"/"1,N" devient une clé étrangère (FK : Foreign key ) ajoutée du côté "1" (ou "0,1"). (key_name\* signifie qu'une clé est optionnel)
3. **Règle 3** : une association N,N des deux côtés devient une table à part entière, avec les clés étrangères combinées en clé primaire.

---

## Tables issues directement d'une entité (Règle 1 + Règle 2 pour les FK)

| Table MLD      | Provient de                                                                             | Règle appliquée                                                              |
| -------------- | --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `tariff`       | Entité `Tariff`                                                                         | Règle 1                                                                      |
| `rule`         | Entité `Rule` + FK `#id_tariff`                                                         | Règle 1 + Règle 2 (association `Rule (1,1) — Tariff (0,N)` → FK côté `Rule`) |
| `company`      | Entité `Company`                                                                        | Règle 1                                                                      |
| `zone`         | Entité `Zone`                                                                           | Règle 1                                                                      |
| `location`     | Entité `Location` + FK `#id_zone`                                                       | Règle 1 + Règle 2 (`Location (1,1) — Zone (1,N)`)                            |
| `tag`          | Entité `Tag`                                                                            | Règle 1                                                                      |
| `role`         | Entité `Role`                                                                           | Règle 1                                                                      |
| `permission`   | Entité `Permission`                                                                     | Règle 1                                                                      |
| `company_info` | Entité `CompanyInfo` + FK `#id_company`                                                 | Règle 1 + Règle 2 (`CompanyInfo (1,1) — Company (0,1)`)                      |
| `user_`        | Entité `User` + FK `#id_role`                                                           | Règle 1 + Règle 2 (`User (1,1) — Role (0,N)`)                                |
| `vehicule`     | Entité `Vehicule` + FK `#id_company*`                                                   | Règle 1 + Règle 2 (`Vehicule (0,1) — Company (0,N)`)                         |
| `invoice`      | Entité `Invoice` + FK `#id_user`, `#id_company*`                                        | Règle 1 + Règle 2 (×2)                                                       |
| `personnal`    | Entité `Personnal` + FK `#id_user`                                                      | Règle 1 + Règle 2 (`Personnal (1,1) — User (0,1)`)                           |
| `borne`        | Entité `Borne` + FK `#id_location`                                                      | Règle 1 + Règle 2 (`Borne (1,1) — Location (0,N)`)                           |
| `badge`        | Entité `Badge` + FK `#id_user`, `#id_company*`                                          | Règle 1 + Règle 2 (×2)                                                       |
| `charge_point` | Entité `ChargePoint` + FK `#id_borne`                                                   | Règle 1 + Règle 2 (`ChargePoint (1,1) — Borne (1,N)`)                        |
| `operation`    | Entité `Operation` + FK `#id_user`, `#id_borne`                                         | Règle 1 + Règle 2 (×2)                                                       |
| `favorite`     | Entité `Favorite` + FK `#id_user`, `#id_charge_point`                                   | Règle 1 + Règle 2 (×2)                                                       |
| `recharge`     | Entité `Recharge` + FK `#id_badge`, `#id_charge_point`, `#id_vehicule*`, `#id_invoice*` | Règle 1 + Règle 2 (×4)                                                       |

---

## Tables issues d'une association N,N (Règle 3)

| Table MLD         | Provient de                     | Règle appliquée              |
| ----------------- | ------------------------------- | ---------------------------- |
| `user_vehicule`   | Association `User ↔ Vehicule`   | Règle 3 (N,N des deux côtés) |
| `user_company`    | Association `User ↔ Company`    | Règle 3 (N,N des deux côtés) |
| `rule_zone`       | Association `Rule ↔ Zone`       | Règle 3 (N,N des deux côtés) |
| `borne_tariff`    | Association `Rule ↔ Borne`      | Règle 3 (N,N des deux côtés) |
| `location_tag`    | Association `Location ↔ Tag`    | Règle 3 (N,N des deux côtés) |
| `role_permission` | Association `Role ↔ Permission` | Règle 3 (N,N des deux côtés) |

---
