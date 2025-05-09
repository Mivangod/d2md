#!/bin/bash

#This script is used to set the environment variables for the Docker container
#It is used to run the Docker container with the optimized version of DM2D

# Environment variables for NVIDIA GPU support
export NVIDIA_VISIBLE_DEVICES=all
export NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Volume mappings
export VOLUME_INPUT=/app/input
export VOLUME_OUTPUT=/app/output
export VOLUME_SCRATCH=/app/scratch_1
export VOLUME_JSON=/app/json_out

# Default parameters
export DIVISION_X=1
export DIVISION_Y=1
export VE_THRESHOLD=0.0
export ET_THRESHOLD=0.0
export KEEP_SCRATCH=false

# Docker image name
export DOCKER_IMAGE="mitracshl/dm2d:optimized"

# Platform specification for Apple Silicon
export DOCKER_PLATFORM="--platform linux/amd64"
