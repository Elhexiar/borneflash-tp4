import { SessionRecharge } from "#domaine/session-recharge";
import type { Tarif } from "#tarification/tarif";

export class TarifWeekend implements Tarif {
  private prixSemaine: number;
  private prixWeekend: number;

  constructor(prixSemaine: number, prixWeekend: number) {
    this.prixSemaine = prixSemaine;
    this.prixWeekend = prixWeekend;
  }

  calculerCout(session: SessionRecharge): number {
    const jour = session.debut.getDay();
    const estWeekend = jour === 0 || jour === 6;
    return (
      session.energieKwh * (estWeekend ? this.prixWeekend : this.prixSemaine)
    );
  }
}
