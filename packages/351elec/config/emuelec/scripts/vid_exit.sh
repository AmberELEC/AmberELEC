#!/bin/bash

echo '{"command":["keypress", "q"]}' | socat - /tmp/mpvsocket
