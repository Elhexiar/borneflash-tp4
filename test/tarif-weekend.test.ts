// Exercice 4 — TDD : écris D'ABORD les tests, PUIS crée la classe.
// Étapes : 1) ROUGE (test qui échoue) 2) VERT (implémente) 3) REFACTOR.
import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { SessionRecharge } from "#domaine/session-recharge";
import { TarifWeekend } from "#tarification/tarif-weekend";

describe("TarifWeekend (en TDD)", () => {
  // TODO 1 (ROUGE) : écris un test « le week-end : énergie × prix week-end »
  //   (2026-01-03 = samedi) — il échoue car la classe n'existe pas encore.
  // TODO 2 (VERT)  : crée src/tarification/tarif-weekend.ts pour faire passer le test.
  // TODO 3         : ajoute le test « en semaine : énergie × prix semaine » (2026-01-05 = lundi).

  const session = new SessionRecharge(
    "Session 1",
    20,
    new Date(2026, 1, 3, 10, 0, 0), // samedi 10 h
    new TarifWeekend(0.25, 0.15), // prix semaine = 0.25 €/kWh, prix week-end = 0.15 €/kWh
  );
  assert.equal(session.cout(), 5); // 20 kWh × 0.15 €/kWh =  3€
});
