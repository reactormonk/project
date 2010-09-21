module Project
  require 'project/project'
  require 'project/workflow'
  require 'fileutils'
  require 'yaml'

  class Loader
    attr_reader :raw_config, :project, :workflow

    def initialize
      @template_path = File.join(ROOT, 'templates', 'example.yml')
    end

    def load!
      if File.exists?(PATH)
        @raw_config = YAML.load_file(PATH)

        @project = load_from_hash :project
        @workflow = load_from_hash :workflow
      else
        FileUtils.mkdir_p(File.dirname(PATH))
        FileUtils.cp(@template_path, PATH)

        raise NoConfigFound, <<-EOS
* No YAML configuration file found!
+ #{PATH}
* One has been created for you, please edit it to your liking and try again."
EOS
      end
    end

    def load_from_hash(type)
      loader = proc {const_get(type.upcase).method(&:new)}
      if config = @raw_config[type.to_s]
        loader[config]
      elsif config = @raw_config[type.to_sym]
        warn "Using old Symbol style loader."
        loader[config]
      else
        raise NoConfigFound, "* No key #{type} found. Please check sanity of your config file."
      end
    end
  end
end
