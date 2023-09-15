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

# handle input file
readonly INPUT_FILE=$(basename "${1}")
readonly INPUT_DIR=$(dirname $(realpath "${1}"))
shift

# handle output file
readonly OUTPUT_FILE=$(basename "${1}")
readonly OUTPUT_DIR=$(dirname $(realpath "${1}"))
shift

# Links within the container
readonly CONTAINER_SRC_DIR=/input
readonly CONTAINER_DST_DIR=/output

if [[ ! -d "${OUTPUT_DIR}" ]]; then
    mkdir "${OUTPUT_DIR}"
    if [[ $? -ne "0" ]]; then
      echo "mkdir ${OUTPUT_DIR} failed"
    fi  
fi 

# echo "input dir: ${INPUT_DIR}"
# echo "input file: ${INPUT_FILE}"
# echo "output dir: ${OUTPUT_DIR}"
# echo "output file: ${OUTPUT_FILE}"

###############################################################################
# 2. Run mmseqs taxonomy
###############################################################################

docker run \
  --volume ${INPUT_DIR}:${CONTAINER_SRC_DIR}:ro \
  --volume ${OUTPUT_DIR}:${CONTAINER_DST_DIR}:rw \
  --detach=false \
  --rm \
  --user=$(id -u):$(id -g) \
  epereira/mmseqs:latest easy-taxonomy \
  ${CONTAINER_SRC_DIR}/${INPUT_FILE} \
  /resources/siwss_prot \
  ${CONTAINER_DST_DIR}/${OUTPUT_FILE} \
  /tmp/tmp \
  $@
  

