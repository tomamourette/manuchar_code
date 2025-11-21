# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "5a33d451-347a-40ac-992d-029395af1c55",
# META       "default_lakehouse_name": "dbb_lakehouse_DIH",
# META       "default_lakehouse_workspace_id": "5c450b57-bfb8-4fc6-b34c-e6fe494e12c1"
# META     }
# META   }
# META }

# CELL ********************

# MAGIC %%bash
# MAGIC sudo apt-get install -y odbcinst1debian2 unixodbc
# MAGIC curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# MAGIC curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
# MAGIC sudo apt-get update
# MAGIC sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df = spark.read.format("csv").option("header","true").load("Files/test/2020011 Market Intel EU CHEM 1.csv")
# df now is a Spark DataFrame containing CSV data from "Files/test/2020011 Market Intel EU CHEM 1.csv".
display(df)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

!pip install pyodbc


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import pyodbc

try:
    # Define the connection string
    conn = pyodbc.connect(
        'Driver={ODBC Driver 17 for SQL Server};'
        'Server=hm4kihleqcae3ljgp3reucweo4-k4fukxfyx7de7m2m437estqsye.database.fabric.microsoft.com,1433;'
        'Database={OperationalDataSources_Sql-6abf6d4e-d280-44cd-879b-22e93fb97969};'
        'Encrypt=yes;'
        'TrustServerCertificate=no;'
        'Authentication=ActiveDirectoryInteractive'
    )
    print("Connected to the database")

except pyodbc.Error as e:
    print(f"Error connecting to the database: {e}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


# Create a cursor object
cursor = conn.cursor()

# Define the stored procedure with parameters
stored_procedure = "EXEC [03DataSys].SP_Update_DataProcess_Run"

# Execute the stored procedure
cursor.execute(stored_procedure)

# Fetch results (if the stored procedure returns data)
results = cursor.fetchall()
for row in results:
    print(row)

# Close the connection
cursor.close()
conn.close()


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
