#!/bin/bash

set -o errexit
set -o nounset

function realpath() {
    echo $(readlink -f $1 2>/dev/null || python -c "import sys; import os; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" $1)
}

# handle input file
readonly INPUT_FILE=$(basename $1)
readonly INPUT_DIR=$(dirname $(realpath $1))
shift

# handle output file
readonly OUTPUT_DIR=$(realpath $1)
shift

# handle version
readonly VERSION=$1
shift

# Links within the container
readonly CONTAINER_SRC_DIR=/input
readonly CONTAINER_DST_DIR=/output

if [ ! -d ${OUTPUT_DIR} ]; then
    mkdir ${OUTPUT_DIR}
fi

# echo $INPUT_FILE
# echo "${OUTPUT_DIR}"
# echo "${VERSION}"

docker run \
    --volume ${INPUT_DIR}:${CONTAINER_SRC_DIR}:ro \
    --volume ${OUTPUT_DIR}:${CONTAINER_DST_DIR}:rw \
    --detach=false \
    --rm \
    --user=$(id -u):$(id -g) \
    antismash/standalone:${VERSION} \
    ${INPUT_FILE} \
    $@
