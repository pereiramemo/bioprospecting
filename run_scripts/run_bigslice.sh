#!/bin/bash

set -o errexit
# set -o nounset

###############################################################################
# 1. Parse input and output dirs
###############################################################################

function realpath() {
  CURRENT_DIR=$(pwd)
  DIR=$(dirname $1)
  FILE=$(basename $1)
  cd "${DIR}"
  echo "$(pwd)/${FILE}"
  cd "${CURRENT_DIR}"
}

# handle mode
readonly MODE="${1}"
shift

# handle input dir
readonly INPUT_DIR_PATH=$(dirname $(realpath "${1}"))
readonly INPUT_DIR_NAME=$(basename $(realpath "${1}"))
shift

# handle output file
readonly OUTPUT_DIR_PATH=$(dirname $(realpath "${1}"))
readonly OUTPUT_DIR_NAME=$(basename $(realpath "${1}"))
shift

# Links within the container
readonly CONTAINER_SRC_DIR=/input
readonly CONTAINER_DST_DIR=/output

if [[ ! -d "${OUTPUT_DIR_PATH}" ]]; then
    mkdir "${OUTPUT_DIR_PATH}"
    if [[ $? -ne "0" ]]; then
      echo "mkdir ${OUTPUT_DIR_PATH} failed"
    fi  
fi 

# echo "input dir path: ${INPUT_DIR_PATH}"
# echo "input dir name: ${INPUT_DIR_NAME}"
# echo "output dir path: ${OUTPUT_DIR_PATH}"
# echo "output dir name: ${OUTPUT_DIR_NAME}"

###############################################################################
# 2. Run bigslice in Mode 1: clustering input BGCs
###############################################################################

if [[ "${MODE}" == "cluster" ]]; then
  docker run \
      --volume ${INPUT_DIR_PATH}:${CONTAINER_SRC_DIR}:ro \
      --volume ${OUTPUT_DIR_PATH}:${CONTAINER_DST_DIR}:rw \
      --detach=false \
      --rm \
      --user=$(id -u):$(id -g) \
      epereira/bigslice:latest \
      -i ${CONTAINER_SRC_DIR}/${INPUT_DIR_NAME} \
      $@ \
      ${CONTAINER_DST_DIR}/${OUTPUT_DIR_NAME}
fi

###############################################################################
# 3. Run bigslice in Mode 2: quering input BGCs against reference DB
###############################################################################

if [[ "${MODE}" == "query" ]]; then
  docker run \
      --volume ${INPUT_DIR_PATH}:${CONTAINER_SRC_DIR}:ro \
      --volume ${OUTPUT_DIR_PATH}:${CONTAINER_DST_DIR}:rw \
      --detach=false \
      --rm \
      --user=$(id -u):$(id -g) \
      epereira/bigslice:latest \
      --query ${CONTAINER_SRC_DIR}/${INPUT_DIR_NAME} \
      $@ \
      ${CONTAINER_DST_DIR}/${OUTPUT_DIR_NAME} 
fi

