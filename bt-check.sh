#!/bin/bash

[ "$#" -eq 1 ] || { echo "MAC Address is required. no arguments are provided." >&2; exit 1; }

readonly MAC=${1}
readonly GPIO=${2:-25}
readonly DURATION_S=${3:-30}
readonly WAIT_S=${4:-3}
readonly DEBUG=false

function check_btdevice(){
	mac=$1
	# scan on and wait.
	echo -e 'menu scan\nclear\nback\nscan on' >&${COPROC[1]}
	sleep $WAIT_S
	echo -e 'scan off' >&${COPROC[1]}

	echo -e 'info '$mac>&${COPROC[1]}


	# judge the outputs.
	is_exist=1
	reg_t="*NEW*Device[[:space:]]$mac*"
	reg_f="Device[[:space:]]$mac[[:space:]]not[[:space:]]available*"
	while read -r -u "${COPROC[0]}" line; do
	  if [[ $line == $reg_t ]]; then
		  is_exist=0
		  break
	  fi

	  if [[ $line == $reg_f  ]]; then
		  is_exist=1
		  break
	  fi

	  if $DEBUG; then
		  echo $line
	  fi
	done
	return $is_exist
}

init_gpio() {
	gpio -g mode $GPIO out
	trap "gpio -g write $GPIO 0;echo -e 'exit' >&${COPROC[1]}; exit 0" 0 
	gpio -g write $GPIO 0
	return 0
}

gpio_on(){
	gpio -g write $GPIO 1
	return 0
}

gpio_off(){
	gpio -g write $GPIO 0
	return 0
}


coproc bluetoothctl
init_gpio
status=-1
while true; do

     	if check_btdevice $MAC; then
		if [ "$status" != 0 ]; then
			status=0
			echo "Found: $MAC"
			gpio_on
		fi
	else
		if [ "$status" != 1 ]; then
			status=1
			echo "Not Found: $MAC"
			gpio_off
		fi
	fi
	sleep $DURATION_S
done
