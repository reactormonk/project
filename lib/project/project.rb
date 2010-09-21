module Project
  require 'ostruct'

  class Project < Lookup

    def create(opts)
      project = opts.dup
      project.keep_if {|k| [:path, :workflow].include? k}
      project.keys.each {|k| project[k.to_s] = project.delete(k)}
      set(opts[:project], project)
    end

    protected
    def return_object(data)
      OpenStruct.new(data)
    end
  end
end
