import type { Tarif } from "#tarification/tarif";
import type { SessionRecharge } from "#domaine/session-recharge";

export class TarifHeureCreuse implements Tarif {
  private prixCreux: number;
  private prixPlein: number;
  private heureDebutCreux: number;
  private heureFinCreux: number;

  constructor(
    prixCreux: number = 0.15,
    prixPlein: number = 0.25,
    heureDebutCreux: number = 22,
    heureFinCreux: number = 6,
  ) {
    this.prixCreux = prixCreux;
    this.prixPlein = prixPlein;
    this.heureDebutCreux = heureDebutCreux;
    this.heureFinCreux = heureFinCreux;
  }

  calculerCout(session: SessionRecharge): number {
    const heure = session.debut.getHours();
    const estHeureCreuse = heure >= this.heureDebutCreux || heure < this.heureFinCreux;
    return session.energieKwh * (estHeureCreuse ? this.prixCreux : this.prixPlein);
  }
}
