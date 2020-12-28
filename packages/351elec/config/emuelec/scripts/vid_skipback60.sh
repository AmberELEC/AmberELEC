#!/bin/bash

echo '{"command":["keypress", "DOWN"]}' | socat - /tmp/mpvsocket
