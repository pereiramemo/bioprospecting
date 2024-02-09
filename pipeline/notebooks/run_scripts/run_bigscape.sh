#!/bin/bash

set -o errexit
set -o nounset

function realpath() {
  echo $(readlink -f $1 2>/dev/null || python -c "import sys; import os; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" $1)
}

# handle input file
readonly INPUT_FILE=$(basename $1)
echo input ${INPUT_FILE}
readonly INPUT_DIR=$(dirname $(realpath $1))
shift

# handle output file
if [[ $# -eq 0 ]]; then
  echo You must specify an output dir
  exit 1;
else
  readonly OUTPUT_FILE=$(basename $1)
  echo output ${OUTPUT_FILE}
  readonly OUTPUT_DIR=$(dirname $(realpath $1))
  shift
fi

if [ ! -d ${OUTPUT_DIR} ]; then
  mkdir ${OUTPUT_DIR}
fi

# Links within the container
readonly CONTAINER_SRC_DIR=/home/input
readonly CONTAINER_DST_DIR=/home/output


#if [ ${INPUT_FILE} ${OUTPUT_FILE} ]; then
if [ ! -z ${INPUT_FILE} ] && [ ! -z ${OUTPUT_FILE} ]; then
#  docker pull ghcr.io/medema-group/big-scape:master
  docker run \
  --volume ${INPUT_DIR}:${CONTAINER_SRC_DIR}:ro \
  --volume ${OUTPUT_DIR}:${CONTAINER_DST_DIR}:rw \
  --detach=false \
  --rm \
  --user=$(id -u):$(id -g) \
  ghcr.io/medema-group/big-scape:master \
  -i ${CONTAINER_SRC_DIR}/${INPUT_FILE} \
  -o ${CONTAINER_DST_DIR}/${OUTPUT_FILE} \
  $@
fi

