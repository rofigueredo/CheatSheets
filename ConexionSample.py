import pyodbc

server = 'ASUSTUF\SQL22'
database = 'AdventureWorksDW2019'


try:
    connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
                                f'SERVER={server};'
                                f'DATABASE={database};'
                                f'Trusted_Connection=yes;')
    print('Conexión exitosa')
except pyodbc.Error as e:
    print(f'Error al conectar a la base de datos: {str(e)}')

# Consulta a la tabla
cursor.execute('SELECT top 12 * FROM FactFinance')
# Imprimir filas
resultados = cursor.fetchall()
resultados