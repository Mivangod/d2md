#!/bin/bash

# Source the options file
source "$(dirname "$0")/options.sh"

usage() {
    echo "Usage: $0 <input_file_relative_to_lkl> [options]"
    echo "Options:"
    echo "  -x <number>    Division in x direction (default: $DIVISION_X)"
    echo "  -y <number>    Division in y direction (default: $DIVISION_Y)"
    echo "  -v <number>    VE persistence threshold (default: $VE_THRESHOLD)"
    echo "  -e <number>    ET persistence threshold (default: $ET_THRESHOLD)"
    echo "  -k            Keep scratch directory"
    echo "  -h            Show this help message"
    exit 1
}

# Parse command line arguments
while getopts "x:y:v:e:kh" opt; do
    case $opt in
        x) DIVISION_X="$OPTARG";;
        y) DIVISION_Y="$OPTARG";;
        v) VE_THRESHOLD="$OPTARG";;
        e) ET_THRESHOLD="$OPTARG";;
        k) KEEP_SCRATCH=true;;
        h) usage;;
        ?) usage;;
    esac
done

shift $((OPTIND-1))

if [ $# -eq 0 ]; then
    echo "Error: Input file is required"
    usage
fi

INPUT_FILE_REL="$1"  # e.g., PMD1211_58_5001_12501.tif

# Get absolute paths for all mounts
BASE_DIR="$(pwd)"
LKL_DIR="$BASE_DIR/lkl"
OUTPUT_DIR="$BASE_DIR/output"
JSON_OUT_DIR="$BASE_DIR/json_out"
SCRATCH_DIR="$BASE_DIR/scratch"

# Create necessary directories
mkdir -p "$LKL_DIR" "$OUTPUT_DIR" "$JSON_OUT_DIR" "$SCRATCH_DIR"

# Build the Docker run command
DOCKER_CMD="docker run $DOCKER_PLATFORM \
    -v $LKL_DIR:$VOLUME_INPUT \
    -v $OUTPUT_DIR:$VOLUME_OUTPUT \
    -v $JSON_OUT_DIR:$VOLUME_JSON \
    -v $SCRATCH_DIR:$VOLUME_SCRATCH \
    $DOCKER_IMAGE \
    $VOLUME_INPUT/$INPUT_FILE_REL"

# Add extra arguments if specified
if [ ! -z "$DIVISION_X" ]; then
    DOCKER_CMD="$DOCKER_CMD --division-x $DIVISION_X"
fi
if [ ! -z "$DIVISION_Y" ]; then
    DOCKER_CMD="$DOCKER_CMD --division-y $DIVISION_Y"
fi
if [ ! -z "$VE_THRESHOLD" ]; then
    DOCKER_CMD="$DOCKER_CMD --ve-threshold $VE_THRESHOLD"
fi
if [ ! -z "$ET_THRESHOLD" ]; then
    DOCKER_CMD="$DOCKER_CMD --et-threshold $ET_THRESHOLD"
fi
if [ "$KEEP_SCRATCH" = true ]; then
    DOCKER_CMD="$DOCKER_CMD --keep-scratch"
fi

echo "Running: $DOCKER_CMD"
eval "$DOCKER_CMD"

