// Exercice 3 — Vérifier que la session notifie ses observateurs (spy).
import { test, mock } from "node:test";
import assert from "node:assert/strict";
import { SessionRecharge } from "#domaine/session-recharge";
import { TarifForfait } from "#tarification/tarif-forfait";
import type { ObservateurSession } from "#notification/observateur-session";

test("terminer() notifie chaque observateur une fois", () => {
  const surSessionTerminee = mock.fn();
  const spy1 = { surSessionTerminee };
  const spy2 = { surSessionTerminee };

  const session = new SessionRecharge(
    "Session 1",
    20,
    new Date(),
    new TarifForfait(0.5),
  );

  session.ajouterObservateur(spy1);
  session.ajouterObservateur(spy2);

  session.terminer();

  assert.equal(surSessionTerminee.mock.callCount(), 2);
});
