require 'rubygems'
require 'uri' # TODO: add uri to emrpc
require 'tokyocabinet'
require 'tokyocabinet-wrapper'
require 'emrpc'

module Serials
  
  class SerialNumber
    SEPARATOR = ":"
    
    attr_accessor :company, :namespace, :number, :metadata
    def initialize(attrs = {})
      @company   = attrs.delete(:company)   or raise ":company is required!"
      @namespace = attrs.delete(:namespace) or raise ":namespace is required!"
      @number    = attrs.delete(:number)    or raise ":number is required!"
      @metadata  = attrs
    end
    
    def serialized_key
      _ = SEPARATOR
      "#{@company}#{_}#{@namespace}#{_}#{@number}"
    end
    
    def serialized_value
      Marshal.dump(@metadata)
    end
    
    def ==(other)
      serialized_key   == other.serialized_key && 
      serialized_value == other.serialized_value
    end
    
    class <<self
      def load(key, value)
        c, ns, n = key.split(SEPARATOR)
        md = Marshal.load(value)
        new({:company => c, :namespace => ns, :number => n}.merge(md))
      end
    end
  end
  
  class Database
    attr_accessor :chunks
    def initialize(options = {})
      chunks_num = options[:chunks] or raise ":chunks must specify number of chunks"
      @chunks = Array.new(chunks_num).map{|i| Chunk.new(:index => i) }
    end
    
    class Chunk
      
      def initialize(options = {})
        
      end
      
    end # Chunk
    
  end # Database
  
end # Serials
