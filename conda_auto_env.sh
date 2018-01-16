#!/bin/bash

# conda-auto-env is a utility to activate a conda environment in a folder
# with an environment.yml file or based on the current dir's name.
#
# If the environment doesn't exist, conda-auto-env creates it and
# activates it for you.
#
# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env.sh
#

DEFAULT_PY_VER=3.6

function conda_auto_env() {

  function activate_env() {
    conda activate $1
    if [[ $? -eq 0 ]]; then
      echo "${1} activated successfully"
    else
      echo "Failed to activate ${1}"
      return 1
    fi
  }

  function deactivate_env() {
    conda deactivate
    if [[ $? -eq 0 ]]; then
      echo "Deactivated successfully"
    else
      echo "Failed to deactivate"
      return 1
    fi
  }

  # Determine ENV's name; eitehr from environment.yml
  # or based on current dir name
  if [ -e "environment.yml" ]; then
    echo "Found environment.yml"
    ENV=$(head -n 1 environment.yml | cut -f2 -d ' ')
  else
    echo "No environment.yml found. Reverting to current dir"
    ENV=${PWD##*/}
  fi

  echo "Processing the environment: ${ENV}"

  CURRENT_ENV=$(conda env list | grep \* | cut -f 1 -d " ")

  if [ $ENV = $CURRENT_ENV ]; then
    # ENV is already activated. Deactivate
    deactivate_env
  elif [[ $PATH != *$ENV* ]]; then
    # ENV is not activated. Trying to activate
    activate_env $ENV
    if [ $? -ne 0 ]; then
      # Failed to activate. Creating environment
      echo "Conda env '$ENV' doesn't exist."
      if [[ -e "environment.yml" ]]; then
        echo "Creating ${ENV} based on environment.yml"
        conda env create -q
      else
        echo "Creating ${ENV} with default settings"
        conda create -n ${ENV} python=${DEFAULT_PY_VER}
      fi
      activate_env $ENV
    fi
  fi

  # Make sure utility functions are local
  unset -f activate_env
  unset -f deactivate_env
}
