## 1.2 - Ordre d'insertion

Les `INSERT` sont exécutés des tables parentes vers les tables enfants, car une clé étrangère doit référencer une ligne déjà existante ; dans l'ordre inverse, PostgreSQL refuse l'insertion pour violation d'une contrainte de clé étrangère.

Le même principe s'applique aux tables d'association : les deux entités qu'elles référencent doivent déjà exister.

Dans ces cas, j'utilise les CTE et `RETURNING` pour récupérer et réutiliser les identifiants générés par la base de données.

## 1.3 - Idempotence

J'ai retenu la stratégie `TRUNCATE ... RESTART IDENTITY CASCADE` au début du fichier `seed.sql`. `TRUNCATE` supprime les données des tables indiquées et, grâce à `CASCADE`, celles des tables qui en dépendent. `RESTART IDENTITY` remet les compteurs d'identifiants à zéro. Chaque exécution recrée donc exactement le même jeu de données, sans doublon ni erreur.

La commande produit notamment les messages suivants :

```text
NOTICE: TRUNCATE cascade sur la table « rule »
NOTICE: TRUNCATE cascade sur la table « location »
NOTICE: TRUNCATE cascade sur la table « user_ »
NOTICE: TRUNCATE cascade sur la table « recharge »
TRUNCATE TABLE
```

L'alternative consiste à utiliser `INSERT ... ON CONFLICT DO NOTHING`. Cette solution nécessite une contrainte `UNIQUE` permettant d'identifier le conflit. Cependant, comme mon `seed.sql` utilise de nombreux CTE et `RETURNING`, elle est moins adaptée : lors d'un conflit, `DO NOTHING` ne renvoie pas l'identifiant de la ligne déjà existante.

Cela ne pose pas de problème lorsqu'une base contient déjà exactement toutes les données du seed : les insertions suivantes peuvent elles aussi être ignorées. En revanche, le résultat est incomplet si la base est partiellement remplie.

Par exemple, si les rôles ont été ajoutés manuellement mais pas les utilisateurs, l'insertion du rôle `Admin` est ignorée. Le CTE `admin_role` ne renvoie alors aucun identifiant, donc les `INSERT` qui en dépendent, comme celui d'un utilisateur, ne s'exécutent pas alors qu'ils devraient créer des données manquantes.

Une autre solution est de remplacer `DO NOTHING` par `DO UPDATE`, afin de récupérer l'identifiant de la ligne existante avec `RETURNING` :

```sql
admin_role AS (
       INSERT INTO role (name_role)
       VALUES ('Admin')
       ON CONFLICT (name_role) DO UPDATE
              SET name_role = EXCLUDED.name_role
       RETURNING id_role
),
```

`EXCLUDED.name_role` désigne la valeur proposée par l'insertion qui entre en conflit. Ici, la mise à jour ne change donc pas la valeur du rôle, mais permet de récupérer son `id_role`.
