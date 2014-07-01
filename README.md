pubstack
========

Publisher's DevStack

## Installation

1. Install [Vagrant](http://www.vagrantup.com/).
1. Install [VirtualBox](https://www.virtualbox.org/).
1. Add project files to your machine (for example in `~Sites/www`).
1. Run the following:

    ```bash
    git clone git@github.com:NBCUOTS/pubstack.git
    cd pubstack
    cp default.config.yml config.yml
    # modify config.yml as needed (note each config has commented instructions):
    vim config.yml
    vagrant up
    echo "172.20.20.10 pubstack" >> /etc/hosts
    ```

1. Visit [http://pubstack/](http://pubstack/) in your browser.

## Authors
- breathingrock
- conortm
- ericduran
- scottrigby
