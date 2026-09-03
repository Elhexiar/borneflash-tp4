// Exercice 1 — Tests unitaires des tarifs.  Lance : pnpm test
import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { SessionRecharge } from "#domaine/session-recharge";
import { TarifAuKwh } from "#tarification/tarif-au-kwh";
import { TarifForfait } from "#tarification/tarif-forfait";
import { TarifHeureCreuse } from "#tarification/tarif-heure-creuse";

describe("Tarifs", () => {
  test("TarifAuKwh : énergie × prix", () => {
    // crée une SessionRecharge de 30 kWh avec new TarifAuKwh(0.25),
    //        puis vérifie avec assert.equal(...) que .cout() vaut 7.5

    const session = new SessionRecharge(
      "Session 1",
      30,
      new Date(),
      new TarifAuKwh(0.25),
    );
    assert.equal(session.cout(), 7.5);
  });

  // ajoute un test pour TarifForfait (montant fixe, quelle que soit l'énergie)
  test("TarifForfait : montant fixe", () => {
    const session2 = new SessionRecharge(
      "Session 2",
      50,
      new Date(),
      new TarifForfait(10),
    );
    assert.equal(session2.cout(), 10);

    const session3 = new SessionRecharge(
      "Session 3",
      100,
      new Date(),
      new TarifForfait(15),
    );
    assert.equal(session3.cout(), 15);
  });

  // ajoute deux tests pour TarifHeureCreuse : la nuit (23 h) et le jour (14 h)
  test("TarifHeureCreuse : tarif creux la nuit", () => {
    const session = new SessionRecharge(
      "Session 4",
      40,
      new Date(2026, 0, 1, 23, 0, 0), // 23 h, heure creuse
      new TarifHeureCreuse(0.15, 0.25, 22, 6),
    );
    assert.equal(session.cout(), 6); // 40 kWh × 0.15 €/kWh = 6 €

    const session2 = new SessionRecharge(
      "Session 5",
      40,
      new Date(2026, 0, 1, 14, 0, 0), // 14 h, heure pleine
      new TarifHeureCreuse(0.15, 0.25, 22, 6),
    );
    assert.equal(session2.cout(), 10); // 40 kWh × 0.25 €/kWh = 10 €
    assert.notEqual(session.cout(), session2.cout()); // Vérifie que les deux coûts sont différents
  });
});
