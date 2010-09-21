module Project
  class Scraper
    def initialize(path)
      @path = path
    end

    def run!
      Scrapers.instance_methods.map{|m| Scrapers.send(m, @path)}
    end

    module Scrapers
      extend self
      def git(path)
        Dir.glob("#{path}/**/*/.git").map do |dir|
          {
            project: dir.match(/.*\/(.*?)\/\.git/)[1],
            path:    dir
          }
        end
      end
    end

  end
end
