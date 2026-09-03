import type { ObservateurSession } from "#notification/observateur-session";
import type { SessionRecharge } from "#domaine/session-recharge";

export class RecuEmail implements ObservateurSession {
  surSessionTerminee(session: SessionRecharge): void {
    console.log(`[Email] Reçu pour la session ${session.id} : ${session.cout()} €`);
  }
}
