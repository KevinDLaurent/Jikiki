#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

class MenuWindow(QWidget):

	# Constructor
	def __init__(self, conn):
		super().__init__()
		self.conn = conn
		self.user_id = None

		# Titre de la fenêtre
		self.title_label = QLabel("Jikiki - Menu")
		self.title_label.setAlignment(Qt.AlignCenter)
		
		# Label welcome
		self.welcome_label = QLabel()
		self.welcome_label.setAlignment(Qt.AlignCenter)

		# Bouton Magasiner
		self.menu_shop_btn = QPushButton("Magasiner")

		# Bouton Créer une affiche
		self.menu_advertise_btn = QPushButton("Créer une annonce")

		# Bouton Historique
		self.menu_history_btn = QPushButton("Historique")

		# Bouton pour quitter l'application
		self.menu_quit_btn = QPushButton("Quitter")

		# Layout principal du menu window
		self.menu_layout = QVBoxLayout()

		# Ajoute les widgets au layout du menu
		self.menu_layout.addWidget(self.title_label)
		self.menu_layout.addWidget(self.welcome_label)
		self.menu_layout.addWidget(self.menu_shop_btn)
		self.menu_layout.addWidget(self.menu_advertise_btn)
		self.menu_layout.addWidget(self.menu_history_btn)
		self.menu_layout.addWidget(self.menu_quit_btn)
		
		self.setLayout(self.menu_layout)

	# Set l'identifiant et set le welcome label
	def set_user_id(self, user_id):
		self.user_id = user_id
		self.welcome_label.setText("Bienvenue "+self.user_id+"!")