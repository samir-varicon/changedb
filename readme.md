Here's a README file that describes how to use the provided script:

---



# Database Switching Script

This script automates the process of switching databases within a Docker environment of varicon. It performs the following steps:

1. Deletes the existing database (optional).
2. Updates the database name in the configuration file.
3. Creates a new database.
4. Executes SQL commands from a specified file within the new database.
5. Brings down and then brings up the Docker Compose services.

## Usage

Ensure you have Docker and Docker Compose installed on your system.

## Installation
```bash
git clone git@github.com:samir-varicon/changedb.git

cd changedb

mv changedb.sh $HOME/Work/varicon-docker

chmod +x $HOME/Work/varicon-docker/switch_database.sh

```

Place the script in $HOME/Work/varicon-docker directory for easy access.



### Arguments

The script takes the following arguments:

- `<database_name>`: The name of the new database.
- `<sql_file>`: Path to the SQL file containing commands to be executed.
- `[varicon_text_file]` (optional): Path to the text file containing environment variables (defaults to "varicon.txt").

### Example

```
./changedb.sh my_new_database db_setup.sql
```

### Optional Flag

- `-D`: If specified, it will delete the existing database before proceeding with the switch.

```
./changedb.sh multitenant_db staging_db.sql -D 
```

## Steps

1. **Replacing SQL_DATABASE value in the file**: Updates the database name in the configuration file.
2. **Creating the database**: Creates a new database.
3. **Executing SQL commands from the file within the newly created database**: Executes SQL commands from the specified file within the new database.
4. **Bringing down the Docker Compose services**: Stops the Docker Compose services.
5. **Bringing up the Docker Compose services**: Starts the Docker Compose services.

## Note

- Ensure the SQL file exists and contains valid SQL commands.
- Review and customize the script as per your environment setup.

---

Feel free to adjust the instructions and descriptions as needed for your specific use case.
