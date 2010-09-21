module Project
  class Lookup
    def initialize(hash)
      hash.each_pair do |key, data|
        store[key.to_s] = data
      end
    end

    def store
      @store = {} unless @store
      @store
    end

    def set(key, data)
      store[key.to_s] = data
    end
    alias :register :set

    def get(key)
      store[key.to_s] ? return_object(store[key.to_s]) : nil
    end
    alias :find :get

    protected
    def return_object(data)
      raise AbstractClassError, "this is an abstract method and should not be called directly."
    end
  end
end
