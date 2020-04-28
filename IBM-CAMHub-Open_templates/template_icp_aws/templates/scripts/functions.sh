#!/bin/bash
DefaultOrg="ibmcom"
DefaultRepo="icp-inception"

# Populates globals $org $repo $tag
function parse_icpversion() {
  # Determine if registry is also specified
  if [[ $1 =~ .*/.*/.* ]]
  then
    # Save the registry section of the string
    local r=$(echo ${1} | cut -d/ -f1)
    # Save username password if specified for registry
    if [[ $r =~ .*@.* ]]
    then
      local up=${r%%@*}
      username=${up%%:*}
      password=${up##*:}
      registry=${r##*@}
    else
      registry=${r}
    fi
    org=$(echo ${1} | cut -d/ -f2)
  elif [[ $1 =~ .*/.* ]]
   # Determine organisation
  then
    org=$(echo ${1} | cut -d/ -f1)
  else
    org=$DefaultOrg
  fi

  # Determine repository and tag
  if [[ $1 =~ .*:.* ]]
  then
    repo=$(echo ${1##*/} | cut -d: -f1)
    tag=$(echo ${1##*/} | cut -d/ -f2 | cut -d: -f2)
  else
    repo=$DefaultRepo
    tag=$1
  fi
}

##
#Function to check if docker run is successful
##
function check_container(){
	if [ $1 -ne 0 ]
	then
		echo $2
		##
		#File to indicate failure of ICP install. Can be used
		#to monitor the completion using terrafrom null_resource.
		##
		touch /opt/ibm/cluster/icp_install_failed
		exit 1
	fi
}	
