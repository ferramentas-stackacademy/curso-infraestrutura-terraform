import pymysql
import os
endpoint = os.environ['db_instance_address']
username = os.environ['db_username']
password = os.environ['db_password']
database_name = os.environ['db_name']

# Connection
connection = pymysql.connect(host=endpoint, user=username,passwd=password, db=database_name)
 
def lambda_handler(event, context):
	cursor = connection.cursor()
	cursor.execute('select * from playlist')
 
	rows = cursor.fetchall()
 
	for row in rows:
		print("{0} {1} {2}".format(row[0], row[1], row[2]))