# Function to print bigger text
print_bigger_text() {
    echo -e "\e[1m$@\e[0m"  # Print text in bold
}

# Ensure correct number of arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    print_bigger_text "Usage: $0 <database_name> <sql_file> [varicon_text_file]"
    exit 1
fi

# Extract database name and SQL file from arguments
database_name=$1
sql_file=$2

# Check if third argument (varicon_text_file) is provided, otherwise use default
if [ $# -eq 3 ]; then
    varicon_text_file=$3
else
    varicon_text_file="varicon.txt"
fi

# If the specified SQL file does not exist, exit with an error
if [ ! -f "$sql_file" ]; then
    print_bigger_text "Error: SQL file '$sql_file' not found."
    exit 1
fi

if [ "${@: -1}" == "-D" ]; then
    delete_database=true
    sql_database_value=$(grep "^SQL_DATABASE=" "$varicon_text_file" | cut -d '=' -f2-)
    print_bigger_text "Deleting the database: $sql_database_value"
    docker exec -i db psql -U postgres -c "DROP DATABASE IF EXISTS $sql_database_value;"
    set -- "${@:1:$(($#-1))}"
fi

# Replace SQL_DATABASE value in the specified file
sed -i "s/^SQL_DATABASE=.*/SQL_DATABASE=$database_name/" "$varicon_text_file"

print_bigger_text "Step 1: Replacing SQL_DATABASE value in the file"

print_bigger_text "Step 2: Creating the database"
# Step 2: Create the database
docker exec -i db psql -U postgres -c "CREATE DATABASE $database_name;"

print_bigger_text "Step 3: Executing SQL commands from the file within the newly created database"
# Step 3: Execute SQL commands from the file within the newly created database
cat "$sql_file" | docker exec -i db psql -U postgres -d "$database_name"

print_bigger_text "Step 4: Bringing down the Docker Compose services"
# Step 4: Bring down the Docker Compose services
docker compose down

print_bigger_text "Step 5: Bringing up the Docker Compose services"
# Step 5: Bring up the Docker Compose services
docker compose up -d

print_bigger_text "All processes completed!"


