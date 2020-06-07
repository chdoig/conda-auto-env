#!/bin/bash

# conda-auto-env automatically activates a conda environment when
# entering a folder with an environment.yml file.
#
# If the environment doesn't exist, conda-auto-env creates it and
# activates it for you.
#
# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env_remote.sh
#
# conda-auto-env also supports remote anaconda.org environments.
# To specify a remote environment create an environment-remote.yml
# file with the name and channel of your environment

function conda_auto_env_remote() {
  if [ -e "environment.yml" ]; then
    # echo "environment.yml file found"
    ENV=$(head -n 1 environment.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      conda activate $ENV
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate
        echo "Conda env '$ENV' doesn't exist."
        conda env create -q
        conda activate $ENV
      fi
    fi
  fi
  if [ -e "environment-remote.yml" ]; then
    # echo "environment.yml file found"
    ENV=$(sed -n '1p' environment-remote.yml | cut -f2 -d ' ')
    CHANNEL=$(sed -n '2p' environment-remote.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      conda activate $ENV
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate
        echo "Conda env '$ENV' doesn't exist."
        REMOTE=$CHANNEL'/'$ENV
        conda env create $REMOTE -q
        conda activate $ENV
      fi
    fi
  fi
}

export PROMPT_COMMAND=conda_auto_env_remote
