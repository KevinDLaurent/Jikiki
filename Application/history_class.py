from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

class HistoryWindow(QWidget):

	# Constructor
	def __init__(self, conn):
		super().__init__()
		self.conn = conn
		self.user_id = None

		# Titre de la fenêtre
		self.title_label = QLabel("Jikiki - Historique")
		self.title_label.setAlignment(Qt.AlignCenter)
		self.spacer = QLabel("")

		# Paramètre de recherche utilisateur
		self.hist_borrow_chk = QCheckBox("Reçus emprunts")
		self.hist_buy_chk = QCheckBox("Reçus achats")
		self.hist_sell_chk = QCheckBox("Reçus ventes")
		self.hist_lend_chk = QCheckBox("Reçus prêts")

		self.hist_search_btn = QPushButton("Rechercher")
		self.hist_back_btn = QPushButton("Revenir au menu")

		self.hist_param_layout = QVBoxLayout()
		self.hist_param_layout.addWidget(self.title_label)
		self.hist_param_layout.addWidget(self.hist_borrow_chk)
		self.hist_param_layout.addWidget(self.hist_buy_chk)
		self.hist_param_layout.addWidget(self.hist_sell_chk)
		self.hist_param_layout.addWidget(self.hist_lend_chk)
		self.hist_param_layout.addWidget(self.spacer)
		self.hist_param_layout.addWidget(self.hist_search_btn)
		self.hist_param_layout.addWidget(self.hist_back_btn)

		self.hist_param_wd = QWidget()
		self.hist_param_wd.setLayout(self.hist_param_layout)

		# Set paramètre par défaut
		self.hist_borrow_chk.setChecked(True)
		self.hist_buy_chk.setChecked(True)
		self.hist_sell_chk.setChecked(True)
		self.hist_lend_chk.setChecked(True)

		# Affichage des objets
		# Table d'affichage
		self.object_table_label = QLabel("Liste des reçus :")
		self.objects_table = QTableWidget()
		# Table colonne et header
		self.objects_table.setColumnCount(8)
		self.objects_table.setHorizontalHeaderLabels(("ID;Nom;Type;Destinataire;Prix;Quantité;Date;Heure").split(";"))

		# Object affichage
		self.object_detail_label = QLabel("Détails de l'objet :")
		self.object_detail = QListWidget()

		self.hist_display_layout = QVBoxLayout()
		self.hist_display_layout.addWidget(self.object_table_label)
		self.hist_display_layout.addWidget(self.objects_table)
		self.hist_display_layout.addWidget(self.object_detail_label)
		self.hist_display_layout.addWidget(self.object_detail)
		self.hist_display_wd = QWidget()
		self.hist_display_wd.setLayout(self.hist_display_layout)

		# Layout de la page
		self.hist_layout = QGridLayout()

		self.hist_layout.addWidget(self.hist_param_wd, 0, 0)
		self.hist_layout.addWidget(self.hist_display_wd, 0, 1)

		self.setLayout(self.hist_layout)

		# Set Button Listener
		self.hist_search_btn.clicked.connect(
			lambda: self.update_table())
		self.objects_table.cellClicked.connect(
			self.update_object_detail)

	def update_table(self):

		self.clear_table()
		self.object_detail.clear()
		self.object_id = None
		self.object_type = None

		# Paramètre de la recherche
		buy = self.hist_buy_chk.isChecked()
		bor = self.hist_borrow_chk.isChecked()
		sell = self.hist_sell_chk.isChecked()
		lend = self.hist_lend_chk.isChecked()
		user = self.user_id

		# On fait une requête à la base de donnée pour la table de recus
		item_list = op.get_recu(
			self.conn,buy, bor, sell, lend, user)

		# Populate la table
		for i in item_list:
			n=0
			self.objects_table.insertRow(n)
			for j in range(8):
				item = QTableWidgetItem(str(i[j]))
				item.setFlags(Qt.ItemIsEnabled)
				self.objects_table.setItem(n, j, item)
			n = n+1

	def clear_table(self):
		while (self.objects_table.rowCount() > 0):
			self.objects_table.removeRow(0)

	def update_object_detail(self, row, column):

		# clear des informations
		self.object_detail.clear()

		# Garde les infos important de l'objet
		self.object_id = self.objects_table.item(row, 0).text()
		self.object_type = self.objects_table.item(row, 2).text()

		# Recherche de l'objet dans la base de données
		item_detail_list = list(op.get_item(
			self.conn,
			self.object_id,
			self.object_type))

		# Affichage des détails de la liste
		item_detail_list = ['- '+' :   '.join(tup) for tup in item_detail_list]
		self.object_detail.addItems(item_detail_list)



	# Definit l'identifiant de l'utilisateur
	def set_user_id(self, user_id):
		self.user_id = user_id