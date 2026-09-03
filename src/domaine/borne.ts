import type { SessionRecharge } from "#domaine/session-recharge";

export type EtatBorne = "Libre" | "Occupee" | "HorsService";

export class Borne {
  public readonly id: string;
  private etat: EtatBorne;
  private sessionEnCours: SessionRecharge | null = null;

  constructor(id: string, etatInitial: EtatBorne = "Libre") {
    this.id = id;
    this.etat = etatInitial;
  }

  get etatActuel(): EtatBorne {
    return this.etat;
  }

  demarrer(session: SessionRecharge): void {
    if (this.etat !== "Libre") {
      throw new Error(`Impossible de démarrer : la borne ${this.id} est ${this.etat}.`);
    }
    this.sessionEnCours = session;
    this.etat = "Occupee";
  }

  terminer(): void {
    if (this.etat !== "Occupee") {
      throw new Error(`Aucune session à terminer sur la borne ${this.id}.`);
    }
    this.sessionEnCours = null;
    this.etat = "Libre";
  }
}
