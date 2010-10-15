require 'fileutils'
require 'tmpdir'

class DhMakeDrupal
  DH_MAKE_DRUPAL_CMD = "/usr/bin/dh-make-drupal"

  def self.get_project_info(project, drupal_version=nil, developer=false)
    command_string = get_command_string(project, drupal_version, developer, "-r" )

    return_value = {}

    IO.popen(command_string).readlines.each do |l|
        case l
          when /^ERROR:/
            return nil

          when /^Release: ([^ ]*)/
            return_value[:release] = $1

          when /^Download URL: (.*)\)/
            return_value[:url] = $1
        end
    end

    return return_value
  end

  def self.build_package(project, drupal_version=nil, developer=false)

    command_string = get_command_string(project, drupal_version, developer)

    build_path = Dir.mktmpdir("d", File.join(File.dirname(__FILE__), '../tmp/build'))

    FileUtils.mkpath(build_path)

    old_pwd = FileUtils.pwd

    FileUtils.cd(build_path)

    IO.popen(command_string).readlines.each do |l|
      if l =~ /dpkg-genchanges  >\.\.\/(.*\.changes)/
        FileUtils.cd(old_pwd)

        Reprepro.include(developer ? "developer" : "recommended", build_path + '/' + $1)

        break
      end
    end

    FileUtils.rm_rf(build_path)
  end

  private

  def self.get_command_string(project, drupal_version, developer, extra_opts="")
    command_string = DH_MAKE_DRUPAL_CMD + " " + extra_opts + " "
    command_string += " -d #{drupal_version} " unless drupal_version.nil?
    command_string += " -s developer " if developer
    command_string += project

    return command_string
  end
end
