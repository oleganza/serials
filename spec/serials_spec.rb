require File.expand_path(File.dirname(__FILE__) + "/../lib/serials")
include Serials

describe Serials do

  describe SerialNumber do
    before(:each) do
      @sn = SerialNumber.new(:company => "Apple", :namespace => "iPod", :number => "001")
    end
    it "should have company" do
      @sn.company.should == "Apple"
    end
    it "should have namespace" do
      @sn.namespace.should == "iPod"
    end
    it "should have number" do
      @sn.number.should == "001"
    end
    it "should have serialized_key" do
      @sn.serialized_key.should == "Apple:iPod:001"
    end
    it "should have serialized_value" do
      @sn.serialized_value.should == Marshal.dump(@sn)
    end
    describe "#==" do
      before(:each) do
        @sn2 = SerialNumber.new(:company => "Apple", :namespace => "iPod", :number => "001")
      end
      it "should return true with the same serial" do
        @sn2.should == @sn
      end
      it "should return false when companies do not match" do
        @sn2.company = "Sony"
        @sn2.should_not == @sn
      end
      it "should return false when namespaces do not match" do
        @sn2.namespace = "MacBook"
        @sn2.should_not == @sn
      end
      it "should return false when numbers do not match" do
        @sn2.number = "042"
        @sn2.should_not == @sn
      end
    end
  end
  
  describe Database do
    before(:each) do
      @db = Database.new(:chunks => 128)
      @sn = SerialNumber.new(:company => "Apple", :namespace => "iPod", :number => "001")
    end
    it "should write and read serial number" do
      @db.write(@sn)
      sn = @db.find(:company => "Apple", :namespace => "iPod", :number => "001")
      sn.should == @sn
    end
  end
  
  describe Database::Chunk do
    before(:each) do
      @chunk = Chunk
    end
    
  end
  
end
