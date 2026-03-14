import mysql.connector
from mysql.connector import Error

def run_task_b():
    connection = None
    try:
        # 1. Connect to the MySQL Server
        connection = mysql.connector.connect(
            host='localhost',
            user='root',     
            password='pass', 
            database='COMPANY'
        )

        if connection.is_connected():
            cursor = connection.cursor()

            # TASK 1: Create 'student' table
            # We use IF NOT EXISTS so the script doesn't error on second run
            create_table_query = """
            CREATE TABLE IF NOT EXISTS student (
                Roll_no INT PRIMARY KEY,
                Name VARCHAR(50),
                BirthDate DATE,
                Gender CHAR(1),
                City VARCHAR(30)
            )
            """
            cursor.execute(create_table_query)
            print("Step 1: Relation 'student' created/verified.")

            # TASK 2: Insert 5 rows
            insert_query = """
            INSERT IGNORE INTO student (Roll_no, Name, BirthDate, Gender, City) 
            VALUES (%s, %s, %s, %s, %s)
            """
            
            records_to_insert = [
                (1, 'Goku', '2000-04-16', 'M', 'Mount Paozu'),
                (2, 'Vegeta', '1999-11-20', 'M', 'Capsule Corp'),
                (3, 'Bulma', '2001-08-18', 'F', 'West City'),
                (4, 'Gohan', '2004-05-12', 'M', 'Mount Paozu'),
                (5, 'Chi-Chi', '2000-11-05', 'F', 'Fire Mountain')
            ]

            cursor.executemany(insert_query, records_to_insert)
            connection.commit()  
            print(f"Step 2: {cursor.rowcount} records handled successfully.")

            # TASK 3: Print all details
            print("\nStep 3: Printing all student details:")
            print("-" * 60)
            cursor.execute("SELECT * FROM student")
            
            rows = cursor.fetchall()
            for row in rows:
                print(f"Roll: {row[0]} | Name: {row[1]} | DOB: {row[2]} | Sex: {row[3]} | City: {row[4]}")
            print("-" * 60)

    except Error as e:
        print(f"Error while connecting to MySQL: {e}")

    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()
            print("\nMySQL connection closed.")

if __name__ == "__main__":
    run_task_b()