require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'net/https'

require 'action_controller'
require_one 'action_controller/test_process', 'action_controller/test_case'

describe LyberCore::Connection do
  before(:all) do
    with_warnings_suppressed do 
      LyberCore::CERT_FILE = File.dirname(__FILE__) + '/../certs/dummy.crt'
      LyberCore::KEY_FILE = File.dirname(__FILE__) + '/../certs/dummy.key'
      LyberCore::KEY_PASS = 'dummy'
    end
  end
  
  before(:each) do 
    @response = Net::HTTPSuccess.new("", "", "")
    @response.stub!(:body).and_return('returned text')
    @http = mock('https', :null_object => true)
  end
  
  describe "#connect" do
    before(:each) do
      @xml = "<xml/>"
      @mock_request = ActionController::TestRequest.new
      @mock_request.should_receive(:body=).with(@xml)
      @mock_request.should_receive(:content_type=).with("application/xml")
    end
    
    it "should create an HTTP post and return an HTTP response" do
      Net::HTTP::Post.should_receive(:new).and_return(@mock_request)
      Net::HTTP.should_receive(:new).and_return(@http)
      @http.should_receive(:start).and_return(@response)
      
      b = LyberCore::Connection.post('https://some.edu/some/path', @xml)
      b.should == 'returned text'
    end
    
    it "should create an HTTP put and return an HTTP response" do
      Net::HTTP::Put.should_receive(:new).and_return(@mock_request)
      Net::HTTP.should_receive(:new).and_return(@http)
      @http.should_receive(:start).and_return(@response)
      
      b = LyberCore::Connection.put('http://some.edu/some/path', @xml) {|res| res.body}
      b.should == 'returned text'
    end
    
    it "should set the basic_auth user and password if they are passed in as options :auth_user and :auth_password" do
      Net::HTTP::Post.should_receive(:new).and_return(@mock_request)
      Net::HTTP.should_receive(:new).and_return(@http)
      @http.should_receive(:start).and_return(@response)
      @mock_request.should_receive(:basic_auth).with('user', 'password')
      
      b = LyberCore::Connection.post('https://some.edu/some/path', @xml, :auth_user => 'user', :auth_password => 'password')
      b.should == 'returned text'
    end

    it "should throw a ServiceError if a timeout exception occurs after 2 retries" do
      Net::HTTP::Post.should_receive(:new).and_return(@mock_request)
      Net::HTTP.should_receive(:new).exactly(3).times.and_return(@http)
      @http.should_receive(:start).exactly(3).times.and_raise(Timeout::Error)

      with_warnings_suppressed do
        RETRYABLE_SLEEP_VALUE = 0
      end
      lambda{ LyberCore::Connection.post('https://some.edu/some/path', @xml)
        }.should raise_error(LyberCore::Exceptions::ServiceError)
        with_warnings_suppressed do
          RETRYABLE_SLEEP_VALUE = 300
        end
    end
    
    it "should throw an exception if response to connect is an HTTP error" do
      e = 'HTTP Server Error'
      res = Net::HTTPServerError.new("", "", "")
      res.should_receive(:error!).and_return(e)
      Net::HTTP::Post.should_receive(:new).and_return(@mock_request)
      Net::HTTP.should_receive(:new).and_return(@http)
      @http.should_receive(:start).and_return(res)
    
      lambda{ LyberCore::Connection.post('https://some.edu/some/path', @xml)
        }.should raise_error(Exception, e)
    end
    
  end
  
  it "should create an HTTP post with an empty body" do
    empty_request = ActionController::TestRequest.new
    empty_request.should_receive(:content_type=).with("application/xml")
    Net::HTTP::Post.should_receive(:new).and_return(empty_request)
    Net::HTTP.should_receive(:new).and_return(@http)
    @http.should_receive(:start).and_return(@response)

    b = LyberCore::Connection.post('http://some.edu/some/path', nil) {|res| res.body}
    b.should == 'returned text'
  end
  
  it "should create an HTTP get with user auth and no body" do
    empty_request = ActionController::TestRequest.new
    empty_request.should_receive(:content_type=).with("application/xml")
    empty_request.should_not_receive(:body=)
    empty_request.should_receive(:basic_auth).with('user', 'password')
    Net::HTTP::Get.should_receive(:new).and_return(empty_request)
    Net::HTTP.should_receive(:new).and_return(@http)
    @http.should_receive(:start).and_return(@response)

    b = LyberCore::Connection.get('http://some.edu/some/path', :auth_user => 'user', :auth_password => 'password') {|res| res.body}
    b.should == 'returned text'
  end
  
  it "should handle an HTTP get without any options" do
     LyberCore::Connection.should_receive(:connect).with('http://some.edu/some/path', :get, nil, {})

     b = LyberCore::Connection.get('http://some.edu/some/path')
   end
  
  describe "#get_https_connection" do
    it "should setup an SSL connection if the URL uses https" do
      Net::HTTP.should_receive(:new).and_return(@http)
      @http.should_receive(:use_ssl=)
      @http.should_receive(:cert=)
      @http.should_receive(:key=)
      @http.should_receive(:verify_mode=)
      url = URI.parse('https://some.host.edu/some/path')
      LyberCore::Connection.get_https_connection(url).should == @http
    end
  end
  

end