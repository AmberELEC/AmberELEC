#!/bin/bash
# fan_control.sh
# v0.1:

# files that give us info about FAN and temperaturews of GPU and CPU

FAN=/sys/class/hwmon/hwmon0/pwm1
CPU=/sys/class/hwmon/hwmon1/temp1_input
GPU=/sys/class/hwmon/hwmon2/temp1_input

let TEMP_MIN=55000 #everything below this will turn off the fan
let TEMP_MAX=65000 #everything above this will turn fan to max
let TEMP_PREV=40000  # last temp measured (previous cicle)
let TEMP_CURRENT=0  # current temp measured (current cicle)

let FAN_OFF=0 # fan off
let FAN_MIN=55 # fan min speed
let FAN_MAX=255 # fan max peed
let FAN_PREV=125 # last fan speed (the first time we start from 50%)
FIRST_TIME="true"




# Constant to be used in the Linear funciton to increase the fan (to avoid division by number lower than zero we use the two expressions)
let FAN_K_DIFF=$FAN_MAX-$FAN_MIN;
let TEMP_K_DIFF=$TEMP_MAX-$TEMP_MIN; 
#let K=$FAN_K_DIFF/$TEMP_K_DIFF



while true; do
  
  OUTPUT=""
  TEMP_CURRENT_CPU=`cat ${CPU}`
  TEMP_CURRENT=`cat ${CPU}`
  
  # if temp of GPU is higher we take that one 
  TEMP_CURRENT_GPU=`cat ${GPU}`
  
  if [ "$TEMP_CURRENT_CPU" -le "$TEMP_CURRENT_GPU" ]; then
    TEMP_CURRENT=$TEMP_CURRENT_GPU
  fi
  OUTPUT+="-CPU: ${TEMP_CURRENT_CPU} -GPU: ${TEMP_CURRENT_GPU} -Max temp: ${TEMP_CURRENT}";
  
  if [ "$FIRST_TIME" == "true" ]; then
  # first time we se the fan at 50%
    echo $FAN_PREV  > $FAN
    OUTPUT+=" -- First run - Setting pwm to: ${FAN_PREV}"
    FIRST_TIME="false"
    # Set the fan speed based on highest temperature
  elif [ "$TEMP_CURRENT" -le "$TEMP_MIN" ]; then
    FAN_PREV=`cat $FAN` 
    # set fan to off
    echo $FAN_OFF  > $FAN
    OUTPUT+=" -- Reached min temp - Setting pwm to: ${FAN_OFF}"
  elif [ "$TEMP_CURRENT" -ge "$TEMP_MAX" ]; then
  FAN_PREV=`cat $FAN`
  # set fan to full speed
  echo $FAN_MAX > $FAN
  OUTPUT+=" -- Reached max temp - Setting pwm to: ${FAN_MAX}"
  else
    # Calculate linear fuction value between FAN_MIN and FAN_MAX

    let TEMP_DIFF=$TEMP_CURRENT-$TEMP_MIN
   #echo ">>TEMP_CURRENT: "$TEMP_CURRENT
   # echo ">>TEMP_PREV: "$TEMP_PREV
   # echo ">>TEMP_DIFF: "$TEMP_DIFF
    let NEW_FAN=$FAN_MIN+$TEMP_DIFF*$FAN_K_DIFF/$TEMP_K_DIFF 
   if  [ $TEMP_DIFF -eq 0 ] && [ "$FIRST_TIME" != "true" ] ; then
      NEW_FAN=$FAN_PREV
   fi
   
    #echo ">>NEW_FAN: "$NEW_FAN
    echo $NEW_FAN > $FAN
    OUTPUT+=" -- Adapting fan - Setting pwm to: ${NEW_FAN}"
  fi
  
  FAN_CURRENT=`cat $FAN`
  TEMP_PREV=$TEMP_CURRENT

  echo "${OUTPUT}"

  sleep 15;
done
