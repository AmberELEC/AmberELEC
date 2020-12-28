#!/bin/bash

echo '{"command":["keypress", "RIGHT"]}' | socat - /tmp/mpvsocket
