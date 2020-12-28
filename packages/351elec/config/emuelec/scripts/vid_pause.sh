#!/bin/bash

echo '{"command":["keypress", "p"]}' | socat - /tmp/mpvsocket
