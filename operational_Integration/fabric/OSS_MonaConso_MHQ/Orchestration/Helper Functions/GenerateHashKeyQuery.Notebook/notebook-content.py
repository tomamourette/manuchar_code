# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

# Setting parameters
db_table = ''
columns_raw = ''

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Other parameters needed
hash_column = 'ODSHash'
hash_algo = 'MD5'

columns = [col.strip() for col in columns_raw.split(',')]

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Function that generates the hash sql
def generate_hash_sql(table_name, hash_column, columns, hash_algo='MD5'):
    if not columns:
        return "-- ERROR: No columns provided."

    concat_parts = [
        f"ISNULL(CAST([{col}] AS VARCHAR(100)), '') + '|'" for col in columns
    ]
    concat_parts[-1] = concat_parts[-1].replace(" + '|'", "")  # Remove trailing pipe

    concat_expr = '\n    + '.join(concat_parts)

    sql = f"""
UPDATE {table_name}
SET {hash_column} = CONVERT(VARCHAR(32), HASHBYTES('{hash_algo}',
    {concat_expr}
), 2);
"""
    return sql

# Call the function to generate the SQL wuery
generated_sql = generate_hash_sql(db_table, hash_column, columns, hash_algo)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

print(generated_sql)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Return the sql query
notebookutils.notebook.exit(generated_sql)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
