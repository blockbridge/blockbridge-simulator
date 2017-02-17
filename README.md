# blockbridge-simulator
Blockbridge Storage Simulator.

The Blockbridge simulator is a full version of the Blockbridge storage stack. It is considered a *simulator* because it runs as a Docker container, uses loopback file-based thin devices by default, and is generally limited in performance and security. It is ideal for demonstration or testing purposes as it runs anywhere Docker runs, including Docker Toolbox.

The Blockbridge stack is split into control plane and data plane "nodes". A management node is required for management, and a storage node is required for data access.

The simulator runs as a `converged` node (combined management and storage) by default, but can also run as a separate `management` or `storage` node for multi-host or multi-site configurations.

Docker compose files are available for each of the simulator node types.

### Quick Start
````
$ docker-compose up
````

This runs a converged node.

The default simulator compose file exposes Management ports and Storage access ports. The Management port is port 4443.

### Credentials

The simulator will generate access credentials for the `system` administrator user, a `block` non-administrator user, and an API token for the `system` user. View these in the simulator docker logs.

Example:
````
bbsim-converged  | ==============================================
bbsim-converged  | Blockbridge simulator (container) has started.
bbsim-converged  | 
bbsim-converged  | Mode:            converged
bbsim-converged  | Management node: management-a2c893018a02
bbsim-converged  | Storage node:    storage-a2c893018a02
bbsim-converged  | IP Address:      172.18.0.2
bbsim-converged  | Admin API Key:   1/oCO0isKC5ZUF9QIq1VKyfHUggnqnWiLbjhBKYbZGekCwI7SKwoLk1A
bbsim-converged  | Admin account:   system
bbsim-converged  | Admin password:  26f2fd0fb8b5905d22041bd0132d4897
bbsim-converged  | User account:    block
bbsim-converged  | User password:   2b9c63c8b01c8d917189dcb4a42140ea
bbsim-converged  | 
bbsim-converged  | ==============================================
````

### Management UI

Access the management UI via web browser pointing to the local host running the simulator. For docker-machine this address is accessible through `docker-machine ip`.

Example: `https://192.168.99.100:4443`

Login as `system` or `block` using the appropriate credentials.

### Management CLI

Use the [Blockbridge Command Line Tools (See 'Use The Tools')](http://www.blockbridge.com/trial/) for management via the command line. The CLI is available for both Linux and Windows.

````
$ bb auth login
Enter a default management host: 192.168.99.100:4443
Peer certificate is self-signed:

  API:         https://192.168.99.100:4443/api
  Serial:      AD:FF:A3:20:E1:F6:19:22
  Subject:     /CN=e386f1033735/C=US/ST=Massachusetts/L=Cambridge/O=Blockbridge
  Fingerprint: BB:06:22:40:0E:16:36:27:A8:84:32:61:6C:74:4A:67:58:71:67:44 (SHA1)

Automatically trust this certificate for 192.168.99.100? [y/N] y

CA certificate registered for api host https://192.168.99.100:4443/api

Authenticating to https://192.168.99.100:4443/api

Enter user or access token: block
Password for block:
Authenticated; token expires in 3599 seconds.

== Authenticated as user block.
````

### Generate an API Key (Authorization)

To facilitate easier management as the `block` user, generate an API Key for that user.

After authenticating as `block`, list your auth info:
````
$ bb auth info
== Authorization: SES1669194C40626440
type                  session token            
user                  block                    
created at            2017-02-17 13:48:53 +0000
expires in            59 minutes and 57 seconds
````

Generate a persistent authorization (API Key)
````
$ bb authorization create
== Created authorization: ATH4769B94C40626460

== Authorization: ATH4769B94C40626460
serial                ATH4769B94C40626460        
account               block (ACT0769794C40626470)
user                  block (USR1B69294C40626470)
enabled               yes                        
created at            2017-02-17 13:49:23 +0000  
access type           online                     
token suffix          rqF49adA                   
restrict              auth                       
enforce 2-factor      false                      

== Access Token
access token          1/zE6a6hePWzXFBr8GMUsYGPiHt7cT4jfAfAmzaOC0gNr8TprqF49adA

*** Remember to record your access token!
````

Use this API Key in scripts or automated tests.

````
$ BLOCKBRIDGE_API_KEY="1/zE6a6hePWzXFBr8GMUsYGPiHt7cT4jfAfAmzaOC0gNr8TprqF49adA" bb auth info
BLOCKBRIDGE_API_KEY="1/zE6a6hePWzXFBr8GMUsYGPiHt7cT4jfAfAmzaOC0gNr8TprqF49adA" bb auth info
== Authorization: ATH4769B94C40626460
type                  access token             
user                  block                    
created at            2017-02-17 13:49:23 +0000
expires in            -never-                  
````

### Storage Access

#### Host attach

The Blockbridge CLI attaches Blockbridge virtual disks directly to your host as a block device. Provision a virtual disk, and attach it to your host.

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

This is a real block device on your host. The `host attach` functionality works for both Linux and Windows hosts. Use the block device as you would any other block device by formatting a filesystem, mounting it, etc.

### Blockbridge

Blockbridge is a comprehensive storage software product. It enables tenant isolation, automated thin-provisioning, encryption, secure deletion, snapshots and QoS for any storage backend: on local storage or with any storage vendor over any protocol. Tenant management and data are securely isolated. Each tenant can exercise complete control over storage operations and management with APIs and tools that are powerful and simple to use.

#### Use Cases

* Secure Multi-tenant Storage for Docker, OpenStack, bare-metal, etc.
* Storage As A Service / Self-Service for DevOps
* Disaster Tolerance
* High Performance
* IT Automation
* Application / Customer Isolation

For more information, please see:
* [Blockbridge](https://blockbridge.com)
* [Blockbridge Blog](https://blockbridge.com/blog)
* [Blockbridge Trial Download](https://blockbridge.com/trial)
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
