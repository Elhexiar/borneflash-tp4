## Arbitrage

- **Consentement RGPD** : `personnal.date_consent_tos` prouve l'acceptation des CGU. Le consentement peut être retiré, ce qui déclenche la procédure de suppression de compte.

## Questions/Réponses

- **Facturation** : `le client change ses prix, et les anciennes factures doivent rester justes. Où, précisément, ton modèle encaisse-t-il ça ?`

Les factures du tableau **invoice** ne sont liée a aucun des tableau permettant de generer les factures, ils ne sont lié qu'a **user** et **company**. Ainsi chaque information de la facture, est une donnée copié et découplé des autres tableau a un instant 't'. Ainsi meme si les autres tableau changes, l'historique de facturation est immuable en ce qui concerne les donnée de facturation

- **Occurence d'Association** : `le même véhicule revient plusieurs fois sur le même point de recharge, parfois dans la même semaine. Vérifie que ton modèle le permet réellement.`

Le modele actuelle permet sans probleme a une même voiture, d'aller plusieur fois a la meme borne dans une même semaine. Vehicule et Borne sont séparée de plusieur tableau mes se rejoignent via **recharge**. Celle ci n'a aucune contrainte de fréquence ou de temps.

- **Roles** : L'association de role et de permission a été réaliser en suivant le modele RBAC. Cela permet de facilement pouvoir rajouter de nouveau roles et permission sans avoir a changer fondamentalement le modele de donnée. La meme chose est vrai pour le fait de pouvoir rajouter de nouvelles zones géographiques et Emplacement de borne, avec des tariffs et règles qui leurs seront propres.

## Décisions

- **Décision #1 : Zones Géographiques**

Les zones géographiques été initalement prévue comme étant des Entité auto-référencé, cela aurait permis de pouvoir stocker des zones dans des zones dans des zones etc... et ainsi avoir une granularité plus importante dans la création et l'attributions de zones. Cependant cela compléxifie beaucoup le modele, surtout avec quelques chose dont je n'ai aucune éxpèrience. Si jamais le client désire l'implémenter, et/ou que le temps le permet cela pourrait etre implémenter.

- **décision #2 : Priorité de règles**

LEs Tarrifs fonctionnent avec un systeme de priorité, en effet plusieur tariffs différents peuvent etre attribué simultanément a une meme borne, a même horaire (exemple : solde de fin d'années + recharge du mardi soir a -10%), la borne doit alors choisir quel tariff appliqué, et utilise son parametre de priorité pour le faire. Si elle possede une priorité égale, elle priorétise ensuite ce de la régions, puis la date, puis le jour, puis la date de création la plus proche. Ce systeme pourrait etre plus simple avec une seule Règle applicable a la fois et gerer ainsi du coté utilisateur les chevauchement de changement de tarrif lui meme. Cela pourrait etre aussi plus complexe en permettant celon certains contexte la fusion et/ou le cumule de certains tarrif. J'ai séléctionner la solution actuelle car elle permet d'avoir un niveau de controle que je juge suffisant sur les regles sans pour autant rajouter trop de compléxité. Si j'avais plus ou a l'inverse moins de temps j'aurais opter pour l'une des deux autres options.
