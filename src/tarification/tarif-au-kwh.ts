import type { Tarif } from "#tarification/tarif";
import type { SessionRecharge } from "#domaine/session-recharge";

export class TarifAuKwh implements Tarif {
  private prixParKwh: number;

  constructor(prixParKwh: number) {
    this.prixParKwh = prixParKwh;
  }

  calculerCout(session: SessionRecharge): number {
    return session.energieKwh * this.prixParKwh;
  }
}
