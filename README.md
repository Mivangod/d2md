# DM2D Pipeline Scripts

This directory contains the scripts needed to run the DM2D image processing pipeline using Docker.

## Contents

- `options.sh`: Configuration file for environment variables and default settings
- `run.sh`: Main script for running the pipeline

## Quick Start

1. Make the scripts executable:
```bash
chmod +x options.sh run.sh
```

2. Place your input files in the `lkl/` directory (e.g., `lkl/PMD1211_58_5001_12501.tif`).

3. Run the pipeline:
```bash
./run.sh PMD1211_58_5001_12501.tif
```

## Configuration (options.sh)

The `options.sh` file contains the following configurable settings:

```bash
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
```

## Usage (run.sh)

The `run.sh` script provides a command-line interface for running the pipeline:

```bash
./run.sh <input_file_relative_to_lkl> [options]
```

### Command Line Options

- `-x <number>`: Division in x direction
- `-y <number>`: Division in y direction
- `-v <number>`: VE persistence threshold
- `-e <number>`: ET persistence threshold
- `-k`: Keep scratch directory after processing
- `-h`: Show help message

### Examples

1. Basic usage with default parameters:
```bash
./run.sh PMD1211_58_5001_12501.tif
```

2. Custom division and thresholds:
```bash
./run.sh PMD1211_58_5001_12501.tif -x 2 -y 2 -v 0.5 -e 0.3
```

3. Keep scratch files:
```bash
./run.sh PMD1211_58_5001_12501.tif -k
```

## Directory Structure

The script will use and create the following structure:

```
for_github/
├── lkl/                  # Input directory (place your .tif files here)
│   └── PMD1211_58_5001_12501.tif
├── output/               # Output directory (results will be saved here)
│   └── merged_geojson.json
├── json_out/             # JSON output directory (intermediate and final JSON files)
├── scratch/              # Temporary files (cleaned up by default)
├── run.sh
├── options.sh
└── README.md
```

## Troubleshooting

1. **Permission Issues**
   - Ensure scripts are executable: `chmod +x *.sh`
   - Check directory permissions: `ls -la`

2. **Docker Issues**
   - Verify Docker is running: `docker ps`
   - Check image exists: `docker images | grep mitracshl/dm2d`
   - For Apple Silicon users:
     ```bash
     # Verify the image is available
     docker images | grep mitracshl/dm2d
     
     # If image is not found, pull it:
     docker pull mitracshl/dm2d:optimized
     ```

3. **GPU Issues**
   - Verify NVIDIA drivers: `nvidia-smi`
   - Check NVIDIA Container Toolkit: `docker info | grep nvidia`

## Notes

- The scripts use the Docker image tagged as `mitracshl/dm2d:optimized`
- For Apple Silicon Macs:
  - Ensure Docker Desktop is running with Rosetta 2
  - The `--platform linux/amd64` flag is automatically added
  - You may need to build the image locally first if not available on Docker Hub
- Output files are saved in the `output/` directory
- Temporary files are stored in the `scratch/` directory and cleaned up by default
- Place your input files in the `lkl/` directory

# To pull the image from Docker Hub (if not present locally):
docker pull mitracshl/dm2d:optimized 