pubstack
========

Publisher's DevStack

#Installation

1. Install [Vagrant](http://www.vagrantup.com/).
1. Install [VirtualBox](https://www.virtualbox.org/).
1. Run the following:

```bash
git clone git@github.com:NBCUOTS/pubstack.git
cd pubstack
cp default.config.yml config.yml
# modify config.yml as needed:
vim config.yml
vagrant up
echo "192.168.33.10 pubstack" >> /etc/hosts
```

Then, visit [http://pubstack/](http://pubstack/) in your browser.

###Authors:
- breathingrock
- conortm
- ericduran
- scottrigby
