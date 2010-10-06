require 'yaml'
require 'tmpdir'
require 'ostruct'
require 'fileutils'

require 'ruby-debug'

shared :integration do
  class << self
    root = File.join(File.dirname(__FILE__), '..')
    bin_path = File.join(root, 'bin', 'project')
    bin = ['ruby', '-I', File.join(root, 'lib'), '--', bin_path].join(' ')
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

          result.stdout = run_command(bin, '--config', 'config.yaml', *args)
          File.exist?('config.yaml') and result.config = YAML::load_file('config.yaml')
        end
      end
      result
    end

    def run_command(*command)
      io = IO.popen(command.join(' '))
      result = []
      until io.none?
        result << io.read
      end
      result
    end

  end
end
