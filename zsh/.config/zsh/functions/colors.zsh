# log methods log_XXX
# Colors
RED='\033[00;31m'
RESTORE='\033[0m'
BLACK="\033[0;30m"        # Black
GREEN="\033[0;32m"        # Green
YELLOW="\033[0;33m"       # Yellow
BLUE="\033[0;34m"         # Blue
PURPLE="\033[0;35m"       # Purple
CYAN="\033[0;36m"         # Cyan
WHITE="\033[0;37m"        # White

function log_error() { 
  echo -e "${RED}ERROR: $1${RESTORE}"
}

function log_warn() { 
  echo -e "${YELLOW}WARN: $1${RESTORE}"
}

function log_debug() { 
  echo -e "${BLUE}DEBUG: $1${RESTORE}"
}

function log_info() { 
  echo -e "${PURPLE}INFO: $1${RESTORE}"
}
