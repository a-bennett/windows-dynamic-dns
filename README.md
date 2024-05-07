# windows-dynamic-dns
A collection of windows scripts that support updating dynamic DNS records

While Dynamic DNS has probably passed its popularity, there are still occasions when it comes in handy. (Really, have a look at other options like CloudFlare Tunnel or Tailscale or ZeroTier first).

The primary goal here is to find your public IP from behind a local NAT router (not a CG-NAT router, you'll need to talk to your ISP about that one) and update a remote Dynamic DNS service, without installing any additional packages inside of a windows environment.

Yes, batch scripts are clunky, but they're also transparent and within a few minutes you can read through every line and know exactly what you're putting on your system, unlike closed sourced GUI updaters.

## Services Supported

- [namecheap](https://namecheap.com) ([Dynamic DNS docs](https://www.namecheap.com/support/knowledgebase/subcategory/11/dynamic-dns/))


## Overview

Why?
Most scripts appear to be bash based for Linux / Unix.
Other scripts use random websites to extract the IP, which are here today, could be gone tomorrow.
Instead this script uses OpenDNS's DNS resolvers with the help of nslookup (rather than dig. dig is easier, but not native to windows)

### How it works:

1. Discovers Public IP via a nslookup to OpenDNS and drops this into ip.txt
2. Checks ip.txt against lastip.txt, if different (or lastip.txt is missing) it pushes the IP update to the 3rd party service.
3. ip.txt is copied to lastip.txt so that subsequent checks don't send unnecessary updates (which are sometimes rate limited by free services)
4. The check against lastip.txt prevents subsequent checks from sending unnecessary updates

### Limitations:

- Because the checking it does by comparing the local files ip.txt and lastip.txt, if a 3rd party service updates the record, it won't trigger an update as it doesn't actually resolve the current record information (although if this was important to you, you could adapt the script pretty easily).
- Lack of logging.
- No error reporting/alerting when things don't update. 
To prevent the cmd window, we need a vbs script to call our bat script silently 

### Getting started:

1. Update [servicename]-dynamicdns.bat with the variables at the top of the file.
2. Call either the [servicename]-dynamicdns.bat or [servicename]-dynamicdns.vbs file.

### How to automate it:

1. Create a Scheduled Task in Windows Task Scheduler.
2. Set the trigger to 'On log on' and 'Repeat task every 30 minutes' for a duration of 'Indefinitely'.
3. Set the Actions to 'Start a program' and set the Program/Script to `namecheap-dynamicdns-run.vbs`.

### Example Use Cases

1. Providing up to date DNS info for your onsite VPN server
2. Assiting with remote access to PVR/NVR/Secuirty Cameras/RDP/etc (again, there's probably better options out their now than port forwarding).
3. Hosting your own website from a raspberry pi in your bedroom, just because you can. 

## TODO 

### Possible Future services to support:
- CloudFlare
- DNSMadeEasy
- No-IP
- Dyn.com

