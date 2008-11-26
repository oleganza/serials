require 'rubygems'
require 'uri' # TODO: add uri to emrpc
require 'tokyocabinet'
require 'tokyocabinet-wrapper'
require 'emrpc'

module Serials extend self
  SEP = ":"
  
  # always returns Integer for a given [company, namespace, number]
  def partition_key(company, namespace, number)
    "#{company}#{SEP}#{namespace}".hash # we use simple built-in hash method
  end
  
  def dump_key(company, namespace, number)
    "#{company}#{SEP}#{namespace}#{SEP}#{number}"
  end
  
  def load_key(key)
    key.split(SEP)
  end
  
  class SerialNumber
    
    attr_accessor :company, :namespace, :number, :metadata
    def initialize(attrs = {})
      @company   = attrs.delete(:company)   or raise ":company is required!"
      @namespace = attrs.delete(:namespace) or raise ":namespace is required!"
      @number    = attrs.delete(:number)    or raise ":number is required!"
      @metadata  = attrs
    end
    
    def partition_key
      Serials.partition_key(@company, @namespace, @number)
    end
    
    def serialized_key
      Serials.dump_key(@company, @namespace, @number)
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
        c, ns, n = Serials.load_key(key)
        md = Marshal.load(value)
        new({:company => c, :namespace => ns, :number => n}.merge(md))
      end
    end
  end
  
  class Database
    attr_accessor :chunks, :path
    def initialize(options = {})
      chunks_num = options[:chunks] or raise ":chunks must specify number of chunks!"
      @path = options[:path] or raise ":path is required!"
      @chunks = Array.new(chunks_num){|i| Chunk.new(:total => chunks_num, :index => i, :path_prefix => @path) }
    end
    
    def write(sn)
      pkey  = sn.partition_key
      key   = sn.serialized_key
      value = sn.serialized_value
      
      
      
      nil
    end
    
    def find(options)
      
    end
    
    def open
      @chunks.each{ |c| c.open }
    end
    
    def close
      @chunks.each{ |c| c.close }
    end
    
    class Chunk
      include TokyoCabinet
      
      attr_accessor :index, :path
      def initialize(options = {})
        @index = options[:index] or raise ":index is required!"
        total  = options[:total] or raise ":total is required!"
        path_prefix = options[:path_prefix] or raise ":path_prefix required!"
        @path = "#{path_prefix}.#{index}-#{total}.chunk"
        
        @storage = HDB::new
      end
      
      def write(key, value)
        raise "File is closed!" unless @opened
        @storage.put(key, value)
      end
      
      def read(key)
        raise "File is closed!" unless @opened
        @storage.get(key)
      end
      
      def open
        @opened = true
        @storage.open(:path => @path, :writer => true, :create => true)
      end
      
      def close
        @opened = false
        @storage.close
      end
      
    end # Chunk
  end # Database
end # Serials
