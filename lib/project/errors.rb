module Project

  class ProjectError < StandardError
    attr_accessor :data

    def initialize(data)
      self.data = data
      super
    end
  end

  AbstractClassError = Class.new ProjectError
  MissingTemplateVariable = Class.new ProjectError
  NoConfigFound = Class.new ProjectError

end
