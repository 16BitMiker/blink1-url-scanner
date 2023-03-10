# blink(1) URL scanner

## About

This script is used to continually scan a domain and report back via the [**blink(1)**](https://blink1.thingm.com/) device on the domains status.

Color status breakdown:

- **flashing blue** >> scanning webite
- **red** >> can not connect to domain
- **green** >> connection success
- **yellow** >> redirected
- **purple** >> access denied 

## Usage 

- `blink1-url-scanner.pl <URL>`

## To Do 

- fix location of blink device
- make script run in the background