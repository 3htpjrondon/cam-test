#!/bin/bash
#################################################################
# Script to generate a Terraform template for AWS security group
# creation for a Middleware.
#
# Version: 1.0
#
# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

set -o errexit
set -o nounset
set -o pipefail

function help() {
    cat <<EOF
Script to generate a Terraform template for AWS security group creation for a Middleware.

Options
-q  Quiet Install
-m  Install middleware on multiple nodes

Parameters
GITHUB_ACCESS_TOKEN   The token for authorization to access github.ibm.com
ATTRIBUTE_RECIPE_URL  The url of the chef recipe for a middleware in github.ibm.com
MIDDLEWARE_NAME       The name of middleware that user can specify
                      The suggested naming convention and values are:
                        ibm_was
                        ibm_wasliberty
                        ibm_db2
                        ibm_im
                        ibm_wmq
                        ibm_ihs
                        oracle_mysql
                        oracle_enterprisedatabase
                        microsoft_iis
                        microsoft_sqlserver
                        apache_httpd
                        apache_tomcat
                      Note: All special characters except dash (-), dot (.) and underscore (_) will be removed and all letters will be changed to lower-case.

Usage
bash createAWSSecurityGroup.sh [-q] [-m] GITHUB_ACCESS_TOKEN ATTRIBUTE_RECIPE_URL MIDDLEWARE_NAME

Example
bash createAWSSecurityGroup.sh -m iamafaketoken https://raw.github.ibm.com/OpenContent/cookbook_ibm_was_multios/master/chef/cookbooks/was/attributes/default.rb ibm_was_multi_nodes

@Copyright IBM Corporation 2017.
EOF
    exit 0
}

function log() {
    if ! $QUIET; then
        echo $@
    fi

    if [ "$1" == "-n" ]; then
        shift
    fi

    if [ "$*" != "..." ]; then
        date +"Timestamp: %Y-%m-%d %H:%M:%S.%s Log: $*" >> $LOG
    fi
}

function error() {
   echo "Error: $*"
   usage
}

function usage() {
   echo "Usage: $(basename ${0}) [-q] [-m] GITHUB_ACCESS_TOKEN ATTRIBUTE_RECIPE_URL MIDDLEWARE_NAME"
   exit 1
}

QUIET=false
MULTI_NODE=false
while getopts hqm opt; do
    case $opt in
        h)  help
            ;;
        q)  QUIET=true
            ;;
        m)  MULTI_NODE=true
            ;;
        *)  echo "Invalid option: $*"
            usage
            ;;
   esac
done
shift $((OPTIND-1))

if [ $# -ne 3 ]; then
   error "Must specify correct parameters."
fi

GITHUB_ACCESS_TOKEN=$1
ATTRIBUTE_RECIPE_URL=$2
MIDDLEWARE_NAME=$3

# Remove all special characters except dash (-), dot (.) and underscore (_).
MIDDLEWARE_NAME=$(echo $MIDDLEWARE_NAME | tr -dc '[:alnum:]-._' | tr '[:upper:]' '[:lower:]')

# Generate a folder to hold all artifacts
rm -rf $MIDDLEWARE_NAME
mkdir $MIDDLEWARE_NAME
TEMPLATE_PATH=$MIDDLEWARE_NAME

LOG=$TEMPLATE_PATH/installation.log

log "------Start Artifacts Generation for $MIDDLEWARE_NAME------"

log "---------Download and analyze chef recipe---------"
RECIPE_FILE=$TEMPLATE_PATH/attributes.rb
CURL_RESPONSE_CODE=$(curl -H "Authorization: Token $GITHUB_ACCESS_TOKEN" -k -s -o $RECIPE_FILE -w "%{http_code}" $ATTRIBUTE_RECIPE_URL)
if [ $CURL_RESPONSE_CODE -ne 200 ]; then
  error "Please check GITHUB_ACCESS_TOKEN and/or ATTRIBUTE_RECIPE_URL."
fi

# Remove empty lines
sed -i -e '/^$/d' $RECIPE_FILE

# Special handling for ibm_was recipe which has standalone, multi-nodes and other unused attributes in the same file.
# Determine if the URL is for ibm_was. If yes, rule out different profiles according to standalone or multi-nodes
EXCLUSION_PROFILES=@@@@@@
if [ "${ATTRIBUTE_RECIPE_URL#*'_ibm_was_'}" != "$ATTRIBUTE_RECIPE_URL" ] ; then
    if $MULTI_NODE; then
        EXCLUSION_PROFILES="job_manager|standalone_profiles"
    else
        EXCLUSION_PROFILES="job_manager|dmgr|node_profile|ihs_server"
    fi
fi

# Grep the lines which start the port or listen description after excluding unrelated profiles, and then return line numbers
LINE_NUMBERS=$(grep -n -E "^\s*#\s*<md>\s*attribute\s*'[A-Za-z0-9/-_()$]*(port|listen)" $RECIPE_FILE | grep -v -E "$EXCLUSION_PROFILES" | cut -d : -f 1 || echo )

# Check the 5th line after each matching, get the port number and generate the corresponding inbound rules
PORT_NUMBER_LIST=
for i in $LINE_NUMBERS ; do
    PORT_LINE_NUMBER=$(( i + 5 ))
    PORT_NUMBER=$(sed ''"$PORT_LINE_NUMBER"'q;d' $RECIPE_FILE | cut -d \' -f 2)

    # Only consider the port number which is not null/empty and not duplicate
    if [ -n "$PORT_NUMBER" ] ; then
        if [ "${PORT_NUMBER_LIST#*-$PORT_NUMBER}" == "$PORT_NUMBER_LIST" ] ; then
            PORT_NUMBER_LIST=$PORT_NUMBER_LIST-$PORT_NUMBER
        fi
    fi
done

# Special handling for microsoft_sqlserver, which does not follow the description convention
if [ "${ATTRIBUTE_RECIPE_URL#*'_microsoft_sqlserver_'}" != "$ATTRIBUTE_RECIPE_URL" ] ; then
    PORT_NUMBER=$(grep "default\['sql_server'\]\['port'\]" $RECIPE_FILE | cut -d \= -f 2)
    PORT_NUMBER_LIST=$PORT_NUMBER_LIST-$PORT_NUMBER
fi

# Special handling for microsoft_sqlserver, which does not follow the description convention
if [ "${ATTRIBUTE_RECIPE_URL#*'_microsoft_iis_'}" != "$ATTRIBUTE_RECIPE_URL" ] ; then
    PORT_NUMBER=$(grep "'bindings' =>" $RECIPE_FILE | cut -d : -f 2)
    PORT_NUMBER_LIST=$PORT_NUMBER_LIST-$PORT_NUMBER
fi

# Remove the beginning dash (-) if it exists
PORT_NUMBER_LIST=${PORT_NUMBER_LIST:1}

# Remove downloaded file
rm -f $RECIPE_FILE*

log "---------Generate ${MIDDLEWARE_NAME}_aws_security_group.tf---------"

# Generate the beginning common parts in terraform template
TERRAFORM_TEMPLATE=$TEMPLATE_PATH/${MIDDLEWARE_NAME}_aws_security_group.tf
cat << EOF > $TERRAFORM_TEMPLATE
# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

##############################################################
# Define the AWS provider
##############################################################
provider "aws" {
  region = "\${var.aws_region}"
}

##############################################################
# Define Variables
##############################################################
variable "aws_region" {
  description = "AWS region to launch servers"
}

variable "aws_vpc_name" {
  description = "Name of the existing AWS VPC"
}

variable "aws_security_group_name" {
  description = "Name of the AWS Security Group to be created"
  default     = "${MIDDLEWARE_NAME}_aws_security_group"
}

##############################################################
# Retrieve VPC
##############################################################
data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Name"
    values = ["\${var.aws_vpc_name}"]
  }
}

##############################################################
# Create Security Group
##############################################################
resource "aws_security_group" "$MIDDLEWARE_NAME" {
  name        = "\${var.aws_security_group_name}"
  description = "Security group which applies to $MIDDLEWARE_NAME"
  vpc_id      = "\${data.aws_vpc.selected_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
EOF

# Add inbound rules in terraform template
IFS='-' read -a ARRAY_PORT_NUMBER_LIST <<< "$PORT_NUMBER_LIST"
COUNTER=${#ARRAY_PORT_NUMBER_LIST[@]}
INDEX=0
while [ $INDEX -lt $COUNTER ]; do
  PORT_NUMBER=${ARRAY_PORT_NUMBER_LIST[$INDEX]}
  let INDEX=INDEX+1
  log "------------Add inbound rule for port $PORT_NUMBER------------"
  cat << EOF >> $TERRAFORM_TEMPLATE
  ingress {
    from_port   = $PORT_NUMBER
    to_port     = $PORT_NUMBER
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
EOF
done

# Generate the ending common parts in terraform template
cat << EOF >> $TERRAFORM_TEMPLATE
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "\${var.aws_security_group_name}"
  }
}

##############################################################
# Output
##############################################################
output "Security Group Name" {
  value = "\${aws_security_group.$MIDDLEWARE_NAME.name}"
}

output "Security Group Id" {
  value = "\${aws_security_group.$MIDDLEWARE_NAME.id}"
}
EOF

# Generate catalog.json
log "---------Generate catalog.json---------"

# Contruct features for rules
FEATURE_RULES="<ul><li>Inbound: Allow access from any source for ICMP, SSH (22) and the following ports.<div style=\\\"margin-left:20px\\\"><ul>"
INDEX=0
while [ $INDEX -lt $COUNTER ]; do
  PORT_NUMBER=${ARRAY_PORT_NUMBER_LIST[$INDEX]}
  let INDEX=INDEX+1
  FEATURE_RULES=$FEATURE_RULES"<li>- $PORT_NUMBER</li>"
done
FEATURE_RULES=$FEATURE_RULES"</ul></div></li><li>Outbound: Allow any type access to any destination.</li></ul>"

# Finalize catalog.json
CATALOG_JSON=$TEMPLATE_PATH/catalog.json
cat << EOF > $CATALOG_JSON
{
   "name": "AWS Security Group for $MIDDLEWARE_NAME",
   "description": "This template creates an AWS security group to manage inbound and outbound traffics.",
   "version": "1.0.0.0",
   "type": "prebuilt",
   "manifest": {
     "template_type": "Terraform",
     "template_format": "HCL",
     "template_provider": "Amazon EC2",
     "template": {
       "templateData": "",
       "templateVariables": "",
       "templateOutput": ""
     }
   },
   "metadata": {
     "displayName": "AWS Security Group for $MIDDLEWARE_NAME",
     "longDescription": "This template creates an AWS security group to manage inbound and outbound traffics, which can be applied to the virtual machines for the middleware $MIDDLEWARE_NAME to operate correctly.",
     "bullets": [
       {
         "title": "Clouds",
         "description": "Amazon"
       },
       {
         "title": "Template version",
         "description": "1.0"
       },
       {
         "title": "Security group rules",
         "description": "$FEATURE_RULES"
       },
       {
         "title": "Usage and special notes",
         "description": "<ul><li>1. The default Security Group name is ${MIDDLEWARE_NAME}_aws_security_group which is allowed to be overwritten by customers' input.</li><li>2. Please deploy this template to create Security Group before deploying middleware $MIDDLEWARE_NAME.</li><li>3. Please obtain the Security Group id from output, as it may be required in the input for middleware deployment.</li></ul>"
       }
     ]
   }
}
EOF

# Generate camvariables.json
log "---------Generate ${MIDDLEWARE_NAME}_aws_security_group_varaibles.json---------"
CAMVARIABLES_JSON=$TEMPLATE_PATH/${MIDDLEWARE_NAME}_aws_security_group_varaibles.json
cat << EOF > $CAMVARIABLES_JSON
{
  "template_input_params": [
    {
      "name": "aws_region",
      "type": "string",
      "description": "AWS region to launch servers",
      "label": "AWS Region",
      "required": true,
      "hidden": false,
      "secured": false,
      "immutable": false,
      "options": [
        {
          "value": "us-east-1",
          "label": "US East (N. Virginia)",
          "default": true
        },
        {
          "value": "us-east-2",
          "label": "US East (Ohio)"
        },
        {
          "value": "us-west-1",
          "label": "US West (N. California)"
        },
        {
          "value": "us-west-2",
          "label": "US West (Oregon)"
        },
        {
          "value": "ca-central-1",
          "label": "Canada (Central)"
        },
        {
          "value": "eu-west-1",
          "label": "EU (Ireland)"
        },
        {
          "value": "eu-central-1",
          "label": "EU (Frankfurt)"
        },
        {
          "value": "eu-west-2",
          "label": "EU (London)"
        },
        {
          "value": "ap-northeast-1",
          "label": "Asia Pacific (Tokyo)"
        },
        {
          "value": "ap-northeast-2",
          "label": "Asia Pacific (Seoul)"
        },
        {
          "value": "ap-southeast-1",
          "label": "Asia Pacific (Singapore)"
        },
        {
          "value": "ap-southeast-2",
          "label": "Asia Pacific (Sydney)"
        },
        {
          "value": "ap-south-1",
          "label": "Asia Pacific (Mumbai)"
        },
        {
          "value": "sa-east-1",
          "label": "South America (São Paulo)"
        }
      ]
    },
    {
      "name": "aws_vpc_name",
      "type": "string",
      "description": "Name of the existing AWS VPC; Allow 1 to 255 alphanumeric characters and special characters +=._:/@- as tag value that is not starting with 'aws'",
      "label": "AWS VPC Name",
      "required": true,
      "hidden": false,
      "secured": false,
      "immutable": false,
      "regex": "^(?![Aa][Ww][Ss])[A-Za-z0-9 +=._:\/@-]{1,255}$"
    },
    {
      "name": "aws_security_group_name",
      "type": "string",
      "description": "Name of the AWS Security Group to be created; Allow 1 to 255 alphanumeric characters and special characters +=._:/@- as tag value that is not starting with 'aws'",
      "label": "AWS Security Group Name",
      "default": "${MIDDLEWARE_NAME}_aws_security_group",
      "required": true,
      "hidden": false,
      "secured": false,
      "immutable": false,
      "regex": "^(?![Aa][Ww][Ss])[A-Za-z0-9 +=._:\/@-]{1,255}$"
    }
  ],
  "template_output_params": [
    {
      "name": "Security Group Name",
      "label": "Security Group Name",
      "description": "Name of the AWS Security Group that has been created",
      "type": "string",
      "hidden": false,
      "secured": false
    },
    {
      "name": "Security Group Id",
      "label": "Security Group Id",
      "description": "Id of the AWS Security Group that has been created",
      "type": "string",
      "hidden": false,
      "secured": false
    }
  ]
}
EOF

log "------Finish Artifacts Generation for $MIDDLEWARE_NAME------"
