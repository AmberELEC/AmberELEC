#!/bin/bash

echo '{"command":["keypress", "UP"]}' | socat - /tmp/mpvsocket
