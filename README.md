# Prometheus OneWire sensors exporter

This is an exporter that exposes information gathered from OneWire
sensors in Prometheus friendly format.

## Prerequisites

Before building this exporter you need a working golang development environment. A good starting point is the 
[Golang Getting Started](https://golang.org/doc/install) document.

To install latest version on Raspberry Pi, follow [this forum post](https://forums.raspberrypi.com/viewtopic.php?t=317369#p1926129) or its transcript below.
```
su -
password

1) Download Golang - ARMv6 version at https://golang.org/dl/
Example:
root@raspberrypi:/home/pi/Downloads#
go1.17.2.linux-armv6l.tar.gz

2) Extract the archive you downloaded into /usr/local, creating a Go tree in /usr/local/go
root@raspberrypi:/home/pi/Downloads#
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.2.linux-armv6l.tar.gz

4) Create directory go at /home/pi
/home/pi mkdir go

5) Create directories at /home/pi/go
mkdir bin
mkdir pkg
mkdir src
mkdir programs (insert your programs here)

3) Add to the PATH environment variable
nano ~/.profile
Insert this:
PATH=$PATH:/usr/local/go/bin
GOPATH=/home/pi/go
Reference nano: https://phoenixnap.com/kb/use-nano-text ... ands-linux

4) Make the system aware of the new profile
source ~/.profile

5) Verify that you've installed Go by opening a command prompt and typing the following command
root@raspberrypi:~# go env
Check this:
GOPATH="/home/pi/go"
GOROOT="/usr/local/go"
GOVERSION="go1.17.2"
```
## Building and Installation

The current build.sh script will build the binary for ARM 5 architecture (good for Raspberry Pi)
```
go get github.com/cliviu74/onewire-prom-exporter
cd $GOPATH/src/github.com/cliviu74/onewire-prom-exporter
./build.sh
```

## Usage

```
./onewire-prom-exporter
```

Visit http://localhost:8105/metrics to get metrics from exporter. The exporter will list all sensors
and display the metrics as gauges, labeled with device_id (onwire address)

```
~# curl -s http://localhost:8105/metrics | grep onewire
# HELP onewire_temperature_c Onewire Temperature Sensor Value in Celsius.
# TYPE onewire_temperature_c gauge
onewire_temperature_c{device_id="28-xxxxxxxxxxxx",hostname="pienv"} 29.125
onewire_temperature_c{device_id="28-xxxxxxxxxxxx",hostname="pienv"} 31.812

```

## Configuration

You can also specify a the web port and metrics path upon launching the exporter

```
Usage of ./onewire-prom-exporter:
  -web.listen-address string
    	Address and port to expose metrics (default ":8105")
  -web.telemetry-path string
    	Path under which to expose metrics. (default "/metrics")
```

```
./onewire-prom-exporter -web.listen-address=0.0.0.0:8105 -web.telemetry-path=/metrics 
```

## Runing the exporter with systemd

see examples: [here](examples/systemd/README.md)
## Prometheus Configuration

This is a simple target configuration for prometheus. The ip in the targets array
needs to be replaced with the IP of the node running the exporter.

Example config:
```YAML
scrape_configs:
  - job_name: 'onewire_exporter'
    scrape_interval: 60s
    metrics_path: /metrics
    scheme: http  
    static_configs:
      - targets: ['192.168.1.123:8105']
```
## Contributing

Feel free to report bugs, contribute, discuss changes, fork this project, create pull requests.
If you wish to become a contributor, you are welcome to contact me. 
## License
Apache License 2.0, see [LICENSE](LICENSE).
