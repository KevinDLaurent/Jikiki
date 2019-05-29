#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import dictionary as di


class FormWidget(QWidget):

	def __init__(self, label="", instruction="", field_list=[]):
		super().__init__()

		self.title_label = None
		self.field_layout = None
		self.form_group_box = None
		self.form_layout = None
		self.set_form_items(label,instruction,field_list)


	def set_form_items(self, label, instruction, field_list):

		QObjectCleanupHandler().add(self.title_label)
		QObjectCleanupHandler().add(self.field_layout)
		QObjectCleanupHandler().add(self.form_group_box)
		QObjectCleanupHandler().add(self.form_layout)

		self.title_label = QLabel(label)
		self.form_group_box = QGroupBox(instruction)
		self.field_layout = QFormLayout()

		for f in field_list:
			#field_type = self.get_field_type(f[1])
			self.field_layout.addRow(QLabel(f[0]), f[1])

		self.form_group_box.setLayout(self.field_layout)

		self.form_layout = QVBoxLayout()
		self.form_layout.addWidget(self.title_label)
		self.form_layout.addWidget(self.form_group_box)
		
		self.setLayout(self.form_layout)


	# Retourne toute les entrées du formulaire dans une liste de strings
	def get_form_items(self, bool_raw):

		# bool_raw : si on retourne le texte ou l'index d'un combobox
		form_items = []

		for i in range(self.field_layout.rowCount()):

			text = self.get_form_item(i,bool_raw)

			#if(type(text)==str):
			#	text = "\'" + text + "\'"
			form_items.append(text)

		return form_items


	def get_form_item(self, pos, bool_raw):

		widget_type = type(self.field_layout.itemAt(pos,1).widget())

		if(widget_type is QComboBox):
			if(bool_raw):
				text = self.field_layout.itemAt(pos,1).widget().currentIndex()
			else:
				text = self.field_layout.itemAt(pos,1).widget().currentText()
		elif(widget_type is QTextEdit):
			text = self.field_layout.itemAt(pos,1).widget().toPlainText()
		elif(widget_type is QSpinBox):
			text = self.field_layout.itemAt(pos,1).widget().value()
		elif(widget_type is QCheckBox):
			check = self.field_layout.itemAt(pos,1).widget().isChecked()
			if(check):
				text = '1'
			else:
				text = '0'
		else:
			text = self.field_layout.itemAt(pos,1).widget().text()

		return text