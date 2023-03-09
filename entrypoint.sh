#!/bin/sh

function usage_docs {
  echo ""
  echo "- uses: robbrad/github-aws-device-farm@v1.0.0"
  echo "  with:"
  echo "    command: devicefarm" # NEEDS us-west-2
  echo ""
}
function get_configuration_settings {
  if [ -z "$INPUT_AWS_ACCESS_KEY_ID" ]
  then
    echo "AWS Access Key Id was not found. Using configuration from previous step."
  else
    aws configure set aws_access_key_id "$INPUT_AWS_ACCESS_KEY_ID"
  fi

  if [ -z "$INPUT_AWS_SECRET_ACCESS_KEY" ]
  then
    echo "AWS Secret Access Key was not found. Using configuration from previous step."
  else
    aws configure set aws_secret_access_key "$INPUT_AWS_SECRET_ACCESS_KEY"
  fi

  if [ -z "$INPUT_AWS_SESSION_TOKEN" ]
  then
    echo "AWS Session Token was not found. Using configuration from previous step."
  else
    aws configure set aws_session_token "$INPUT_AWS_SESSION_TOKEN"
  fi

  if [ -z "$INPUT_METADATA_SERVICE_TIMEOUT" ]
  then
    echo "Metadata service timeout was not found. Using configuration from previous step."
  else
    aws configure set metadata_service_timeout "$INPUT_METADATA_SERVICE_TIMEOUT"
  fi

  if [ -z "$INPUT_AWS_REGION" ]
  then
    echo "AWS region not found. Using configuration from previous step."
  else
    aws configure set region "$INPUT_AWS_REGION"
  fi
}
function get_command {
  VALID_COMMANDS=("create-test-grid-url" "list-test-grid-sessions")
  COMMAND="create-test-grid-url"
  if [ -z "$INPUT_COMMAND" ]
  then
    echo "Command not set using create-test-grid-url"
  elif [[ ! ${VALID_COMMANDS[*]} =~ "$INPUT_COMMAND" ]]
  then
    echo ""
    echo "Invalid command provided :: [$INPUT_COMMAND]"
    usage_docs
    exit 1
  else
    echo "Using provided command"
    COMMAND=$INPUT_COMMAND
  fi
}
function main {
  echo "v1.0.0"
  get_configuration_settings
  get_command

  aws --version

  if [ "$COMMAND" == "create-test-grid-url" ] || [ "$COMMAND" == "list-test-grid-sessions" ]
  then
    echo aws devicefarm $COMMAND $INPUT_FLAGS
    aws devicefarm "$COMMAND" $INPUT_FLAGS --output text --query 'url'
  fi
}

main