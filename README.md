puppet-pip with Wayfair modifications
=====================================
Alteration of orginal pip provider to use easy_install for installation.

* Puppet: <https://github.com/puppetlabs/puppet>
* An operating-system-level package provider such as 'apt', 'yum' or 'pkg'
* pip: <http://pip.openplans.org/>
* setuptools: <http://pypi.python.org/packages/2.3/s/setuptools/>
* PyPI: <http://pypi.python.org/pypi>

Installation
------------

    We are not seeing that 'gem install puppet-pip' works for this project, but
    that's not how we install puppet providers anyway.
    You can take easypip.rb and place it in an appropriate place in the puppet tree.

Example
-------

Resource:

	package { "virtualenv":
		      ensure  => present,
              source  => "http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.7.tar.gz",
              provider => "easypip",
    }
