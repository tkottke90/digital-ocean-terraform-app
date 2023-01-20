#! /bin/bash

# Variables

RED_BOLD='\033[1;31m'
RED='\033[0;31m'
GREEN_BOLD='\033[1;32m'
GREEN='\033[0;32m'
YELLOW_BOLD='\033[1;33m'
YELLOW='\033[0;33m'
BLUE_BOLD='\033[1;34m'
BLUE='\033[0;34m'
WHITE_BOLD='\033[1;37m'
WHITE='\033[0;37m'

DRY_RUN=0
VERBOSE=0
ALREADY_RUN=0

# Title
echo -e "${WHITE_BOLD}== Setup Digital Ocean/Terraform ==$WHITE"

# Functions
print_usage() {
  echo 
  echo "${WHITE_BOLD}Usage: setup.sh [options]${WHITE}"
  echo
  echo "Options"
  echo "  -d      Enable Dry Run Mode.  No files changed in the process"
  echo "  -v      Verbose Mode. File contents written to console"
}

# Arguments
while getopts 'dv' flag; do
  case "${flag}" in
    d) DRY_RUN=1 ;;
    v) VERBOSE=1 ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Script Start
echo -e "${BLUE_BOLD}> Checking for existing configuration$WHITE"

echo -ne ">> Checking for TFState Config..."
if [ ! -f "./terraform/config.s3.tfbackend" ]; then
  echo -e "${YELLOW_BOLD}Creating$WHITE"
  touch terraform/config.s3.tfbackend
else
  ALREADY_RUN=1
  echo -e "${GREEN_BOLD}FOUND$WHITE"
fi

echo -ne ">> Checking for Dev Vars File..."
if [ ! -f "./terraform/dev.auto.tfvars" ]; then
  echo -e "${YELLOW_BOLD}Creating$WHITE"
  touch terraform/dev.auto.tfvars
else
  ALREADY_RUN=1
  echo -e "${GREEN_BOLD}FOUND$WHITE"
fi

if [ $ALREADY_RUN -eq 1 ]; then
  echo -e "\n${RED_BOLD}!! It looks like you already ran this script"
  echo "  - Running this script again will overwrite your previous configurations"
  echo -ne $"  ? Are you should you would like to proceed? (Type yes to proceed) ${WHITE} "
  read OVERWRITE_CONFIRM

  if [ $OVERWRITE_CONFIRM != "yes" ]; then
    echo -e "${YELLOW_BOLD}  !! Aborting...${WHITE}"
    exit 0
  else
    echo -e "  ${YELLOW_BOLD}Proceeding with overwrite...${WHITE}\n"
  fi
fi

# Access Token Setup
echo -e "${BLUE_BOLD}> Access Setup:${WHITE}"
read -p "  ? What is your Digital Ocean Access Token? " DO_TOKEN
# echo "do_token=\"$DO_TOKEN\"" > terraform/dev.auto.tfvars


# Terraform State Setup
echo -e "\n${BLUE_BOLD}> Terraform State Setup$WHITE"
read -p "  ? What is your Digital Ocean Spaces Endpoint? " SPACES_ENDPOINT
read -p "  ? What region is your spaces hosted in? (us-east-1) " SPACES_REGION 
read -p "  ? What is your Digital Ocean Spaces Key? " SPACES_KEY
read -p "  ? What is your Digital Ocean Spaces Secret? " SPACES_SECRET
read -p "  ? What is your Digital Ocean Spaces Bucket Name? " SPACES_NAME
read -p "  ? What is your Digital Ocean Spaces State Filename? (terraform.tfstate) " SPACES_STATE_NAME

SPACES_REGION=${SPACES_REGION:-'us-east-1'}
SPACES_STATE_NAME=${SPACES_STATE_NAME:-'terraform.tfstate'}

echo -e "\n${BLUE_BOLD}> Creating Files$WHITE"

if [ $DRY_RUN -eq 1 ]; then 
  echo -e "${YELLOW_BOLD}>> !! Dry Run Mode Enabled !!${WHITE}"
fi

echo -ne ">> Dev Tfvars File (./terraform/dev.auto.tfvars)..."

TFVARS="do_token=\"${DO_TOKEN}\""

if [ $DRY_RUN -eq 0 ]; then
  echo "do_token=\"$DO_TOKEN\"" > terraform/dev.auto.tfvars
  echo -e "${GREEN_BOLD}CREATED${WHITE}"
else 
  echo -e "${YELLOW_BOLD}SKIPPED${WHITE}"
fi

echo -ne ">> S3 TFBackend File (./terraform/config.s3.tfbackend)..."

S3_CONFIG=$(cat << EOF
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoint                    = "${SPACES_ENDPOINT}"
  region                      = "${SPACES_REGION}"
  bucket                      = "${SPACES_NAME}"
  key                         = "${SPACES_STATE_NAME}"
  access_key                  = "${SPACES_KEY}"
  secret_key                  = "${SPACES_SECRET}"
EOF
)

if [ $DRY_RUN -eq 0 ]; then
  echo $S3_CONFIG > ./terraform/config.s3.tfbackend
  echo -e "${GREEN_BOLD}CREATED${WHITE}"
else 
  echo -e "${YELLOW_BOLD}SKIPPED${WHITE}"
fi

if [ $VERBOSE -eq 1 ]; then
  echo -e "\n${BLUE}> Dev Tfvars File:${WHITE}\n"
  echo $TFVARS
  echo

  echo -e "\n${BLUE}> Tfstate Config File:${WHITE}\n"
  echo $S3_CONFIG
fi

echo -e "\n${GREEN_BOLD}> Script Complete ${WHITE}\n"