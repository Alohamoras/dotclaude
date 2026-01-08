#!/bin/bash
cd /home/duane/.steam/debian-installation/steamapps/common/Valheim
nohup ./start_game_bepinex.sh > /dev/null 2>&1 &
disown
