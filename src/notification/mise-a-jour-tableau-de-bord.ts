import type { ObservateurSession } from "#notification/observateur-session";
import type { SessionRecharge } from "#domaine/session-recharge";

export class MiseAJourTableauDeBord implements ObservateurSession {
  surSessionTerminee(session: SessionRecharge): void {
    console.log(`[Tableau de bord] Session ${session.id} ajoutée au suivi (${session.energieKwh} kWh).`);
  }
}
