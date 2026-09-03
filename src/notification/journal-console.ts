import type { ObservateurSession } from "#notification/observateur-session";
import type { SessionRecharge } from "#domaine/session-recharge";

export class JournalConsole implements ObservateurSession {
  surSessionTerminee(session: SessionRecharge): void {
    console.log(`[Journal] Session ${session.id} terminée.`);
  }
}
