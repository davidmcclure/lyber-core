require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
require 'rexml/document'

include REXML

class DorService
       
    def DorService.get_https_connection(url)
      https = Net::HTTP.new(url.host, url.port)
      if(url.scheme == 'https')
        https.use_ssl = true
        https.cert = OpenSSL::X509::Certificate.new( File.read(CERT_FILE) )
        https.key = OpenSSL::PKey::RSA.new( File.read(KEY_FILE), KEY_PASS )
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      https
    end
   
  def DorService.create_object(form_data)
    begin      
      url = DOR_URI + '/objects'
      body = DorService.encodeParams(form_data)
      content_type = 'application/x-www-form-urlencoded'
      res = LyberCore::Connection.post(url, body, :content_type => content_type)
      res =~ /\/objects\/(.*)/
      druid = $1
      return druid
    rescue Exception => e
      $stderr.print "Unable to create object " + e
      raise
    end  
  end
  
  #objects/dr:123/resources
  #parms: model, id
  #will create object of type dor:GoogleScannedPage
  def DorService.create_child_object(parent_druid, child_id)
    begin
      #See if page exists before creating new fedora object
      # raise "Object exists with id: " + child_id if(DorService.get_druid_by_id(child_id)) 
      form_data = {'model' => 'dor:googleScannedPage', 'id' => child_id}
      url = DOR_URI + '/objects/' + parent_druid + '/resources'
      body = DorService.encodeParams(form_data)
      content_type = 'application/x-www-form-urlencoded'
      res = LyberCore::Connection.post(url, body, :content_type => content_type)
      res=~ /\/resources\/(.*)/
      druid = $1
      puts "Child googleScannedPage object created for parent " + parent_druid 
      puts "child_id " + child_id
      puts "new druid " + druid
      return druid
    rescue Exception => e
      $stderr.print "Unable to create object " + e
      raise
    end
  end
  
  
  # Takes a hash of arrays and builds a x-www-form-urlencoded string for POSTing form parameters
  #
  # == Parameters
  # - <b>form_data</b> - a hash of arrays that contains the form data, ie. {'param1' => ['val1', 'val2'], 'param2' => ['val3']}
  def DorService.encodeParams form_data
    body = ""
    form_data.each_pair do |param, array|
      array.each do |value|
        encoded = CGI.escape value
        body += '&' unless (body == "")
        body += param + '=' + encoded
      end
    end
    body
  end
 
  
  # Depricated.  Use Dor::WorkflowService#create_workflow in lyber_core gem
  # def DorService.create_workflow(workflow, druid)
  #   begin
  #     url = URI.parse(DOR_URI + '/objects/' + druid + '/workflows/' + workflow.workflow_id)
  #     req = Net::HTTP::Put.new(url.path)
  #     #req.basic_auth 'fedoraUser', 'pass'
  #     req.body = workflow.workflow_process_xml
  #     req.content_type = 'application/xml'
  #     res = DorService.get_https_connection(url).start {|http| http.request(req) }
  #     
  #     WorkflowService.create_workflow()
  #     
  #     case res
  #       when Net::HTTPSuccess
  #         puts workflow.workflow_id + " created for " + druid
  #       else
  #         $stderr.print res.body
  #         raise res.error!
  #     end
  #   rescue Exception => e
  #     $stderr.print "Unable to create workflow " + e
  #     raise
  #   end
  # end
  
 
  # See if an object exists with this dor_id (not druid, but sub-identifier)
  # Caller will have to handle any exception thrown
  def DorService.get_druid_by_id (dor_id)
    url = URI.parse(DOR_URI + '/query_by_id?id=' + dor_id)
    req = Net::HTTP::Get.new(url.request_uri)
    res = DorService.get_https_connection(url).start {|http| http.request(req) }
    case res
      when Net::HTTPSuccess
        res.body =~ /druid="([^"\r\n]*)"/
        return $1
      else
        puts "Id not found in DOR " + dor_id
        return nil
    end
  end
  
  #############################################  Start of Datastream methods
  # Until ActiveFedora supports client-side certificate configuration, we are stuck with our own methods to access datastreams
  
  #/objects/{pid}/datastreams/{dsID} ? [controlGroup] [dsLocation] [altIDs] [dsLabel] [versionable] [dsState] [formatURI] [checksumType] [checksum] [logMessage]
  def DorService.add_datastream(druid, ds_id, ds_label, xml, content_type='application/xml', versionable = false )
    DorService.add_datastream_managed(druid, ds_id, ds_label, xml, content_type, versionable)
  end
  
  def DorService.add_datastream_external_url(druid, ds_id, ds_label, ext_url, content_type, versionable = false)
    parms = '?controlGroup=E'
    parms += '&dsLabel=' + CGI.escape(ds_label)
    parms += '&versionable=false' unless(versionable)
    parms += '&dsLocation=' + ext_url
    DorService.set_datastream(druid, ds_id, parms, :post, {:type => content_type})
  end
  
  def DorService.update_datastream(druid, ds_id, xml, content_type='application/xml', versionable = false)
    parms = '?controlGroup=M'
    parms += '&versionable=false' unless(versionable)
    DorService.set_datastream(druid, ds_id, parms, :put, {:type => content_type, :xml => xml})
  end
  
  def DorService.add_datastream_managed(druid, ds_id, ds_label, xml, content_type='application/xml', versionable = false )
    parms = '?controlGroup=M'
    parms += '&dsLabel=' + CGI.escape(ds_label)
    parms += '&versionable=false' unless(versionable)
    DorService.set_datastream(druid, ds_id, parms, :post, {:type => content_type, :xml => xml})
  end
    
  # Retrieve the content of a datastream of a DOR object
  # e.g. FEDORA_URI + /objects/ + druid + /datastreams/dor/content gets "dor" datastream content
  def DorService.get_datastream(druid, ds_id)
    begin
      url = URI.parse(FEDORA_URI + '/objects/' + druid + '/datastreams/' + ds_id + '/content')
      req = Net::HTTP::Get.new(url.request_uri)
      res = DorService.get_https_connection(url).start {|http| http.request(req) }  
      case res
        when Net::HTTPSuccess
          return res.body
        else
          $stderr.puts "Datastream " + ds_id + " not found for " + druid
          return nil
       end
    end     
  end

  # Depricated - use Dor::WorkflowService#get_workflow_xml
  def DorService.get_workflow_xml(druid, workflow)
    raise Exception.new("This method is deprecated.  Please use Dor::WorkflowService#get_workflow_xml")
  end
  
  # Retrieve the metadata of a datastream of a DOR object
  # e.g. FEDORA_URI + /objects/ + druid + /datastreams/dor gets "dor" datastream metadata
  def DorService.get_datastream_md(druid, ds_id)
    begin
      url = URI.parse(FEDORA_URI + '/objects/' + druid + '/datastreams/' + ds_id)
      req = Net::HTTP::Get.new(url.request_uri)
      req.basic_auth FEDORA_USER, FEDORA_PASS
      res = DorService.get_https_connection(url).start {|http| http.request(req) }  
      case res
        when Net::HTTPSuccess
          return res.body
        else
          $stderr.puts "Datastream " + ds_id + " not found for " + druid
          return nil
       end
    end     
  end
  
   # Add a new datastream, but only if it does not yet exist
   def DorService.add_datastream_unless_exists(druid, ds_id, ds_label, xml)
      # make sure xml is not empty
      unless xml
        raise "No data supplied for datastream " + ds + "of " + druid
      end
      # check to make sure datastream does not yet exist
      unless DorService.get_datastream(druid, ds_id)
        DorService.add_datastream(druid, ds_id, ds_label, xml)
      end
  end
  
  #############################################  End of Datastream methods

  
  # Deprecated.  Use Dor::WorkflowService#update_workflow_status
  #PUT "objects/pid:123/workflows/GoogleScannedWF/convert"
  #<process name=\"convert\" status=\"waiting\" elapsed="0.11" lifecycle="released" "/>"
  #TODO increment attempts
  # def DorService.updateWorkflowStatus(repository, druid, workflow, process, status, elapsed = 0, lifecycle = nil)
  #   begin
  #     url = URI.parse(WORKFLOW_URI + '/' + repository + '/objects/' + druid + '/workflows/' + workflow + '/' + process)
  #     req = Net::HTTP::Put.new(url.path)
  #     process_xml = '<process name="'+ process + '" status="' + status + '" ' 
  #     process_xml << 'elapsed="' + elapsed.to_s + '" '
  #     process_xml << 'lifecycle="' + lifecycle + '" ' if(lifecycle)
  #     process_xml << '/>' 
  #     req.body = process_xml
  #     req.content_type = 'application/xml'
  #     res = DorService.get_https_connection(url).start {|http| http.request(req) }
  #     case res
  #       when Net::HTTPSuccess
  #         puts "#{workflow} process updated for " + druid
  #       else
  #         $stderr.print res.body
  #         raise res.error!
  #     end
  #   rescue Exception => e
  #     $stderr.print "Unable to update workflow " + e
  #     raise
  #   end
  #   
  # end
  
  # Returns string containing object list XML from a DOR query
  # XML returned looks like:
  #   <objects>
  #     <object druid="dr:123" url="http://localhost:9999/jersey-spring/objects/dr:123%5c" />
  #     <object druid="dr:abc" url="http://localhost:9999/jersey-spring/objects/dr:abc%5c" />
  #   </objects>
  def DorService.get_objects_for_workstep(repository, workflow, completed, waiting)
    LyberCore::Log.debug("DorService.get_objects_for_workstep(#{repository}, #{workflow}, #{completed}, #{waiting})")
    begin  
      if repository.nil? or workflow.nil? or completed.nil? or waiting.nil?
        LyberCore::Log.fatal("Can't execute DorService.get_objects_for_workstep: missing info")
      end
      
      unless defined?(WORKFLOW_URI) and WORKFLOW_URI != nil
        LyberCore::Log.fatal("WORKFLOW_URI is not set. ROBOT_ROOT = #{ROBOT_ROOT}")
        raise "WORKFLOW_URI is not set"   
      end
      
      uri_string = "#{WORKFLOW_URI}/workflow_queue?repository=#{repository}&workflow=#{workflow}&completed=#{completed}&waiting=#{waiting}"
      LyberCore::Log.info("Attempting to connect to #{uri_string}")
      url = URI.parse(uri_string)
      req = Net::HTTP::Get.new(url.request_uri)
      res = DorService.get_https_connection(url).start {|http| http.request(req) }  
      case res
        when Net::HTTPSuccess
          return res.body
        else
          LyberCore::Log.fatal("Workflow queue not found for #{workflow} : #{waiting}")
          LyberCore::Log.debug("I am attempting to connect to WORKFLOW_URI #{WORKFLOW_URI}")
          LyberCore::Log.debug("repository: #{repository}")
          LyberCore::Log.debug("workflow: #{workflow}")
          LyberCore::Log.debug("completed: #{completed}")
          LyberCore::Log.debug("waiting: #{waiting}")
          LyberCore::Log.debug(res.inspect)
          raise "Could not connect to url"
       end
    end 
  end
  
  # Transforms the XML from getObjectsForWorkStep into a list of druids
  # TODO figure out how to return a partial list
  # This method is here for backward compatibility, but it has
  # been superceded by DlssService.get_druids_from_object_list(objectListXml)
  def DorService.get_druids_from_object_list(objectListXml)
    DlssService.get_all_druids_from_object_list(objectListXml)
  end
  
  # Retrieves a string containing Identifiers for a DOR object 
  def DorService.get_object_identifiers(druid)
    identifiers = Hash.new
    dorXml = Document.new(get_datastream(druid, 'identityMetadata'))
    dorXml.elements.each("identityMetadata/otherId") do |element| 
      identifiers[element.attributes["name"]] = case element.text
        when nil then nil
        else element.text.strip     
      end
    end
    return identifiers    
  end
  
  def DorService.transfer_object(objectid, sourceDir, destinationDir) 
    rsync='rsync -a -e ssh '
    rsync_cmd = rsync + "'" + sourceDir + objectid + "' " +  destinationDir
    print rsync_cmd + "\n"
    system(rsync_cmd)
    return File.exists?(File.join(destinationDir, objectid))
  end
  
  def DorService.verify_checksums(directory, checksumFile)
    dirSave = Dir.pwd
    Dir.chdir(directory)
    checksumCmd = 'md5sum -c ' + checksumFile + ' | grep -v OK | wc -l'
    badcount = `#{checksumCmd}`.to_i
    Dir.chdir(dirSave)
    return (badcount==0)
  end
  
  def DorService.update_workflow_error_status(repository, druid, workflow, process, error_msg, error_txt = nil)
    begin
      url = URI.parse(WORKFLOW_URI + '/' + repository + '/objects/' + druid + '/workflows/' + workflow + '/' + process)
      req = Net::HTTP::Put.new(url.path)
      req.body = '<process name="'+ process + '" status="error" errorMessage="' + error_msg + '" ' 
      req.body += 'errorText="' + error_txt + '" ' if(error_txt)
      req.body += '/>' 
      req.content_type = 'application/xml'
      res = DorService.get_https_connection(url).start {|http| http.request(req) }
      case res
        when Net::HTTPSuccess
          puts "#{workflow} - #{process} set to error for " + druid
        else
          $stderr.print res.body
          raise res.error!
      end
    rescue Exception => e
      $stderr.print "Unable to update workflow " + e
      raise
    end
  end

#========= This method send GET to jenson and returns MARC XML  ==========#
    def DorService.query_symphony(flexkey)

      symphony_url = 'http://zaph.stanford.edu'
      path_info = '/cgi-bin/holding.pl?'
      parm_list = URI.escape('search=location&flexkey=' + flexkey)

      url = URI.parse( symphony_url + path_info + parm_list )
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get( path_info + parm_list )
      }

      res.body

     end #query_symphony


  private
  # druid, ds, url, content_type, method, parms
  def DorService.set_datastream(druid, ds_id, parms, method, content = {})
    begin  
      url = URI.parse(FEDORA_URI + '/objects/' + druid + '/datastreams/' + ds_id + parms)
      case method
        when :post
          req = Net::HTTP::Post.new(url.request_uri)
        when :put
          req = Net::HTTP::Put.new(url.request_uri)
      end
      req.basic_auth FEDORA_USER, FEDORA_PASS
      req.body = content[:xml] if(content[:xml])
      req.content_type = content[:type]
      res = DorService.get_https_connection(url).start {|http| http.request(req) }
      case res
        when Net::HTTPSuccess
          return true
        else
          $stderr.print res.body
          raise res.error!
      end
    rescue Exception => e
      raise
    end 
  end
  
  def DorService.get_object_metadata(druid) 
    dor = DorService.get_datastream(druid, 'identityMetadata')
    mods = DorService.get_datastream(druid, 'descMetadata')
    googlemets = DorService.get_datastream(druid, 'googlemets')
    contentMetadata = DorService.get_datastream(druid, 'contentMetadata')
    adminMetadata = DorService.get_datastream(druid, 'adminMetadata')
    xml = "<objectMD druid='" + druid + "' >\n" + 
      dor + mods + googlemets + contentMetadata + adminMetadata +
      "</objectMD>\n"
    return xml
  end
  
end


def DorService.add_identity_tags(druid, tags)
   begin
     xml = "<tags>"
     tags.each do |tag|
       xml << "<tag>#{tag}</tag>"
     end
     xml << "</tags>"
     puts xml
     url = URI.parse(DOR_URI + '/objects/' + druid + '/datastreams/identityMetadata/tags' )
     req = Net::HTTP::Put.new(url.path)
     req.body = xml
     req.content_type = 'application/xml'
     res = DorService.get_https_connection(url).start {|http| http.request(req) }
     case res
       when Net::HTTPSuccess
         return true
       else
         $stderr.print res.body
         raise res.error!
     end
   rescue Exception => e
     raise
   end
 end

#DorService.updateWorkflowStatus('dr:rf624mb644', 'GoogleScannedWF', 'descriptive-metadata', 'completed')
####Testing
#line = 'id="catkey:1990757"||id="barcode:36105045033136"||model="GoogleScannedBook"||label="The poacher"'
#form_data = {}
#DorService.parse_line_return_hashlist(line, form_data)
#form_data.each_pair{|k,v| puts "key: #{k} value: #{v}"}
#
#puts DorService.encodeParams(form_data)

#DorService.create_object('id="catkey:454545454545454"||id="barcode:434343434343434343434343434"||model="GoogleScannedBook"||label="Ruby multiple Id parms 3"')

