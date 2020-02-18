import pymysql as pymysql
from http.server import BaseHTTPRequestHandler, HTTPServer
import socket

# Setting up the database
db = pymysql.connect(user='dbadmin@mariadb-server',
                       password='Adminpass123',
                       database='mariadb_database',
                       host='mariadb-server.mariadb.database.azure.com',
                       ssl={'ssl': {'ca': '/etc/ssl/certs/Baltimore_CyberTrust_Root.pem'}})

cursor = db.cursor()

cursor.execute("DROP TABLE IF EXISTS sample_table")

sql = """CREATE TABLE sample_table (sample_text VARCHAR(255))"""

try:
    cursor.execute(sql)
    db.commit()
except:
    db.rollback()

sql = """INSERT INTO sample_table VALUES ('Hello, I am a database entry')"""

try:
    cursor.execute(sql)
    db.commit()
except:
    db.rollback()

db.close()

# Simple HTTP server
hostname = socket.gethostname()
port = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        response_string = ""

        db = pymysql.connect(user='dbadmin@mariadb-server',
                       password=
                       database='mariadb_database',
                       host='mariadb-server.mariadb.database.azure.com',
                       ssl={'ssl': {'ca': '/etc/ssl/certs/Baltimore_CyberTrust_Root.pem'}})

        cursor = db.cursor()
        sql = """SELECT * FROM sample_table"""
        cursor.execute(sql)
        data = cursor.fetchall()
        for row in data:
            response_string += row[0] + "\n"

        db.close()

        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(response_string.encode('ascii'))

httpd = HTTPServer((hostname, port), MyServer)
httpd.serve_forever()