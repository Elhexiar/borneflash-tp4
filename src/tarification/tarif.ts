import type { SessionRecharge } from "#domaine/session-recharge";

/**
 * Contrat d'une stratégie de tarification (pattern Strategy).
 *
 * Chaque tarif sait calculer le coût d'une session, sans que la session
 * connaisse la formule. On peut ajouter un nouveau tarif sans modifier
 * l'existant (principe OCP).
 */
export interface Tarif {
  /**
   * Calcule le coût d'une session de recharge.
   * @param session - la session à facturer
   * @returns le montant à payer, en euros
   */
  calculerCout(session: SessionRecharge): number;
}
