import type { SessionRecharge } from "#domaine/session-recharge";

/**
 * Contrat d'un observateur de fin de session (pattern Observer).
 *
 * La session notifie ses observateurs quand elle se termine, sans les
 * connaître concrètement. Ajouter un observateur ne modifie pas la session
 * (principe OCP).
 */
export interface ObservateurSession {
  /**
   * Appelée automatiquement quand une session vient de se terminer.
   * @param session - la session terminée
   */
  surSessionTerminee(session: SessionRecharge): void;
}
