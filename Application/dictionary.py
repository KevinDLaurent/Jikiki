#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op

# Dictionnaire pour l'affichage

dict_sql = {
	# Tables
	'BijouxMontres' : 'Bijoux et montres',
    'Outils' : 'Outils',
    'Vetement' : 'Vêtement',
    'Meubles' : 'Meubles',
    'Nourriture' : 'Nourriture',
    'VehiculePersonnel' : 'Véhicules - personnel',
    'Loisirs'  : 'Véhicules - loisir',
    'EquipementLourd' : 'Véhicules - équipement lourd',
    'Pieces' : 'Véhicules - pièces',
    'AutresVehicules' : 'Véhicules - autres',
    'Ordinateur' : 'Éléctroniques - ordinateur',
    'Lecteur' : 'Éléctroniques - lecteur',
    'Console' : 'Éléctroniques - console',
    'Jeux' : 'Éléctroniques - jeux',
    'Cellulaire' : 'Éléctroniques - cellulaire',
    'CD_DVD_BR' : 'Éléctroniques - CD_DVD_BR',
    'AutresElectronique' : 'Éléctroniques - autres',
    'Livre' : 'Livres',
    'Chambres' : 'Logement - chambres',
    'Appartements' : 'Logement - appartements',
    'Maisons' : 'Logement - maisons',
    'Autres' : 'Autres',

    # Attributs Objets
    'identifiant' : 'ID',
    'utilisateuridentifiant' : 'Vendeur',
    'nom' : 'Nom',
    'quantiteunitaire' : 'Quantité Unitaire',
    'quantitedisponible' : 'Quantité Disponible',
    'description' : 'Description',
    'etat' : 'État',
    'prix' : 'Prix',
    'dureeemprunt' : 'Durée Emprunt',
    'affichable' : 'Affichable',
    'instance' : 'Type',
    'objetidentifiant' : 'ID Objet',
    'typeob' : 'Type de l\'objet',
    'marque' : 'Marque',
    'materiaux' : 'Matériaux',
    'taille' : 'Taille',
    'dimensions' : 'Dimensions',
    'dateperemption' : 'Date de péremption',
    'ingredients' : 'Ingrédients',
    'origine' : 'Origine',
    'kilometrage' : 'Kilométrage',
    'anneefabrication' : 'Année de Fabrication',
    'compagnie' : 'Compagnie',
    'modele' : 'Modèle',
    'portabilite' : 'Portabilité',
    'annee' : 'Année',
    'forfaitinclus' : 'Forfait Inclus',
    'titre' : 'Titre',
    'developpeur' : 'Développeur',
    'auteurs' : 'Auteurs',
    'nblocataires' : 'Nombre de locataire',
    'datedisponible' : 'Date de disponibilité',
    'datefinlocation' : 'Date de fin de location',
    'meublesinclus' : 'Meubles Inclus',
    'nbpieces' : 'Nombre de pièces',
    'console' : 'Console',

    # Attributs User
    'prenom' : 'Prenom',
    'motdepasse' : 'Mot de passe',
    'datenaissance' : 'Date de naissance',
    'courriel' : 'Courriel',
    'adressenumero' : 'Adresse Numéro',
    'adresserue' : 'Adresse Rue',
    'adresseville' : 'Adresse Ville',
    'adresseprovince' : 'Adresse Province',
    'codepostal' : 'Code Postal',

    # Recu de vente
    'dateemprunt' : 'Date de l\'emprunt',
    'dateremise' : 'Date de la remise',
    'vendeur' : 'Vendeur',
    'acheteur' : 'Acheteur',
    'preteur' : 'Prêteur',
    'emprunteur' : 'Emprunteur',
    'quantite' : 'Quantité',
    'statut' : 'Statut'
    }

def dict_type_widget(type_name):

    switcher = {
    'character varying' : QLineEdit(),
    'date' : QDateEdit(),
    'bit' : QCheckBox(),
    'numeric' : QSpinBox(),
    'integer' : QSpinBox()
    }

    widget = switcher.get(type_name, QLineEdit())
    if(type(widget) is QSpinBox):
        widget.setRange(0,999999)

    return widget

