#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p ~/.aws/

# Dump clipboard contents to the credential file
pbpaste > ~/.aws/credentials

echo "Clipboard contents saved to ~/.aws/crendential/credential"
