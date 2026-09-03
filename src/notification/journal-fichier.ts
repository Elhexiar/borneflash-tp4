import { appendFileSync } from "node:fs";
import type { ObservateurSession } from "#notification/observateur-session";
import type { SessionRecharge } from "#domaine/session-recharge";

/**
 * Observer qui écrit chaque fin de session dans un fichier (I/O réel).
 *
 * Contrairement à JournalConsole, il touche le système de fichiers : c'est
 * donc un bon candidat pour un test d'INTÉGRATION (on vérifie ce qui est
 * réellement écrit sur le disque).
 */
export class JournalFichier implements ObservateurSession {
  private readonly chemin: string;

  constructor(chemin: string) {
    this.chemin = chemin;
  }

  surSessionTerminee(session: SessionRecharge): void {
    appendFileSync(this.chemin, `${session.id};${session.cout()}\n`, "utf8");
  }
}
