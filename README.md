# Packer Template CentOS Vagrant
Packer templates for building base VM boxes. Based off of the [shiguredo/packer-templates](https://github.com/shiguredo/packer-templates) centOS7 template and customized for Youtily environment.

## Usage

### Installing Packer

Download the latest packer from [http://www.packer.io/downloads.html](http://www.packer.io/downloads.html) and unzip the appropriate directory.

If you're using Homebrew
    
    $ brew tap homebrew/binary
    $ brew install packer
    
### Running Packer

Add Atlas token as environment variable before running

    $ export ATLAS_TOKEN=<add atlas token>

Then clone repo and run a new build *(VirtualBox should be installed before running)*

##### Note: Make sure to change the version number in template.json

    $ git clone https://github.com/youtily/packer-centos
    $ cd packer-centos
    $ packer build template.json

### Done

That's it. Packer will do the rest by automatically building a new CentOS 7 box on your local system, upload it to Atlas, and release it as a new version for download. To upate a box to the latest version, run:

    $ vagrant box update



