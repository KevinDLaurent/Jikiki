--creation de la base employes 
-- pour executer le script:
-- @baseProjetDDL.sql
--
DROP TABLE Utilisateur;
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
	adressePays VARCHAR(40),
	codePostal VARCHAR(6),
	CHECK (DATE_PART('day', dateNaissance)>=1 AND DATE_PART('day', dateNaissance)<=31),
	CHECK (DATE_PART('month', dateNaissance)>=1 AND DATE_PART('month', dateNaissance)<=12),
	CHECK (DATE_PART('year', dateNaissance)>=1900 AND DATE_PART('year', dateNaissance)<=DATE_PART('year', NOW())),
	CONSTRAINT utilisateurPk PRIMARY KEY (identifiant)
);

CREATE TABLE RecuVente (
	dateVente DATE,
	acheteur VARCHAR(40),
	vendeur VARCHAR(40),
	prix NUMERIC(9,2),
	quantite INT,
	CONSTRAINT recuVentePk PRIMARY KEY (dateVente, acheteur, vendeur),
	CONSTRAINT recuVenteFk1 FOREIGN KEY (acheteur) 
		REFERENCES Utilisateur(identifiant) ON DELETE SET NULL,
	CONSTRAINT recuVenteFk2 FOREIGN KEY (vendeur) 
		REFERENCES Utilisateur(identifiant) ON DELETE SET NULL
);

CREATE TABLE RecuEmprunt (
	dateEmprunt DATE,
	dateRemise DATE,
	preteur VARCHAR(40),
	empruteur VARCHAR(40),
	prix NUMERIC(9,2),
	quantite INT,
	statut BIT NOT NULL,
	CHECK (dateRemise >= dateEmprunt),
	CONSTRAINT recuEmpruntPk PRIMARY KEY (dateEmprunt, preteur, empruteur),
	CONSTRAINT recuEmpruntFk1 FOREIGN KEY (preteur) 
		REFERENCES Utilisateur(identifiant) ON DELETE SET NULL,
	CONSTRAINT recuEmpruntFk2 FOREIGN KEY (empruteur) 
		REFERENCES Utilisateur(identifiant) ON DELETE SET NULL
);

CREATE TABLE Notifications(
	dateTime TIME CONSTRAINT notificationPK PRIMARY KEY,
	utilisateurId VARCHAR(40),
	objetIdentifiant VARCHAR(40),
	CONSTRAINT notificationsPF1 FOREIGN KEY (utilisateurId) 
		REFERENCES Utilisateur(identifiant) ON DELETE SET NULL
	CONSTRAINT notificationsPF2 FOREIGN KEY (objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE ObjetAffiche (
	identifiant VARCHAR(40) UNIQUE NOT NULL ,
	utilisateurIdentifiant VARCHAR(40) UNIQUE NOT NULL ,
	nom VARCHAR(40),
	quantiteUnitaire VARCHAR(15),
	quantiteDisponible INT NOT NULL CHECK (quantiteDisponible >= 0),
	description VARCHAR(300),
	etat VARCHAR(15),
	prix NUMERIC(9,2),
	dureeEmprunt INT NOT NULL CHECK (dureeEmprunt >= 0),
	contacts VARCHAR(100),
	adresseNumero VARCHAR(40),
	adresseRue VARCHAR(40),
	adresseVille VARCHAR(40),
	adressePays VARCHAR(40),
	affichable BIT NOT NULL,
	instance VARCHAR(40),
	CONSTRAINT bijouxMontresPK PRIMARY KEY(identifiant),
	CONSTRAINT bijouxMontresPF FOREIGN KEY(utilisateurIdentifiant) 
		REFERENCES Utilisateur(identifiant) ON DELETE SET NULL
);

CREATE TABLE BijouxMontres (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	marque VARCHAR(40),
	materiaux VARCHAR(60),
	CONSTRAINT bijouxMontresPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT bijouxMontresPF FOREIGN KEY(objetIdentifiant) 
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
	CONSTRAINT vetementPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Meubles (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	dimensions VARCHAR(40),
	materiaux VARCHAR(40),
	CONSTRAINT meublesPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT meublesPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);		

CREATE TABLE Nourriture (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	datePeremptionMois VARCHAR(10),
	datePeremptionAnnee INT,
	ingredients VARCHAR(300),
	origine VARCHAR(40),
	CONSTRAINT nourriturePK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT nourriturePF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE VehiculePersonnel (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	kilometrage INT,
	anneeFabrication INT,
	compagnie VARCHAR(40),
	modele VARCHAR(40),
	CONSTRAINT vehiculePersonnelPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT vehiculePersonnelPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Loisirs (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	modele VARCHAR(40),
	anneeFabrication INT,
	compagnie VARCHAR(40),
	CONSTRAINT loisirsPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT loisirsPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE EquipementLourd (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	anneeFabrication INT,
	compagnie VARCHAR(40),
	modele VARCHAR(40),
	CONSTRAINT equipementLourdPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT equipementLourdPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Pieces (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	modele VARCHAR(40),
	compagnie VARCHAR(40),
	CONSTRAINT piecesPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT piecesPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE AutresVehicules (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	CONSTRAINT autresVehiculesPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT autresVehiculesPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

CREATE TABLE Ordinateur (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	compagnie VARCHAR(40),
	portabilite BIT,
	modele VARCHAR(40),
	CONSTRAINT ordinateurPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT ordinateurPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);		
		
CREATE TABLE Lecteur (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	modele VARCHAR(40),
	compagnie VARCHAR(40),
	CONSTRAINT lecteurPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT lecteurPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);	
		
CREATE TABLE Console (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	modele VARCHAR(40),
	compagnie VARCHAR(40),
	CONSTRAINT consolePK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT consolePF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Cellulaire (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	modele VARCHAR(40),
	compagnie VARCHAR(40),
	annee INT,
	forfaitInclus BIT,
	CONSTRAINT cellulairePK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT cellulairePF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Jeux (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	titre VARCHAR(40),
	annee INT,
	console VARCHAR(40),
	developpeur VARCHAR(40),
	CONSTRAINT jeuxPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT jeuxPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE CD_DVD_BR (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	titre VARCHAR(40),
	annee INT,
	auteurs VARCHAR(100),
	CONSTRAINT CD_DVD_BRPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT CD_DVD_BRPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE AutresElectronique (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	modele VARCHAR(40),
	compagnie VARCHAR(40),
	CONSTRAINT autresElectroniquePK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT autresElectroniquePF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Livre (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	titre VARCHAR(40),
	annee INT,
	auteurs VARCHAR(100),
	CONSTRAINT livrePK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT livrePF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Chambres (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	dateDisponible DATE NOT NULL,
	dateFinLocation DATE,
	nbLocataires INT,
	CONSTRAINT chambresPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT chambresPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Appartements (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	dateDisponible DATE NOT NULL,
	dateFinLocation DATE,
	meublesInclus BIT,
	nbPieces NUMERIC(2,1),
	CONSTRAINT appartementsPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT appartementsPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Maisons (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	dateDisponible DATE NOT NULL,
	dateFinLocation DATE,
	meublesInclus BIT,
	nbPieces NUMERIC(2,1),
	CONSTRAINT maisonsPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT maisonsPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);
		
CREATE TABLE Autres (
	objetIdentifiant VARCHAR(40) UNIQUE NOT NULL,
	typeOb VARCHAR(40),
	CONSTRAINT autresPK PRIMARY KEY(objetIdentifiant),
	CONSTRAINT autresPF FOREIGN KEY(objetIdentifiant) 
		REFERENCES ObjetAffiche(identifiant) ON DELETE SET NULL
);

INSERT INTO Utilisateur VALUES
    ('testUser', 'John', 'Doe', 'nomail@gmail.com', '1234',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');

INSERT INTO Utilisateur VALUES
    ('testUser2', 'Jane', 'Doe', 'nomail2@gmail.com', '1234',
     '2018-04-26', '300', 'av. Montroyal', 'Montréal', 'Québec',
     'H1S1A1');
	 
	 

INSERT INTO ObjetAffiche VALUES
	('1', 'testUser', 'Montre en or ROLEX', '1 montre', 1, 
	'Montre toujours dans sa boite dorigine, 18 carats', 'neuf', 
	550.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'BijouxMontres');

INSERT INTO BijouxMontres VALUES
	('1', 'Montres', 'ROLEX', 'Or 8 carats');
	
INSERT INTO ObjetAffiche VALUES
	('2', 'testUser', 'Coffre a bijoux', '1 coffre', 1, 
	'Ensemble de bijoux variés', 'usage', 
	80.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'BijouxMontres');

INSERT INTO BijouxMontres VALUES
	('2', 'Varie', 'Varie', 'Varie');
	
INSERT INTO ObjetAffiche VALUES
	('3', 'testUser2', 'Collier de perles fait a la main', '1 collier', 
	10, 'Collier fait a la main', 'neuf', 
	12.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'BijouxMontres');

INSERT INTO BijouxMontres VALUES
	('3', 'Collier', NULL, 'Fausses perles');
	
INSERT INTO ObjetAffiche VALUES
	('4', 'testUser', 'Perceuse electrique', '1 perceuse', 1, 
	'Perceuse electriques avec bolts inclus', 'presque neuf', 
	10.00, 7, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Outils');

INSERT INTO Outils VALUES
	('4', 'Construction');
	
INSERT INTO ObjetAffiche VALUES
	('5', 'testUser', 'Coffre a outils', '1 coffre', 1, 
	'Coffre a outils de garage', 'presque neuf', 
	45.00, 14, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Outils');

INSERT INTO Outils VALUES
	('5', 'Garage');
	
INSERT INTO ObjetAffiche VALUES
	('6', 'testUser2', 'Souffleuse neuve', '1 souffleuse', 
	5, 'Souffleuse de marque, haute performance', 'neuf', 
	499.99, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Outils');

INSERT INTO Outils VALUES
	('6', 'Entretien exterieur');
	
INSERT INTO ObjetAffiche VALUES
	('7', 'testUser', 'Pull noir', '1 pull', 1, 
	'Un pull tres peu porte', 'presque neuf', 
	15.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Vetement');

INSERT INTO Vetement VALUES
	('7', 'Medium', 'Chandails', 'Urban B', 'Coton');
	
INSERT INTO ObjetAffiche VALUES
	('8', 'testUser', 'Ensemble formel', '1 ensemble', 1, 
	'Chemise, veste et pantalons formels', 'usage', 
	70.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Vetement');

INSERT INTO Vetement VALUES
	('8', 'Small', 'Complet', 'Gucci', 'Coton');
	
INSERT INTO ObjetAffiche VALUES
	('9', 'testUser2', 'Linge varie a donner', '1 morceau', 
	80, 'Contactez pour details', 'usage', 
	0.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Vetement');

INSERT INTO Vetement VALUES
	('9', 'Varie', 'Varie', 'Varie', 'Varie');
	
INSERT INTO ObjetAffiche VALUES
	('10', 'testUser', 'Horloge grand-pere', '1 horloge', 1, 
	'Grande horloge fonctionnelle', 'usage', 
	150.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Meubles');
	
INSERT INTO Meubles VALUES
	('10', 'Meubles', '50 x 50 x 170', 'bois');
	
INSERT INTO ObjetAffiche VALUES
	('11', 'testUser', 'Coffre en bois', '1 coffre', 1, 
	'Coffre en bois avec cadenas', 'presque neuf', 
	35.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Meubles');

INSERT INTO Meubles VALUES
	('11', 'Meubles', '30 x 40 x 55', 'Bois');
	
INSERT INTO ObjetAffiche VALUES
	('12', 'testUser2', 'Ensemble pour salle a manger', '1 ensemble', 
	10, '1 table et 6 chaises', 'usage', 
	65.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Meubles');

INSERT INTO Meubles VALUES
	('12', 'Salle a manger', NULL, 'Bois');
	
INSERT INTO ObjetAffiche VALUES
	('13', 'testUser2', 'Bouffe a chat', '1 canne', 
	12, 'Delicieux avec vin blanc', 'neuf', 
	8.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Nourriture');

INSERT INTO Nourriture VALUES
	('13', 'Dejeuner', '06/2018', 'Rats broyes', 'Montreal');
	
INSERT INTO ObjetAffiche VALUES
	('14', 'testUser', 'Pain vieilli', '1 pain', 20, 
	'Pain vieilli sur le comptoir', 'usage', 
	10.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Nourriture');
	
INSERT INTO Nourriture VALUES
	('14', 'Experience bacteriologique', '01/2016', 'pain, organismes varies', 
	'Montreal');
	
INSERT INTO ObjetAffiche VALUES
	('15', 'testUser', 'Patisseries a donner', '1 patisserie', 100, 
	'Contactez pour details', NULL, 
	5.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Nourriture');

INSERT INTO Nourriture VALUES
	('15', 'Nourriture', NULL, 'Varie', 'Montreal');
	
INSERT INTO ObjetAffiche VALUES
	('16', 'testUser', 'Vehicule1', '1 voiture', 1, 
	'Vehicule', 'usage', 
	4500.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'VehiculePersonnel');

INSERT INTO VehiculePersonnel VALUES
	('16', 75000, 2010, 'Charcomp', 'M1');
	
INSERT INTO ObjetAffiche VALUES
	('17', 'testUser2', 'Vehicule2', '1 voiture', 
	1, 'Collier fait a la main', 'presque neuf', 
	60.00, 1, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'VehiculePersonnel');

INSERT INTO VehiculePersonnel VALUES
	('17', 10000, 2017, 'Charcomp', 'M2');
	
INSERT INTO ObjetAffiche VALUES
	('18', 'testUser', 'Vehicule3', '1 vehicule', 1, 
	'Vehicule3', 'neuf', 
	6500.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Loisirs');

INSERT INTO Loisirs VALUES
	('18', 'M3', 2015, 'Charlois');
	
INSERT INTO ObjetAffiche VALUES
	('19', 'testUser2', 'Vehicule4', '1 vehicule', 
	2, 'Vehicule4', 'usage', 
	120.00, 1, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Loisirs');

INSERT INTO Loisirs VALUES
	('19', 'M4', 2016, 'Charlois');
	
INSERT INTO ObjetAffiche VALUES
	('20', 'testUser', 'Vehicule5', '1 vehicule', 1, 
	'Vehicule lourd', 'neuf', 
	500.00, 7, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'EquipementLourd');

INSERT INTO EquipementLourd VALUES
	('20', 2010, 'Charlour', 'M5');
	
INSERT INTO ObjetAffiche VALUES
	('21', 'testUser2', 'Vehicule6', '1 vehicule', 
	1, 'Vehicule6', 'usage', 
	12500.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'EquipementLourd');

INSERT INTO EquipementLourd VALUES
	('21', 2008, 'Charlour', 'M6');
	
INSERT INTO ObjetAffiche VALUES
	('22', 'testUser', 'Pieces de garage', '1 ensemble', 1, 
	'Ensemble de pieces variees', 'usage', 
	200.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Pieces');

INSERT INTO Pieces VALUES
	('22', NULL, 'CT');
	
INSERT INTO ObjetAffiche VALUES
	('23', 'testUser2', 'Pneus dhiver', '4 pneus', 
	10, 'Pneus dhiver a clous', 'presque neuf', 
	80.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Pieces');

INSERT INTO Pieces VALUES
	('23', 'Mspec', 'Mich');
	
INSERT INTO ObjetAffiche VALUES
	('24', 'testUser', 'Traineau du Pere-Noel', '1 ensemble', 1, 
	'Traineau et renes domestiques', 'usage', 
	25000.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'AutresVehicules');

INSERT INTO AutresVehicule VALUES
	('24', 'Noel');
	
INSERT INTO ObjetAffiche VALUES
	('25', 'testUser2', 'Toothless', '1 dragon', 
	1, 'Dragon rapide et dangereux', 'neuf', 
	150000.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'AutresVehicule');

INSERT INTO AutresVehicule VALUES
	('25', 'Animaux');
	
INSERT INTO ObjetAffiche VALUES
	('26', 'testUser', 'MSI Portable', '1 ordinateur', 1, 
	'MSI portable', 'usage', 
	700.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Ordinateur');

INSERT INTO Ordinateur VALUES
	('26', 'MSI', 'Portable', 'Stealth Pro');
	
INSERT INTO ObjetAffiche VALUES
	('27', 'testUser2', 'Tour alienware', '1 ordinateur', 
	1, 'Tour alienware', 'neuf', 
	2400.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Ordinateur');

INSERT INTO Ordinateur VALUES
	('27', 'Dell', 'Non portable', 'Alienware');
	
INSERT INTO ObjetAffiche VALUES
	('28', 'testUser', 'Lecteur CD', '1 lecteur', 1, 
	'Lecteur CD', 'usage', 
	80.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Lecteur');

INSERT INTO Lecteur VALUES
	('28', 'CD', NULL, 'Sony');
	
INSERT INTO ObjetAffiche VALUES
	('29', 'testUser2', 'Lecteur DVD/BR', '1 lecteur', 
	3, 'Lecteur DVD/BR', 'presque neuf', 
	245.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Lecteur');

INSERT INTO Lecteur VALUES
	('29', 'DVD/BR', NULL, 'Apple');
	
INSERT INTO ObjetAffiche VALUES
	('30', 'testUser', 'PS4 Pro', '1 console', 1, 
	'PS4 Pro', 'neuf', 
	399.99, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Console');

INSERT INTO Console VALUES
	('30', 'PS4 Pro', 'Sony');
	
INSERT INTO ObjetAffiche VALUES
	('31', 'testUser2', 'NES', '1 console', 
	1, 'NES', 'usage', 
	75.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Console');

INSERT INTO Console VALUES
	('31', 'NES originale', 'Nintendo');
	
INSERT INTO ObjetAffiche VALUES
	('32', 'testUser', 'Cell1', '1 appareil', 1, 
	'Cell1', 'usage', 
	220.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Cellulaire');

INSERT INTO Cellulaire VALUES
	('32', 'S7', 'Samsung', 2016, 1);
	
INSERT INTO ObjetAffiche VALUES
	('33', 'testUser2', 'Cell2', '1 appareil', 
	1, 'Cell2', 'usage', 
	60.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Cellulaire');

INSERT INTO Cellulaire VALUES
	('33', 'S3', 'Samsung', 2010, 0);
	
INSERT INTO ObjetAffiche VALUES
	('34', 'testUser', 'FFXV', '1 jeu', 1, 
	'FFXV', 'usage', 
	50.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Jeux');

INSERT INTO Jeux VALUES
	('34', 'FFXV', 2017, 'PS4', 'Square Enix');
	
INSERT INTO ObjetAffiche VALUES
	('35', 'testUser2', 'FFXV', '1 jeu', 1, 
	'FFXV', 'usage', 
	45.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'Jeux');

INSERT INTO Jeux VALUES
	('35', 'FFXV', 2017, 'Xbox One', 'Square Enix');
	
INSERT INTO ObjetAffiche VALUES
	('36', 'testUser', 'Capitalism', '1 CD', 100, 
	'Capitalism from Jesse Aidyn', 'neuf', 
	0.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'CD_DVD_BR');

INSERT INTO CD_DVD_BR VALUES
	('36', 'Capitalism', 2016, 'Jesse Aidyn');
	
INSERT INTO ObjetAffiche VALUES
	('37', 'testUser2', 'Carrie & Lowell', '1 CD', 
	1, 'Carrie & Lowell', 'usage', 
	10.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'CD_DVD_BR');

INSERT INTO CD_DVD_BR VALUES
	('37', 'Carrie & Lowell', 2015, 'Sufjan Stevens');
	
INSERT INTO ObjetAffiche VALUES
	('38', 'testUser', 'Bopbop', '1 bouton', 1, 
	'Bouton qui ne fait rien', 'usage', 
	20.00, 0, '555-555-5555', '300', 'av. Montroyal', 
	'Montréal', 'Québec', 1, 'AutresElectronique');

INSERT INTO AutresElectronique VALUES
	('38', 'Bop bop', NULL, 'Boup');
	
INSERT INTO ObjetAffiche VALUES
	('39', 'testUser2', 'Bipbip', '1 bouton', 
	10, 'Bouton qui fait du bruit', 'neuf', 
	1200.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'AutresElectronique');

INSERT INTO AutresElectronique VALUES
	('39', 'Bip Bip', NULL, 'Boup');
	
INSERT INTO ObjetAffiche VALUES
	('40', 'testUser', 'Livre1', '1 livre', 1, 
	'Livre1', 'neuf', 
	50.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Livre');

INSERT INTO Livre VALUES
	('41', 'Livre1', 2018, 'Auteur1');
	
INSERT INTO ObjetAffiche VALUES
	('41', 'testUser', 'Livre2', '1 livre', 1, 
	'Livre2', 'neuf', 
	50.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Livre');

INSERT INTO Livre VALUES
	('41', 'Livre2', 2018, 'Auteur2');
	
INSERT INTO ObjetAffiche VALUES
	('42', 'testUser', 'Livre3', '1 livre', 1, 
	'Livre3', 'neuf', 
	50.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Livre');

INSERT INTO Livre VALUES
	('42', 'Livre3', 2018, 'Auteur3');
	
INSERT INTO ObjetAffiche VALUES
	('43', 'testUser', 'Chambre1', '1 chambre', 1, 
	'Chambre1', NULL, 
	550.00, 30, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Chambres');

INSERT INTO Chambres VALUES
	('43', '2018-07-01', '2018-06-30', 2);
	
INSERT INTO ObjetAffiche VALUES
	('44', 'testUser', 'Chambre2', '1 chambre', 1, 
	'Chambre2', NULL, 
	450.00, 30, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Chambres');

INSERT INTO Chambres VALUES
	('44', '2018-07-01', '2018-06-30', 2);
	
INSERT INTO ObjetAffiche VALUES
	('45', 'testUser2', 'Chambre3', '1 chambre', 1, 
	'Chambre3', NULL, 
	750.00, 30, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Chambres');

INSERT INTO Chambres VALUES
	('45', '2018-07-01', NULL, 4);
	
INSERT INTO ObjetAffiche VALUES
	('46', 'testUser', 'Appartement1', '1 appartement', 1, 
	'Appartement1', NULL, 
	850.00, 30, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Appartements');

INSERT INTO Appartements VALUES
	('46', '2018-07-01', '2019-06-30', 1, 3.5);
	
INSERT INTO ObjetAffiche VALUES
	('47', 'testUser', 'Appartement2', '1 appartement', 1, 
	'Appartement2', NULL, 
	1050.00, 30, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Appartements');

INSERT INTO Appartements VALUES
	('47', '2018-07-01', '2019-06-30', 0, 4.5);
	
INSERT INTO ObjetAffiche VALUES
	('48', 'testUser2', 'Appartement3', '1 appartement', 1, 
	'Appartement3', NULL, 
	1450.00, 30, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Appartements');

INSERT INTO Appartements VALUES
	('48', '2018-07-01', '2019-06-30', 1, 6.5);
	
INSERT INTO ObjetAffiche VALUES
	('49', 'testUser', 'Maison1', '1 maison', 1, 
	'Maison1', NULL, 
	500000.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Maisons');

INSERT INTO Maisons VALUES
	('49', '2018-07-01', NULL, 10.5);
	
INSERT INTO ObjetAffiche VALUES
	('50', 'testUser', 'Maison2', '1 maison', 1, 
	'Maison2', NULL, 
	800000.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Maisons');

INSERT INTO Maisons VALUES
	('50', '2018-07-01', NULL, 10.5);
	
INSERT INTO ObjetAffiche VALUES
	('51', 'testUser2', 'Chateau gigantesque', '1 maison', 1, 
	'Chateau gigantesque', NULL, 
	50000000.00, 0, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Maisons');

INSERT INTO Maisons VALUES
	('51', '2018-07-01', NULL, 90.5);
	
INSERT INTO ObjetAffiche VALUES
	('52', 'testUser', 'Autres1', '1 chose', 1, 
	'Autres1', 'neuf', 
	100.00, 10, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Autres');

INSERT INTO Autres VALUES
	('52', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('53', 'testUser', 'Autres2', '10 chose', 10, 
	'Autres2', 'neuf', 
	1000.00, 10, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Autres');

INSERT INTO Autres VALUES
	('53', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('54', 'testUser2', 'Autres3', '100 chose', 1, 
	'Autres3', 'neuf', 
	1000.00, 10, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 1, 'Autres');

INSERT INTO Autres VALUES
	('54', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('55', 'testUser', 'Autres4', '1 chose', 1, 
	'Autres4', 'neuf', 
	100.00, 10, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 0, 'Autres');

INSERT INTO Autres VALUES
	('55', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('56', 'testUser', 'Autres5', '10 chose', 10, 
	'Autres5', 'neuf', 
	1000.00, 10, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 0, 'Autres');

INSERT INTO Autres VALUES
	('56', 'Autres');
	
INSERT INTO ObjetAffiche VALUES
	('57', 'testUser2', 'Autres6', '100 chose', 1, 
	'Autres6', 'neuf', 
	1000.00, 10, '555-555-5555', '300', 'av. Montroyal', 'Montréal',
	'Québec', 0, 'Autres');

INSERT INTO Autres VALUES
	('57', 'Autres');
	
		
COMMIT;






