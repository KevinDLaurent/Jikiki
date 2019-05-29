#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

from form_class import *
from login_class import *
from register_class import *
from menu_class import *
from shop_class import *
from advertise_class import *
from history_class import *

#!/usr/bin/python
import psycopg2

class JikikiWindow(QMainWindow):

	# Constructor
	def __init__(self):
		super().__init__()
		self.setWindowTitle("Jikiki")

		# Connection à la base de donnée
		self.conn = psycopg2.connect(
            dbname='kevin',
            user='kevin',
            password='kevin',
            host='localhost',
            port='5432')

		self.conn.set_client_encoding('UTF8')

		#cur = self.conn.cursor()
		#cur.execute('SET search_path TO jikiki')
		#cur.execute('SET search_path TO public')
		#self.conn.commit()

		self.user_id = None


        # Creation des différentes fenêtre de l'application
		self.create_login_widget()
		self.create_register_widget()
		self.create_menu_widget()
		self.create_shop_widget()
		self.create_advertise_widget()
		self.create_history_widget()

		# Ajoute les fenêtre au stacked layout
		self.stacked_layout = QStackedLayout()
		self.stacked_layout.addWidget(self.login_widget)	#0
		self.stacked_layout.addWidget(self.register_widget)	#1
		self.stacked_layout.addWidget(self.menu_widget)		#2
		self.stacked_layout.addWidget(self.shop_widget)		#3
		self.stacked_layout.addWidget(self.advertise_widget)#4
		self.stacked_layout.addWidget(self.history_widget)	#5

		# Initialise la fenêtre initiale
		self.central_widget = QWidget()
		self.central_widget.setLayout(self.stacked_layout)
		self.setCentralWidget(self.central_widget)
		self.stacked_layout.setCurrentIndex(0)

	# Création de la fenêtre du login
	def create_login_widget(self):

		self.login_widget = LoginWindow(self.conn)

		# Ajoute des listener aux boutons
		self.login_widget.login_connect_btn.clicked.connect(
			lambda:self.login())
		self.login_widget.login_register_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(1))
		self.login_widget.login_quit_btn.clicked.connect(
			lambda:self.exit())


	# Création de la fenêtre d'enregistrement de nouveaux utilisateur
	def create_register_widget(self):

		self.register_widget = RegisterWindow(self.conn)

		# Ajoute des listener aux boutons
		self.register_widget.cancel_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(0))

	def create_menu_widget(self):

		self.menu_widget = MenuWindow(self.conn)
		self.menu_widget.resize(500,500)
		self.menu_widget.show()

		# Ajoute des listener aux boutons
		self.menu_widget.menu_shop_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(3))
		self.menu_widget.menu_advertise_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(4))
		self.menu_widget.menu_history_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(5))
		self.menu_widget.menu_quit_btn.clicked.connect(
			lambda:self.exit())

	def create_shop_widget(self):

		self.shop_widget = ShopWindow(self.conn)
		self.shop_widget.setMinimumSize(1300, 500)

		# Ajoute des listener aux boutons
		self.shop_widget.shop_back_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(2))

	def create_advertise_widget(self):

		self.advertise_widget = AdvertiseWindow(self.conn)

		# Ajoute des listener aux boutons
		self.advertise_widget.advertise_back_btn.clicked.connect(
			lambda:self.stacked_layout.setCurrentIndex(2))

	def create_history_widget(self):

		self.history_widget = HistoryWindow(self.conn)

		# Ajoute des listener aux boutons
		self.history_widget.hist_back_btn.clicked.connect(
			lambda: self.stacked_layout.setCurrentIndex(2))
		

	def login(self):
		valid_login = self.login_widget.verify_login()
		if(valid_login):

			# Set l'identifiant de l'utilisateur pour chaque fenêtre
			self.user_id = self.login_widget.get_user_id()
			self.shop_widget.set_user_id(self.user_id)
			self.menu_widget.set_user_id(self.user_id)
			self.advertise_widget.set_user_id(self.user_id)
			self.history_widget.set_user_id(self.user_id)

			# Load la fenêtre du menu
			self.stacked_layout.setCurrentIndex(2)
		else:
			self.login_widget.set_warning_label(
				"Identification invalide.")


	def exit(self):
		sys.exit()


def main():
	jikiki = QApplication(sys.argv)
	jikiki_window = JikikiWindow()
	jikiki_window.show()
	jikiki_window.raise_()
	jikiki.exec_()

if __name__ == '__main__':   
    main()
    sys.exit(app.exec_())