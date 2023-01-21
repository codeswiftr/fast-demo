#!/bin/bash

# Define the service or host to wait for
host="db"
port="5432"

# Wait for the service or host to be available
while ! nc -z "$host" "$port"; do
  sleep 1
done

