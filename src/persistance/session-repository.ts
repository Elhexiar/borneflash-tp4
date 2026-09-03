import type { SessionRecharge } from "#domaine/session-recharge";

/**
 * Contrat d'accès aux sessions (pattern Repository).
 *
 * Le code métier dépend de cette interface, jamais d'une base de données
 * concrète (principe DIP). On peut ainsi changer de stockage (mémoire,
 * PostgreSQL, …) sans toucher au reste de l'application.
 */
export interface SessionRepository {
  /**
   * Enregistre une session.
   * @param session - la session à persister
   */
  enregistrer(session: SessionRecharge): void;

  /** @returns toutes les sessions enregistrées */
  tous(): SessionRecharge[];
}
