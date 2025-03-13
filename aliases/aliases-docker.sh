# alias docker_ps='docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Command}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Status}}" | grep -v "NAMES" | awk '{print "\033[36m" $1 "\033[0m\t\033[33m" $2 "\033[0m\t\033[32m" $3 " " $4 " " $5 "\033[0m\t\033[35m" $6 "\033[0m\t\033[34m" $7 " " $8 " " $9 "\033[0m\t\033[31m" $10 " " $11 " " $12 " " $13 "\033[0m"}' | (echo -e "\033[1mNAMES\tCONTAINER ID\tCOMMAND\tIMAGE\tCREATED AT\tSTATUS\033[0m"; cat)'
# alias dps="docker_ps"

function full_dps() {
  docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Command}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Status}}" |
  grep -v "NAMES" |
  awk '{print "\033[36m" $1 "\033[0m\t\033[33m" $2 "\033[0m\t\033[32m" $3 " " $4 " " $5 "\033[0m\t\033[35m" $6 "\033[0m\t\033[34m" $7 " " $8 " " $9 "\033[0m\t\033[31m" $10 " " $11 " " $12 " " $13 "\033[0m"}' |
  (echo -e "\033[1mNAMES\tCONTAINER ID\tCOMMAND\tIMAGE\tCREATED AT\tSTATUS\033[0m"; cat)
}

function dps2() {
  docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Command}}\t{{.Image}}\t{{.Status}}" |
  grep -v "NAMES" |
  awk '{print "\033[36m" $1 "\033[0m\t\033[33m" $2 "\033[0m\t\033[32m" $3 " " $4 " " $5 "\033[0m\t\033[35m" $6 "\033[0m\t\033[31m" $7 "\033[0m"}' |
  (echo -e "\033[1mNAMES\tCONTAINER ID\tCOMMAND\tIMAGE\tSTATUS\033[0m"; cat)
}

function dps() {
  docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.Status}}" |
  grep -v "NAMES" |
  awk '{print "\033[36m" $1 "\033[0m\t\033[33m" $2 "\033[0m\t\033[35m" $3 "\033[0m\t\033[31m" $4 " " $5 "\033[0m"}' |
  (echo -e "\033[1mNAMES\tID\tIMAGE\tSTATUS\033[0m"; cat)
}

function dexec() {
  if [ -z "$1" ]; then
    echo "Usage: dexec <container_id_or_name> [shell_command]"
    echo "Example: dexec mycontainer"
    echo "         dexec 49c19c9d29e7 /bin/bash"
    return 1
  fi

  # Default to /bin/sh if no shell is specified
  local shell="${2:-/bin/sh}"

  docker exec -it "$1" $shell
}

function dcup() {
  echo "running: docker compose up -d"
  docker compose up -d
}

function dcdown() {
  echo "running: docker compose down"
  docker compose down
}
