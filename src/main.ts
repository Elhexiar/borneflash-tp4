import { SessionRecharge } from "#domaine/session-recharge";
import { Borne } from "#domaine/borne";
import { TarifAuKwh } from "#tarification/tarif-au-kwh";
import { TarifForfait } from "#tarification/tarif-forfait";
import { TarifHeureCreuse } from "#tarification/tarif-heure-creuse";
import { SessionRepositoryEnMemoire } from "#persistance/session-repository-en-memoire";
import { RecuEmail } from "#notification/recu-email";
import { JournalConsole } from "#notification/journal-console";
import { MiseAJourTableauDeBord } from "#notification/mise-a-jour-tableau-de-bord";

const debutJour = new Date("2026-06-15T14:00:00"); // heure pleine
const debutNuit = new Date("2026-06-15T23:00:00"); // heure creuse

console.log("=== Exercice 1 ===");
const rechargeAuKwh = new SessionRecharge("S-001", 30, debutJour, new TarifAuKwh(0.25));
console.log("Coût au kWh :", rechargeAuKwh.cout(), "€");
const rechargeAuForfait = new SessionRecharge("S-001", 30, debutJour, new TarifForfait(5));
console.log("Coût forfait :", rechargeAuForfait.cout(), "€");

console.log("=== Exercice 2.1 (heures creuses) ===");
const rechargeNuit = new SessionRecharge("S-002", 40, debutNuit, new TarifHeureCreuse());
const rechargeJour = new SessionRecharge("S-002b", 40, debutJour, new TarifHeureCreuse());
console.log("Coût session de nuit (23h) :", rechargeNuit.cout(), "€");
console.log("Coût session de jour (14h) :", rechargeJour.cout(), "€");

console.log("=== Exercice 2.2 (repository en mémoire) ===");
const depot = new SessionRepositoryEnMemoire();
depot.enregistrer(rechargeAuKwh);
depot.enregistrer(rechargeNuit);
const coutTotal = depot.tous().reduce((somme, session) => somme + session.cout(), 0);
console.log("Coût total enregistré :", coutTotal, "€");

console.log("=== Exercice 3 (Observer) ===");
const rechargeObservee = new SessionRecharge("S-003", 20, debutJour, new TarifAuKwh(0.30));
rechargeObservee.ajouterObservateur(new RecuEmail());
rechargeObservee.ajouterObservateur(new JournalConsole());
rechargeObservee.ajouterObservateur(new MiseAJourTableauDeBord()); // Ex 3.3 : sans modifier SessionRecharge
rechargeObservee.terminer();

console.log("=== Exercice 4 (Borne et états) ===");
const borne = new Borne("BORNE-A");
borne.demarrer(rechargeAuKwh);
console.log("État de la borne :", borne.etatActuel);
try {
  borne.demarrer(rechargeAuForfait);
} catch (erreur) {
  console.log("Refusé :", (erreur as Error).message);
}
