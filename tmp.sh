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

function conda_auto_env() {
  if [ -e "env.yml" ]; then
    #echo "env.yml file found"
    ENV=$(head -n 1 env.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    #echo $ENV
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      #echo $ENV
      source activate $ENV
      if [ $? -eq 0 ]; then
        echo "activated"
        :
      else
        # Create the environment and activate
        echo "Conda env '$ENV' doesn't exist."
        conda env create -q
        source activate $ENV
      fi
    fi
  fi
  if [ -e "environment.yml" ]; then
    # echo "environment.yml file found"
    ENV=$(head -n 1 environment.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      source activate $ENV
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate
        echo "Conda env '$ENV' doesn't exist."
        conda env create -q
        source activate $ENV
      fi
    fi
  fi
}

if [ $(ps -p$$ -ocmd=) "=" "zsh" ]
then
  precmd() { conda_auto_env; }
else
  export PROMPT_COMMAND=conda_auto_env
fi
