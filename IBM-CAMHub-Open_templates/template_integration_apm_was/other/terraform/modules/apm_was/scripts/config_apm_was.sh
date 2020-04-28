#!/bin/bash


silent_config() {

  rm $1

template='
#Sample silent response file created by simpleconfig script on 2018/03/05 03:26
[DEFAULT SECTION]
default.hostip=localhost
ms.connect=False
ttapi.enable=True
ttapi.host=127.0.0.1
ttapi.port=5457
soa.enable=False
tpv.enable=False
de.enable=True
temaconnect=True
tema.appserver=True
tema.host=127.0.0.1
tema.port=63335
config.tema.v6=False
tema.jmxport=63355
was.backup.configuration=False
was.backup.configuration.dir=/opt/IBM/ITM/dchome
was.wsadmin.username=
was.wsadmin.password=
was.client.props=True
was.appserver.profile.name=PROFILE
was.appserver.home=WAS_HOME
was.appserver.cell.name=CELL
was.appserver.node.name=NODE
[SERVER]
was.appserver.server.name=*
'

  IFS=$'\n'
  for line in $template
  do
    echo $line >> $1
  done
}

log() {

  echo $1 >> $APM_LOG
  echo $1

}

repl() {

  sed -i "s@$1@$2@g" $3

}

# Process Command Line Parameters

# Get script parameters
while test $# -gt 0; do
  [[ $1 =~ ^-p|--was_profile ]] && { APM_WAS_PROFILE="${2}"; shift 2; continue; };
  [[ $1 =~ ^-h|--was_home ]] && { APM_WAS_HOME="${2}"; shift 2; continue; };
  [[ $1 =~ ^-c|--was_cell ]] && { APM_WAS_CELL="${2}"; shift 2; continue; };
  [[ $1 =~ ^-n|--was_node ]] && { APM_WAS_NODE="${2}"; shift 2; continue; };
  [[ $1 =~ ^-u|--was_user ]] && { APM_WAS_USER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-d|--apm_dir ]] && { APM_DIR="${2}"; shift 2; continue; };

  break;
done

APM_WAS_SILENT=/tmp/apm_was_config.txt

# Set Defaults
APM_LOG=/tmp/config_apm_was.log

# Validate Parameters

if [ ! -d "$APM_DIR" ]; then
  exit 1
fi

# Prepare silent

silent_config $APM_WAS_SILENT

# Check if WebSphere Monitoring Agent Installed
# cinfo code - yn

APM_WAS_AGENT=`$APM_DIR/agent/bin/cinfo -d | grep \"yn\"  | wc -l`

######################### WAS Application Configuration #####################
if [ "$APM_WAS_AGENT" = "1" ]; then

  log "WAS Application Agent Found....."
  log "was.appserver.profile.name = $APM_WAS_PROFILE"
  log "was.appserver.home = $APM_WAS_HOME"
  log "was.appserver.cell.name = $APM_WAS_CELL"
  log "was.appserver.node.name = $APM_WAS_NODE"

  repl PROFILE $APM_WAS_PROFILE $APM_WAS_SILENT
  repl WAS_HOME $APM_WAS_HOME $APM_WAS_SILENT
  repl CELL $APM_WAS_CELL $APM_WAS_SILENT
  repl NODE $APM_WAS_NODE $APM_WAS_SILENT

  # Run config command
  cd $APM_DIR/agent/yndchome/7.3.0.14.0/bin
  ./config.sh -silent $APM_WAS_SILENT
  if [ $? -eq 1 ]; then
    log "APM Configuration Failed"
    exit 1
  fi

  # Fix permissions To ensure WAS User can manage config
  chown -R wasadmin $APM_DIR/agent/yndchome

  # Restart Application Servers
  cd $APM_WAS_HOME/bin
  for SERVER in `./serverStatus.sh -all | grep ADMU0506I | awk '{print $NF}'`
  do
    su - $APM_WAS_USER -c "cd $APM_WAS_HOME/bin;./stopServer.sh $SERVER"
    su - $APM_WAS_USER -c "cd $APM_WAS_HOME/bin;./startServer.sh $SERVER"
  done

fi

exit 0
