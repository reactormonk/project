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

    # Bit bulky of a method. Runs the bin_path in a tmpdir.
    # @param [#to_yaml, nil] config Config given to the project runner.
    # @param [Array<#to_s>] args args passed to the project binary
    # @yield Block called in the tmpdir
    define_method(:run!) do |config=config, *args, &block|
      result = OpenStruct.new

      Dir::Tmpname.create(tmp) do |dirname|
        FileUtils.mkdir_p(dirname)
        Dir.chdir(dirname) do
          config and File.open('config.yaml', 'w') {|file| file.write config.to_yaml}
          block.call if block

          result.stdout = system(bin_path, '--config', 'config.yaml', *args)
          File.exist?('config.yaml') and result.config = YAML::load_file('config.yaml')
        end
      end
      result
    end

  end
end
