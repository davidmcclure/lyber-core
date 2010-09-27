require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'lyber_core'


describe LyberCore::Robots::WorkItem do
  
  
  before(:all) do 
    @work_queue = mock("WorkQueue")
  end #before(:all)
  
  before(:each) do
    @work_item = LyberCore::Robots::WorkItem.new(@work_queue)
  end
  
  
  describe "#identity_metadata" do
    
    it "should create a new ROXML object if the @identity_metadata is nil and there is no druid" do
      
      @work_item.druid = nil
      identity_metadata = @work_item.identity_metadata
      identity_metadata.should be_kind_of(IdentityMetadata)
      identity_metadata.to_xml.should be_kind_of(Nokogiri::XML::Element)
    
    end 
    
    it "should create get the existing identity_metadata XML as a ROXML object the @identity_metadata is nil but there is a druid" do
      
      @work_item.druid = "changeme:boosh"
      DorService.should_receive(:get_datastream).with("changeme:boosh", 'identityMetadata').and_return("<identityMetadata/>")
      
      identity_metadata = @work_item.identity_metadata
      identity_metadata.should be_kind_of(IdentityMetadata)
      identity_metadata.to_xml.should be_kind_of(Nokogiri::XML::Element)
      
    end 
  end #identity_metadata
  
  describe "#identity_metadata_save" do
    
    it "should make a new identityMetadata ds if none exists" do
      @work_item.druid = "changeme:boosh"
      @work_item.identity_metadata = IdentityMetadata.new
      DorService.should_receive(:get_datastream).with("changeme:boosh", 'identityMetadata').and_return(nil)
      DorService.should_receive(:add_datastream).with("changeme:boosh", 'identityMetadata', 'identityMetadata', "<identityMetadata/>" )
      @work_item.identity_metadata_save
    end 
    
    it "should update the identityMetadata ds if one exists" do
      @work_item.druid = "changeme:boosh"
      @work_item.identity_metadata = IdentityMetadata.new
      DorService.should_receive(:get_datastream).with("changeme:boosh", 'identityMetadata').and_return("<identityMetadata/>")
      DorService.should_receive(:update_datastream).with("changeme:boosh", 'identityMetadata', "<identityMetadata/>",  content_type='application/xml', versionable = false )
      @work_item.identity_metadata_save      
    end
    
  end #identity_metadata_save
  
  
  describe "#set_success" do
    
    it "should set the success when told to" do    
    end 
        
  end #set_success
  
end #LyberCore::WorkItem