# == Usage 
#   ruby_cl_skeleton [options] source_file
#
#   For help use: ruby_cl_skeleton -h

module LyberCore
  module Robots
    require 'optparse'
    require 'ostruct'
    require 'logger'

    # ===== Usage
    # User defined robots should derive from this class and override the #process_item method
    class Robot
      attr_accessor :workflow_name
      attr_accessor :workflow_step
      
      # A LyberCore::Robots::Workflow object
      attr_accessor :workflow 
      attr_accessor :collection_name
      attr_accessor :workspace
      attr_accessor :args
      attr_accessor :options
      
      # Logging accessor methods
      attr_accessor :logfile
      attr_accessor :logger

      # ==== Available options
      # - :collection_name - The collection this workflow should work with.  
      #   Defined as a subdirectory within ROBOT_ROOT/config/workflows/your_workflow/your_collection
      # - :workspace - Full path of where to find content for a particular workflow
      def initialize(workflow_name, workflow_step, args = {})
        @workflow_name = workflow_name
        @workflow_step = workflow_step
        @collection_name = args[:collection_name]      
        @opts = args
      
        # Set defaults
        @options = OpenStruct.new
        @options.verbose = false
        @options.quiet = false
        self.parse_options
        self.start_logging(args)
        self.create_workflow
      end

      # ===== Set up the logging system
      # ===== Pass in the location of the desired logfile as an argument, like this:
      #   robot = TestRobot.new(wf_name, wf_step, :logfile => "/path/to/logfile.log")
      # ===== If the logfile is not passed in during instantiation, it gets a default value of 
      #   /tmp/logfile.log
      # ===== Pass in the log level of a robot like this:
      #   robot = TestRobot.new(wf_name, wf_step, :loglevel => 0)
      # ===== where loglevel is one of these:
      #   Logger::FATAL (4):  an unhandleable error that results in a program crash
      #   Logger::ERROR (3):  a handleable error condition
      #   Logger::WARN (2): a warning
      #   Logger::INFO (1): generic (useful) information about system operation
      #   Logger::DEBUG (0):  low-level information for developers
      # ===== An invalid option passed to :loglevel will put the robot in debug mode
      def start_logging(args)          
          @logfile = "/tmp/logfile.log"             
          
          # Check for the presence of args[:logfile] and attempt to open the indicated file
          begin
            if args[:logfile]
              filename = args[:logfile]
              File.open(filename, 'w') {}
              raise "Couldn't open file #{filename} for writing" unless File.writable?(filename) 
              @logfile = filename
            end
          rescue Exception => e
            raise e, "Couldn't initialize logfile: #{e.backtrace}"
          end
          
          # Instantiate the Logger object with the current logfile value
          @logger = Logger.new(@logfile)

          # Check for the presence of args[:loglevel] and set the log level appropriately
          begin
            if args[:loglevel]
              loglevel = args[:loglevel]
              if [0,1,2,3,4].contains? loglevel
                @logger.level = loglevel
                @logger.debug "Setting @logger.loglevel to #{loglevel}"
              else
                @logger.warn "I received an invalid option for log level. I expected a number between 0 and 4 but I got #{loglevel}"
                @logger.warn "I'm setting the loglevel to 0 (debug) because you seem to be having trouble."
                @logger.level = 0
              end
            else
              @logger.level = Logger::ERROR
            end
          rescue Exception => e
            raise e, "Couldn't set log level: #{e.backtrace}"
          end

          @logger.formatter = proc{|s,t,p,m|"%5s [%s] (%s) %s :: %s\n" % [s, 
                             t.strftime("%Y-%m-%d %H:%M:%S"), $$, p, m]}
    
      end
      
      # === Set the log level. 
      # See http://ruby-doc.org/core/classes/Logger.html for more info. 
      # Possible values are: 
      #   Logger::FATAL (4):  an unhandleable error that results in a program crash
      #   Logger::ERROR (3):  a handleable error condition
      #   Logger::WARN (2): a warning
      #   Logger::INFO (1): generic (useful) information about system operation
      #   Logger::DEBUG (0):  low-level information for developers
      def set_log_level(log_level)
        @logger.level = log_level
      end
      
      # === Returns the current log level of the robot
      def log_level
        @logger.level
      end
      
      # Create the workflow at instantiation, not when we start running the robot.
      # That way we can do better error checking and ensure that everything is going
      # to run okay before we actually start things.
      def create_workflow
        unless defined?(WORKFLOW_URI)
          @logger.fatal "FATAL: WORKFLOW_URI is not defined"
          @logger.fatal "Usually this is a value like 'http://lyberservices-dev.stanford.edu/workflow'"
          @logger.fatal "Usually you load it by setting ROBOT_ENVIRONMENT when you invoke your robot"
          raise "WORKFLOW_URI is not set! Do you need to set your ROBOT_ENVIRONMENT value?"
        end
        @logger.debug("About to instatiate a Workflow object: LyberCore::Robots::Workflow.new(#{@workflow_name},#{collection_name}")
        @workflow = LyberCore::Robots::Workflow.new(@workflow_name, {:logger => @logger, :collection_name => @collection_name})
        
      end
    
      # == Create a new workflow 
      def start()
        
        
        if(@opts[:workspace] == true)
          @workspace = LyberCore::Robots::Workspace.new(@workflow_name, @collection_name)
        end
        queue = @workflow.queue(@workflow_step)
      
        # If we have arguments, parse out the parts that indicate druids
        if(@options.file or @options.druid)
          queue.enqueue_druids(get_druid_list)
        else
          queue.enqueue_workstep_waiting()
        end
        process_queue(queue)
      end

      # Generate a list of druids to process
      def get_druid_list
      
        druid_list = Array.new
        
        # append any druids passed explicitly
        if(@options.druid)
          druid_list << @options.druid
        end
      
        # identifier list is in a file
         if (@options.file && File.exist?(@options.file))
          File.open(@options.file) do |file|
            file.each_line do |line|
              druid = line.strip
              if (druid.length > 0)
                druid_list << druid
              end
            end
          end
        end
      
        return druid_list
      end

      def process_queue(queue)
        while work_item = queue.next_item do
          begin
            #call overridden method
            process_item(work_item)
            work_item.set_success
          rescue Exception => e
            work_item.set_error(e)
          end
        end
        queue.print_stats()
      end
    
      # Override this method in your robot instance.  The method in this base class will throw an exception if it is not overriden.
      def process_item(work_item)
        #to be overridden by child classes
        raise 'You must implement this method in your subclass'
      end 
      
    # ###########################
    # command line option parsing 
  
        def parse_options
        
          options = {}

          o = OptionParser.new do |opts|
            opts.banner = "Usage: example.rb [options]"
            opts.separator ""

            opts.on("-d DRUID", "--druid DRUID", "Pass in a druid to process") do |d|
              @options.druid = d
            end
          
            opts.on("-f", "--file FILE", "Pass in a file of druids to process") do |f|
              @options.file = f
            end
          
          end
        
          # Parse the command line options and ignore anything not specified above
          begin
            o.parse!
          rescue OptionParser::ParseError => e
            puts e
          end
        
        end

        # def output_options
        #   puts "Options:\n"
        # 
        #   @options.marshal_dump.each do |name, val|        
        #     puts "  #{name} = #{val}"
        #   end
        # end
        # 
        # def output_help
        #   output_version
        #   RDoc::usage() #exits app
        # end
        # 
        # def output_usage
        #   RDoc::usage('usage') # gets usage from comments above
        # end
        # 
        # def output_version
        #   puts "#{File.basename(__FILE__)} version #{VERSION}"
        # end
  
    # ##################################
    # end of command line option parsing 
    # ##################################
  
    end # end of class
  end # end of Robots module
end # end of LyberCore module