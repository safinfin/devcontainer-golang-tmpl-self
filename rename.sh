#!/bin/bash
set -eu

mkFile="$(dirname "${0}")/Makefile"
devconDir="$(dirname "${0}")/.devcontainer"
devconJson="${devconDir}/devcontainer.json"
composeYml="${devconDir}/compose.yaml"
appName=""
modName=""

function usage() {
  cat << EOF

initialization script to replace app-name and mod-name in the template files.

- app-name: your app name
- mod-name: your module name
- template files:
  - project_root/Makefile
  - project_root/.devcontainer/devcontainer.json
  - project_root/.devcontainer/compose.yaml

Usage:
  ${0} -a <app-name> -m <mod-name>

Example:
  ${0} -a sampleapp -m github.com/safinfin/sampleapp
EOF
}

function parse_args() {
  while getopts "a:m:h" OPT; do
    case ${OPT} in
      a)
        appName=${OPTARG}
        ;;
      m)
        modName=${OPTARG}
        ;;
      h)
        usage
        exit 0
        ;;
      :|\?)
        usage
        exit 0
        ;;
    esac
  done
}

function check_args() {
  if [[ -z ${appName} || -z ${modName} ]]; then
    echo "the flag '-a' and '-m' is required"
    usage
    exit 1
  fi
}

function check_file() {
  if [[ ! -f ${mkFile} ]]; then
    echo "${mkFile} does not exist"
    exit 1
  fi
  if [[ ! -f ${devconJson} ]]; then
    echo "${devconJson} does not exist"
    exit 1
  fi
  if [[ ! -f ${composeYml} ]]; then
    echo "${composeYml} does not exist"
    exit 1
  fi
}

function main() {
  echo "----- start -----"

  echo "--- replace 'app-name' to '${appName}' in ${mkFile} ---"
  sed -i -e "s|app-name|${appName}|g" "${mkFile}"
  echo "--- replace 'mod-name' to '${modName}' in ${mkFile} ---"
  sed -i -e "s|mod-name|${modName}|g" "${mkFile}"

  echo "--- replace 'app-name' to '${appName}' in ${devconJson} ---"
  sed -i -e "s|app-name|${appName}|g" "${devconJson}"

  echo "--- replace 'app-name' to '${appName}' in ${composeYml} ---"
  sed -i -e "s|app-name|${appName}|g" "${composeYml}"
  echo "--- replace 'mod-name' to '${modName}' in ${composeYml} ---"
  sed -i -e "s|mod-name|${modName}|g" "${composeYml}"

  echo "----- finish -----"
}

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  parse_args "$@"
  check_args "$@"
  check_file
  main "${appName}" "${modName}"
  exit 0
fi
