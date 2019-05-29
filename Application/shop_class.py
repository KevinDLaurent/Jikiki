#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

class ShopWindow(QWidget):

	# Constructor
	def __init__(self, conn):
		super().__init__()
		self.conn = conn
		self.user_id = None

		# Selected Object Param
		self.object_id = None
		self.object_type = None

		# Titre de la fenêtre
		self.title_label = QLabel("Jikiki - Magasiner")
		self.title_label.setAlignment(Qt.AlignCenter)

		# Paramètre de recherche utilisateur
		self.shop_borrow_chk = QCheckBox("Emprunt")
		self.shop_buy_chk = QCheckBox("Achat")

		self.price_label = QLabel("Prix")
		self.price_min_label = QLabel("min")
		self.price_max_label = QLabel("max")
		self.price_min = QSpinBox()
		self.price_max = QSpinBox()
		self.price_grid = QGridLayout()
		self.price_grid.addWidget(self.price_label,1,0)
		self.price_grid.addWidget(self.price_min_label,0,1)
		self.price_grid.addWidget(self.price_max_label,0,2)
		self.price_grid.addWidget(self.price_min,1,1)
		self.price_grid.addWidget(self.price_max,1,2)
		self.shop_price_wd = QWidget()
		self.shop_price_wd.setLayout(self.price_grid)

		self.shop_used_chk = QCheckBox("Usagé")
		self.shop_new_chk = QCheckBox("Nouveau")

		self.type_list = op.get_enum(self.conn, "typeObjet")
		type_l = [di.dict_sql[t] for t  in self.type_list]
		self.shop_type_list = QComboBox()
		self.shop_type_list.addItems(type_l)

		self.shop_search_btn = QPushButton("Rechercher")
		self.shop_back_btn = QPushButton("Revenir au menu")

		self.shop_param_layout = QVBoxLayout()
		self.shop_param_layout.addWidget(self.title_label)
		self.shop_param_layout.addWidget(self.shop_borrow_chk)
		self.shop_param_layout.addWidget(self.shop_buy_chk)
		self.shop_param_layout.addWidget(self.shop_price_wd)
		self.shop_param_layout.addWidget(self.shop_used_chk)
		self.shop_param_layout.addWidget(self.shop_new_chk)
		self.shop_param_layout.addWidget(self.shop_type_list)
		self.shop_param_layout.addWidget(self.shop_search_btn)
		self.shop_param_layout.addWidget(self.shop_back_btn)

		self.shop_param_wd = QWidget()
		self.shop_param_wd.setLayout(self.shop_param_layout)

		# Set paramètre par défaut
		self.shop_borrow_chk.setChecked(True)
		self.shop_buy_chk.setChecked(True)
		self.shop_used_chk.setChecked(True)
		self.shop_new_chk.setChecked(True)

		self.price_min.setRange(0,999998)
		self.price_min.setValue(0)
		self.price_max.setRange(0,999999)
		self.price_max.setValue(999999)

		# Affichage des objets
		# Table d'affichage
		self.object_table_label = QLabel("Liste des objets :")
		self.objects_table = QTableWidget()

		# Object affichage
		self.object_detail_label = QLabel("Détails de l'objet :")
		self.object_detail = QListWidget()

		# Label de transaction
		self.transaction_label = QLabel()

		# Buy / Borrow Button
		self.shop_buy_qt = QSpinBox()
		self.shop_bb_btn = QPushButton("Acheter / Emprunter")
		self.shop_bb_btn.close()

		self.shop_display_layout = QVBoxLayout()
		self.shop_display_layout.addWidget(self.object_table_label)
		self.shop_display_layout.addWidget(self.objects_table)
		self.shop_display_layout.addWidget(self.object_detail_label)
		self.shop_display_layout.addWidget(self.object_detail)
		self.shop_display_layout.addWidget(self.transaction_label)
		self.shop_display_layout.addWidget(self.shop_buy_qt)
		self.shop_display_layout.addWidget(self.shop_bb_btn)
		self.shop_display_wd = QWidget()
		self.shop_display_wd.setLayout(self.shop_display_layout)

		# Layout de la page
		self.shop_layout = QGridLayout()

		self.shop_layout.addWidget(self.shop_param_wd, 0,0)
		self.shop_layout.addWidget(self.shop_display_wd, 0,1)

		self.setLayout(self.shop_layout)

		# Set Button Listener
		self.shop_search_btn.clicked.connect(
			lambda:self.update_table())
		self.objects_table.cellClicked.connect(
			self.update_object_detail)
		self.shop_bb_btn.clicked.connect(
			lambda:self.buy_object())


	def update_table(self):

		self.clear_table()
		self.object_detail.clear()
		self.object_id = None
		self.object_type = None

		# Paramètre de la recherche
		pmin = self.price_min.value()
		pmax = self.price_max.value()
		used = self.shop_used_chk.isChecked()
		new = self.shop_new_chk.isChecked()
		buy = self.shop_buy_chk.isChecked()
		bor = self.shop_borrow_chk.isChecked()
		typ = self.type_list[self.shop_type_list.currentIndex()]

		# On fait une requête à la base de donnée
		item_list = op.get_items_list(
			self.conn,bor,buy,pmin,pmax,used,new,typ)

		# Formattage du header
		header = list(item_list[0])
		self.headerList = [di.dict_sql[h] for h in header]
		item_list = list(item_list[1])

		# Table colonne et header
		self.objects_table.setColumnCount(len(self.headerList))
		self.objects_table.setHorizontalHeaderLabels(self.headerList)

		# Populate la table
		for i in range(len(item_list)):
			self.objects_table.insertRow(i)
			for j in range(len(self.headerList)):				
				item = QTableWidgetItem(str(item_list[i][j]))
				item.setFlags(Qt.ItemIsEnabled)
				self.objects_table.setItem(i,j,item)


	def clear_table(self):
		while (self.objects_table.rowCount() > 0):
			self.objects_table.removeRow(0)

	def update_object_detail(self, row, column):

		# clear des informations
		self.transaction_label.setText("")
		self.object_detail.clear()

		# Ajuste le spinbox de quantité
		qt_dispo = int(self.objects_table.item(row, 5).text())
		self.shop_buy_qt.setRange(1, qt_dispo)
		self.shop_buy_qt.setValue(1)

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


	def buy_object(self):
		
		# Si aucun objet sélectionné
		if(self.object_id == None):
			return

		qt = self.shop_buy_qt.value()

		# transaction
		op.transaction(self.conn, self.user_id, self.object_id, self.object_type, qt)
		self.update_table()
		self.transaction_label.setText("Transaction effectuée avec succès!")


	# Definit l'identifiant de l'utilisateur
	def set_user_id(self, user_id):
		self.user_id = user_id