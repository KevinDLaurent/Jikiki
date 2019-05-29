#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from PyQt5.QtWidgets import (QApplication, QWidget, QComboBox, QDialog,
        QDialogButtonBox, QFormLayout, QGridLayout, QGroupBox, QHBoxLayout,
        QLabel, QLineEdit, QMenu, QMenuBar, QPushButton, QSpinBox, QTextEdit,
        QVBoxLayout)
from PyQt5.QtCore import *
import operations as op

#!/usr/bin/python
import psycopg2

class Form_new_user(QDialog):
    NumGridRows = 3
    NumButtons = 4
    
    def __init__(self):
        super(Form_new_user, self).__init__()
        self.createFormGroupBox()
 
        buttonBox = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        buttonBox.accepted.connect(self.accept)
        buttonBox.rejected.connect(self.reject)
 
        mainLayout = QVBoxLayout()
        mainLayout.addWidget(self.formGroupBox)
        mainLayout.addWidget(buttonBox)
        self.setLayout(mainLayout)
 
        self.setWindowTitle("Form Layout - pythonspot.com")
 
    def createFormGroupBox(self):
        self.formGroupBox = QGroupBox("Form layout")
        layout = QFormLayout()
        layout.addRow(QLabel("Name:"), QLineEdit())
        layout.addRow(QLabel("Country:"), QComboBox())
        layout.addRow(QLabel("Age:"), QSpinBox())
        self.formGroupBox.setLayout(layout)


class App(QWidget):

    def __init__(self):
        super().__init__()

        self.window()
        self.loginUI()
        self.conn = psycopg2.connect(
            dbname='larosjon',
            user='larosjon_app',
            password='boyer1234',
            host='postgres.iro.umontreal.ca')

        cur = self.conn.cursor()
        cur.execute('SET search_path TO jikiki')
        self.conn.commit()

    def window(self):
        self.title = 'ObjetSys'
        self.left = 10
        self.top = 10
        self.width = 1000
        self.height = 1000

        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)

        self.grid = QGridLayout()

    def loginUI(self):
        for i in range(self.grid.count()): self.grid.itemAt(i).widget().close()
        # login assets
        self.loginButton = QPushButton('S\'identifier', self)
        self.createButton = QPushButton('Créer un nouveau compte', self)
        self.exitButton = QPushButton('Fermer', self)
        self.ID = QLineEdit(self)
        self.password = QLineEdit(self)
        self.info = QLabel("Bienvenue dans ObjetSys. S'il vous plaît entrer vos informations de connexion", self)
        self.userText = QLabel("Nom d'utilisateur:", self)
        self.passText = QLabel("Mot de passe:", self)
        self.feedback = QLabel("", self)

        self.userText.setAlignment(Qt.AlignCenter)
        self.passText.setAlignment(Qt.AlignCenter)

        self.loginButton.resize(150, 50)
        self.createButton.resize(150, 50)
        self.loginButton.clicked.connect(self.login)
        self.createButton.clicked.connect(self.createProfile)


        self.exitButton.resize(150, 50)
        self.exitButton.clicked.connect(self.exit)

        self.ID.resize(150, 50)
        self.password.resize(150, 50)

        self.grid.setSpacing(30)
        self.grid.setColumnStretch(0, 1)
        self.grid.setColumnStretch(8, 1)
        self.grid.setRowStretch(0, 1)
        self.grid.setRowStretch(8, 1)

        self.grid.addWidget(self.info, 1, 1)
        self.grid.addWidget(self.userText, 2, 0)
        self.grid.addWidget(self.ID, 2, 1)
        self.grid.addWidget(self.passText, 3, 0)
        self.grid.addWidget(self.password, 3, 1)
        self.grid.addWidget(self.feedback, 4, 1)
        self.grid.addWidget(self.loginButton, 5, 1)
        self.grid.addWidget(self.createButton, 6, 1)
        self.grid.addWidget(self.exitButton, 7, 1)

        self.setLayout(self.grid)

        self.show()

    def createProfile(self):

        form = Form_new_user()
        '''QFormLayout *new_user_form = new QFormLayout;

        #profile creation assets
        sefl.identifiant = = QLabel("Nom d'utilisateur:", self)
        self.prenom = QLabel("Prénom:", self)
        self.nom = QLabel("Nom de famille:", self)
        self.courriel = QLabel("Courriel:", self)
        self.password = QLabel("Mot de passe:", self)

        self.dateDeNaissance = QLabel("Date de naissance:", self)
        self.adresseNumero = QLabel("Adresse numéro:", self)
        self.addresseRue = QLabel("Courriel:", self)
        self.addresseVille = QLabel("Mot de passe:", self)

        self.prenom_line = QLineEdit(self)
        self.nom_line = QLineEdit(self)
        self.courriel_line = QLineEdit(self)
        self.password_line = QLineEdit(self)
        self.createButton = QPushButton('Creer', self)
        self.cancelButton = QPushButton('Annuler', self)

        self.grid.setSpacing(30)
        self.grid.setColumnStretch(0, 1)
        self.grid.setColumnStretch(8, 1)
        self.grid.setRowStretch(0, 1)
        self.grid.setRowStretch(8, 1)

        self.prenom.setAlignment(Qt.AlignCenter)
        self.nom.setAlignment(Qt.AlignCenter)
        self.courriel.setAlignment(Qt.AlignCenter)
        self.password.setAlignment(Qt.AlignCenter)

        self.grid.addWidget(self.prenom_line, 1, 2)
        self.grid.addWidget(self.prenom, 1, 1)

        self.grid.addWidget(self.nom_line, 2, 2)
        self.grid.addWidget(self.nom, 2, 1)

        self.grid.addWidget(self.courriel_line, 3, 2)
        self.grid.addWidget(self.courriel, 3, 1)

        self.grid.addWidget(self.password_line, 4, 2)
        self.grid.addWidget(self.password, 4, 1)

        self.grid.addWidget(self.createButton, 5, 1)
        self.grid.addWidget(self.cancelButton, 5, 2)

        #self.createButton.clicked.connect(self.)
        self.cancelButton.clicked.connect(self.loginUI)'''

    def mainUI(self):
        # main assets
        self.intButton = QPushButton('Intérêts', self)
        self.achatButton = QPushButton('Acheter', self)
        self.empruntButton = QPushButton('Emprunter', self)
        self.vendButton = QPushButton('Vendre', self)
        self.pretButton = QPushButton('Prêter', self)
        self.histButton = QPushButton('Historique', self)
        self.exitButton = QPushButton('Fermer', self)

        self.intButton.clicked.connect(self.interets)
        self.achatButton.clicked.connect(self.achats)
        self.exitButton.clicked.connect(self.exit)

        self.grid.setSpacing(30)

        self.grid.addWidget(self.intButton, 1, 1)
        self.grid.addWidget(self.achatButton, 2, 1)
        self.grid.addWidget(self.empruntButton, 3, 1)
        self.grid.addWidget(self.vendButton, 4, 1)
        self.grid.addWidget(self.pretButton, 5, 1)
        self.grid.addWidget(self.histButton, 6, 1)
        self.grid.setRowStretch(7, 1)
        self.grid.addWidget(self.exitButton, 8, 1)
        self.grid.setRowStretch(0, 1)
        self.grid.setRowStretch(9, 1)

    def interetsUI(self):
        pass

    def achatsUI(self):
        pass

    @pyqtSlot()

    def createProfileButton(self):
        for i in range(self.grid.count()): self.grid.itemAt(i).widget().close()
        self.createProfile()

    def login(self):
        #Matcher l'identifiant avec l'utilisateur de la base
        if (True):
        #if (self.counter == 0):
            user_id = self.ID.text()
            password = self.password.text()

            ###Placer requete SQL ici, if select == identifiant...###
            validation = op.verify_login(self.conn, user_id, password)

        if (validation):
            # Clear widgets for next screen
            for i in range(self.grid.count()): self.grid.itemAt(i).widget().close()
            self.mainUI()

    def interets(self):
        for i in range(self.grid.count()): self.grid.itemAt(i).widget().close()
        self.interetsUI()

    def achats(self):
        for i in range(self.grid.count()): self.grid.itemAt(i).widget().close()
        self.achatsUI()

    def exit(self):
        self.conn.close()
        sys.exit()


if __name__ == '__main__':   
    app = QApplication(sys.argv)
    main = App()
    sys.exit(app.exec_())
