require 'rubygems'
require 'uri'
require 'tokyocabinet'
require 'tokyocabinet-wrapper'
require 'emrpc'

module Serials
  
  class SerialNumber
    attr_accessor :company, :namespace, :number
    def initialize(attrs = {})
      @company   = attrs[:company]   or raise ":company is required!"
      @namespace = attrs[:namespace] or raise ":namespace is required!"
      @number    = attrs[:number]    or raise ":number is required!"
    end
    
  end
  
  class Database
    
    def initialize(options = {})
      
    end
    
    class Chunk
      
      def initialize(options = {})
        
      end
      
    end # Chunk
    
  end # Database
  
end # Serials
