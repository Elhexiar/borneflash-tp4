// Exercice 5 — Test d'INTÉGRATION : JournalFichier écrit vraiment sur le disque.
import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { SessionRecharge } from "#domaine/session-recharge";
import { TarifForfait } from "#tarification/tarif-forfait";
import { JournalFichier } from "#notification/journal-fichier";

test("JournalFichier écrit la fin de session dans un fichier", () => {

  const cheminTemp = join(tmpdir(), `journal-${Date.now()}.csv`);

  const session = new SessionRecharge(
    "Session 1",
    20,
    new Date(),
    new TarifForfait(10),
  );

  const journal = new JournalFichier(cheminTemp);
  session.ajouterObservateur(journal);

  session.terminer();

  const contenu = readFileSync(cheminTemp, "utf-8");

  assert(contenu.includes("Session 1"));
  assert(contenu.includes("10"));

  rmSync(cheminTemp);
});
