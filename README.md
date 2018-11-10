# rpi-clock

![screenshot](https://raw.githubusercontent.com/seven1m/rpi-clock/master/screenshot.jpg)

This is a very simple clock and weather page for Raspberry Pi.

I needed a clock in my office and had a spare (cheap) flat-screen TV and a raspberry pi, so this was born.

It shows the current time, weather conditions (via Erik Flower's beautiful [weather icons](https://erikflowers.github.io/weather-icons/)),
current temperature (using the [OpenWeatherMap API](http://openweathermap.org/api)), low temp, high temp, and sunset.

You will *NEED* to get an API Key from [OpenWeatherMap](http://openweathermap.org) in order to successfully run this application

## Setup

I'm using Raspbian -- you can use any distro, but YMMV.

Pre-Req:

0.a: Install Git for the Raspberry Pi
```bash
sudo apt-get install git
```

1. Install Ruby 2.2.2 on your Raspberry Pi. I used RVM, but you can do it however you want.

1.a. Using RVM on your Raspberry PI
```bash
curl -L https://get.rvm.io | bash -s stable --ruby

source ~/.rvm/scripts/rvm

# Confirm everything was installed correctly
type rvm | head -n 1

# should read "rvm is a function"
```

2. Clone this repo or download the tarball and expand into your home directory on the Pi.
```
git clone https://github.com/hectorleiva/rpi-clock.git
```

3. Write a script in your home directory to start the app called "run_clock". This is mine:

    (NOTE: There are a few additional steps required below in order to get it set-up on a Pi. This guide is overall incomplete - but it can help you get started at the moment)

    ```bash
    #!/bin/bash

    cd /home/pi/rpi-clock
    GEM_PATH=/home/pi/.rvm/gems/ruby-2.2.2@rpi-clock:/home/pi/.rvm/gems/ruby-2.2.2@global 
    /home/pi/.rvm/rubies/ruby-2.2.2/bin/ruby app.rb &
    chmod +x run_clock
    ```

5. Run the script to make sure it works:

    ```bash
    ./run_clock
    ```

6. Now create a desktop item that will automatically start the script:

    ```bash
    sudo vim /etc/xdg/autostart/clock.desktop
    ```

    Put this in the file:

    ```
    [Desktop Entry]
    Name=Clock App
    Exec=/home/pi/run_clock
    Type=Application
    Terminal=true
    ```

7. Last, set the Pi to start with no desktop:

    ```bash
    sudo vim /etc/xdg/lxsession/LXDE/autostart
    ```

    **Comment out the stuff in that file** and then put this in the file:

    ```
    @xset s off
    @xset -dpms
    @xset s noblank
    ```

8. (Optional) Disable overscan and force HDMI output:

    ```bash
    sudo vim /boot/config.txt
    ```

    Set the following options:

    ```
    disable_overscan=1
    hdmi_force_hotplug=1
    hdmi_drive=2
    ```

Boot the Pi and see if it works!

## Copyright and License

The weather icons are licensed SIL Open Font License 1.1.

All other code was written by me and is public domain. Use it as you wish.
