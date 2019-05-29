--creation de la base employes 
-- pour executer le script:
-- @DDL.sql

SET search_path TO jikiki;

DROP TABLE Utilisateur CASCADE;
DROP TABLE ObjetAffiche CASCADE;
DROP TABLE RecuEmprunt;
DROP TABLE RecuVente;
DROP TABLE Notifications;
DROP TABLE BijouxMontres;
DROP TABLE Outils;
DROP TABLE Vetement;
DROP TABLE Meubles;
DROP TABLE Nourriture;
DROP TABLE VehiculePersonnel;
DROP TABLE Loisirs;
DROP TABLE EquipementLourd;
DROP TABLE Pieces;
DROP TABLE AutresVehicules;
DROP TABLE Ordinateur;
DROP TABLE Lecteur;
DROP TABLE Console;
DROP TABLE Cellulaire;
DROP TABLE Jeux;
DROP TABLE CD_DVD_BR;
DROP TABLE AutresElectronique;
DROP TABLE Livre;
DROP TABLE Chambres;
DROP TABLE Appartements;
DROP TABLE Maisons;
DROP TABLE Autres;
DROP TYPE province;
DROP TYPE typeObjet;

CREATE TYPE province AS ENUM (
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Northwest Territories',
    'Nova Scotia',
    'Nunavut',
    'Ontario',
    'Prince Edward Island',
    'Québec',
    'Saskatchewan',
    'Yukon'
);

CREATE TABLE Utilisateur (
    identifiant VARCHAR(40) UNIQUE NOT NULL,
    prenom VARCHAR(40) NOT NULL,
    nom VARCHAR(40) NOT NULL,
    courriel VARCHAR(40) UNIQUE NOT NULL,
    motDePasse VARCHAR(40) NOT NULL,
    dateNaissance DATE,
    adresseNumero VARCHAR(40),
    adresseRue VARCHAR(40),
    adresseVille VARCHAR(40),
    adresseProvince province,
    codePostal VARCHAR(6),
    CHECK (DATE_PART('day', dateNaissance)>=1 AND DATE_PART('day', dateNaissance)<=31),
    CHECK (DATE_PART('month', dateNaissance)>=1 AND DATE_PART('month', dateNaissance)<=12),
    CHECK (DATE_PART('year', dateNaissance)>=1900 AND DATE_PART('year', dateNaissance)<=DATE_PART('year', NOW())),
    CONSTRAINT utilisateurPk PRIMARY KEY (identifiant)
);

CREATE TYPE typeObjet AS ENUM (
    'BijouxMontres',
    'Outils',
    'Vetement',
    'Meubles',
    'Nourriture',
    'VehiculePersonnel',
    'Loisirs',
    'EquipementLourd',
    'Pieces',
    'AutresVehicules',
    'Ordinateur',
    'Lecteur',
    'Console',
    'Jeux',
    'Cellulaire',
    'CD_DVD_BR',
    'AutresElectronique',
    'Livre',
    'Chambres',
    'Appartements',
    'Maisons',
    'Autres'
);

CREATE TABLE ObjetAffiche (
    identifiant VARCHAR(40) UNIQUE NOT NULL,
    utilisateurIdentifiant VARCHAR(40),
    nom VARCHAR(40),
    quantiteUnitaire INT NOT NULL CHECK (quantiteDisponible >= 0),
    quantiteDisponible INT NOT NULL CHECK (quantiteDisponible >= 0),
    description VARCHAR(300),
    etat BIT(1) NOT NULL,
    prix NUMERIC(10,2),
    dureeEmprunt INT NOT NULL CHECK (dureeEmprunt >= 0),
    affichable BIT(1) NOT NULL,
    instance typeObjet,
    CONSTRAINT objetAffichePK PRIMARY KEY(identifiant),
    CONSTRAINT objetAfficheFK FOREIGN KEY(utilisateurIdentifiant) 
        REFERENCES Utilisateur(identifiant) ON DELETE SET NULL
);

CREATE TABLE RecuVente (
    dateVente DATE DEFAULT CURRENT_DATE,
    heureVente TIME DEFAULT CURRENT_TIME,
    acheteur VARCHAR(40),
    objetIdentifiant VARCHAR(40),
    vendeur VARCHAR(40),
    prix NUMERIC(9,2),
    quantite INT,
    CONSTRAINT recuVentePk PRIMARY KEY (dateVente, heureVente, acheteur, objetIdentifiant),
    CONSTRAINT recuVenteFk1 FOREIGN KEY (acheteur) 
        REFERENCES Utilisateur(identifiant) ON DELETE CASCADE,
    CONSTRAINT recuVenteFk2 FOREIGN KEY (objetIdentifiant)
        REFERENCES ObjetAffiche(identifiant) ON DELETE CASCADE
);

CREATE TABLE RecuEmprunt (
    dateEmprunt DATE DEFAULT CURRENT_DATE,
    heureEmprunt TIME DEFAULT CURRENT_TIME,
    dateRemise DATE DEFAULT NULL,
    emprunteur VARCHAR(40),
    objetIdentifiant VARCHAR(40),    
    prix NUMERIC(9,2),
    quantite INT,
    statut BIT(1) NOT NULL,
    CHECK (dateRemise >= dateEmprunt),
    CONSTRAINT recuEmpruntPk PRIMARY KEY (dateEmprunt, heureEmprunt, emprunteur, objetIdentifiant),
    CONSTRAINT recuEmpruntFk1 FOREIGN KEY (emprunteur)
        REFERENCES Utilisateur(identifiant) ON DELETE CASCADE,
    CONSTRAINT recuEmpruntFk2 FOREIGN KEY (objetIdentifiant)
        REFERENCES ObjetAffiche(identifiant) ON DELETE CASCADE
);

CREATE TABLE Notifications(
    dateTime TIME CONSTRAINT notificationPK PRIMARY KEY,
    utilisateurId VARCHAR(40),
    objetIdentifiant VARCHAR(40),
    CONSTRAINT notificationsPF1 FOREIGN KEY (utilisateurId) 
        REFERENCES Utilisateur(identifiant) ON DELETE SET NULL,
    CONSTRAINT notificationsPF2 FOREIGN KEY (objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE BijouxMontres (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    marque VARCHAR(40),
    materiaux VARCHAR(60),
    CONSTRAINT bijouxMontresPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT bijouxMontresFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Outils (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    CONSTRAINT outilsPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT outilsFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Vetement (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    taille VARCHAR(40),
    materiaux VARCHAR(40),
    marque VARCHAR(40),
    CONSTRAINT vetementPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT vetementFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Meubles (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    dimensions VARCHAR(40),
    materiaux VARCHAR(40),
    CONSTRAINT meublesPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT meublesFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);      

CREATE TABLE Nourriture (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    datePeremption DATE,
    ingredients VARCHAR(300),
    origine VARCHAR(40),
    CONSTRAINT nourriturePK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT nourritureFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE VehiculePersonnel (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    kilometrage INT,
    anneeFabrication INT,
    compagnie VARCHAR(40),
    modele VARCHAR(40),
    CONSTRAINT vehiculePersonnelPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT vehiculePersonnelFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Loisirs (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    modele VARCHAR(40),
    anneeFabrication INT,
    compagnie VARCHAR(40),
    CONSTRAINT loisirsPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT loisirsFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE EquipementLourd (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    anneeFabrication INT,
    compagnie VARCHAR(40),
    modele VARCHAR(40),
    CONSTRAINT equipementLourdPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT equipementLourdFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Pieces (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    modele VARCHAR(40),
    compagnie VARCHAR(40),
    CONSTRAINT piecesPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT piecesFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE AutresVehicules (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    CONSTRAINT autresVehiculesPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT autresVehiculesFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Ordinateur (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    compagnie VARCHAR(40),
    portabilite BIT,
    modele VARCHAR(40),
    CONSTRAINT ordinateurPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT ordinateurFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);      
        
CREATE TABLE Lecteur (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    modele VARCHAR(40),
    compagnie VARCHAR(40),
    CONSTRAINT lecteurPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT lecteurFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);  
        
CREATE TABLE Console (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    modele VARCHAR(40),
    compagnie VARCHAR(40),
    CONSTRAINT consolePK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT consoleFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Cellulaire (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    modele VARCHAR(40),
    compagnie VARCHAR(40),
    annee INT,
    forfaitInclus BIT,
    CONSTRAINT cellulairePK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT cellulaireFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Jeux (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    titre VARCHAR(40),
    annee INT,
    console VARCHAR(40),
    developpeur VARCHAR(40),
    CONSTRAINT jeuxPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT jeuxFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE CD_DVD_BR (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    titre VARCHAR(40),
    annee INT,
    auteurs VARCHAR(100),
    CONSTRAINT CD_DVD_BRPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT CD_DVD_BRFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE AutresElectronique (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    modele VARCHAR(40),
    compagnie VARCHAR(40),
    CONSTRAINT autresElectroniquePK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT autresElectroniqueFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Livre (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    titre VARCHAR(40),
    annee INT,
    auteurs VARCHAR(100),
    CONSTRAINT livrePK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT livreFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Chambres (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    dateDisponible DATE NOT NULL,
    dateFinLocation DATE,
    nbLocataires INT,
    CONSTRAINT chambresPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT chambresFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Appartements (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    dateDisponible DATE NOT NULL,
    dateFinLocation DATE,
    meublesInclus BIT,
    nbPieces NUMERIC(2,1),
    CONSTRAINT appartementsPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT appartementsFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Maisons (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    dateDisponible DATE NOT NULL,
    dateFinLocation DATE,
    meublesInclus BIT,
    nbPieces NUMERIC(3,1),
    CONSTRAINT maisonsPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT maisonsFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
        
CREATE TABLE Autres (
    objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
    typeOb VARCHAR(40),
    CONSTRAINT autresPK PRIMARY KEY(objetIdentifiant),
    CONSTRAINT autresFK FOREIGN KEY(objetIdentifiant) 
        REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);


COMMIT;

INSERT INTO Utilisateur VALUES
    ('testUser', 'John', 'Doe', 'nomail@gmail.com', '1234',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO Utilisateur VALUES
    ('testUser2', 'Jane', 'Doe', 'nomail2@gmail.com', '1234',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO Utilisateur VALUES
    ('u', 'Bob', 'Doe', 'nomail3@gmail.com', '0',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO Utilisateur VALUES
    ('', 'Ted', 'Doe', 'nomail4@gmail.com', '',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO Utilisateur VALUES
    ('user3', 'Ed', 'Doe', 'nomail5@gmail.com', '',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO Utilisateur VALUES
    ('user4', 'Bob', 'Doe', 'nomail6@gmail.com', '',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO ObjetAffiche VALUES
    ('1', 'testUser', 'Montre en or ROLEX', 1, 1, 
    'Montre toujours dans sa boite dorigine, 18 carats', '1', 
    550.00, 0, '1', 'BijouxMontres');

INSERT INTO BijouxMontres VALUES
    ('1', 'Montres', 'ROLEX', 'Or 8 carats');
    
INSERT INTO ObjetAffiche VALUES
    ('2', 'testUser', 'Coffre a bijoux', 1, 1, 
    'Ensemble de bijoux variés', '0', 
    80.00, 0, '1', 'BijouxMontres');

INSERT INTO BijouxMontres VALUES
    ('2', 'Varie', 'Varie', 'Varie');

INSERT INTO ObjetAffiche VALUES
    ('3', 'testUser2', 'Collier de perles fait a la main', 1, 
    10, 'Collier fait a la main', '1', 
    12.00, 0, '1', 'BijouxMontres');

INSERT INTO BijouxMontres VALUES
    ('3', 'Collier', NULL, 'Fausses perles');
    
INSERT INTO ObjetAffiche VALUES
    ('4', 'testUser', 'Perceuse electrique', 1, 1, 
    'Perceuse electriques avec bolts inclus', '0', 
    10.00, 7, '1', 'Outils');

INSERT INTO Outils VALUES
    ('4', 'Construction');
    
INSERT INTO ObjetAffiche VALUES
    ('5', 'testUser', 'Coffre a outils', 1, 1, 
    'Coffre a outils de garage', '0', 
    45.00, 14, '1', 'Outils');

INSERT INTO Outils VALUES
    ('5', 'Garage');
        
INSERT INTO ObjetAffiche VALUES
	('6', 'testUser2', 'Souffleuse neuve', 1, 
	5, 'Souffleuse de marque, haute performance', '1', 
	499.99, 0, '1', 'Outils');

INSERT INTO Outils VALUES
	('6', 'Entretien exterieur');
	
INSERT INTO ObjetAffiche VALUES
	('7', 'testUser', 'Pull noir', 1, 1, 
	'Un pull tres peu porte', '0', 
	15.00, 0, '1', 'Vetement');

INSERT INTO Vetement VALUES
	('7', 'Medium', 'Chandails', 'Urban B', 'Coton');
	
INSERT INTO ObjetAffiche VALUES
	('8', 'testUser', 'Ensemble formel', 1, 1, 
	'Chemise, veste et pantalons formels', '0', 
	70.00, 0, '1', 'Vetement');

INSERT INTO Vetement VALUES
	('8', 'Small', 'Complet', 'Gucci', 'Coton');
	
INSERT INTO ObjetAffiche VALUES
	('9', 'testUser2', 'Linge varie a donner', 1, 
	80, 'Contactez pour details', '0', 
	0.00, 0, '1', 'Vetement');

INSERT INTO Vetement VALUES
	('9', 'Varie', 'Varie', 'Varie', 'Varie');
	
INSERT INTO ObjetAffiche VALUES
	('10', 'testUser', 'Horloge grand-pere', 1, 1, 
	'Grande horloge fonctionnelle', '0', 
	150.00, 0, '1', 'Meubles');
	
INSERT INTO Meubles VALUES
	('10', 'Meubles', '50 x 50 x 170', 'bois');
	
INSERT INTO ObjetAffiche VALUES
	('11', 'testUser', 'Coffre en bois', 1, 1, 
	'Coffre en bois avec cadenas', '0', 
	35.00, 0, '1', 'Meubles');

INSERT INTO Meubles VALUES
	('11', 'Meubles', '30 x 40 x 55', 'Bois');
	
INSERT INTO ObjetAffiche VALUES
	('12', 'testUser2', 'Ensemble pour salle a manger', 1, 
	10, '1 table et 6 chaises', '0', 
	65.00, 0, '1', 'Meubles');

INSERT INTO Meubles VALUES
	('12', 'Salle a manger', NULL, 'Bois');
	
INSERT INTO ObjetAffiche VALUES
	('13', 'testUser2', 'Bouffe a chat', 1, 
	12, 'Delicieux avec vin blanc', '1', 
	8.00, 0, '1', 'Nourriture');

INSERT INTO Nourriture VALUES
	('13', 'Dejeuner', '2018-06-01', 'Rats broyes', 'Montreal');
	
INSERT INTO ObjetAffiche VALUES
	('14', 'testUser', 'Pain vieilli', 1, 20, 
	'Pain vieilli sur le comptoir', '0', 
	10.00, 0, '1', 'Nourriture');
	
INSERT INTO Nourriture VALUES
	('14', 'Experience bacteriologique', '2016-06-01', 'pain, organismes varies', 
	'Montreal');
	
INSERT INTO ObjetAffiche VALUES
	('15', 'testUser', 'Patisseries a donner', 1, 100, 
	'Contactez pour details', '1', 
	5.00, 0, '1', 'Nourriture');

INSERT INTO Nourriture VALUES
	('15', 'Nourriture', NULL, 'Varie', 'Montreal');
	
INSERT INTO ObjetAffiche VALUES
	('16', 'testUser', 'Vehicule1', 1, 1, 
	'Vehicule', '0', 
	4500.00, 0, '1', 'VehiculePersonnel');

INSERT INTO VehiculePersonnel VALUES
	('16', 75000, 2010, 'Charcomp', 'M1');
	
INSERT INTO ObjetAffiche VALUES
	('17', 'testUser2', 'Vehicule2', 1, 
	1, 'Collier fait a la main', '0', 
	60.00, 1, '1', 'VehiculePersonnel');

INSERT INTO VehiculePersonnel VALUES
	('17', 10000, 2017, 'Charcomp', 'M2');
	
INSERT INTO ObjetAffiche VALUES
	('18', 'testUser', 'Vehicule3', 1, 1, 
	'Vehicule3', '1', 
	6500.00, 0, '1', 'Loisirs');

INSERT INTO Loisirs VALUES
	('18', 'M3', 2015, 'Charlois');
	
INSERT INTO ObjetAffiche VALUES
	('19', 'testUser2', 'Vehicule4', 1, 
	2, 'Vehicule4', '0', 
	120.00, 1, '1', 'Loisirs');

INSERT INTO Loisirs VALUES
	('19', 'M4', 2016, 'Charlois');
	
INSERT INTO ObjetAffiche VALUES
	('20', 'testUser', 'Vehicule5', 1, 1, 
	'Vehicule lourd', '1', 
	500.00, 7, '1', 'EquipementLourd');

INSERT INTO EquipementLourd VALUES
	('20', 2010, 'Charlour', 'M5');
	
INSERT INTO ObjetAffiche VALUES
	('21', 'testUser2', 'Vehicule6', 1, 
	1, 'Vehicule6', '0', 
	12500.00, 0, '1', 'EquipementLourd');

INSERT INTO EquipementLourd VALUES
	('21', 2008, 'Charlour', 'M6');
	
INSERT INTO ObjetAffiche VALUES
	('22', 'testUser', 'Pieces de garage', 1, 1, 
	'Ensemble de pieces variees', '0', 
	200.00, 0, '1', 'Pieces');

INSERT INTO Pieces VALUES
	('22', NULL, 'CT');
	
INSERT INTO ObjetAffiche VALUES
	('23', 'testUser2', 'Pneus dhiver', 4, 
	10, 'Pneus dhiver a clous', '0', 
	80.00, 0, '1', 'Pieces');

INSERT INTO Pieces VALUES
	('23', 'Mspec', 'Mich');
	
INSERT INTO ObjetAffiche VALUES
	('24', 'testUser', 'Traineau du Pere-Noel', 1, 1, 
	'Traineau et renes domestiques', '0', 
	25000.00, 0, '1', 'AutresVehicules');

INSERT INTO AutresVehicules VALUES
	('24', 'Noel');
	
INSERT INTO ObjetAffiche VALUES
	('25', 'testUser2', 'Toothless', 1, 
	1, 'Dragon rapide et dangereux', '1', 
	150000.00, 0, '1', 'AutresVehicules');

INSERT INTO AutresVehicules VALUES
	('25', 'Animaux');
	
INSERT INTO ObjetAffiche VALUES
	('26', 'testUser', 'MSI Portable', 1, 1, 
	'MSI portable', '0', 
	700.00, 0, '1', 'Ordinateur');

INSERT INTO Ordinateur VALUES
	('26', 'MSI', '1', 'Stealth Pro');
	
INSERT INTO ObjetAffiche VALUES
	('27', 'testUser2', 'Tour alienware', 1, 
	1, 'Tour alienware', '1', 
	2400.00, 0, '1', 'Ordinateur');

INSERT INTO Ordinateur VALUES
	('27', 'Dell', '0', 'Alienware');
	
INSERT INTO ObjetAffiche VALUES
	('28', 'testUser', 'Lecteur CD', 1, 1, 
	'Lecteur CD', '0', 
	80.00, 0, '1', 'Lecteur');

INSERT INTO Lecteur VALUES
	('28', 'CD', NULL, 'Sony');
	
INSERT INTO ObjetAffiche VALUES
	('29', 'testUser2', 'Lecteur DVD/BR', 1, 
	3, 'Lecteur DVD/BR', '0', 
	245.00, 0, '1', 'Lecteur');

INSERT INTO Lecteur VALUES
	('29', 'DVD/BR', NULL, 'Apple');
	
INSERT INTO ObjetAffiche VALUES
	('30', 'testUser', 'PS4 Pro', 1, 1, 
	'PS4 Pro', '1', 
	399.99, 0, '1', 'Console');

INSERT INTO Console VALUES
	('30', 'PS4 Pro', 'Sony');
	
INSERT INTO ObjetAffiche VALUES
	('31', 'testUser2', 'NES', 1, 
	1, 'NES', '0', 
	75.00, 0, '1', 'Console');

INSERT INTO Console VALUES
	('31', 'NES originale', 'Nintendo');
	
INSERT INTO ObjetAffiche VALUES
	('32', 'testUser', 'Cell1', 1, 1, 
	'Cell1', '0', 
	220.00, 0, '1', 'Cellulaire');

INSERT INTO Cellulaire VALUES
	('32', 'S7', 'Samsung', 2016, '1');
	
INSERT INTO ObjetAffiche VALUES
	('33', 'testUser2', 'Cell2', 1, 
	1, 'Cell2', '0', 
	60.00, 0, '1', 'Cellulaire');

INSERT INTO Cellulaire VALUES
	('33', 'S3', 'Samsung', 2010, '0');
	
INSERT INTO ObjetAffiche VALUES
	('34', 'testUser', 'FFXV', 1, 1, 
	'FFXV', '0', 
	50.00, 0, '1', 'Jeux');

INSERT INTO Jeux VALUES
	('34', 'FFXV', 2017, 'PS4', 'Square Enix');
	
INSERT INTO ObjetAffiche VALUES
	('35', 'testUser2', 'FFXV', 1, 1, 
	'FFXV', '0', 
	45.00, 0, '1', 'Jeux');

INSERT INTO Jeux VALUES
	('35', 'FFXV', 2017, 'Xbox One', 'Square Enix');
	
INSERT INTO ObjetAffiche VALUES
	('36', 'testUser', 'Capitalism', 1, 100, 
	'Capitalism from Jesse Aidyn', '1', 
	0.00, 0, '1', 'CD_DVD_BR');

INSERT INTO CD_DVD_BR VALUES
	('36', 'Capitalism', 2016, 'Jesse Aidyn');
	
INSERT INTO ObjetAffiche VALUES
	('37', 'testUser2', 'Carrie & Lowell', 1, 
	1, 'Carrie & Lowell', '0', 
	10.00, 0, '1', 'CD_DVD_BR');

INSERT INTO CD_DVD_BR VALUES
	('37', 'Carrie & Lowell', 2015, 'Sufjan Stevens');
	
INSERT INTO ObjetAffiche VALUES
	('38', 'testUser', 'Bopbop', 1, 1, 
	'Bouton qui ne fait rien', '0', 
	20.00, 0, '1', 'AutresElectronique');

INSERT INTO AutresElectronique VALUES
	('38', 'Bop bop', NULL, 'Boup');
	
INSERT INTO ObjetAffiche VALUES
	('39', 'testUser2', 'Bipbip', 1, 
	10, 'Bouton qui fait du bruit', '1', 
	1200.00, 0, '1', 'AutresElectronique');

INSERT INTO AutresElectronique VALUES
	('39', 'Bip Bip', NULL, 'Boup');
	
INSERT INTO ObjetAffiche VALUES
	('40', 'testUser', 'Livre1', 1, 1, 
	'Livre1', '1', 
	50.00, 0, '1', 'Livre');

INSERT INTO Livre VALUES
	('40', 'Livre1', 2018, 'Auteur1');
	
INSERT INTO ObjetAffiche VALUES
	('41', 'testUser', 'Livre2', 1, 1, 
	'Livre2', '1', 
	50.00, 0, '1', 'Livre');

INSERT INTO Livre VALUES
	('41', 'Livre2', 2018, 'Auteur2');
	
INSERT INTO ObjetAffiche VALUES
	('42', 'testUser', 'Livre3', 1, 1, 
	'Livre3', '1', 
	50.00, 0, '1', 'Livre');

INSERT INTO Livre VALUES
	('42', 'Livre3', 2018, 'Auteur3');
	
INSERT INTO ObjetAffiche VALUES
	('43', 'testUser', 'Chambre1', 1, 1, 
	'Chambre1', '0', 
	550.00, 30, '1', 'Chambres');

INSERT INTO Chambres VALUES
	('43', '2018-07-01', '2018-06-30', 2);
	
INSERT INTO ObjetAffiche VALUES
	('44', 'testUser', 'Chambre2', 1, 1, 
	'Chambre2', '0', 
	450.00, 30, '1', 'Chambres');

INSERT INTO Chambres VALUES
	('44', '2018-07-01', '2018-06-30', 2);
	
INSERT INTO ObjetAffiche VALUES
	('45', 'testUser2', 'Chambre3', 1, 1, 
	'Chambre3', '0', 
	750.00, 30, '1', 'Chambres');

INSERT INTO Chambres VALUES
	('45', '2018-07-01', NULL, 4);
	
INSERT INTO ObjetAffiche VALUES
	('46', 'testUser', 'Appartement1', 1, 1, 
	'Appartement1', '0', 
	850.00, 30, '1', 'Appartements');

INSERT INTO Appartements VALUES
	('46', '2018-07-01', '2019-06-30', '1', 3.5);
	
INSERT INTO ObjetAffiche VALUES
	('47', 'testUser', 'Appartement2', 1, 1, 
	'Appartement2', '1', 
	1050.00, 30, '1', 'Appartements');

INSERT INTO Appartements VALUES
	('47', '2018-07-01', '2019-06-30', '0', 4.5);
	
INSERT INTO ObjetAffiche VALUES
	('48', 'testUser2', 'Appartement3', 1, 1, 
	'Appartement3', '0', 
	1450.00, 30, '1', 'Appartements');

INSERT INTO Appartements VALUES
	('48', '2018-07-01', '2019-06-30', '1', 6.5);
	
INSERT INTO ObjetAffiche VALUES
	('49', 'testUser', 'Maison1', 1, 1, 
	'Maison1', '0', 
	500000.00, 0, '1', 'Maisons');

INSERT INTO Maisons VALUES
	('49', '2018-07-01', NULL, '0', 10.5);
	
INSERT INTO ObjetAffiche VALUES
	('50', 'testUser', 'Maison2', 1, 1, 
	'Maison2', '0', 
	800000.00, 0, '1', 'Maisons');

INSERT INTO Maisons VALUES
	('50', '2018-07-01', NULL, '0', 10.5);
	
INSERT INTO ObjetAffiche VALUES
	('51', 'testUser2', 'Chateau gigantesque', 1, 1, 
	'Chateau gigantesque', '1', 
	50000000.00, 0, '1', 'Maisons');

INSERT INTO Maisons VALUES
	('51', '2018-07-01', NULL, '1', 90.5);
	
INSERT INTO ObjetAffiche VALUES
	('52', 'testUser', 'Autres1', 1, 1, 
	'Autres1', '1', 
	100.00, 10, '1', 'Autres');

INSERT INTO Autres VALUES
	('52', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('53', 'testUser', 'Autres2', 10, 10, 
	'Autres2', '1', 
	1000.00, 10, '1', 'Autres');

INSERT INTO Autres VALUES
	('53', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('54', 'testUser2', 'Autres3', 100, 1, 
	'Autres3', '1', 
	1000.00, 10, '1', 'Autres');

INSERT INTO Autres VALUES
	('54', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('55', 'testUser', 'Autres4', 1, 1, 
	'Autres4', '1', 
	100.00, 10, '0', 'Autres');

INSERT INTO Autres VALUES
	('55', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('56', 'testUser', 'Autres5', 10, 10, 
	'Autres5', '1', 
	1000.00, 10, '0', 'Autres');

INSERT INTO Autres VALUES
	('56', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('57', 'testUser2', 'Autres6', 100, 1, 
	'Autres6', '1', 
	1000.00, 10, '0', 'Autres');

INSERT INTO Autres VALUES
	('57', 'Autres');
		
		
COMMIT;