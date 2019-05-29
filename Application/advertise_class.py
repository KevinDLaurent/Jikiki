from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import operations as op
import dictionary as di

from form_class import *

class AdvertiseWindow(QWidget):

	# Constructor
	def __init__(self, conn):
		super().__init__()
		self.conn = conn
		self.user_id = None

		# Titre de la fenêtre
		self.title_label = QLabel("Jikiki - Créer une annonce")
		self.title_label.setAlignment(Qt.AlignCenter)

		self.advertise_btn = QPushButton("Créer l\'annonce")
		self.advertise_back_btn = QPushButton("Revenir au menu")

		# Formulaire objet affiche
		self.nomBox = QLineEdit()
		self.descBox = QTextEdit()
		etatComboBox = QComboBox()
		etatComboBox.addItems(["usagé","neuf"])

		prixSpinBox = QSpinBox()
		prixSpinBox.setRange(0,999999)

		self.type_list = op.get_enum(self.conn, "typeObjet")
		type_l = ["-choisir-"] + [di.dict_sql[t] for t  in self.type_list]
		self.typeComboBox = QComboBox()
		self.typeComboBox.addItems(type_l)

		self.form_object = FormWidget(
			"Création d'une annonce",
			"S.V.P. Remplir tout les champs",
			[("Nom de l'objet", self.nomBox),
			("Quantité Unitaire", self.spin_box(1)),
			("Quantité Disponible", self.spin_box(1)),
			("Description (max 300 char)", self.descBox),
			("État", etatComboBox),
			("Prix", prixSpinBox),
			("Durée de l'emprunt (en jours)\n(0 si vente)", self.spin_box(0)),
			("Type de l'objet", self.typeComboBox)])

		# Formulaire spécifique au type
		self.form_object_detail = FormWidget()


		self.warning_label = QLabel()

		# Layout de la fenêtre
		self.advertise_layout = QVBoxLayout()
		self.advertise_layout.addWidget(self.title_label)
		self.advertise_layout.addWidget(self.form_object)
		self.advertise_layout.addWidget(self.form_object_detail)
		self.advertise_layout.addWidget(self.warning_label)
		self.advertise_layout.addWidget(self.advertise_btn)
		self.advertise_layout.addWidget(self.advertise_back_btn)

		self.setLayout(self.advertise_layout)


		# Set Button Listener
		self.advertise_btn.clicked.connect(
			lambda:self.advertise_object())
		self.typeComboBox.activated.connect(
			self.set_type_form)


	def spin_box(self, min):
		spin = QSpinBox()
		spin.setRange(min,999999)
		return spin


	def set_type_form(self, index):

		if(index == 0):
			self.form_object_detail.set_form_items("","",[])
			return

		form = op.get_table_form(self.conn, self.type_list[index-1])
		self.form_object_detail.set_form_items("Détails de l'objet","",form[1:])


	def advertise_object(self):

		if(self.typeComboBox.currentIndex() == 0):
			self.warning_label.setText("Vous devez choisir un type")
			return

		# Trouve le type de l'objet
		object_type = self.form_object.get_form_item(7,True)
		object_type = self.type_list[object_type-1]

		# Object Affiche form values
		obj_affiche = self.form_object.get_form_items(True)
		obj_affiche = [self.user_id] + obj_affiche[:-1] + ['1'] + [object_type]
		# cast état
		obj_affiche[5] = str(obj_affiche[5])

		# Object Type form values
		obj_type = self.form_object_detail.get_form_items(True)

		print(str(tuple(obj_affiche)))
		print(str(tuple(obj_type)))

		values = [obj_affiche, obj_type]

		op.add_item(self.conn, object_type, values)

		self.reset_form()
		self.warning_label.setText("Objet annoncé avec succès!")


	def reset_form(self):

		self.typeComboBox.setCurrentIndex(0)
		self.nomBox.setText("")
		self.descBox.setPlainText("")
		self.form_object_detail.set_form_items("","",[])


	# Definit l'identifiant de l'utilisateur
	def set_user_id(self, user_id):
		self.user_id = user_id