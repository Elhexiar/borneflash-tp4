# Exercice 4.2 — Table de correspondance MCD ↔ Diagramme de classes

## Sens 1 : du MCD vers le diagramme de classes

| Entité / Association MCD      | Équivalent dans le diagramme de classes                                                                                                                                                                                                     |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `user`                        | Classe `User`                                                                                                                                                                                                                               |
| `personnal`                   | Classe `Personnal`                                                                                                                                                                                                                          |
| `role`                        | Classe `Role`                                                                                                                                                                                                                               |
| `permission`                  | Classe `Permission`                                                                                                                                                                                                                         |
| `company`                     | Classe `Company`                                                                                                                                                                                                                            |
| `company_info`                | Classe `CompanyInfo`                                                                                                                                                                                                                        |
| `vehicule`                    | Classe `Vehicule`                                                                                                                                                                                                                           |
| `badge`                       | Classe `Badge`                                                                                                                                                                                                                              |
| `zone`                        | Classe `Zone`                                                                                                                                                                                                                               |
| `location`                    | Classe `Location`                                                                                                                                                                                                                           |
| `tag`                         | Classe `Tag`                                                                                                                                                                                                                                |
| `borne`                       | Classe `Borne`                                                                                                                                                                                                                              |
| `charge_point`                | Classe `ChargePoint`                                                                                                                                                                                                                        |
| `recharge`                    | Classe `Recharge`                                                                                                                                                                                                                           |
| `invoice`                     | Classe `Invoice`                                                                                                                                                                                                                            |
| `favorite`                    | Classe `Favorite`                                                                                                                                                                                                                           |
| `tariff`                      | Classe `Tariff`                                                                                                                                                                                                                             |
| `rule`                        | Classe `Rule`                                                                                                                                                                                                                               |
| `operation`                   | Classe `Operation`                                                                                                                                                                                                                          |
| Association `user_recharge`   | Lien `User "1" -- "0..*" Recharge` : chaque recharge est rattachée à l'utilisateur qui l'a initiée, avec ou sans badge.                                                                                                                     |
| Association `user_company`    | Lien `User "0..*" -- "0..*" Company` (pas de classe intermédiaire)<br> est un tableau nullable de Company[] dans User                                                                                                                       |
| Association `user_vehicule`   | Lien `User "0..*" -- "0..*" Vehicule` (pas de classe intermédiaire)<br> est un tableau nullable de Vehicule[] dans User                                                                                                                     |
| Association `role_permission` | Lien `Role "0..*" -- "0..*" Permission` (pas de classe intermédiaire)<br> est un tableau nullable de Permission[] dans Role                                                                                                                 |
| Association `location_tag`    | Lien `Location "0..*" -- "0..*" Tag` (pas de classe intermédiaire)<br> est un tableau nullable de Tag[] dans Location                                                                                                                       |
| Association `rule_zone`       | Lien `Rule "0..*" -- "0..*" Zone` (pas de classe intermédiaire) une regle peux etre attribué soit a une borne directement via sa borne<br>, ou indirectement via celles associé au zones, ainsi, zone possede un tableau nullable de Rule[] |
| Association `borne_rule`      | Lien `Rule "0..*" -- "0..*" Borne` (pas de classe intermédiaire) voir ci l'éxplication ci dessus                                                                                                                                            |

## Sens 2 : du diagramme de classes vers le MCD

| Classe / Élément du diagramme de classes                                                                                         | Équivalent dans le MCD |
| -------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `User`                                                                                                                           | Entité `user_`         |
| `Personnal`                                                                                                                      | Entité `personnal`     |
| `Role`                                                                                                                           | Entité `role`          |
| `Permission`                                                                                                                     | Entité `permission`    |
| `Company`                                                                                                                        | Entité `company`       |
| `CompanyInfo`                                                                                                                    | Entité `company_info`  |
| `Vehicule`                                                                                                                       | Entité `vehicule`      |
| `Badge`                                                                                                                          | Entité `badge`         |
| `Zone`                                                                                                                           | Entité `zone`          |
| `Location`                                                                                                                       | Entité `location`      |
| `Tag`                                                                                                                            | Entité `tag`           |
| `Borne`                                                                                                                          | Entité `borne`         |
| `ChargePoint`                                                                                                                    | Entité `charge_point`  |
| `Recharge`                                                                                                                       | Entité `recharge`      |
| `Invoice`                                                                                                                        | Entité `invoice`       |
| `Favorite`                                                                                                                       | Entité `favorite`      |
| `Tariff`                                                                                                                         | Entité `tariff`        |
| `Rule`                                                                                                                           | Entité `rule`          |
| `Operation`                                                                                                                      | Entité `operation`     |
| `ObservateurRecharge` (interface) et implémentations (`JournalConsole`, `JournalFichier`, `MiseAJourTableauDeBord`, `RecuEmail`) | **Aucun équivalent**   |
| `RechargeRepository` (interface) et implémentations (`RechargeRepositoryEnMemoire`, `RechargeRepositoryPostgreSQL`)              | **Aucun équivalent**   |

---

## Ce qui existe dans le diagramme de classes et n'a aucun équivalent dans le MCD

- Le package **Notification** entier : l'interface `ObservateurRecharge` et ses implémentations (`JournalConsole`, `JournalFichier`, `MiseAJourTableauDeBord`, `RecuEmail`).
- Le package **Persistance** entier : l'interface `RechargeRepository` et ses implémentations (`RechargeRepositoryEnMemoire`, `RechargeRepositoryPostgreSQL`).

## Ce qui existe dans le MCD et n'a aucun équivalent (en tant que classe) dans le diagramme de classes

- Les 6 tables de jointure pures : `user_company`, `user_vehicule`, `role_permission`, `location_tag`, `rule_zone`, `borne_rule`.
