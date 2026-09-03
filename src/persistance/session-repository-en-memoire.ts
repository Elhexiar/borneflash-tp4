import type { SessionRepository } from "#persistance/session-repository";
import type { SessionRecharge } from "#domaine/session-recharge";

export class SessionRepositoryEnMemoire implements SessionRepository {
  private sessions: SessionRecharge[] = [];

  enregistrer(session: SessionRecharge): void {
    this.sessions.push(session);
  }

  tous(): SessionRecharge[] {
    return [...this.sessions];
  }
}
