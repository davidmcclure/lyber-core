require File.dirname(__FILE__) + '/spec_helper'
# require 'benchmark'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'fakeweb'
require File.expand_path(File.dirname(__FILE__) + "/fixtures/config/environments/test.rb")  


describe DorService do

  before(:all) do
    with_warnings_suppressed do
      LyberCore::CERT_FILE = File.dirname(__FILE__) + '/certs/dummy.crt'
      LyberCore::KEY_FILE = File.dirname(__FILE__) + '/certs/dummy.key'
      LyberCore::KEY_PASS = 'dummy'
    end
  end
  

  context "context" do
    it "#get_workflow_xml should throw an exception saying the method is depricated" do
      lambda{ DorService.get_workflow_xml('somedruid', 'someworkflow')}.should raise_error(Exception, "This method is deprecated.  Please use Dor::WorkflowService#get_workflow_xml")
    end
  end

  context "DorService.encodeParams" do
    it "accepts a hash of arrays" do
      my_hash = {'param1' => ['val1', 'val2'], 'param2' => ['val3']}
      DorService.encodeParams(my_hash).should eql("param1=val1&param1=val2&param2=val3")
    end
  end
  
  context "workflow" do
    it "transforms xml from the workflow service into a list of druids" do
      # puts Benchmark.measure {
      queue = open(File.expand_path(File.dirname(__FILE__) + "/fixtures/queue.xml"))
      array = DorService.get_druids_from_object_list(queue)
      array.should be_kind_of(Array)
      array[0].should eql("druid:hx066mp6063")
      array.length.should eql(9)
      # }
    end
  end
  
  describe "DorService.get_objects_for_workstep" do
    repository = "dor"
    workflow = "googleScannedBookWF"
    completed = "google-download"
    waiting = "process-content"
    
    context "a query with one step completed and one waiting" do
      it "creates the URI string with only the one completed step" do
        uri_str = "#{WORKFLOW_URI}/workflow_queue?repository=#{repository}&workflow=#{workflow}&waiting=#{waiting}&completed=#{completed}"
        uri = URI.parse(uri_str)
        
        URI.should_receive(:parse).with(/workflow_queue\?repository=#{repository}&workflow=#{workflow}&waiting=#{waiting}&completed=#{completed}/).any_number_of_times.and_return(uri)

        FakeWeb.register_uri(:get, %r|lyberservices-dev\.stanford\.edu/|,
          :body => "<objects count=\"1\"><xml>some workflow</xml></objects>")

        DorService.get_objects_for_workstep(repository, workflow, completed, waiting)
      end
    end
    
    context "a query with TWO steps completed and one waiting" do
      it "creates the URI string with the two completed steps correctly" do
        second_completed="google-convert"
        uri_str = "#{WORKFLOW_URI}/workflow_queue?repository=#{repository}&workflow=#{workflow}&waiting=#{waiting}&completed=#{completed}&completed=#{second_completed}"
        uri = URI.parse(uri_str)
        
        URI.should_receive(:parse).with(/workflow_queue\?repository=#{repository}&workflow=#{workflow}&waiting=#{waiting}&completed=#{completed}&completed=#{second_completed}/).any_number_of_times.and_return(uri)

        FakeWeb.register_uri(:get, %r|lyberservices-dev\.stanford\.edu/|,
          :body => "<objects count=\"1\"><xml>some workflow</xml></objects>")

        DorService.get_objects_for_workstep(repository, workflow, [completed, second_completed], waiting)
      end
      
      it "raises an exception if you pass in an array with more than 2 strings for the completed parameter" do
        lambda { DorService.get_objects_for_workstep(repository, workflow, ['1', '2', '3'], waiting) }.should raise_exception(RuntimeError, 'The workflow service can only handle queries with no more than 2 completed steps')
      end
    end
  
    context "a query using qualified workflow names for completed and waiting" do
      it "creates the URI string with the two completed steps across repositories correctly" do
        qualified_waiting = "#{repository}:#{workflow}:#{waiting}"
        qualified_completed = "#{repository}:#{workflow}:#{completed}"
        repo2 = "sdr"
        workflow2 = "sdrIngestWF"
        completed2="complete-deposit"
        qualified_completed2 = "#{repo2}:#{workflow2}:#{completed2}"
      
        uri_str = "#{WORKFLOW_URI}/workflow_queue?waiting=#{qualified_waiting}&completed=#{qualified_completed}&completed=#{qualified_completed2}"
        uri = URI.parse(uri_str)
      
        URI.should_receive(:parse).with(/workflow_queue\?waiting=#{qualified_waiting}&completed=#{qualified_completed}&completed=#{qualified_completed2}/).any_number_of_times.and_return(uri)
    
        FakeWeb.register_uri(:get, %r|lyberservices-dev\.stanford\.edu/|,
          :body => "<objects count=\"1\"><xml>some workflow</xml></objects>")
    
        DorService.get_objects_for_qualified_workstep([qualified_completed, qualified_completed2], qualified_waiting)
      end
      
      it "creates the URI string with only one completed step passed in as a String" do
        qualified_waiting = "#{repository}:#{workflow}:#{waiting}"
        qualified_completed = "#{repository}:#{workflow}:#{completed}"
        repo2 = "sdr"
      
        uri_str = "#{WORKFLOW_URI}/workflow_queue?waiting=#{qualified_waiting}&completed=#{qualified_completed}"
        uri = URI.parse(uri_str)
      
        URI.should_receive(:parse).with(/workflow_queue\?waiting=#{qualified_waiting}&completed=#{qualified_completed}/).any_number_of_times.and_return(uri)
    
        FakeWeb.register_uri(:get, %r|lyberservices-dev\.stanford\.edu/|,
          :body => "<objects count=\"1\"><xml>some workflow</xml></objects>")
    
        DorService.get_objects_for_qualified_workstep(qualified_completed, qualified_waiting)
      end
    end
  end
  
  context "get empty workflow queue" do
    
    it "raises a helpful exception if it encounters an empty workflow queue" do
      repository = "dor"
      workflow = "googleScannedBookWF"
      completed = "google-download"
      waiting = "process-content"
      FakeWeb.register_uri(:get, %r|lyberservices-dev\.stanford\.edu/|,
        :body => "<objects count=\"0\" />")
      lambda { DorService.get_objects_for_workstep(repository, workflow, completed, waiting) }.should raise_exception(LyberCore::Exceptions::EmptyQueue)
    end
  end
  
  context "DorService.get_datastream" do
    
    druid = "druid:wr056zx7133"
    ds_id = "identityMetadata"
    
    before :all do
      FakeWeb.allow_net_connect = false
    end
    
    after :all do
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end
    
    it "returns nil if it can't fetch the datastream" do
      FakeWeb.register_uri(:get, %r|dor-dev\.stanford\.edu/|,
        :body => "",
        :status => ["404", "Not Found"])
      id = DorService.get_datastream(druid, ds_id)
      id.should eql(nil)
    end
    
    it "raises an error if it encounters something unexpected" do
      FakeWeb.register_uri(:get, %r|dor-dev\.stanford\.edu/|,
        :body => "",
        :status => ["302", "Boo!"])
      lambda{ DorService.get_datastream(druid, ds_id) }.should raise_exception(/Encountered unknown error/)   
    end
    
  end
  
  context "DorService.get_druid_by_id" do
    
    before :each do
      FakeWeb.allow_net_connect = false
    end
    
    after :each do
      FakeWeb.allow_net_connect = true
      FakeWeb.clean_registry
    end
    
    barcode = "36105014905793"
    fake_url = "http://dor-dev.stanford.edu/dor/query_by_id?id=#{barcode}"
    
    # This is more of an integration test -- it actually tests the real 
    # query_by_id webservice
    # This test will only pass if this druid actually exists in dor-dev
    # TODO: re-write this test to use FakeWeb
    it "takes a bar code and looks up its druid" do
      FakeWeb.allow_net_connect = true
      # DorService.get_druid_by_id(barcode).should eql("druid:tc627wc3480")
      DorService.get_druid_by_id(barcode).should eql(nil)
    end
    
    it "returns nil if it doesn't find a druid (any 4xx error)" do
      FakeWeb.register_uri(:get, fake_url, 
        :body => "",
        :status => ["404", "Not Found"])
      DorService.get_druid_by_id(barcode).should eql(nil)  
    end
    
    it "raises an error if it encounters a server error (500 code)" do
      FakeWeb.register_uri(:get, fake_url, 
        :body => "",
        :status => ["500", "Error encountered"])
      lambda{ DorService.get_druid_by_id(barcode) }.should raise_exception(/Encountered 500 error/)   
    end
    
    it "raises an error if it encounters anything unexpected (like a 3xx code)" do
      FakeWeb.register_uri(:get, fake_url, 
        :body => "",
        :status => ["301", "Moved"])
      lambda{ DorService.get_druid_by_id(barcode) }.should raise_exception(/Encountered unknown error/)   
    end
    
  end
  
  context "DorService.get_object_identifiers(druid)" do
    
    druid = "druid:wr056zx7133"
    
    # This is an integration test. It actually connects to dor-dev
    it "returns identityMetadata/otherId values for a given druid (live lookup)" do
      pending
        ids = DorService.get_object_identifiers(druid)
        ids["dissertationid"].should eql("0000000216")
        ids["catkey"].should eql("8383197")
    end
    
    # This uses a fixture instead of fetching the datastream
    it "returns identityMetadata/otherId values for a given druid (fixture)" do
      fixture_metadata = open(File.expand_path(File.dirname(__FILE__) + "/fixtures/identityMetadata.xml")) { |f| f.read }
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, %r|dor-dev\.stanford\.edu/|, :body => fixture_metadata)
      ids = DorService.get_object_identifiers(druid)
      ids["dissertationid"].should eql("0000000216")
      ids["catkey"].should eql("8383197")
      FakeWeb.allow_net_connect = true
    end
    
    # This fakes an error from dor-dev
    it "raises an error if it can't connect to fedora" do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, %r|dor-dev\.stanford\.edu/|, 
        :body => "",
        :status => ["500", "Error encountered"])
      lambda{ DorService.get_object_identifiers(druid) }.should raise_exception(/Couldn't get object identifiers for druid/)
      FakeWeb.allow_net_connect = true
    end
    
  end
  
  context "DorService.update_workflow_error_status" do
    repository = "dor"
    druid = "druid:pz901bm7518"
    workflow = "googleScannedBookWF"
    process = "process-content"
    
    context "#construct_error_update_request" do
      
      it "cleans up any error codes that are passed" do
        error_msg = '500 "Internal Server Error"'
        error_txt = nil
        message = DorService.construct_error_update_request(process, error_msg, error_txt)
        lambda { doc = Nokogiri::XML(message) do |config|
          config.strict       
        end }.should_not raise_error
      end
      
      it "cleans up even very messy error text" do
        error_msg = "undefined local variable or method `druid' for #<GoogleScannedBook::GoogleDownload:0x2b6e1bc97b38>"
        error_txt = nil
        message = DorService.construct_error_update_request(process, error_msg, error_txt)
        lambda { doc = Nokogiri::XML(message) do |config|
          config.strict       
        end }.should_not raise_error
      end
    end
    
    it "raises a helpful error if it can't communicate with the workflow server" do
      repository = "foo"
      druid = "druid:bar"
      workflow = "workflow" 
      process = "process" 
      error_msg = "error_msg" 
      error_txt = "Hello, Nurse!"
      fake_url = "#{WORKFLOW_URI}/#{repository}/objects/#{druid}/workflows/#{workflow}/#{process}"
      FakeWeb.register_uri(:get, fake_url, 
        :body => "",
        :status => ["500", "Error encountered"])
      lambda{ DorService.update_workflow_error_status(repository, druid, workflow, process, error_msg, error_txt = nil) }.should raise_exception(/Unable to update workflow service at url/)
    end
    
  end
  
  context "DorService.add_identity_tags" do
    it "takes an array of tags and constructs valid xml for them" do
      tag_array = ["Tag 1", "Tag 2: The Reckoning", "Tag 3: >What's<> up!!!?", 'Tag 4: "Quotes"']
      xml = DorService.construct_xml_for_tag_array(tag_array)
      lambda { doc = Nokogiri::XML(xml) do |config|
        config.strict       
      end }.should_not raise_error
    end
  end
  
  context "DorService.getDatastream" do
    
  end
  
  context "DorService.query_symphony(flexkey)" do
    it "raises an error if it can't connect to symphony" do
      flexkey = "fakekey"
      symphony_url = 'http://zaph.stanford.edu'
      path_info = '/cgi-bin/holding.pl?'
      parm_list = URI.escape('search=location&flexkey=' + flexkey)
      fake_url = symphony_url + path_info + parm_list
      FakeWeb.register_uri(:get, fake_url, 
        :body => "",
        :status => ["500", "Error encountered"])
      lambda{ DorService.query_symphony(flexkey) }.should raise_exception(/Encountered an error from symphony/)
    end
  end
  
end