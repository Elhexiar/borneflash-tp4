import type { Tarif } from "#tarification/tarif";
import type { SessionRecharge } from "#domaine/session-recharge";

export class TarifForfait implements Tarif {
  private montant: number;

  constructor(montant: number) {
    this.montant = montant;
  }

  calculerCout(session: SessionRecharge): number {
    return this.montant;
  }
}
