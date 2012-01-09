Gem::Specification.new do |s|
  s.name = "puppet-pip"
  s.version = "1.0.0.1"
  s.date = "2012-01-06"
  s.authors = ["Richard Crowley", "Karthick Duraisamy Soundararaj"]
  s.email = ["r@rcrowley.org", "ksoundararaj@wayfair.com"]
  s.summary = "Puppet provider for python libraries - pip & easypip[Hybrid of easy_install for install and pip for uninstall]"
  s.homepage = "http://github.com/wayfair/puppet-pip"
  s.description = "Puppet provider of Python libraries - pip & easypip[Hybrid of easy_install for install and pip for uninstall]"
  s.files = [
    "lib/puppet/provider/package/pip.rb",
    "spec/unit/provider/package/pip_spec.rb",
    "lib/puppet/provider/package/easypip.rb",
  ]
  s.add_dependency "puppet"
end
