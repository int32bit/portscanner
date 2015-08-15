# portscan
a shell script to scan open port using nc

## How to use

```bash
./portscan.sh -s localhost -p 1-1024 # scan localhost, port from 1 to 1024
```
result as follow:
```
Server         	Port 	Protocol       
localhost      	22   	[tcp/ssh]      
localhost      	53   	[tcp/domain]   
localhost      	631  	[tcp/ipp]
```

it is shown that port `22`,`53`,`631` is open, and all of their protocols is tcp.

```bash
./portscan.sh -s github.com -p 80 # fetch github:80
```
result:
```
Server         	Port 	Protocol       
github.com     	80   	[tcp/http]
```
it is shown that `github.com:80` is open!

## pull request & issues

Yes, welcome!
