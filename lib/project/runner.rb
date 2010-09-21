module Project
  class Runner
    attr_accessor :opts, :loader, :project, :workflow

    def initialize(opts)
      self.opts = opts

      self.loader = Loader.new
      begin
        loader.load!
      rescue NoConfigFound => e
        say e.exception
      end
    end

    def run!
      if opts.has_key? :create
        create(opts)
      elsif opts.has_key? :project
        load_project
        run
      elsif opts.has_key? :scrape
        scrape(opts[:scrape] || '.', opts)
      end
    end

    def create(opts)
      loader.project.create(opts)
    end

    def scrape(path, opts)
      hashes = SCRAPER.map(&:call)
      hashes.delete_if {|hash| loader.project.find(hash[:project])}
      hashes.each {|opts| create(opts)}
    end

    def load_project
      self.project = loader.project.find(opts[:project])
      exit_with "No project found using key '#{key}'" if project.nil?

      self.workflow = loader.workflow.find(opts[:workflow] || project.workflow)
      exit_with "No workflow found using key '#{project.workflow}'" if workflow.nil?
    end

    def run
      say "* Opening project '#{project.name}' using workflow '#{project.workflow}'"

      workflow.each_with_index do |command, index|
        command = Template.new(command, project).parse!
        output  = %x[ #{command} ].chomp

        unless output.empty?
          say output
          seperator unless index == (workflow.size - 1)
        end
      end
    end

    private
    def say(*things)
      $stdout.puts *things
    end

    def exit_with(message, code=1)
      say message
      Kernel.exit(code)
    end

    def seperator
      say "", ("*" * 80), ""
    end
  end
end
