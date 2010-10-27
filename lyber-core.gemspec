# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lyber-core}
  s.version = "0.9.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Willy Mene"]
  s.date = %q{2010-10-23}
  s.description = %q{Contains classes to make http connections with a client-cert, use Jhove, and call Suri
Also contains core classes to build robots}
  s.email = %q{wmene@stanford.edu}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".bundle/config",
     ".document",
     ".gitignore",
     ".rvmrc",
     ".yardoc/checksums",
     ".yardoc/objects/DlssService.dat",
     ".yardoc/objects/DlssService/fedora_url_i.dat",
     ".yardoc/objects/DlssService/get_all_druids_from_object_list_c.dat",
     ".yardoc/objects/DlssService/get_datastream_md_i.dat",
     ".yardoc/objects/DlssService/get_druids_from_object_list_c.dat",
     ".yardoc/objects/DlssService/get_https_connection_i.dat",
     ".yardoc/objects/DlssService/get_some_druids_from_object_list_c.dat",
     ".yardoc/objects/DlssService/initialize_i.dat",
     ".yardoc/objects/Dor.dat",
     ".yardoc/objects/Dor/Base.dat",
     ".yardoc/objects/Dor/Base/initialize_i.dat",
     ".yardoc/objects/Dor/SuriService.dat",
     ".yardoc/objects/Dor/SuriService/mint_id_c.dat",
     ".yardoc/objects/Dor/WorkflowService.dat",
     ".yardoc/objects/Dor/WorkflowService/create_workflow_c.dat",
     ".yardoc/objects/Dor/WorkflowService/get_workflow_status_c.dat",
     ".yardoc/objects/Dor/WorkflowService/get_workflow_xml_c.dat",
     ".yardoc/objects/Dor/WorkflowService/update_workflow_error_status_c.dat",
     ".yardoc/objects/Dor/WorkflowService/update_workflow_status_c.dat",
     ".yardoc/objects/DorService.dat",
     ".yardoc/objects/DorService/add_datastream_c.dat",
     ".yardoc/objects/DorService/add_datastream_external_url_c.dat",
     ".yardoc/objects/DorService/add_datastream_managed_c.dat",
     ".yardoc/objects/DorService/add_datastream_unless_exists_c.dat",
     ".yardoc/objects/DorService/add_identity_tags_c.dat",
     ".yardoc/objects/DorService/construct_error_update_request_c.dat",
     ".yardoc/objects/DorService/construct_xml_for_tag_array_c.dat",
     ".yardoc/objects/DorService/create_child_object_c.dat",
     ".yardoc/objects/DorService/create_object_c.dat",
     ".yardoc/objects/DorService/encodeParams_c.dat",
     ".yardoc/objects/DorService/get_datastream_c.dat",
     ".yardoc/objects/DorService/get_datastream_md_c.dat",
     ".yardoc/objects/DorService/get_druid_by_id_c.dat",
     ".yardoc/objects/DorService/get_druids_from_object_list_c.dat",
     ".yardoc/objects/DorService/get_https_connection_c.dat",
     ".yardoc/objects/DorService/get_object_identifiers_c.dat",
     ".yardoc/objects/DorService/get_object_metadata_c.dat",
     ".yardoc/objects/DorService/get_objects_for_workstep_c.dat",
     ".yardoc/objects/DorService/get_workflow_xml_c.dat",
     ".yardoc/objects/DorService/query_symphony_c.dat",
     ".yardoc/objects/DorService/set_datastream_c.dat",
     ".yardoc/objects/DorService/transfer_object_c.dat",
     ".yardoc/objects/DorService/update_datastream_c.dat",
     ".yardoc/objects/DorService/update_workflow_error_status_c.dat",
     ".yardoc/objects/DorService/verify_checksums_c.dat",
     ".yardoc/objects/DublinCore.dat",
     ".yardoc/objects/IdentityMetadata.dat",
     ".yardoc/objects/IdentityMetadata/add_identifier_i.dat",
     ".yardoc/objects/IdentityMetadata/add_tag_i.dat",
     ".yardoc/objects/IdentityMetadata/get_id_pairs_i.dat",
     ".yardoc/objects/IdentityMetadata/get_identifier_value_i.dat",
     ".yardoc/objects/IdentityMetadata/get_other_id_i.dat",
     ".yardoc/objects/LyberCore.dat",
     ".yardoc/objects/LyberCore/Connection.dat",
     ".yardoc/objects/LyberCore/Connection/connect_c.dat",
     ".yardoc/objects/LyberCore/Connection/get_c.dat",
     ".yardoc/objects/LyberCore/Connection/get_https_connection_c.dat",
     ".yardoc/objects/LyberCore/Connection/post_c.dat",
     ".yardoc/objects/LyberCore/Connection/put_c.dat",
     ".yardoc/objects/LyberCore/Destroyer.dat",
     ".yardoc/objects/LyberCore/Destroyer/connect_to_fedora_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/current_druid_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/delete_druids_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/druid_list_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/get_druid_list_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/initialize_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/registration_robot_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/repository_i.dat",
     ".yardoc/objects/LyberCore/Destroyer/workflow_i.dat",
     ".yardoc/objects/LyberCore/Log.dat",
     ".yardoc/objects/LyberCore/Log/DEFAULT_FORMATTER.dat",
     ".yardoc/objects/LyberCore/Log/DEFAULT_LOGFILE.dat",
     ".yardoc/objects/LyberCore/Log/DEFAULT_LOG_LEVEL.dat",
     ".yardoc/objects/LyberCore/Log/_40_40logfile.dat",
     ".yardoc/objects/LyberCore/Log/debug_c.dat",
     ".yardoc/objects/LyberCore/Log/error_c.dat",
     ".yardoc/objects/LyberCore/Log/fatal_c.dat",
     ".yardoc/objects/LyberCore/Log/info_c.dat",
     ".yardoc/objects/LyberCore/Log/level_c.dat",
     ".yardoc/objects/LyberCore/Log/logfile_c.dat",
     ".yardoc/objects/LyberCore/Log/restore_defaults_c.dat",
     ".yardoc/objects/LyberCore/Log/set_level_c.dat",
     ".yardoc/objects/LyberCore/Log/set_logfile_c.dat",
     ".yardoc/objects/LyberCore/Log/warn_c.dat",
     ".yardoc/objects/LyberCore/Robots.dat",
     ".yardoc/objects/LyberCore/Robots/Robot.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/args_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/args_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/collection_name_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/collection_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/create_workflow_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/get_druid_list_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/initialize_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/options_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/options_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/parse_options_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/process_item_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/process_queue_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/start_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workflow_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workflow_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workflow_name_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workflow_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workflow_step_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workflow_step_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workspace_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/Robot/workspace_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/druid_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/druid_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/elapsed_time_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/end_time_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/id_pairs_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/identifier_add_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/identifier_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/identity_metadata_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/identity_metadata_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/identity_metadata_save_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/initialize_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/item_id_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/set_error_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/set_success_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/start_time_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkItem/work_queue_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/batch_limit_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/config_file_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/druids_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/elapsed_time_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/end_time_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/enqueue_druids_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/enqueue_identifiers_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/enqueue_workstep_waiting_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/error_count_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/error_count_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/error_limit_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/identifier_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/identifier_values_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/initialize_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/item_count_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/next_item_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/prerequisite_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/print_stats_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/process_config_file_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/start_time_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/success_count_3D_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/success_count_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/workflow_i.dat",
     ".yardoc/objects/LyberCore/Robots/WorkQueue/workflow_step_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/collection_config_dir_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/collection_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/initialize_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/logger_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/object_template_filepath_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/queue_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/repository_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_collection_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_config_dir_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_config_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_id_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_process_xml_filename_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workflow/workflow_process_xml_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/collection_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/content_dir_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/initialize_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/metadata_dir_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/object_dir_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/original_dir_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/workflow_name_i.dat",
     ".yardoc/objects/LyberCore/Robots/Workspace/workspace_base_i.dat",
     ".yardoc/objects/LyberCore/Utils.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/add_content_files_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/add_metadata_file_from_string_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/bag_payload_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/bag_size_human_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/copy_dir_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/initialize_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/validate_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/write_manifests_i.dat",
     ".yardoc/objects/LyberCore/Utils/BagitBag/write_metadata_info_i.dat",
     ".yardoc/objects/LyberCore/Utils/ChecksumValidate.dat",
     ".yardoc/objects/LyberCore/Utils/ChecksumValidate/compare_hashes_c.dat",
     ".yardoc/objects/LyberCore/Utils/ChecksumValidate/get_hash_differences_c.dat",
     ".yardoc/objects/LyberCore/Utils/ChecksumValidate/md5_hash_from_content_metadata_c.dat",
     ".yardoc/objects/LyberCore/Utils/ChecksumValidate/md5_hash_from_md5sum_c.dat",
     ".yardoc/objects/LyberCore/Utils/ChecksumValidate/md5_hash_from_mets_c.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities/execute_c.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities/gpgdecrypt_c.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities/pair_tree_from_barcode_c.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities/transfer_object_c.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities/unpack_c.dat",
     ".yardoc/objects/LyberCore/Utils/FileUtilities/verify_checksums_c.dat",
     ".yardoc/objects/OtherId.dat",
     ".yardoc/objects/SourceId.dat",
     ".yardoc/objects/Tag.dat",
     ".yardoc/objects/root.dat",
     ".yardoc/proxy_types",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "doc/apple_core.svg",
     "lib/dlss_service.rb",
     "lib/dor/base.rb",
     "lib/dor/suri_service.rb",
     "lib/dor/workflow_service.rb",
     "lib/dor_service.rb",
     "lib/lyber_core.rb",
     "lib/lyber_core/connection.rb",
     "lib/lyber_core/destroyer.rb",
     "lib/lyber_core/log.rb",
     "lib/lyber_core/robots/robot.rb",
     "lib/lyber_core/robots/work_item.rb",
     "lib/lyber_core/robots/work_queue.rb",
     "lib/lyber_core/robots/workflow.rb",
     "lib/lyber_core/robots/workspace.rb",
     "lib/lyber_core/utils.rb",
     "lib/lyber_core/utils/bagit_bag.rb",
     "lib/lyber_core/utils/checksum_validate.rb",
     "lib/lyber_core/utils/file_utilities.rb",
     "lib/roxml_models/identity_metadata/dublin_core.rb",
     "lib/roxml_models/identity_metadata/identity_metadata.rb",
     "lib/tasks/rdoc.rake",
     "lyber-core.gemspec",
     "spec/certs/dummy.crt",
     "spec/certs/dummy.key",
     "spec/certs/ls-dev.crt",
     "spec/certs/ls-dev.key",
     "spec/dlss_service_spec.rb",
     "spec/dor/base_spec.rb",
     "spec/dor/suri_service_spec.rb",
     "spec/dor/workflow_servce_spec.rb",
     "spec/dor_service_spec.rb",
     "spec/fixtures/barcode_to_druid.xml",
     "spec/fixtures/config/environments/test.rb",
     "spec/fixtures/config/workflows/googleScannedBookWF/process-config.yaml",
     "spec/fixtures/config/workflows/googleScannedBookWF/workflow-config.yaml",
     "spec/fixtures/config/workflows/sdrIngestWF/process-config.yaml",
     "spec/fixtures/config/workflows/sdrIngestWF/sdrIngestWF.xml",
     "spec/fixtures/config/workflows/sdrIngestWF/workflow-config.yaml",
     "spec/fixtures/identityMetadata.xml",
     "spec/fixtures/objects.xml",
     "spec/fixtures/queue.xml",
     "spec/lyber_core/connection_spec.rb",
     "spec/lyber_core/destroyer_spec.rb",
     "spec/lyber_core/log_spec.rb",
     "spec/lyber_core/robots/robot_spec.rb",
     "spec/lyber_core/robots/test_robot.rb",
     "spec/lyber_core/robots/work_item_spec.rb",
     "spec/lyber_core/robots/work_queue_spec.rb",
     "spec/lyber_core/robots/workflow_spec.rb",
     "spec/lyber_core/utils/checksum_validate_spec.rb",
     "spec/lyber_core/utils/file_transfer_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "test/test_data/100.txt",
     "test/test_data/2-3.txt",
     "test/test_data/3-4.txt",
     "test/test_data/4-5.txt",
     "test/test_data/DS-DublinCore",
     "test/test_data/DS-MODS-big.txt",
     "test/test_data/DS-MODS-small.txt",
     "test/test_data/DublinCoreChimera.xml",
     "test/test_data/IdentityMetadata-after.xml",
     "test/test_data/IdentityMetadata-before.xml",
     "test/test_data/Register",
     "test/test_data/Register.new",
     "test/test_data/RegisterRest.new",
     "test/test_data/add.txt",
     "test/test_data/barcode_catkey_map.txt",
     "test/test_data/bigadd.txt",
     "test/test_data/dc-small.xml",
     "test/test_data/error_catkeys.txt",
     "test/test_helper.rb",
     "test/unit/test_identity_metadata.rb"
  ]
  s.homepage = %q{http://github.com/wmene/lyber-core}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Core services used by the SULAIR Digital Library}
  s.test_files = [
    "spec/dlss_service_spec.rb",
     "spec/dor/base_spec.rb",
     "spec/dor/suri_service_spec.rb",
     "spec/dor/workflow_servce_spec.rb",
     "spec/dor_service_spec.rb",
     "spec/fixtures/config/environments/test.rb",
     "spec/lyber_core/connection_spec.rb",
     "spec/lyber_core/destroyer_spec.rb",
     "spec/lyber_core/log_spec.rb",
     "spec/lyber_core/robots/robot_spec.rb",
     "spec/lyber_core/robots/test_robot.rb",
     "spec/lyber_core/robots/work_item_spec.rb",
     "spec/lyber_core/robots/work_queue_spec.rb",
     "spec/lyber_core/robots/workflow_spec.rb",
     "spec/lyber_core/utils/checksum_validate_spec.rb",
     "spec/lyber_core/utils/file_transfer_spec.rb",
     "spec/spec_helper.rb",
     "test/test_helper.rb",
     "test/unit/test_identity_metadata.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<active-fedora>, [">= 1.2"])
      s.add_runtime_dependency(%q<actionpack>, ["= 2.3.9"])
      s.add_runtime_dependency(%q<activesupport>, ["= 2.3.9"])
      s.add_runtime_dependency(%q<bagit>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<columnize>, ["= 0.3.1"])
      s.add_runtime_dependency(%q<facets>, ["= 2.8.4"])
      s.add_runtime_dependency(%q<gemcutter>, ["= 0.6.1"])
      s.add_runtime_dependency(%q<git>, ["= 1.2.5"])
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_runtime_dependency(%q<jeweler>, [">= 1.4"])
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
      s.add_runtime_dependency(%q<linecache>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, ["= 1.16"])
      s.add_runtime_dependency(%q<multipart-post>, [">= 1.0.1"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.3.1"])
      s.add_runtime_dependency(%q<om>, [">= 0"])
      s.add_runtime_dependency(%q<rake>, [">= 0.8.7"])
      s.add_runtime_dependency(%q<rdoc>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<roxml>, [">= 3.1.5"])
      s.add_runtime_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<rubyforge>, ["= 2.0.4"])
      s.add_runtime_dependency(%q<ruby-debug>, [">= 0"])
      s.add_runtime_dependency(%q<semver>, [">= 0"])
      s.add_runtime_dependency(%q<solr-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<systemu>, [">= 1.2.0"])
      s.add_runtime_dependency(%q<validatable>, [">= 0"])
      s.add_runtime_dependency(%q<xml-simple>, [">= 0"])
    else
      s.add_dependency(%q<active-fedora>, [">= 1.2"])
      s.add_dependency(%q<actionpack>, ["= 2.3.9"])
      s.add_dependency(%q<activesupport>, ["= 2.3.9"])
      s.add_dependency(%q<bagit>, [">= 0.1.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<columnize>, ["= 0.3.1"])
      s.add_dependency(%q<facets>, ["= 2.8.4"])
      s.add_dependency(%q<gemcutter>, ["= 0.6.1"])
      s.add_dependency(%q<git>, ["= 1.2.5"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 1.4"])
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<linecache>, [">= 0"])
      s.add_dependency(%q<mime-types>, ["= 1.16"])
      s.add_dependency(%q<multipart-post>, [">= 1.0.1"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.3.1"])
      s.add_dependency(%q<om>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
      s.add_dependency(%q<rdoc>, [">= 2.3.0"])
      s.add_dependency(%q<roxml>, [">= 3.1.5"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rubyforge>, ["= 2.0.4"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<semver>, [">= 0"])
      s.add_dependency(%q<solr-ruby>, [">= 0"])
      s.add_dependency(%q<systemu>, [">= 1.2.0"])
      s.add_dependency(%q<validatable>, [">= 0"])
      s.add_dependency(%q<xml-simple>, [">= 0"])
    end
  else
    s.add_dependency(%q<active-fedora>, [">= 1.2"])
    s.add_dependency(%q<actionpack>, ["= 2.3.9"])
    s.add_dependency(%q<activesupport>, ["= 2.3.9"])
    s.add_dependency(%q<bagit>, [">= 0.1.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<columnize>, ["= 0.3.1"])
    s.add_dependency(%q<facets>, ["= 2.8.4"])
    s.add_dependency(%q<gemcutter>, ["= 0.6.1"])
    s.add_dependency(%q<git>, ["= 1.2.5"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 1.4"])
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<linecache>, [">= 0"])
    s.add_dependency(%q<mime-types>, ["= 1.16"])
    s.add_dependency(%q<multipart-post>, [">= 1.0.1"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.3.1"])
    s.add_dependency(%q<om>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
    s.add_dependency(%q<rdoc>, [">= 2.3.0"])
    s.add_dependency(%q<roxml>, [">= 3.1.5"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rubyforge>, ["= 2.0.4"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<semver>, [">= 0"])
    s.add_dependency(%q<solr-ruby>, [">= 0"])
    s.add_dependency(%q<systemu>, [">= 1.2.0"])
    s.add_dependency(%q<validatable>, [">= 0"])
    s.add_dependency(%q<xml-simple>, [">= 0"])
  end
end

