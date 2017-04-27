# == Class: puppet::server
#
# Sets up a puppet master.
#
# == puppet::server parameters
#
# $autosign::                  If set to a boolean, autosign is enabled or disabled
#                              for all incoming requests. Otherwise this has to be
#                              set to the full file path of an autosign.conf file or
#                              an autosign script. If this is set to a script, make
#                              sure that script considers the content of autosign.conf
#                              as otherwise Foreman functionality might be broken.
#
# $autosign_entries::          A list of certnames or domain name globs
#                              whose certificate requests will automatically be signed.
#                              Defaults to an empty Array.
#
# $autosign_mode::             mode of the autosign file/script
#
# $autosign_content::          If set, write the autosign file content
#                              using the value of this parameter.
#                              Cannot be used at the same time as autosign_entries
#                              For example, could be a string, or
#                              file('another_module/autosign.sh') or
#                              template('another_module/autosign.sh.erb')
#
# $autosign_source::           If set, use this as the source for the autosign file,
#                              instead of autosign_content.
#
# $hiera_config::              The hiera configuration file.
#
# $user::                      Name of the puppetmaster user.
#
# $group::                     Name of the puppetmaster group.
#
# $dir::                       Puppet configuration directory
#
# $ip::                        Bind ip address of the puppetmaster
#
# $port::                      Puppet master port
#
# $ca::                        Provide puppet CA
#
# $ca_crl_filepath::           Path to ca_crl file
#
# $ca_crl_sync::               Sync the puppet ca crl to compile masters. Requires compile masters to
#                              be agents of the CA master (MOM) defaults to false
#
# $crl_enable::                Enable CRL processing, defaults to true when $ca is true else defaults
#                              to false
#
# $http::                      Should the puppet master listen on HTTP as well as HTTPS.
#                              Useful for load balancer or reverse proxy scenarios. Note that
#                              the HTTP puppet master denies access from all clients by default,
#                              allowed clients must be specified with $http_allow.
#
# $http_port::                 Puppet master HTTP port; defaults to 8139.
#
# $http_allow::                Array of allowed clients for the HTTP puppet master. Passed
#                              to Apache's 'Allow' directive.
#
# $reports::                   List of report types to include on the puppetmaster
#
# $implementation::            Puppet master implementation, either "master" (traditional
#                              Ruby) or "puppetserver" (JVM-based)
#
# $passenger::                 If set to true, we will configure apache with
#                              passenger. If set to false, we will enable the
#                              default puppetmaster service unless
#                              service_fallback is set to false. See 'Advanced
#                              server parameters' for more information.
#                              Only applicable when server_implementation is "master".
#
# $external_nodes::            External nodes classifier executable
#
# $git_repo::                  Use git repository as a source of modules
#
# $dynamic_environments::      Use $environment in the modulepath
#                              Deprecated when $directory_environments is true,
#                              set $environments to [] instead.
#
# $directory_environments::    Enable directory environments, defaulting to true
#                              with Puppet 3.6.0 or higher
#
# $environments::              Environments to setup (creates directories).
#                              Applies only when $dynamic_environments
#                              is false
#
# $environments_owner::        The owner of the environments directory
#
# $environments_group::        The group owning the environments directory
#
# $environments_mode::         Environments directory mode.
#
# $envs_dir::                  Directory that holds puppet environments
#
# $envs_target::               Indicates that $envs_dir should be
#                              a symbolic link to this target
#
# $common_modules_path::       Common modules paths (only when
#                              $git_repo_path and $dynamic_environments
#                              are false)
#
# $git_repo_path::             Git repository path
#
# $git_repo_mode::             Git repository mode
#
# $git_repo_group::            Git repository group
#
# $git_repo_user::             Git repository user
#
# $git_branch_map::            Git branch to puppet env mapping for the
#                              default post receive hook
#
# $post_hook_content::         Which template to use for git post hook
#
# $post_hook_name::            Name of a git hook
#
# $storeconfigs_backend::      Do you use storeconfigs? (note: not required)
#                              false if you don't, "active_record" for 2.X
#                              style db, "puppetdb" for puppetdb
#
# $app_root::                  Directory where the application lives
#
# $ssl_dir::                   SSL directory
#
# $package::                   Custom package name for puppet master
#
# $version::                   Custom package version for puppet master
#
# $certname::                  The name to use when handling certificates.
#
# $strict_variables::          if set to true, it will throw parse errors
#                              when accessing undeclared variables.
#
# $additional_settings::       A hash of additional settings.
#                              Example: {trusted_node_data => true, ordering => 'manifest'}
#
# $rack_arguments::            Arguments passed to rack app ARGV in addition to --confdir and
#                              --vardir.  The default is an empty array.
#
# $puppetdb_host::             PuppetDB host
#
# $puppetdb_port::             PuppetDB port
#
# $puppetdb_swf::              PuppetDB soft_write_failure
#
# $parser::                    Sets the parser to use. Valid options are 'current' or 'future'.
#                              Defaults to 'current'.
#
# === Advanced server parameters:
#
# $httpd_service::             Apache/httpd service name to notify
#                              on configuration changes. Defaults
#                              to 'httpd' based on the default
#                              apache module included with foreman-installer.
#
# $service_fallback::          If passenger is not used, do we want to fallback
#                              to using the puppetmaster service? Set to false
#                              if you disabled passenger and you do NOT want to
#                              use the puppetmaster service. Defaults to true.
#
# $passenger_min_instances::   The PassengerMinInstances parameter. Sets the
#                              minimum number of application processes to run.
#                              Defaults to the number of processors on your
#                              system.
#
# $passenger_pre_start::       Pre-start the first passenger worker instance
#                              process during httpd start.
#
# $passenger_ruby::            The PassengerRuby parameter. Sets the Ruby
#                              interpreter for serving the puppetmaster rack
#                              application.
#
# $config_version::            How to determine the configuration version. When
#                              using git_repo, by default a git describe
#                              approach will be installed.
#
# $server_foreman_facts::      Should foreman receive facts from puppet
#
# $foreman::                   Should foreman integration be installed
#
# $foreman_url::               Foreman URL
#
# $foreman_ssl_ca::            SSL CA of the Foreman server
#
# $foreman_ssl_cert::          Client certificate for authenticating against Foreman server
#
# $foreman_ssl_key::           Key for authenticating against Foreman server
#
# $puppet_basedir::            Where is the puppet code base located
#
# $enc_api::                   What version of enc script to deploy. Valid
#                              values are 'v2' for latest, and 'v1'
#                              for Foreman =< 1.2
#
# $report_api::                What version of report processor to deploy.
#                              Valid values are 'v2' for latest, and 'v1'
#                              for Foreman =< 1.2
#
# $request_timeout::           Timeout in node.rb script for fetching
#                              catalog from Foreman (in seconds).
#
# $environment_timeout::       Timeout for cached compiled catalogs (10s, 5m, ...)
#
# $ca_proxy::                  The actual server that handles puppet CA.
#                              Setting this to anything non-empty causes
#                              the apache vhost to set up a proxy for all
#                              certificates pointing to the value.
#
# $jvm_java_bin::              Set the default java to use.
#
# $jvm_config::                Specify the puppetserver jvm configuration file.
#
# $jvm_min_heap_size::         Specify the minimum jvm heap space.
#
# $jvm_max_heap_size::         Specify the maximum jvm heap space.
#
# $jvm_extra_args::            Additional java options to pass through.
#                              This can be used for Java versions prior to
#                              Java 8 to specify the max perm space to use:
#                              For example: '-XX:MaxPermSpace=128m'.
#
# $jruby_gem_home::            Where jruby gems are located for puppetserver
#
# $allow_any_crl_auth::        Allow any authentication for the CRL. This
#                              is needed on the puppet CA to accept clients
#                              from a the puppet CA proxy.
#
# $auth_allowed::              An array of authenticated nodes allowed to
#                              access all catalog and node endpoints.
#                              default to ['$1']
#
# $default_manifest::          Toggle if default_manifest setting should
#                              be added to the [main] section
#
# $default_manifest_path::     A string setting the path to the default_manifest
#
# $default_manifest_content::  A string to set the content of the default_manifest
#                              If set to '' it will not manage the file
#
# $ssl_dir_manage::            Toggle if ssl_dir should be added to the [master]
#                              configuration section. This is necessary to
#                              disable in case CA is delegated to a separate instance
#
# $ssl_key_manage::            Toggle if "private_keys/${::puppet::server::certname}.pem"
#                              should be created with default user and group. This is used in
#                              the default Forman setup to reuse the key for TLS communication.
#
# $puppetserver_vardir::       The path of the puppetserver var dir
#
# $puppetserver_dir::          The path of the puppetserver config dir
#
# $puppetserver_version::      The version of puppetserver 2 installed (or being installed)
#                              Unfortunately, different versions of puppetserver need configuring differently,
#                              and there's no easy way of determining which version is being installed.
#                              Defaults to '2.3.1' but can be overriden if you're installing an older version.
#
# $max_active_instances::      Max number of active jruby instances. Defaults to
#                              processor count
#
# $max_requests_per_instance:: Max number of requests per jruby instance. Defaults to 0 (disabled)
#
# $idle_timeout::              How long the server will wait for a response on an existing connection
#
# $connect_timeout::           How long the server will wait for a response to a connection attempt
#
# $web_idle_timeout::          Time in ms that Jetty allows a socket to be idle, after processing has completed.
#                              Defaults to the Jetty default of 30s
#
# $ssl_protocols::             Array of SSL protocols to use.
#                              Defaults to [ 'TLSv1.2' ]
#
# $ssl_chain_filepath::        Path to certificate chain for puppetserver
#                              Defaults to "${ssl_dir}/ca/ca_crt.pem"
#
# $cipher_suites::             List of SSL ciphers to use in negotiation
#                              Defaults to [ 'TLS_RSA_WITH_AES_256_CBC_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA',
#                              'TLS_RSA_WITH_AES_128_CBC_SHA256', 'TLS_RSA_WITH_AES_128_CBC_SHA', ]
#
# $ruby_load_paths::           List of ruby paths
#                              Defaults based on $::puppetversion
#
# $ca_client_whitelist::       The whitelist of client certificates that
#                              can query the certificate-status endpoint
#                              Defaults to [ '127.0.0.1', '::1', $::ipaddress ]
#
# $admin_api_whitelist::       The whitelist of clients that
#                              can query the puppet-admin-api endpoint
#                              Defaults to [ '127.0.0.1', '::1', $::ipaddress ]
#
# $enable_ruby_profiler::      Should the puppetserver ruby profiler be enabled?
#                              Defaults to false
#
# $ca_auth_required::          Whether client certificates are needed to access the puppet-admin api
#                              Defaults to true
#
# $use_legacy_auth_conf::      Should the puppetserver use the legacy puppet auth.conf?
#                              Defaults to false (the puppetserver will use its own conf.d/auth.conf)
#
# $allow_header_cert_info::    Allow client authentication over HTTP Headers
#                              Defaults to false, is also activated by the $http setting
#
class puppet::server(
  Variant[Boolean, Stdlib::Absolutepath] $autosign = $::puppet::autosign,
  Array[String] $autosign_entries = $::puppet::autosign_entries,
  Pattern[/^[0-9]{3,4}$/] $autosign_mode = $::puppet::autosign_mode,
  Optional[String] $autosign_content = $::puppet::autosign_content,
  Optional[String] $autosign_source = $::puppet::autosign_source,
  String $hiera_config = $::puppet::hiera_config,
  Array[String] $admin_api_whitelist = $::puppet::server_admin_api_whitelist,
  String $user = $::puppet::server_user,
  String $group = $::puppet::server_group,
  String $dir = $::puppet::server_dir,
  Stdlib::Absolutepath $codedir = $::puppet::codedir,
  Integer $port = $::puppet::server_port,
  String $ip = $::puppet::server_ip,
  Boolean $ca = $::puppet::server_ca,
  Optional[String] $ca_crl_filepath = $::puppet::ca_crl_filepath,
  Boolean $ca_crl_sync = $::puppet::server_ca_crl_sync,
  Optional[Boolean] $crl_enable = $::puppet::server_crl_enable,
  Boolean $ca_auth_required = $::puppet::server_ca_auth_required,
  Array[String] $ca_client_whitelist = $::puppet::server_ca_client_whitelist,
  Boolean $http = $::puppet::server_http,
  Integer $http_port = $::puppet::server_http_port,
  Array[String] $http_allow = $::puppet::server_http_allow,
  String $reports = $::puppet::server_reports,
  Enum['master', 'puppetserver'] $implementation = $::puppet::server_implementation,
  Boolean $passenger = $::puppet::server_passenger,
  Stdlib::Absolutepath $puppetserver_vardir = $::puppet::server_puppetserver_vardir,
  Optional[Stdlib::Absolutepath] $puppetserver_rundir = $::puppet::server_puppetserver_rundir,
  Optional[Stdlib::Absolutepath] $puppetserver_logdir = $::puppet::server_puppetserver_logdir,
  Stdlib::Absolutepath $puppetserver_dir = $::puppet::server_puppetserver_dir,
  Pattern[/^[\d]\.[\d]+\.[\d]+$/] $puppetserver_version = $::puppet::server_puppetserver_version,
  Boolean $service_fallback = $::puppet::server_service_fallback,
  Integer[0] $passenger_min_instances = $::puppet::server_passenger_min_instances,
  Boolean $passenger_pre_start = $::puppet::server_passenger_pre_start,
  Optional[String] $passenger_ruby = $::puppet::server_passenger_ruby,
  String $httpd_service = $::puppet::server_httpd_service,
  Variant[Undef, String[0], Stdlib::Absolutepath] $external_nodes = $::puppet::server_external_nodes,
  Array[String] $cipher_suites = $::puppet::server_cipher_suites,
  Optional[String] $config_version = $::puppet::server_config_version,
  Integer[0] $connect_timeout = $::puppet::server_connect_timeout,
  Integer[0] $web_idle_timeout = $puppet::server_web_idle_timeout,
  Boolean $git_repo = $::puppet::server_git_repo,
  Boolean $dynamic_environments = $::puppet::server_dynamic_environments,
  Boolean $directory_environments = $::puppet::server_directory_environments,
  Boolean $default_manifest = $::puppet::server_default_manifest,
  Stdlib::Absolutepath $default_manifest_path = $::puppet::server_default_manifest_path,
  String $default_manifest_content = $::puppet::server_default_manifest_content,
  Boolean $enable_ruby_profiler = $::puppet::server_enable_ruby_profiler,
  Array[String] $environments = $::puppet::server_environments,
  String $environments_owner = $::puppet::server_environments_owner,
  Optional[String] $environments_group = $::puppet::server_environments_group,
  Pattern[/^[0-9]{3,4}$/] $environments_mode = $::puppet::server_environments_mode,
  Stdlib::Absolutepath $envs_dir = $::puppet::server_envs_dir,
  Optional[Stdlib::Absolutepath] $envs_target = $::puppet::server_envs_target,
  Variant[Undef, String[0], Array[Stdlib::Absolutepath]] $common_modules_path = $::puppet::server_common_modules_path,
  Pattern[/^[0-9]{3,4}$/] $git_repo_mode = $::puppet::server_git_repo_mode,
  Stdlib::Absolutepath $git_repo_path = $::puppet::server_git_repo_path,
  String $git_repo_group = $::puppet::server_git_repo_group,
  String $git_repo_user = $::puppet::server_git_repo_user,
  Hash[String, String] $git_branch_map = $::puppet::server_git_branch_map,
  Integer[0] $idle_timeout = $::puppet::server_idle_timeout,
  String $post_hook_content = $::puppet::server_post_hook_content,
  String $post_hook_name = $::puppet::server_post_hook_name,
  Variant[Undef, Boolean, Enum['active_record', 'puppetdb']] $storeconfigs_backend = $::puppet::server_storeconfigs_backend,
  Stdlib::Absolutepath $app_root = $::puppet::server_app_root,
  Array[Stdlib::Absolutepath] $ruby_load_paths = $::puppet::server_ruby_load_paths,
  Stdlib::Absolutepath $ssl_dir = $::puppet::server_ssl_dir,
  Boolean $ssl_dir_manage = $::puppet::server_ssl_dir_manage,
  Boolean $ssl_key_manage = $::puppet::server_ssl_key_manage,
  Array[String] $ssl_protocols = $::puppet::server_ssl_protocols,
  Optional[Stdlib::Absolutepath] $ssl_chain_filepath = $::puppet::server_ssl_chain_filepath,
  Optional[Variant[String, Array[String]]] $package = $::puppet::server_package,
  Optional[String] $version = $::puppet::server_version,
  String $certname = $::puppet::server_certname,
  Enum['v2', 'v1'] $enc_api = $::puppet::server_enc_api,
  Enum['v2', 'v1'] $report_api = $::puppet::server_report_api,
  Integer[0] $request_timeout = $::puppet::server_request_timeout,
  Optional[String] $ca_proxy = $::puppet::server_ca_proxy,
  Boolean $strict_variables = $::puppet::server_strict_variables,
  Hash[String, Data] $additional_settings = $::puppet::server_additional_settings,
  Array[String] $rack_arguments = $::puppet::server_rack_arguments,
  Boolean $foreman = $::puppet::server_foreman,
  Stdlib::HTTPUrl $foreman_url = $::puppet::server_foreman_url,
  Optional[Stdlib::Absolutepath] $foreman_ssl_ca = $::puppet::server_foreman_ssl_ca,
  Optional[Stdlib::Absolutepath] $foreman_ssl_cert = $::puppet::server_foreman_ssl_cert,
  Optional[Stdlib::Absolutepath] $foreman_ssl_key = $::puppet::server_foreman_ssl_key,
  Boolean $server_foreman_facts = $::puppet::server_foreman_facts,
  Optional[Stdlib::Absolutepath] $puppet_basedir = $::puppet::server_puppet_basedir,
  Optional[String] $puppetdb_host = $::puppet::server_puppetdb_host,
  Integer[0, 65535] $puppetdb_port = $::puppet::server_puppetdb_port,
  Boolean $puppetdb_swf = $::puppet::server_puppetdb_swf,
  Enum['current', 'future'] $parser = $::puppet::server_parser,
  Variant[Undef, Enum['unlimited'], Pattern[/^\d+[smhdy]?$/]] $environment_timeout = $::puppet::server_environment_timeout,
  String $jvm_java_bin = $::puppet::server_jvm_java_bin,
  String $jvm_config = $::puppet::server_jvm_config,
  Pattern[/^[0-9]+[kKmMgG]$/] $jvm_min_heap_size = $::puppet::server_jvm_min_heap_size,
  Pattern[/^[0-9]+[kKmMgG]$/] $jvm_max_heap_size = $::puppet::server_jvm_max_heap_size,
  String $jvm_extra_args = $::puppet::server_jvm_extra_args,
  Optional[Stdlib::Absolutepath] $jruby_gem_home = $::puppet::server_jruby_gem_home,
  Integer[1] $max_active_instances = $::puppet::server_max_active_instances,
  Integer[0] $max_requests_per_instance = $::puppet::server_max_requests_per_instance,
  Boolean $use_legacy_auth_conf = $::puppet::server_use_legacy_auth_conf,
  Boolean $check_for_updates = $::puppet::server_check_for_updates,
  Boolean $environment_class_cache_enabled = $::puppet::server_environment_class_cache_enabled,
  Boolean $allow_header_cert_info = $::puppet::server_allow_header_cert_info,
) {
  if $implementation == 'master' and $ip != $puppet::params::ip {
    notify {
      'ip_not_supported':
        message  => "Bind IP address is unsupported for the ${implementation} implementation.",
        loglevel => 'warning',
    }
  }

  if $ca {
    $ssl_ca_cert = "${ssl_dir}/ca/ca_crt.pem"
    $ssl_ca_crl  = "${ssl_dir}/ca/ca_crl.pem"
    $ssl_chain   = $ssl_chain_filepath
    $_crl_enable = pick($crl_enable, true)
  } else {
    $ssl_ca_cert = "${ssl_dir}/certs/ca.pem"
    $ssl_ca_crl  = pick($ca_crl_filepath, "${ssl_dir}/crl.pem")
    $ssl_chain   = false
    $_crl_enable = pick($crl_enable, false)
  }

  $ssl_cert      = "${ssl_dir}/certs/${certname}.pem"
  $ssl_cert_key  = "${ssl_dir}/private_keys/${certname}.pem"

  if $config_version == undef {
    if $git_repo {
      $config_version_cmd = "git --git-dir ${envs_dir}/\$environment/.git describe --all --long"
    } else {
      $config_version_cmd = undef
    }
  } else {
    $config_version_cmd = $config_version
  }

  if $implementation == 'master' {
    $pm_service   = !$passenger and $service_fallback
    $ps_service   = undef
    $rack_service = $passenger
  } elsif $implementation == 'puppetserver' {
    $pm_service   = undef
    $ps_service   = true
    $rack_service = false
  }

  class { '::puppet::server::install': }
  ~> class { '::puppet::server::config':  }
  ~> class { '::puppet::server::service':
    app_root      => $app_root,
    httpd_service => $httpd_service,
    puppetmaster  => $pm_service,
    puppetserver  => $ps_service,
    rack          => $rack_service,
  }
  -> Class['puppet::server']

  Class['puppet::config'] ~> Class['puppet::server::service']
}
