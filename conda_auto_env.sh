#!/bin/bash

# conda-auto-env automatically activates a conda environment when
# entering a folder with an environment.yml file.
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
  # Determine ENV's name; eitehr from environment.yml
  # or based on current dir name
  if [ -e "environment.yml" ]; then
    echo "environment.yml file found"
    ENV=$(head -n 1 environment.yml | cut -f2 -d ' ')
  else
    echo "No environment.yml found. Reverting to current dir"
    ENV=${PWD##*/}
  fi

  echo "Processing the environment: ${ENV}"

  ACTIVATED="${ENV} activated!"
  DEACTIVATE="${ENV} is already activated. Deactivating..."
  CURRENT_ENV=$(conda env list | grep \* | cut -f 1 -d " ")

  if [ $ENV = $CURRENT_ENV ]; then
    # ENV is already activated. Deactivate
    echo $DEACTIVATE
    conda deactivate
    if [[ $? -eq 0 ]]; then
      echo "Deactivated successfully"
    else
      echo "Failed to deactivate"
    fi
  elif [[ $PATH != *$ENV* ]]; then
    # ENV is not activated. Trying to activate
    conda activate $ENV
    if [ $? -eq 0 ]; then
      echo $ACTIVATED
    else
      # Failed to activate. Creating environment
      echo "Conda env '$ENV' doesn't exist."
      if [[ -e "environment.yml" ]]; then
        conda env create -q
      else
        echo "Creating ${ENV} with default settings"
        conda create -n ${ENV} python=${DEFAULT_PY_VER}
      fi
      conda activate $ENV
      echo $ACTIVATED
    fi
  fi
}
