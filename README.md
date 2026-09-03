# BorneFlash — TP 3 : écrire les tests

Tu pars du projet BorneFlash (qui fonctionne déjà) et tu écris **ses tests**.

## Lancer

```bash
pnpm install
pnpm test        # lance les tests (runner natif node:test)
pnpm typecheck   # vérifie les types (src + test)
```

## Où écrire

Un fichier de test par exercice, dans `test/`, avec des `TODO` à compléter :

- `test/tarifs.test.ts`         — Ex. 1 : tests unitaires des tarifs
- `test/borne.test.ts`          — Ex. 2 : machine à états (dont les cas d'erreur)
- `test/observer.test.ts`       — Ex. 3 : notifications (spy avec `mock.fn()`)
- `test/tarif-weekend.test.ts`  — Ex. 4 : **TDD** (écris le test AVANT de créer la classe)
- `test/journal-fichier.test.ts`— Ex. 5 : test d'**intégration** (écriture réelle dans un fichier)

Le code de l'application est dans `src/` : tu n'y touches pas, **sauf** à l'exercice 4
où tu crées `src/tarification/tarif-weekend.ts`.
