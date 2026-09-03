import type { Tarif } from "#tarification/tarif";
import type { ObservateurSession } from "#notification/observateur-session";

export class SessionRecharge {
  public readonly id: string;
  public readonly energieKwh: number;
  public readonly debut: Date;
  private tarif: Tarif;
  private observateurs: ObservateurSession[] = [];

  constructor(id: string, energieKwh: number, debut: Date, tarif: Tarif) {
    this.id = id;
    this.energieKwh = energieKwh;
    this.debut = debut;
    this.tarif = tarif;
  }

  cout(): number {
    return this.tarif.calculerCout(this);
  }

  ajouterObservateur(observateur: ObservateurSession): void {
    this.observateurs.push(observateur);
  }

  terminer(): void {
    for (const observateur of this.observateurs) {
      observateur.surSessionTerminee(this);
    }
  }
}
