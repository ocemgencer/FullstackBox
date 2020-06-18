<h2>Vagrant and Puppet configuration for various Fullstack projects</h2>

Vagrant configuration with puppet to create a Virtual Box machine with 
Ubuntu Server Xenial, Nginx, Node.js, MongoDB, PostGreSql, MariaDB, PHP7, Python

**installation:**

* Install Vagrant
* Install Virtual
* Clone the repository git clone [git://github.com/joaquimserafim/vagrant-nodejs-redis-mongodb.git](git://github.com/cgencer/vagrant.git)


**running:**

* Run - vagrant up<br>
* SSH - vagrant ssh<br>
* Halt - vagrant halt<br>


**access mongo and redis from your machine:**

* redis.cli h localhost -p 6379
* mongo localhost 27017

*attention: you may have this ports occupied by your installations for redis and mongodb in your machine*


**development:**

by default this vagrantfile have this configuration for shared folder between the host and the VM
*[config.vm.synced_folder "~/Projects", "/vagrant"](https://github.com/joaquimserafim/vagrant-nodejs-redis-mongodb/blob/master/Vagrantfile#L25)*



**Puppet Manifest will install:**

* MariaDB 10
* Nginx - last stable release
* Redis - last stable release
* MongoDB
* wget
* git
* vim htop
* g++
and others will follow...

Good hacking!!!!!!!!
