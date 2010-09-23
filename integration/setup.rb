require 'yaml'
require 'tmpdir'
require 'ostruct'
require 'fileutils'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'project'

require 'ruby-debug'

shared :integration do
  class << self
    root = File.join(File.dirname(__FILE__), '..')
    bin_path = File.join(root, 'bin', 'project')
    tmp = File.join('/tmp', 'project', 'integration')
    define_method(:run!) do |config, *args, &block|
      Dir::Tmpname.create(tmp) do |dirname|
        FileUtils.mkdir_p(dirname)
        Dir.chdir(dirname) do
          config and File.open('config.yaml', 'w') {|file| file.write config.to_yaml}
          result = OpenStruct.new
          result.stdout = system(bin_path, '--config', 'config.yaml', *args)
          File.exist?('config.yaml') and result.config = YAML::load_file('config.yaml')
          block.call(result)
        end
      end
    end
  end
end
