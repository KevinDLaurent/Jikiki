#!/usr/bin/env python
# -*- coding: utf-8 -*-

#!/usr/bin/python
import psycopg2
import sys


def main():

	sql_file = sys.argv[1]

	conn = psycopg2.connect(
            dbname='kevindb',
            user='kevin',
            password='kevin',
            host='localhost',
            port='5432')

	cur = conn.cursor()
	cur.execute(open(sql_file, 'r', encoding='utf-8').read())

	conn.commit()
	conn.close()


if __name__ == '__main__':
	main()


