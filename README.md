# BT Device Status Notifier


Simple bash script to notify bluetooth device power status by lighting LED for Raspberry pi.
It's for online conference participants to let their roommates know that they are in a conference.

![demo](https://user-images.githubusercontent.com/25410554/114296955-f5b06380-9ae8-11eb-95b2-70b1607a1bd1.gif)

It requires bluez and wiringpi to run.

```bash
sudo apt install wiringpi bluez
```

Tested on Raspberry pi zero.


# Usage

## START

Before you start, check your BT device MAC Address.  
Default GPIO port is 25. Connect LED to 25 and then run:

```bash
sudo bash bt-check.sh <MACADDR>
```

example:

```bash
sudo bash bt-check.sh AA:BB:CC:DD:EE:FF
```

additional positional arguments:
```bash
sudo bash bt-check.sh <MACADDR> <GPIO_PORT> <INTERVAL_TIME> <SCAN_TIME> <DEBUG>
```


* GPIO_PORT: The gpio port number to use. default value is 25.  
* INTERVAL_TIME: The interval how often the script scan BT devices. Unit is secound. default value is 30.    
* SCAN_TIME: The scanning time. Unit is secound. default value is 3.  
* DEBUG: Show all scaninng outputs. default is false.  


## STOP 

To stop the script, Crtl+C will work.


# note

Paring is not necessary. The script will just scan BT devices around the raspberry pi and check the device exist.

