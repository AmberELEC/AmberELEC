#!/bin/bash
# fan_control.sh
# v0.1:

# files that give us info about FAN and temperaturews of GPU and CPU

FAN=/sys/class/hwmon/hwmon0/pwm1
CPU=/sys/class/hwmon/hwmon1/temp1_input
GPU=/sys/class/hwmon/hwmon2/temp1_input
CONFIG_FILE="/storage/.config/distribution/configs/distribution.conf"

source /etc/profile

function set_fan_variables() {
  let FAN_SLEEP=15 # how long to sleep before reevaluating
  let FAN_OFF=0 # fan off
  let FAN_MIN=78 # fan min speed (below 78 the fan is so close to stopping, rotating the device can cause it to stop)
  let FAN_MAX=255 # fan max speed
  let TEMP_MIN=40000 #everything below this will turn off the fan
  let TEMP_MAX=70000 #everything above this will turn fan to max

  # 'critical' temp is mostly to allow for 'quiet' to still hit 255 without being 'linear'
  #  at some point without gradually scaling up to it since 'MAX' will be less than 255
  let FAN_CRITICAL=255 # fan speed at critical temp
  let TEMP_CRITICAL=75000

  if [[ "$FAN_PROFILE" == "performance" ]]; then
    let TEMP_MIN=30000
    let TEMP_MAX=65000
  elif [[ "$FAN_PROFILE" == "quiet" ]]; then
    let TEMP_MIN=45000
    let TEMP_MAX=$TEMP_CRITICAL
    let FAN_MAX=127
  fi
  echo "Fan profile: ${FAN_PROFILE}"
  echo "TEMP_MIN: ${TEMP_MIN} TEMP_MAX: ${TEMP_MAX} FAN_MIN: ${FAN_MIN} FAN_MAX: ${FAN_MAX} SLEEP: ${FAN_SLEEP}"
  let TEMP_CURRENT=0  # current temp measured (current cycle)
  # Constant to be used in the Linear funciton to increase the fan (to avoid division by number lower than zero we use the two expressions)
  let FAN_K_DIFF=$FAN_MAX-$FAN_MIN;
  let TEMP_K_DIFF=$TEMP_MAX-$TEMP_MIN;

}


while true; do
  
  # To avoid calling get_ee_setting each time through loop, only check fan.profile setting when distribution.conf changes
  CONFIG_FILE_LAST_MODIFIED_TIME=$(date -r ${CONFIG_FILE})
  
  if [[ "${CONFIG_FILE_LAST_MODIFIED_TIME}" != "${CONFIG_FILE_LAST_MODIFIED_TIME_PREV}" ]]; then
    FAN_PROFILE=$(get_ee_setting fan.profile)
    if [[ -z "$FAN_PROFILE" ]]; then
      FAN_PROFILE=default
    fi
    # To avoid outputting logging as though profile changed, check fan.profile changed
    if [[ "$FAN_PROFILE" != "$FAN_PROFILE_PREV" ]]; then
      set_fan_variables
    fi

    # Variables to keep track of to see if fan.profile changed
    CONFIG_FILE_LAST_MODIFIED_TIME_PREV=$(date -r ${CONFIG_FILE})
    FAN_PROFILE_PREV="${FAN_PROFILE}"

  fi
  FAN_PROFILE_PREV="${FAN_PROFILE}"
  OUTPUT=""
  TEMP_CURRENT_CPU=`cat ${CPU}`
  TEMP_CURRENT=`cat ${CPU}`
  
  # if temp of GPU is higher we take that one 
  TEMP_CURRENT_GPU=`cat ${GPU}`
  
  if [ "$TEMP_CURRENT_CPU" -le "$TEMP_CURRENT_GPU" ]; then
    TEMP_CURRENT=$TEMP_CURRENT_GPU
  fi
  OUTPUT+="-CPU: ${TEMP_CURRENT_CPU} -GPU: ${TEMP_CURRENT_GPU} -Max temp: ${TEMP_CURRENT}";
  
  if [ "$TEMP_CURRENT" -le "$TEMP_MIN" ]; then
    # set fan to off
    echo $FAN_OFF  > $FAN
    OUTPUT+=" -- Reached min temp - Setting pwm to: ${FAN_OFF}"
  elif [ "$TEMP_CURRENT" -ge "$TEMP_CRITICAL" ]; then
    # set fan to full speed
    echo $FAN_CRITICAL > $FAN
    OUTPUT+=" -- Reached critical temp - Setting pwm to: ${FAN_CRITICAL}"
  elif [ "$TEMP_CURRENT" -ge "$TEMP_MAX" ]; then
    # set fan to full speed
    echo $FAN_MAX > $FAN
    OUTPUT+=" -- Reached max temp - Setting pwm to: ${FAN_MAX}"
  else
    # Calculate linear fuction value between FAN_MIN and FAN_MAX
    let TEMP_DIFF=$TEMP_CURRENT-$TEMP_MIN
    let NEW_FAN=$FAN_MIN+$TEMP_DIFF*$FAN_K_DIFF/$TEMP_K_DIFF 
    echo $NEW_FAN > $FAN
    OUTPUT+=" -- Adapting fan - Setting pwm to: ${NEW_FAN}"
  fi

  echo "${OUTPUT}"

  sleep $FAN_SLEEP;
done
