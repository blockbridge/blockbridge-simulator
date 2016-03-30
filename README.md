# blockbridge-simulator
Blockbridge Storage Simulator.

The Blockbridge simulator runs as a docker container. It is ideal for demonstration or testing purposes as it runs anywhere Docker runs, and runs the full Blockbridge backend software stack. It is a *simulator* in that it runs as a container, by default uses loopback file-based thin devices, and is generally limited in performance.

The Blockbridge stack is split into a control plane and data plane "nodes". A management node is required for management, and a storage node is required for data access.

The simulator runs as a `converged` (combined management and storage node) by default, but can also run as a separate solo `management` or solo `storage` node, for multi-host or multi-site configurations.

Docker compose files are available for each of the simulator node types.

### Quick Start
````
$ docker-compose up
````

This runs a converged node.

### Management UI

Access the management UI via web browser pointing to the local host running the simulator. For docker-machine this address is accessible through `docker-machine ip`.

Example: `https://192.168.99.100`

### Management CLI

Use the [Blockbridge Command Line Tools](http://www.blockbridge.com/the-blockbridge-command-line-tools/) for management via the command line. The CLI is available for both linux and windows.

````
$ bb auth login
Enter a default management host: 192.168.99.100
Peer certificate is self-signed:

  API:         https://192.168.99.100/api
  Serial:      AD:FF:A3:20:E1:F6:19:22
  Subject:     /CN=e386f1033735/C=US/ST=Massachusetts/L=Cambridge/O=Blockbridge
  Fingerprint: BB:06:22:40:0E:16:36:27:A8:84:32:61:6C:74:4A:67:58:71:67:44 (SHA1)

Automatically trust this certificate for 192.168.99.100? [y/N] y

CA certificate registered for api host https://192.168.99.100/api

Authenticating to https://192.168.99.100/api

Enter user or access token: block
Password for block:
Authenticated; token expires in 3599 seconds.

== Authenticated as user block.
````

### Storage Access

#### Volume driver for Docker

The [Blockbridge volume driver for Docker](https://github.com/blockbridge/blockbridge-docker-volume) enables Docker volumes to be backed by Blockbridge storage. The volume driver works directly with the Blockbridge simulator.

Create a volume through Docker:

````
docker volume create --driver blockbridge
````

#### Host attach

The Blockbridge CLI attaches Blockbridge virtual disks directly to your host as a block device. Provision a virtual disk, and attach it.

````
$ bb vss provision -c 1GiB --with-disk
== Created vss: service-1 (VSS1869B94C40626440)

== VSS: service-1 (VSS1869B94C40626440)
label                 service-1                
serial                VSS1869B94C40626440      
created               2016-03-30 18:13:42 +0000
status                online                   
current time          2016-03-30T18:13+00:00   
````

````
$ bb host attach
========================================================================
service-1/disk-1 attached (read-write) to localhost.localnet as /dev/sdb
========================================================================
````

### Blockbridge

Blockbridge is a comprehensive storage software product. It enables tenant isolation, automated thin-provisioning, encryption, secure deletion, snapshots and QoS for any storage backend: on local storage or with any storage vendor over any protocol. Tenant management and data are securely isolated. Each tenant can exercise complete control over storage operation and
management with APIs and tools that are powerful and simple to use.

#### Use Cases

* Secure Multi-tenant Storage for Docker, OpenStack, bare-metal, etc.
* Storage As A Service / Self-Service for DevOps
* Disaster Tolerance
* High Performance
* IT Automation
* Application / Customer Isolation

For more information, please see:
* [Blockbridge](https://blockbridge.com)
* [Blog](https://blockbridge.com/blog)
* [Blockbridge volume driver for Docker](https://github.com/blockbridge/blockbridge-docker-volume)

### Not For Production Use

_Note_: The simulator is for non-production use only; no guarantee or warranty
is provided. Use at your own risk. The simulator is provided for demonstration and testing
purposes only.

### Limitations

3 storage node maximum configuration.

### Support

Please contact us on github or at support@blockbridge.com.

### License

The Blockbridge storage simulator comes with a 30-day evaluation license.
