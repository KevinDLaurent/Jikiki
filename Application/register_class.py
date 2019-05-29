#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

from form_class import *


class RegisterWindow(QWidget):

	# Constructor
	def __init__(self, conn):
		super().__init__()
		self.conn = conn

		# Titre de la fenêtre
		self.title_label = QLabel("Jikiki - Enregistrement Nouvel Utilisateur")
		self.title_label.setAlignment(Qt.AlignCenter)

		# Layout pour le formulaire d'identification

		# Trouve la liste des pays disponible pour l'application dans la BD
		province_list = op.get_enum(self.conn, "province")

		ProvinceComboBox = QComboBox()
		ProvinceComboBox.addItems(list(province_list))

		# Forme le formulaire avec les différents champs
		self.form_group = FormWidget(
			"Formulaire Nouvel Utilisateur",
			"S.V.P. Remplir tout les champs",
			[("Nom Utilisateur", QLineEdit()),
			("Prénom", QLineEdit()),
			("Nom de Famille", QLineEdit()),
			("Courriel", QLineEdit()),
			("Mot de Passe", QLineEdit()),
			("Date de Naissance", QDateEdit()),
			("Adresse Numéro", QLineEdit()),
			("Adresse Rue", QLineEdit()),
			("Adresse Ville", QLineEdit()),
			("Adresse Province", ProvinceComboBox),
			("Code Postal", QLineEdit())])

		self.warning_label = QLabel()

		self.confirm_btn = QPushButton("Confirmer")
		self.cancel_btn = QPushButton("Annuler")

		self.register_layout = QVBoxLayout()
		self.register_layout.addWidget(self.title_label)
		self.register_layout.addWidget(self.form_group)
		self.register_layout.addWidget(self.warning_label)
		self.register_layout.addWidget(self.confirm_btn)
		self.register_layout.addWidget(self.cancel_btn)

		self.setLayout(self.register_layout)


		# Set Button listener
		self.confirm_btn.clicked.connect(
			lambda:self.create_new_user())


	def get_register_form(self):

		return self.form_group.get_form_items(False)

	# Ajoute un nouvel utilisateur à la base de donnée
	def create_new_user(self):

		infos_user = self.form_group.get_form_items(False)
		result = op.add_user(self.conn, infos_user)

		# Vérifie le code de retour pour savoir si le user a bien été ajouté
		if(result == -1):
			self.warning_label.setText("Nom d'Utilisateur déjà utilisé")
			return
		if(result == -2):
			self.warning_label.setText("Courriel déjà utilisé")
			return
		else:
			self.cancel_btn.click()
