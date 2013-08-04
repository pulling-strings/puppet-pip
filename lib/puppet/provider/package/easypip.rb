require 'puppet/provider/package'

include Puppet::Util::Package

Puppet::Type.type(:package).provide(:easypip,
            :parent => ::Puppet::Provider::Package) do

    
    has_feature :ensurable,:versionable, :install_options

    commands:easy_install=>"/usr/bin/easy_install"
    desc "Python packages Installation via `easy_install` and Uninstallation via 'pip'."

    # Parse lines of output from `pip freeze`, which are structured as
    # _package_==_version_.
    def self.parse(line)
      if line.chomp =~ /^([^=]+)==([^=]+)$/
        {:ensure => $2, :name => $1, :provider => name}
      else
        nil
      end
    end

    def self.instances
      debug("Gathering Installed Instances")
      pip_cmd = which('pip') or return []
      packages = []
      execpipe "#{pip_cmd} freeze" do |process|
        process.collect do |line|
             next unless options = parse(line)
               packages << new(options)
             end
        end
      return packages
    end

    def extractname(name)
       if name =~ /^([^-]+)-([0-9.]+)/
         name = $1;
         return name
       end
       return nil
    end

    def query
       # We have following three line to restrict the download only from our local repository
       # if !(@resource[:source] =~ /http:\/\/myinternaldomain.com\/my\/egg\/root*/)
       #   raise Puppet::Error, "Trying to fetch from invalid domain"
       # end

        packages=self.class.instances
        return nil unless packages != nil
        packages.each do |provider_pip|
          name = extractname @resource[:name]
          if name == provider_pip.name
            debug("Package Found - If the version doesnt match, you can expect an install")
            #This is the parameter based on which puppet makes a decision whether or not to install the package based on the version number/present/absent values in the ensure parameter
            return provider_pip.properties
          return nil
          end
        end
        return nil
    end

    def mirror
     @resource[:install_options].first ||  "http://pypi.python.org/pypi"
    end

    def install
	debug("Installing!!")
	args = ['-i', "#{mirror}/simple" ,'-v']
	name = @resource[:name]

	source = @resource[:name] 
	case @resource[:ensure]
	when String
	  args << source
	when :present
	  args << source
	  #for advanced versions, we might have to add features like latest or holdable. This case branch would be useful then.
	end
	ezy_install *args
    end

    def uninstall
	name = extractname @resource[:name]
	PiP "uninstall", "-y", "-q", name
    end

    private 
    # executes easy_install command with the passed arguments
    def ezy_install(*args)
	easy_install *args
    rescue NoMethodError => e

	if pathname = which('easy_install')
	  self.class.commands :easy_install => pathname
	  easy_install *args
	else
	  raise e
	end
    end

    # executes pip command with the passed arguments
    def PiP(*args)
	pip *args
    rescue NoMethodError => e

	if pathname = which('pip')
	  self.class.commands :pip => pathname
	  pip *args
	else
	  raise e
	end
    end
end

