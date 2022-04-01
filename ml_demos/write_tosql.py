import os
from posixpath import expanduser
import pandas as pd
from paramiko import SSHClient
import paramiko
from sshtunnel import SSHTunnelForwarder

# os.system('sudo apt-get install python3-mysql.connector')
# OR
# os.system('pip install mysql-connector-python')
import mysql.connector

sql_hostname = "ec2-x-x-x-x.us-east-2.compute.amazonaws.com"
sql_username = "-db-user"
sql_password = ""
sql_main_database = "_db"
sql_port = 3306
ssh_host = "ec2-x-x-x-x.us-east-2.compute.amazonaws.com"
ssh_user = "ubuntu"
ssh_port = 22
sql_ip = "127.0.0.1"

home = expanduser("~")
mypkey = paramiko.RSAKey.from_private_key_file(
    home + "key_pair.pem"
)


with SSHTunnelForwarder(
    (ssh_host, ssh_port),
    ssh_username=ssh_user,
    ssh_pkey=mypkey,
    remote_bind_address=(sql_hostname, sql_port),
) as tunnel:
    conn = mysql.connector.connect(
        host="127.0.0.1",
        user=sql_username,
        passwd=sql_password,
        db=sql_main_database,
        port=tunnel.local_bind_port,
    )
    query = """INSERT INTO wsi_table(
   client_name, job_name, wsi_name)
   VALUES ('test_client', 'test_job','wsi_n')"""
    data = pd.read_sql_query(query, conn)
    conn.close()


# ---------------------The code for non ssh connection - not tested

# establishing the connection
conn = mysql.connector.connect(
    user="root", password="password", host="127.0.0.1", database="spintellx_hm_db"
)

# Creating a cursor object using the cursor() method
cursor = conn.cursor()

# Preparing SQL query to INSERT a record into the database.
sql = """INSERT INTO wsi_table(
   client_name, job_name, wsi_name)
   VALUES ('test_client', 'test_job','wsi_n')"""

try:
    # Executing the SQL command
    cursor.execute(sql)

    # Commit your changes in the database
    conn.commit()

except:
    # Rolling back in case of error
    conn.rollback()

# Closing the connection
conn.close()
