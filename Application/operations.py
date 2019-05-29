#!/usr/bin/env python
# -*- coding: utf-8 -*-

#!/usr/bin/python
import psycopg2

import dictionary as di

#-----------------------------------#
#- Fonctions liees aux utilisateurs -#
#-----------------------------------#
def add_user(conn, args):

	cur = conn.cursor()

	# Vérifie si le user_id est déjà utilisé
	cur.execute("SELECT COUNT(*) FROM Utilisateur \
		WHERE identifiant = '"+args[0]+"';")

	if(cur.fetchall()[0][0] != 0):
		return -1

	# Vérifie si le email est déjà utilisé
	cur.execute("SELECT COUNT(*) FROM Utilisateur \
		WHERE courriel = '"+args[3]+"';")

	if(cur.fetchall()[0][0] != 0):
		return -2

	# Ajoute le nouvel utilisateur à la base de donnée

	add_user_str = "INSERT INTO Utilisateur \
		VALUES "+ str(tuple(args)) +";"

	cur.execute(add_user_str)

	conn.commit()

	return 0

# Retourne si les informations entrées pour le login sont valides ou non
def verify_login(conn, user_id, password):

	# Verification de l'identifiant et du password dans la base de donnees
	cur = conn.cursor()

	verify_login_str = "SELECT COUNT(*) \
		FROM Utilisateur \
		WHERE identifiant='"+user_id+"' AND motDePasse='" + password +"';"

	cur.execute(verify_login_str)

	match = cur.fetchall()[0][0]

	if(match == 1):
		return True

	return False


def show_notification(user_id):

	return

#-------------------------------------#
#- Fonctions liees au partage d'items -#
#-------------------------------------#

def get_enum(conn, enum):
  
	cur = conn.cursor()

	get_enum_str = "SELECT unnest(enum_range(NULL::"+enum+"));"

	cur.execute(get_enum_str)

	enum = cur.fetchall()
	enum_list = []

	for e in enum:
		enum_list.append(e[0])

	return enum_list
	
# Retourne les informations d'une table [(colonne, type)]
def get_table_form(conn, table):

	cur = conn.cursor()

	get_table_form_str = "SELECT COLUMN_NAME, DATA_TYPE\
		FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+table.lower()+"';"

	cur.execute(get_table_form_str)

	table_infos = cur.fetchall()

	infos = []
	for i in table_infos:
		col = di.dict_sql[i[0]]
		typ = di.dict_type_widget(i[1])
		infos.append((col, typ))

	return infos


# Ajoute un item à la base de donnee
def add_item(conn, table, values):

	cur = conn.cursor()

	# Id sketch
	cur.execute("SELECT COUNT(*) FROM ObjetAffiche;")
	id = cur.fetchall()[0][0] + 1

	val_obj_affiche = [id] + values[0]
	val_obj_type = [id] + values[1]

	# Insert dans les deux tables
	add_item_str1 = "INSERT INTO ObjetAffiche \
		VALUES " + str(tuple(val_obj_affiche)) + ";"
	add_item_str2 ="INSERT INTO "+ table +" \
		VALUES " + str(tuple(val_obj_type)) + ";"

	cur.execute(add_item_str1)

	cur.execute(add_item_str2)

	conn.commit()

	return

# Recupère la liste des items en fonction des préférences de recherche de l'utilisateur
def get_items_list(conn, borrow, buy, min_price, max_price, old, new, type):

	search_str = "SELECT identifiant, nom, instance, prix, quantiteUnitaire, quantiteDisponible, etat, dureeEmprunt \
	FROM ObjetAffiche WHERE "

	# Si pas emprunt et achat en même temps
	if(not ((borrow and buy) or (not borrow and not buy))):
		if(borrow):
			search_str = search_str + "dureeEmprunt > 0 AND "	
		if(buy):
			search_str = search_str + "dureeEmprunt = 0 AND "

	# Prix dans la fourchette de recherche
	search_str = search_str + "prix >= "+str(min_price)+" AND prix <= "+str(max_price)+" AND "

	# Si pas usagé et usage en même temps
	if(not ((old and new) or (not old and not new))):
		if(old):
			search_str = search_str + "etat = '0' AND "	
		if(new):
			search_str = search_str + "etat = '1' AND "

	# Si l'objet est affichable
	search_str = search_str + "affichable = '1' AND "

	# Le type d'objet
	search_str = search_str + "instance = '"+type+"';"

	cur = conn.cursor()
	cur.execute(search_str)

	items = cur.fetchall()
	cols = [desc[0] for desc in cur.description]	

	item_list = []

	for i in items:
		item_list.append(i)

	return [cols, items]

def get_recu(conn, buy, bor, sell, lend, user):
	item_list = []

	if (buy):
		search_str = "SELECT TB.identifiant, TB.nom, TB.instance, TA.acheteur, TA.prix, TA.quantite, TA.dateVente, TA.heureVente " \
					 "FROM RecuVente TA " \
					 "INNER JOIN ObjetAffiche TB " \
					 "ON TA.objetIdentifiant = TB.identifiant " \
					"WHERE TA.acheteur = TB.utilisateurIdentifiant AND TA.acheteur = " + "'" + user + "';"

		cur = conn.cursor()
		cur.execute(search_str)
		items1 = cur.fetchall()
		for i in items1:
			item_list.append(i)

	if (sell):
		search_str = "SELECT TB.identifiant, TB.nom, TB.instance, TA.acheteur, TA.prix, TA.quantite, TA.dateVente, TA.heureVente " \
					 "FROM RecuVente TA " \
					 "INNER JOIN ObjetAffiche TB " \
					 "ON TA.objetIdentifiant = TB.identifiant " \
					"WHERE TA.acheteur = TB.utilisateurIdentifiant AND TA.acheteur != " + "'" + user + "';"

		cur = conn.cursor()
		cur.execute(search_str)
		items2 = cur.fetchall()
		for i in items2:
			item_list.append(i)

	if (bor):
		search_str = "SELECT TB.identifiant, TB.nom, TB.instance, TA.emprunteur, TA.prix, TA.quantite, TA.dateEmprunt, TA.heureEmprunt " \
					 "FROM RecuEmprunt TA " \
					 "INNER JOIN ObjetAffiche TB " \
					 "ON TA.objetIdentifiant = TB.identifiant " \
					"WHERE TA.emprunteur = TB.utilisateurIdentifiant AND TA.emprunteur = " + "'" + user + "';"

		cur = conn.cursor()
		cur.execute(search_str)
		items3 = cur.fetchall()
		for i in items3:
			item_list.append(i)

	if (lend):
		search_str = "SELECT TB.identifiant, TB.nom, TB.instance, TA.emprunteur, TA.prix, TA.quantite, TA.dateEmprunt, TA.heureEmprunt " \
					 "FROM RecuEmprunt TA " \
					 "INNER JOIN ObjetAffiche TB " \
					 "ON TA.objetIdentifiant = TB.identifiant " \
					"WHERE TA.emprunteur = TB.utilisateurIdentifiant AND TA.emprunteur = " + "'" + user + "';"

		cur = conn.cursor()
		cur.execute(search_str)
		items4 = cur.fetchall()
		for i in items4:
			item_list.append(i)

	return item_list


# Recupère l'item cliqué dans la liste des objets recherchés
def get_item(conn, item_id, type_table_name):

	search_str = "SELECT * FROM (SELECT * FROM (SELECT * FROM ObjetAffiche WHERE identifiant = '"+item_id+"') AS a \
		NATURAL JOIN \
		(SELECT * FROM "+type_table_name+" WHERE objetIdentifiant = '"+item_id+"') AS b) AS object \
		NATURAL JOIN \
		(SELECT adresseNumero, adresseRue, adresseVille, adresseProvince, codePostal\
		FROM Utilisateur WHERE identifiant IN \
		(SELECT utilisateurIdentifiant FROM ObjetAffiche WHERE identifiant = '"+item_id+"')) AS contact;"

	cur = conn.cursor()
	cur.execute(search_str)

	items = cur.fetchall()
	cols = [di.dict_sql[desc[0]] for desc in cur.description]

	items = [str(i) for i in items[0]]

	return zip(cols, items)

# Fonction qui gère toutes les transactions d'achat et emprunt
# Met la table d'objets
# Génère les reçus de vente et emprunt
def transaction(conn, user_id, item_id, type_table_name, quantity):

	# Mettre à jour la table d'objets

	cur = conn.cursor()
	cur.execute("SELECT quantiteDisponible FROM ObjetAffiche WHERE identifiant = '"+item_id+"';")
	available_qty = cur.fetchall()[0][0]

	# Mettre à jour la quantité d'objets disponibles
	if(quantity <= available_qty):
		objects_update_str = "UPDATE ObjetAffiche SET quantiteDisponible = "+str(available_qty-quantity)
		
		# Si il n'y a plus d'objets disponibles on rend l'objet non affichable
		if(available_qty - quantity == 0):
			objects_update_str = objects_update_str + ", affichable = '0'"

		objects_update_str = objects_update_str + "WHERE identifiant = '"+item_id+"';"

		cur = conn.cursor()
		cur.execute(objects_update_str)
		conn.commit()


	# Durée d'emprunt == 0 signifie une vente
	cur = conn.cursor()
	cur.execute("SELECT dureeEmprunt FROM ObjetAffiche WHERE identifiant = '"+item_id+"';")
	borrow_period = cur.fetchall()[0][0]

	# Mettre à jour la table de reçus de vente

	if(borrow_period == 0 and quantity <= available_qty):
		sell_str = "INSERT INTO RecuVente (acheteur, objetIdentifiant, prix, quantite) VALUES\
		('"+user_id+"',\
		'"+item_id+"',\
		(SELECT prix FROM (SELECT * FROM (SELECT * FROM ObjetAffiche WHERE identifiant = '"+item_id+"') AS a NATURAL JOIN \
		(SELECT * FROM "+type_table_name+" WHERE objetIdentifiant = '"+item_id+"') AS b) AS prix),\
		"+str(quantity)+");"

		cur = conn.cursor()
		cur.execute(sell_str)
		conn.commit()

	# Mettre à jour la table de reçus d'emprunt

	if(borrow_period != 0 and quantity <= available_qty):
		borrow_str = "INSERT INTO RecuEmprunt (emprunteur, objetIdentifiant, prix, quantite, statut) VALUES\
		('"+user_id+"',\
		'"+item_id+"',\
		(SELECT prix FROM (SELECT * FROM (SELECT * FROM ObjetAffiche WHERE identifiant = '"+item_id+"') AS a NATURAL JOIN \
		(SELECT * FROM "+type_table_name+" WHERE objetIdentifiant = '"+item_id+"') AS b) AS prix),\
		"+str(quantity)+",\
		'1');"

		cur = conn.cursor()
		cur.execute(borrow_str)
		conn.commit()