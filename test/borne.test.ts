// Exercice 2 — La machine à états de la Borne (dont les cas d'erreur).
import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { Borne } from "#domaine/borne";
import { SessionRecharge } from "#domaine/session-recharge";
import { TarifForfait } from "#tarification/tarif-forfait";

describe("Borne", () => {
  test("une borne libre qui démarre passe à Occupee", () => {
    const borne = new Borne("Borne 1");
    const session = new SessionRecharge(
      "Session 1",
      20,
      new Date(),
      new TarifForfait(0.5),
    );
    borne.demarrer(session);
    assert.strictEqual(borne.etatActuel, "Occupee");
  });

  test("démarrer une borne déjà occupée doit lever une erreur", () => {
    const borne = new Borne("Borne 1");
    const session1 = new SessionRecharge(
      "Session 1",
      20,
      new Date(),
      new TarifForfait(0.5),
    );
    borne.demarrer(session1);

    const session2 = new SessionRecharge(
      "Session 2",
      30,
      new Date(),
      new TarifForfait(0.5),
    );

    assert.throws(() => {
      borne.demarrer(session2);
    });
  });

  test("terminer une borne occupée la remet à Libre", () => {
    const borne = new Borne("Borne 1");
    const session = new SessionRecharge(
      "Session 1",
      20,
      new Date(),
      new TarifForfait(0.5),
    );
    borne.demarrer(session);
    assert.strictEqual(borne.etatActuel, "Occupee");
    borne.terminer();
    assert.strictEqual(borne.etatActuel, "Libre");
  });
});
