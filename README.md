pubstack
========

Publisher's DevStack

## Installation

1. Install [Vagrant](http://www.vagrantup.com/).
1. Install [VirtualBox](https://www.virtualbox.org/).
1. Install Ansible:
    - [Latest Releases Via Homebrew (Mac OSX)](http://docs.ansible.com/intro_installation.html#latest-releases-via-homebrew-mac-osx)
    - [Latest Releases Via Apt (Ubuntu)](http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu)
    - [See all](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)
1. Make sure all the git repositories for the projects you want to work on are already clone locally. (for example in `~/Sites/nbcu/Publisher7`).
1. Clone this repo:

    ```bash
    git clone --branch master git@github.com:NBCUOTS/pubstack.git ~/pubstack
    cd ~/pubstack
    ```

1. Install Hostupdater:

    ```bash
    vagrant plugin install vagrant-hostsupdater
    ```

1. Create your config file from the default template and modify as needed (note each config has commented instructions):

    ```bash
    cp default.config.yml config.yml
    vim config.yml
    ```

    **NOTE:** after the initial `vagrant up`, any time you edit your config file values you will want to run `vagrant reload --provision`.

1. Start-up your vagrant box:

    ```bash
    vagrant up
    ```

1. Visit [http://pubstack.dev/](http://pubstack.dev/) in your browser.

##Documentations:
 - [Setting up your IDE for debugging](https://github.com/NBCUOTS/pubstack/wiki/Setting-up-your-IDE-for-debugging)
 - [Differences between Acquia & pubstack](https://github.com/NBCUOTS/pubstack/wiki/Detailed-difference-between-pubstack-&-Acquia)
 - [Detailed IP Address Setup](https://github.com/NBCUOTS/pubstack/wiki/IP-Address-SetUp)

## Customizing

1. Power users can add their own playbook(s):
    - An optional, main user playbook will be loaded if it exists: `provisioning/user.playbook.yml`
    - This playbook can include additional playbooks, including the main playbook, before or after your user-specific roles:

        ```yaml
        ---
        - include: webserver.yml
        ```

2. You can also add custom roles:
    - User-specific roles should follow this naming convention:

        ```bash
        provisioning/roles/user-ROLE-NAME
        ```

**Note:** Both your user playbook, and user-specific roles will be gitignored.

## Troubleshooting

### Operating Systems
- We support Mac users running Mavericks
- Linux users (we trust you to know what you're doing!)
- Windows (untested and currently unsupported, but feedback welcome)

### Common Errors
- ```PDOException: SQLSTATE[42S02]: Base table or view not found```
 : This means your Database is empty. Pubstack only creates the database for you it does not populate it.

- ```Unable to connect to :127.0.0.1:INCORRECT_DATABASE_NAME```
 : Please make sure you do not have a ```settings.local.php``` in your site folder. If you do please remove your database credentials in that file. Pubstack sets up its own database credentials and loads those.


### VPN

- Cisco Issue
    When enabled, the Cisco Anyconnect VPN client blocks out all IP to IP communication.
    The fix is to remove this one line from Mac's IP Firewall, by running this script:

    ```sh
    ./scripts/cisco.workaround.sh
    ```

    You will be prompted for your password. Note you may need to run this twice.

## Maintainers
- [conortm](https://github.com/conortm)
- [ericduran](https://github.com/ericduran)
- [scottrigby](https://github.com/scottrigby)

###contributors
 - [rebmullin](https://github.com/rebmullin)
 - https://github.com/NBCUOTS/pubstack/graphs/contributors
