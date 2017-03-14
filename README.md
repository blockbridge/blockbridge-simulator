# blockbridge-container
Blockbridge Storage Container.

The Blockbridge container is a full version of the Blockbridge storage stack. It runs as a Docker container, uses loopback file-based thin devices by default, and is generally limited in performance and security. It is ideal for demonstration or testing purposes as it runs anywhere Docker runs, including Docker Toolbox.

The Blockbridge stack is split into control plane and data plane "nodes". A management node is required for management, and a storage node is required for data access.

The container runs as a `converged` node (combined management and storage) by default, but can also run as a separate `management` or `storage` node for multi-host or multi-site configurations.

### Quick Start
* Install Docker
````
curl https://get.docker.com | sh
````

For more information and step-by-step installation guides see [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/)

* Install the Blockbridge Container
````
curl https://get.blockbridge.com/container | sh
````

For more information including tutorials and getting started guides see [https://blockbridge.com/container/](https://blockbridge.com/container/)

This runs a converged node.

The quick start installation by default uses port 80/443 for web management and port 3260 for data access.

### Credentials

The container will generate access credentials for the `system` administrator user, and a default tenant user `default`. API tokens are also generated for use with the Docker volume plugin and command line tools.

````
=================================================================================
Blockbridge Storage Container 3.1.0-3893.3 (3c4ec416-43bc-44aa-bec2-4b6c2309ca08)
Mode: converged

Generated Credentials (may not reflect current system state)

System admin API token:  1/a0tx78VuTRg39rPzc05K9bzUXoyPp9ZufCifBCjixVh7S3HvxW5MWQ
System admin username:   system
System admin passpass:   88d6312ea0c6c5329962a631645e53b9
Default user username:   default
Default user password:   f994e588c02d5610a300ad255aa60042
Volume plugin API token: 1/fpTVWfSwPaKqE18UIcRQP/ZLbfAJXWQjr9f0520depRelNVZ9LA84w
=================================================================================
````

### Management UI

Access the management UI via web browser pointing to the local host running the container. For docker-machine this address is accessible through `docker-machine ip`.

Example: `https://192.168.99.100`

Login as `system` or `default` using the appropriate credentials.

### Management CLI

Use the [Blockbridge Command Line Tools (See 'Use The Tools')](http://www.blockbridge.com/tools/) for management via the command line. The CLI is available for both Linux and Windows. After installing the CLI, you can login via command line.

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

Enter user or access token: default
Password for default:
Authenticated; token expires in 3599 seconds.

== Authenticated as user block.
````

### Generate an API Key (Authorization)

To facilitate easier management as the `default` user, generate an API Key for that user.

After authenticating as `default`, list your auth info:
````
$ bb auth info
== Authorization: SES1669194C40626440
type                  session token            
user                  default 
created at            2017-02-17 13:48:53 +0000
expires in            59 minutes and 57 seconds
````

Generate a persistent authorization (API Key)
````
$ bb authorization create
== Created authorization: ATH4769B94C40626460

== Authorization: ATH4769B94C40626460
serial                ATH4769B94C40626460        
account               default (ACT0769794C40626470)
user                  default (USR1B69294C40626470)
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
== Authorization: ATH4769B94C40626460
type                  access token             
user                  default 
created at            2017-02-17 13:49:23 +0000
expires in            -never-                  
````

### Storage Access

#### Docker Volume Plugin

Install the plugin using the volume plugin token and host of the container.

````
docker plugin install --alias blockbridge blockbridge/volume-plugin BLOCKBRIDGE_API_KEY=1/zE6a6hePWzXFBr8GMUsYGPiHt7cT4jfAfAmzaOC0gNr8TprqF49adA BLOCKBRIDGE_API_HOST=192.168.1.100
````

Create a volume

````
docker volume create --driver blockbridge --name testvol --opt capacity=4GiB
testvol
````

Use the volume

````
docker run --rm -it -v testvol:/data alpine sh
/# df -k /data
````

For more information on the Blockbridge Docker volume plugin see:
* [https://github.com/blockbridge/blockbridge-docker-volume](https://github.com/blockbridge/blockbridge-docker-volume)

#### Host attach

The Blockbridge CLI attaches Blockbridge virtual disks directly to your host as a block device. Provision a virtual disk, and attach it to your host.

````
$ bb vss provision -c 4GiB --with-disk
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
* [Blockbridge Install](https://blockbridge.com/container/)
* [Blockbridge Tools](https://blockbridge.com/tools/)
* [Blockbridge Volume Plugin for Docker](https://github.com/blockbridge/blockbridge-docker-volume)

### Not For Production Use

_Note_: The container is for non-production use only; no guarantee or warranty
is provided. Use at your own risk. The container is provided for demonstration and testing
purposes only.

### Limitations

3 storage node maximum configuration.

### Support

Please contact us on github or at support@blockbridge.com.

### License

The Blockbridge storage container comes with a 30-day evaluation license.
