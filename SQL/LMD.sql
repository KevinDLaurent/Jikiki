--creation de la base employes 
--pour executer le script:
--@LMD.sql

--Exemples de requête 'get_enum' :
SELECT unnest(enum_range(NULL::province));
SELECT unnest(enum_range(NULL::typeObjet));

-- Exemple de requête 'add_user' :
INSERT INTO Utilisateur VALUES ('augu', 'Augusto', 'dos Santos Latgé', 
    'augusto.dos.santos.latge@umontreal.ca', '1234','01/01/2000', 
    '123', 'av. Montréal', 'Montréal', 'Québec', 'H211A1');

--Exemple de requête 'verify_login' :
SELECT COUNT(*) FROM Utilisateur WHERE identifiant='augu' AND motDePasse='1234';

--Exemple de requête 'get_items_list' :
SELECT identifiant, nom, instance, prix, quantiteUnitaire, quantiteDisponible, etat, dureeEmprunt 
FROM ObjetAffiche 
WHERE dureeEmprunt = 0 AND prix >= 0 AND prix <= 999999 AND etat = '1' AND affichable = '1' AND instance = 'Outils';
--Exemple de requête 'get_items_list' :
SELECT identifiant, nom, instance, prix, quantiteUnitaire, quantiteDisponible, etat, dureeEmprunt
FROM ObjetAffiche 
WHERE prix >= 0 AND prix <= 999999 AND etat = '0' AND affichable = '1' AND instance = 'Outils';

--Exemple de requête 'get_item' :
SELECT * FROM (SELECT * FROM (SELECT * FROM ObjetAffiche WHERE identifiant = '5') AS a 
NATURAL JOIN
(SELECT * FROM Outils WHERE objetIdentifiant = '5') AS b) 
AS object 
NATURAL JOIN (SELECT adresseNumero, adresseRue, adresseVille, adresseProvince, codePostal 
FROM Utilisateur WHERE identifiant IN
(SELECT utilisateurIdentifiant FROM ObjetAffiche WHERE identifiant = '5')) 
AS contact;

--Exemple de requête 'transaction' (mise à jour de la table 'ObjetAffiche') :
UPDATE ObjetAffiche SET quantiteDisponible = 0, affichable = '0'WHERE identifiant = '5';
--Exemple de requête 'transaction' (mise à jour de la table 'RecuEmprunt') :
INSERT INTO RecuEmprunt (emprunteur, objetIdentifiant, prix, quantite, statut) VALUES
('augu',
'5', 
(SELECT prix FROM (SELECT * FROM (SELECT * FROM ObjetAffiche WHERE identifiant = '5') AS a 
    NATURAL JOIN (SELECT * FROM Outils WHERE objetIdentifiant = '5') AS b) 
        AS prix), 
1, 
'1');

--Exemple de requête 'get_items_list' :
SELECT identifiant, nom, instance, prix, quantiteUnitaire, quantiteDisponible, etat, dureeEmprunt 
FROM ObjetAffiche WHERE prix >= 0 AND prix <= 999999 AND etat = '0' AND affichable = '1' AND instance = 'Outils';

--Exemple de requête 'get_recu' (achat) :
SELECT TB.identifiant, TB.nom, TB.instance, TA.acheteur, TA.prix, TA.quantite, TA.dateVente, TA.heureVente 
FROM RecuVente TA INNER JOIN ObjetAffiche TB ON TA.objetIdentifiant = TB.identifiant 
WHERE TA.acheteur = TB.utilisateurIdentifiant AND TA.acheteur = 'augu';
--Exemple de requête 'get_recu' (vente) :
SELECT TB.identifiant, TB.nom, TB.instance, TA.acheteur, TA.prix, TA.quantite, TA.dateVente, TA.heureVente 
FROM RecuVente TA INNER JOIN ObjetAffiche TB ON TA.objetIdentifiant = TB.identifiant 
WHERE TA.acheteur = TB.utilisateurIdentifiant AND TA.acheteur != 'augu';
--Exemple de requête 'get_recu' (emprunt) :
SELECT TB.identifiant, TB.nom, TB.instance, TA.emprunteur, TA.prix, TA.quantite, TA.dateEmprunt, TA.heureEmprunt 
FROM RecuEmprunt TA INNER JOIN ObjetAffiche TB ON TA.objetIdentifiant = TB.identifiant 
WHERE TA.emprunteur = TB.utilisateurIdentifiant AND TA.emprunteur = 'augu';
--Exemple de requête 'get_recu' (prêt) :
SELECT TB.identifiant, TB.nom, TB.instance, TA.emprunteur, TA.prix, TA.quantite, TA.dateEmprunt, TA.heureEmprunt 
FROM RecuEmprunt TA INNER JOIN ObjetAffiche TB ON TA.objetIdentifiant = TB.identifiant 
WHERE TA.emprunteur = TB.utilisateurIdentifiant AND TA.emprunteur = 'augu';

--Exemple de requête 'get_item' :
SELECT * FROM (SELECT * FROM (SELECT * FROM ObjetAffiche WHERE identifiant = '2') AS a 
NATURAL JOIN
(SELECT * FROM BijouxMontres WHERE objetIdentifiant = '2') AS b) AS object 
NATURAL JOIN 
(SELECT adresseNumero, adresseRue, adresseVille, adresseProvince, codePostal 
    FROM Utilisateur WHERE identifiant IN
        (SELECT utilisateurIdentifiant FROM ObjetAffiche WHERE identifiant = '2')) AS contact;

--Exemple de requête 'get_table_form' :
--SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'autres';

--Exemple de requête 'add_item' :
--Insértion dans la table 'ObjetAffiche' :
INSERT INTO ObjetAffiche 
VALUES (8, 'augu', 'Cuillère', 1, 1, 'Cuillère en argent', '0', 0, 3, '1', 'Autres');
--Insértion dans une table de type :
INSERT INTO Autres VALUES (8, 'Cuillère');

COMMIT;