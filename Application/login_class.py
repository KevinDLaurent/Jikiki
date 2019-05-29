#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

class LoginWindow(QWidget):

	# Constructor
	def __init__(self, conn):
		super().__init__()
		self.conn = conn

		# Titre de la fenêtre
		self.title_label = QLabel("Jikiki - Login")
		self.title_label.setAlignment(Qt.AlignCenter)

		# Layout pour le formulaire d'identification
		self.user_id_label = QLabel("Nom Utilisateur")
		self.user_pw_label = QLabel("Mot de Passe")
		self.user_id_field = QLineEdit()
		self.user_pw_field = QLineEdit()

		self.login_form_layout = QGridLayout()
		self.login_form_layout.addWidget(self.user_id_label,0,0)
		self.login_form_layout.addWidget(self.user_pw_label,1,0)
		self.login_form_layout.addWidget(self.user_id_field,0,1)
		self.login_form_layout.addWidget(self.user_pw_field,1,1)
		self.login_form_widget = QWidget()
		self.login_form_widget.setLayout(self.login_form_layout)

		# Label pour le message d'identification
		self.login_warning_label = QLabel("")

		# Bouton pour se connecter
		self.login_connect_btn = QPushButton("Se Connecter")

		# Bouton pour créer un nouvel utilisateur
		self.login_register_btn = QPushButton("S'Inscrire")

		# Bouton pour quitter l'application
		self.login_quit_btn = QPushButton("Quitter")

		# Layout principal du login window
		self.login_layout = QVBoxLayout()

		# Ajoute les widgets au layout du login
		self.login_layout.addWidget(self.title_label)
		self.login_layout.addWidget(self.login_form_widget)
		self.login_layout.addWidget(self.login_warning_label)
		self.login_layout.addWidget(self.login_connect_btn)
		self.login_layout.addWidget(self.login_register_btn)
		self.login_layout.addWidget(self.login_quit_btn)
		
		self.setLayout(self.login_layout)

	def verify_login(self):
		return op.verify_login(
			self.conn,
			self.user_id_field.text(),
			self.user_pw_field.text())

	def get_user_id(self):
		return self.user_id_field.text()

	def set_warning_label(self, warning):
		self.login_warning_label.setText(warning)