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
    # Check if the environment is already active.
    if [[ $PATH != */envs/*$ENV*/* ]]; then
      # Attempt to activate environment.
      CONDA_ENVIRONMENT_ROOT="" #For spawned shells
      source activate $ENV
      # Set root directory of active environment.
      CONDA_ENVIRONMENT_ROOT="$(pwd)"
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate.
        echo "Conda environment '$ENV' doesn't exist: Creating."
        conda env create -q
        source activate $ENV
      fi
    fi
  fi
  if [ -e "environment-remote.yml" ]; then
    # echo "environment.yml file found"
    ENV=$(sed -n '1p' environment-remote.yml | cut -f2 -d ' ')
    CHANNEL=$(sed -n '2p' environment-remote.yml | cut -f2 -d ' ')
    # Check if the environment is already active.
    if [[ $PATH != */envs/*$ENV*/* ]]; then
      # Attempt to activate environment.
      CONDA_ENVIRONMENT_ROOT="" #For spawned shells
      source activate $ENV
      # Set root directory of active environment.
      CONDA_ENVIRONMENT_ROOT="$(pwd)"
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate.
        echo "Conda env '$ENV' doesn't exist."
        REMOTE=$CHANNEL'/'$ENV
        conda env create $REMOTE -q
        source activate $ENV
      fi
    fi
  fi
  # Deactivate active environment if we are no longer among its subdirectories.
  if [[ $PATH = */envs/* ]]\
    && [[ $(pwd) != $CONDA_ENVIRONMENT_ROOT ]]\
    && [[ $(pwd) != $CONDA_ENVIRONMENT_ROOT/* ]]
  then
    CONDA_ENVIRONMENT_ROOT=""
    source deactivate
  fi
}

export PROMPT_COMMAND=conda_auto_env_remote
