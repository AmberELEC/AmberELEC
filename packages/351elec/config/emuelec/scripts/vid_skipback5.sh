#!/bin/bash

echo '{"command":["keypress", "LEFT"]}' | socat - /tmp/mpvsocket
