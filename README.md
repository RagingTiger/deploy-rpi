# TL;DR
A set of *convenience scripts* for deploying various common applications on
a **Raspberry Pi**.

# Introduction
This repository was created in order to establish a *simple* and *reproducible*
**interface** for the *setup* and *deployment* of common applications/services
that are deployed on a **Raspberry Pi**. Ideally, this *interface* helps to
lower the *cognitive overhead* of all the setup and various details that
must be remembered to deploy these common applications.

# Applications
The following is a list of applications that are available through the
*deploy script*:
+ [OpenVPN](https://github.com/RagingTiger/docker-openvpn)
+ [DDNS Updater](https://github.com/qdm12/ddns-updater)
+ [Pi-hole](https://github.com/pi-hole/docker-pi-hole)

# Usage
The following will walk through the *usage* of the *shell scripts* available in
the repository.

## Setup
The **initial step** is to run the `setup.sh` script:
```
bash setup.sh
```
This will launch an *interactive* prompt, that will cycle through all the
available applications, asking you to setup each. **NOTE**: While this will take
care of the *majority* of setup for the available applications, we still
advise you to read the documentation for the respective applications listed in
the [Applications](#applications) section.

## Deploy
The **final step**, assuming the [Setup](#setup) step has been completed, is to
run the `deploy.sh` script:
```
bash deploy.sh
```
Similar to the *interactive* prompt in the [Setup](#setup) section, you will
be prompted to deploy each application, and you can choose which one(s) you
would like to deploy.
