import mysql.connector

# MySQL server configuration
config = {    
    'host': 'localhost',
    'port': 3306,
    'database': 'db_skin_cancer',
    'user': 'root',
    'password': '$holtech123'
}

connection = None  # Initialize the connection variable

# Establish a connection to the MySQL server
try:
    connection = mysql.connector.connect(**config)
    print('Connected to MySQL server!')
    # Perform your database operations here...
except mysql.connector.Error as error:
    print('Failed to connect to MySQL server:', error)
finally:
    # Close the connection if it's open
    if connection is not None and connection.is_connected():
        connection.close()
        print('Disconnected from MySQL server')