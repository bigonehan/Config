# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_edgedb_global_optspecs
	string join \n debug-print-frames debug-print-descriptors debug-print-codecs test-output-conn-params help-connect t/tab-separated j/json c= V/version no-version-check no-cli-update-check skip-hooks I/instance= docker container= dsn= credentials-file= H/host= P/port= unix-path= u/user= d/database= b/branch= password no-password password-from-stdin secret-key= tls-ca-file= tls-verify-hostname no-tls-verify-hostname tls-security= tls-server-name= wait-until-available= admin connect-timeout= cloud-api-endpoint= cloud-secret-key= cloud-profile= h/help
end

function __fish_edgedb_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_edgedb_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_edgedb_using_subcommand
	set -l cmd (__fish_edgedb_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c edgedb -n "__fish_edgedb_needs_command" -s c -d 'Execute a query instead of starting REPL' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_needs_command" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_needs_command" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_needs_command" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_needs_command" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_needs_command" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_needs_command" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_needs_command" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_needs_command" -l debug-print-frames
complete -c edgedb -n "__fish_edgedb_needs_command" -l debug-print-descriptors
complete -c edgedb -n "__fish_edgedb_needs_command" -l debug-print-codecs
complete -c edgedb -n "__fish_edgedb_needs_command" -l test-output-conn-params
complete -c edgedb -n "__fish_edgedb_needs_command" -l help-connect -d 'Print all available connection options for interactive shell along with subcommands'
complete -c edgedb -n "__fish_edgedb_needs_command" -s t -l tab-separated -d 'Tab-separated output for queries'
complete -c edgedb -n "__fish_edgedb_needs_command" -s j -l json -d 'JSON output for queries (single JSON list per query)'
complete -c edgedb -n "__fish_edgedb_needs_command" -s V -l version -d 'Show command-line tool version'
complete -c edgedb -n "__fish_edgedb_needs_command" -l no-version-check
complete -c edgedb -n "__fish_edgedb_needs_command" -l no-cli-update-check -d 'Disable check for new available CLI version'
complete -c edgedb -n "__fish_edgedb_needs_command" -l skip-hooks -d 'Do not run any command hooks defined in [MANIFEST_FILE_DISPLAY_NAME]'
complete -c edgedb -n "__fish_edgedb_needs_command" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_needs_command" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_needs_command" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_needs_command" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_needs_command" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_needs_command" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_needs_command" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "init" -d 'Initialize project (alias for gel project init)'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "sync" -d 'Synchronize project with the current directory'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "dump" -d 'Create database backup'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "restore" -d 'Restore database from backup file'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "configure" -d 'Modify database configuration'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "generate" -d 'Run language-specific code generators'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "migration" -d 'Migration management subcommands'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "migrate" -d 'Apply migration (alias for gel migration apply)'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "database" -d 'Database commands'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "branch" -d 'Manage branches'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "describe" -d 'Describe database schema or object'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "list" -d 'List name and related info of database objects (types, scalars, modules, etc.)'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "analyze" -d 'Analyze performance of query in quotes (e.g. "select 9;")'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "pgaddr" -d 'Show PostgreSQL address. Works on dev-mode database only'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "psql" -d 'Run psql shell. Works on dev-mode database only'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "query" -d 'Execute EdgeQL query in quotes (e.g. "select 9;")'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "ui" -d 'Launch Gel instance in browser web UI'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "info" -d 'Show paths for Gel installation'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "project" -d 'Manage project installation'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "instance" -d 'Manage local Gel instances'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "server" -d 'Manage local Gel installations'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "extension" -d 'Manage extensions of local instances'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "_gen_completions" -d 'Generate shell completions'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "cli" -d 'Self-installation commands'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "_self_install" -d 'Install Gel'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "cloud" -d 'Gel Cloud authentication'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "watch" -d 'Start a long-running process that watches the project directory and runs scripts'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "hash-password" -d 'Generate a SCRAM-SHA-256 hash for a password'
complete -c edgedb -n "__fish_edgedb_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l project-dir -d 'Explicitly set a root directory for the project' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l server-version -d 'Specify the desired EdgeDB server version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l server-instance -d 'Specify the EdgeDB server instance to be associated with the project' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s d -l database -d 'Specify the default database for the project to use on that instance' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s b -l branch -d 'Specify the default branch for the project to use on that instance' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l server-start-conf -d 'Deprecated parameter, does nothing' -r -f -a "auto\t''
manual\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l link -d 'Specify whether the existing EdgeDB server instance should be linked with the project'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l no-migrations -d 'Skip running migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l non-interactive -d 'Initialize in non-interactive mode (accepting all defaults)'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l interactive -d 'Initialize in interactive mode'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l project-dir -d 'Explicitly set a root directory for the project' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand sync" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l format -d 'Choose dump format. For normal dumps this parameter should be omitted. For --all, only --format=dir is required' -r -f -a "dir\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l all -d 'Dump all databases and server configuration. path is a directory in this case and thus --format=dir is also required.  Will automatically overwrite any existing files of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l include-secrets -d 'Include secret configuration variables in the dump'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -l overwrite-existing -d 'Used to automatically overwrite existing files of the same name. Defaults to true'
complete -c edgedb -n "__fish_edgedb_using_subcommand dump" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -l all -d 'Restore all databases and server configuration. path is a directory in this case'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s v -l verbose -d 'Verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand restore" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -f -a "apply" -d 'Reads gel.local.toml from project directory and applies it to the instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -f -a "insert" -d 'Insert another configuration entry to the list setting'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -f -a "reset" -d 'Reset configuration entry (empty the list for list settings)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -f -a "set" -d 'Set scalar configuration value'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and not __fish_seen_subcommand_from apply insert reset set help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l project-dir -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from apply" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -f -a "Auth" -d 'Insert a client authentication rule'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from insert" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "listen_addresses" -d 'Reset listen addresses to 127.0.0.1'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "listen_port" -d 'Reset port to 5656'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "Auth" -d 'Clear authentication table (only admin socket can be used to connect)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "shared_buffers" -d 'Reset shared_buffers PostgreSQL configuration parameter to default value'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "query_work_mem" -d 'Reset work_mem PostgreSQL configuration parameter to default value'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "maintenance_work_mem" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "effective_cache_size" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "default_statistics_target" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "default_transaction_isolation" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "default_transaction_deferrable" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "default_transaction_access_mode" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "effective_io_concurrency" -d 'Reset PostgreSQL configuration parameter of the same name'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "session_idle_timeout" -d 'Reset session idle timeout'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "session_idle_transaction_timeout" -d 'Reset session idle transaction timeout'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "query_execution_timeout" -d 'Reset query execution timeout'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "allow_bare_ddl" -d 'Reset allow_bare_ddl parameter to AlwaysAllow'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "apply_access_policies" -d 'Reset apply_access_policies parameter to true'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "apply_access_policies_pg" -d 'Reset apply_access_policies_pg parameter to false'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "allow_user_specified_id" -d 'Reset allow_user_specified_id parameter to false'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "cors_allow_origins" -d 'Reset cors_allow_origins to an empty set'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "auto_rebuild_query_cache" -d 'Reset auto_rebuild_query_cache to true'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "auto_rebuild_query_cache_timeout" -d 'Reset auto_rebuild_query_cache_timeout'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "query_cache_size" -d 'Reset query_cache_size'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "store_migration_sdl" -d 'When to store resulting SDL of a Migration'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "http_max_connections" -d 'The maximum number of concurrent HTTP connections'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "current_email_provider_name" -d 'The name of the current email provider'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "simple_scoping" -d 'Whether to use the new simple scoping behavior'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "warn_old_scoping" -d 'Whether to warn when depending on old scoping behavior'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "track_query_stats" -d 'Select what queries are tracked in sys::QueryStats'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from reset" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "listen_addresses" -d 'Specifies the TCP/IP address(es) on which the server is to listen for connections from client applications'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "listen_port" -d 'The TCP port the server listens on; 5656 by default. Note that the same port number is used for all IP addresses the server listens on'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "shared_buffers" -d 'The amount of memory the database uses for shared memory buffers'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "query_work_mem" -d 'The amount of memory used by internal query operations such as sorting'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "maintenance_work_mem" -d 'The maximum amount of memory to be used by maintenance operations'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "effective_cache_size" -d 'Sets the planner’s assumption about the effective size of the disk cache available to a single query'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "default_statistics_target" -d 'Sets the default data statistics target for the planner'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "default_transaction_isolation" -d 'Controls the default isolation level of each new transaction, including implicit transactions. Defaults to Serializable. Note that changing this to a lower isolation level implies that the transactions are also read-only by default regardless of the value of the default_transaction_access_mode setting'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "default_transaction_deferrable" -d 'Controls the default deferrable status of each new transaction. It currently has no effect on read-write transactions or those operating at isolation levels lower than Serializable. The default is NotDeferrable'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "default_transaction_access_mode"
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "effective_io_concurrency" -d 'Sets the number of concurrent disk I/O operations that PostgreSQL expects can be executed simultaneously'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "session_idle_timeout" -d 'How long client connections can stay inactive before being closed by the server. Defaults to 60 seconds; set to 0s to disable'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "session_idle_transaction_timeout" -d 'How long client connections can stay inactive while in a transaction. Defaults to 10 seconds; set to 0s to disable'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "query_execution_timeout" -d 'How long an individual query can run before being aborted. A value of 0s disables the mechanism; it is disabled by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "allow_bare_ddl" -d 'Defines whether to allow DDL commands outside of migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "apply_access_policies" -d 'Apply access policies'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "apply_access_policies_pg" -d 'Apply access policies in SQL queries'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "allow_user_specified_id" -d 'Allow setting user-specified object identifiers'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "cors_allow_origins" -d 'Web origins that are allowed to send HTTP requests to this server'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "auto_rebuild_query_cache" -d 'Recompile all cached queries on DDL if enabled'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "auto_rebuild_query_cache_timeout" -d 'Timeout to recompile the cached queries on DDL'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "query_cache_size" -d 'Number of queries whose compilation can be cached'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "store_migration_sdl" -d 'When to store resulting SDL of a Migration. This may be slow'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "http_max_connections" -d 'The maximum number of concurrent HTTP connections'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "current_email_provider_name" -d 'The name of the current email provider'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "simple_scoping" -d 'Whether to use the new simple scoping behavior (disable path factoring)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "warn_old_scoping" -d 'Whether to warn when depending on old scoping behavior'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "track_query_stats" -d 'Select what queries are tracked in sys::QueryStats'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from set" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from help" -f -a "apply" -d 'Reads gel.local.toml from project directory and applies it to the instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from help" -f -a "insert" -d 'Insert another configuration entry to the list setting'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from help" -f -a "reset" -d 'Reset configuration entry (empty the list for list settings)'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from help" -f -a "set" -d 'Set scalar configuration value'
complete -c edgedb -n "__fish_edgedb_using_subcommand configure; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -s h -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l help -d 'Print help (see a summary with \'-h\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand generate" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "apply" -d 'Apply migration from latest migration script'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "create" -d 'Create migration script inside /migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "status" -d 'Show current migration status'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "log" -d 'Show all migration versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "edit" -d 'Edit migration file'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "upgrade-check" -d 'Check if current schema is compatible with new Gel version'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "extract" -d 'Extract migration history from the database and write it to <schema-dir>/migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "upgrade-format" -d 'Upgrades the format of migration files'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and not __fish_seen_subcommand_from apply create status log edit upgrade-check extract upgrade-format help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l to-revision -d 'Upgrade to a specified revision' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l quiet -d 'Do not print messages, only indicate success by exit status'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l dev-mode -d 'Dev mode is used to temporarily apply schema on top of those found in the migration history. Usually used for testing purposes, as well as gel watch which creates a dev mode migration script each time a file is saved by a user'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l no-index-build -d 'Disable building of concurrent indexes after applying migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -l single-transaction -d 'Runs the migration(s) in a single transaction'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from apply" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l squash -d 'Squash all schema migrations into one and optionally provide a fixup migration'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l non-interactive -d 'Do not ask questions. By default works only if "safe" changes are to be done (those for which Gel has a high degree of confidence). This safe default can be overridden with --allow-unsafe'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l expert -d 'Run the migration creation in expert mode. In this mode, the user will receive less-detailed prompts'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l allow-unsafe -d 'Apply the most probable unsafe changes in case there are ones. This is only useful in non-interactive mode'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l allow-empty -d 'Create a new migration even if there are no changes (use this for data-only migrations)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l debug-print-queries -d 'Print queries executed'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l debug-print-err -d 'Show error details'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l quiet -d 'Do not print messages, only indicate success by exit status'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l quiet -d 'Do not print any messages, only indicate success by exit status'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l limit -d 'Show maximum N revisions (default: no limit)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l from-fs -d 'Print revisions from the filesystem. (Database connection not required.)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l from-db -d 'Print revisions from the database. (No filesystem schema is required.)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l newest-first -d 'Sort migrations starting from newer to older, instead of the default older to newer'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from log" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l no-check -d 'Do not check migration using the database connection'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l non-interactive -d 'Fix migration id non-interactively, and do not run editor'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from edit" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l to-version -d 'Check upgrade to a specified version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l to-channel -d 'Check upgrade to latest version in the channel' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l to-nightly -d 'Check upgrade to latest nightly version'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l to-testing -d 'Check upgrade to latest testing version'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l watch -d 'Monitor schema changes and check again on change'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l no-exit-with-parent -d 'Do not exit when the parent process exits'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-check" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l non-interactive -d 'Don\'t ask questions, only add missing files, abort if mismatching'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l force -d 'Force overwrite existing migration files'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from extract" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from upgrade-format" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "apply" -d 'Apply migration from latest migration script'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create migration script inside /migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "status" -d 'Show current migration status'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "log" -d 'Show all migration versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "edit" -d 'Edit migration file'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "upgrade-check" -d 'Check if current schema is compatible with new Gel version'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "extract" -d 'Extract migration history from the database and write it to <schema-dir>/migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "upgrade-format" -d 'Upgrades the format of migration files'
complete -c edgedb -n "__fish_edgedb_using_subcommand migration; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l schema-dir -d 'Project schema directory.  The default is dbschema/, which can be changed by setting project.schema-dir in {gel,edgedb}.toml' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l to-revision -d 'Upgrade to a specified revision' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l quiet -d 'Do not print messages, only indicate success by exit status'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l dev-mode -d 'Dev mode is used to temporarily apply schema on top of those found in the migration history. Usually used for testing purposes, as well as gel watch which creates a dev mode migration script each time a file is saved by a user'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l no-index-build -d 'Disable building of concurrent indexes after applying migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -l single-transaction -d 'Runs the migration(s) in a single transaction'
complete -c edgedb -n "__fish_edgedb_using_subcommand migrate" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -f -a "create" -d 'Create a new database'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -f -a "drop" -d 'Delete a database along with its data'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -f -a "wipe" -d 'Delete a database\'s data and reset its schema while preserving the database itself (its cfg::DatabaseConfig) and existing migration scripts'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and not __fish_seen_subcommand_from create drop wipe help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l non-interactive -d 'Drop database without confirming'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from drop" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l non-interactive -d 'Drop database without confirming'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from wipe" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a new database'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from help" -f -a "drop" -d 'Delete a database along with its data'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from help" -f -a "wipe" -d 'Delete a database\'s data and reset its schema while preserving the database itself (its cfg::DatabaseConfig) and existing migration scripts'
complete -c edgedb -n "__fish_edgedb_using_subcommand database; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "create" -d 'Create a new branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "switch" -d 'Switch the current branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "list" -d 'List all branches'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "current" -d 'Prints the current branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "rebase" -d 'Creates a new branch that is based on the target branch, but also contains any new migrations on the current branch. Warning: data stored in current branch will be deleted'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "merge" -d 'Merges a branch into this one via a fast-forward merge'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "rename" -d 'Renames a branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "drop" -d 'Drops an existing branch, removing it and its data'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "wipe" -d 'Wipes all data within a branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and not __fish_seen_subcommand_from create switch list current rebase merge rename drop wipe help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l from -d 'The optional \'base\' of the branch to create' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s e -l empty -d 'Create the branch without any schema or data'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l copy-data -d 'Copy data from the \'base\' branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l from -d 'If creating a new branch: the optional \'base\' of the branch to create' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s c -l create -d 'Create the branch if it doesn\'t exist'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s e -l empty -d 'If creating a new branch: whether the new branch should be empty'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l copy-data -d 'If creating a new branch: whether to copy data from the \'base\' branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from switch" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l plain -d 'Print as plain text output to stdout. Prints nothing instead of erroring if the current branch can\'t be resolved'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from current" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l no-apply -d 'Skip applying migrations generated from the rebase'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rebase" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l no-apply -d 'Skip applying migrations generated from the merge'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from merge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l force -d 'Close any existing connection to the branch before renaming it'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l non-interactive -d 'Drop the branch without asking for confirmation'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l force -d 'Close any existing connections to the branch before dropping it'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from drop" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l non-interactive -d 'Wipe without asking for confirmation'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from wipe" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a new branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "switch" -d 'Switch the current branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all branches'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "current" -d 'Prints the current branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "rebase" -d 'Creates a new branch that is based on the target branch, but also contains any new migrations on the current branch. Warning: data stored in current branch will be deleted'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "merge" -d 'Merges a branch into this one via a fast-forward merge'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "rename" -d 'Renames a branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "drop" -d 'Drops an existing branch, removing it and its data'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "wipe" -d 'Wipes all data within a branch'
complete -c edgedb -n "__fish_edgedb_using_subcommand branch; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -f -a "object" -d 'Describe a database object'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -f -a "schema" -d 'Describe current database schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and not __fish_seen_subcommand_from object schema help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s v -l verbose
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from object" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from schema" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from help" -f -a "object" -d 'Describe a database object'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from help" -f -a "schema" -d 'Describe current database schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand describe; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "aliases" -d 'Display list of aliases defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "casts" -d 'Display list of casts defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "databases" -d 'On EdgeDB < 5.x: Display list of databases for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "branches" -d 'On EdgeDB/Gel >= 5.x: Display list of branches for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "indexes" -d 'Display list of indexes defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "modules" -d 'Display list of modules defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "roles" -d 'Display list of roles for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "scalars" -d 'Display list of scalar types defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "types" -d 'Display list of object types defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and not __fish_seen_subcommand_from aliases casts databases branches indexes modules roles scalars types help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s s -l system
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s v -l verbose
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from aliases" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from casts" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from databases" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from branches" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s s -l system
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s v -l verbose
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from indexes" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from modules" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from roles" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s s -l system
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from scalars" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s c -l case-sensitive
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s s -l system
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from types" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "aliases" -d 'Display list of aliases defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "casts" -d 'Display list of casts defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "databases" -d 'On EdgeDB < 5.x: Display list of databases for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "branches" -d 'On EdgeDB/Gel >= 5.x: Display list of branches for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "indexes" -d 'Display list of indexes defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "modules" -d 'Display list of modules defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "roles" -d 'Display list of roles for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "scalars" -d 'Display list of scalar types defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "types" -d 'Display list of object types defined in the schema'
complete -c edgedb -n "__fish_edgedb_using_subcommand list; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l debug-output-file -d 'Write analysis into specified JSON file instead of formatting' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l read-json -d 'Read JSON file instead of executing a query' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -l expand -d 'Show detailed output of analyze command'
complete -c edgedb -n "__fish_edgedb_using_subcommand analyze" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand pgaddr" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand psql" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s F -l output-format -d 'Output format: json, json-pretty, json-lines, tab-separated. Default is json-pretty' -r -f -a "default\t''
json\t''
json-pretty\t''
json-lines\t''
tab-separated\t''
tabular\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s L -l input-language -d 'Input language: edgeql, sql. Default is edgeql' -r -f -a "edgeql\t''
sql\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s f -l file -d 'Filename to execute queries from. Pass --file - to execute queries from stdin' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand query" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l print-url -d 'Print URL in console instead of opening in the browser'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -l no-server-check -d 'Do not probe the UI endpoint of the server instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand ui" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l get -d 'Get specific value:' -r -f -a "install-dir\t''
config-dir\t''
cache-dir\t''
data-dir\t''
service-dir\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand info" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -f -a "init" -d 'Initialize project or link to existing unlinked project'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -f -a "unlink" -d 'Clean up project configuration'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -f -a "info" -d 'Get various metadata about project instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -f -a "upgrade" -d 'Upgrade Gel instance used for current project'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and not __fish_seen_subcommand_from init unlink info upgrade help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l project-dir -d 'Explicitly set a root directory for the project' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l server-version -d 'Specify the desired EdgeDB server version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l server-instance -d 'Specify the EdgeDB server instance to be associated with the project' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s d -l database -d 'Specify the default database for the project to use on that instance' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s b -l branch -d 'Specify the default branch for the project to use on that instance' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l server-start-conf -d 'Deprecated parameter, does nothing' -r -f -a "auto\t''
manual\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l link -d 'Specify whether the existing EdgeDB server instance should be linked with the project'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l no-migrations -d 'Skip running migrations'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l non-interactive -d 'Initialize in non-interactive mode (accepting all defaults)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l interactive -d 'Initialize in interactive mode'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l project-dir -d 'Explicitly set a root directory for the project' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s D -l destroy-server-instance -d 'If specified, the associated EdgeDB instance is destroyed using edgedb instance destroy'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l non-interactive -d 'Unlink in in non-interactive mode (accepting all defaults)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from unlink" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l project-dir -d 'Explicitly set a root directory for the project' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l get -d 'Get a specific value:' -r -f -a "instance-name\t''
cloud-profile\t''
schema-dir\t''
branch\t''
database\t''
root\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l instance-name -d 'Display only the instance name (shortcut to --get instance-name)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l json -d 'Output in JSON format'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from info" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l project-dir -d 'Explicitly set a root directory for the project' -r -f -a "(__fish_complete_directories)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l to-version -d 'Upgrade specified instance to a specified version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l to-channel -d 'Upgrade specified instance to the specified channel' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l to-latest -d 'Upgrade specified instance to latest version'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l to-nightly -d 'Upgrade specified instance to latest nightly version'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l to-testing -d 'Upgrade specified instance to latest testing version'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s v -l verbose -d 'Verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l force -d 'Force upgrade process even if there is no new version'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l force-dump-restore -d 'Force dump-restore upgrade method for Cloud instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l force-in-place -d 'Force in-place upgrade method for Cloud instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l non-interactive -d 'Do not ask questions, assume user wants to upgrade instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from upgrade" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "init" -d 'Initialize project or link to existing unlinked project'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "unlink" -d 'Clean up project configuration'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "info" -d 'Get various metadata about project instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "upgrade" -d 'Upgrade Gel instance used for current project'
complete -c edgedb -n "__fish_edgedb_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "create" -d 'Initialize a new Gel instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "list" -d 'Show all instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "status" -d 'Show status of an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "start" -d 'Start an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "stop" -d 'Stop an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "restart" -d 'Restart an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "destroy" -d 'Destroy an instance and remove the data'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "link" -d 'Link to a remote Gel instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "unlink" -d 'Unlink from a remote Gel instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "logs" -d 'Show logs for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "resize" -d 'Resize an instance (Gel Cloud only)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "backup" -d 'Create a backup for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "restore" -d 'Restore an instance from a backup'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "list-backups" -d 'List backups for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "upgrade" -d 'Upgrade installations and instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "revert" -d 'Revert a major instance upgrade'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "reset-password" -d 'Generate new password for instance user (randomly generated by default)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "credentials" -d 'Display instance credentials (add --json for verbose)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and not __fish_seen_subcommand_from create list status start stop restart destroy link unlink logs resize backup restore list-backups upgrade revert reset-password credentials help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l version -d 'Create instance with specified version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l channel -d 'Indicate channel (stable, testing, or nightly) for instance to create' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l port -d 'Indicate port for instance to create' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l region -d 'The region in which to create the instance (for cloud instances)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l tier -d 'Cloud instance subscription tier' -r -f -a "pro\t''
free\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l compute-size -d 'The size of compute to be allocated for the Cloud instance in Compute Units' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l storage-size -d 'The size of storage to be allocated for the Cloud instance in Gigabytes' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l from-instance -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l from-backup-id -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l start-conf -d 'Deprecated parameter, unused' -r -f -a "auto\t''
manual\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l default-user -d 'Default user name (created during initialization and saved in credentials file). This defaults to \'admin\' on EdgeDB >=6.x; otherwise \'edgedb\' is used' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l nightly -d 'Create instance using the latest nightly version'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l non-interactive -d 'Do not ask questions. Assume user wants to upgrade instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l extended -d 'Output more debug info about each instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l debug -d 'Output all available debug info about each instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l json -d 'Output in JSON format'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l no-remote -d 'Query remote instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l quiet -d 'Do not show warnings on no instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l service -d 'Show current systems service info'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l extended -d 'Output more debug info about each instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l debug -d 'Output all available debug info about each instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l json -d 'Output in JSON format'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l quiet -d 'Do not print error on "No instance found", only indicate by error code'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l managed-by -d 'Indicate whether managed by edgedb-cli, systemd, launchctl, or None' -r -f -a "systemd\t''
launchctl\t''
edgedb-cli\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l foreground -d 'Start the server in the foreground rather than using systemd to manage the process (note: you might need to stop the non-foreground instance first)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l auto-restart -d 'With --foreground, stops server running in the background; also restarts the service on exit'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restart" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s v -l verbose -d 'Verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s q -l quiet -d 'Quiet output'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l force -d 'Force destroy even if instance is referred to by a project'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l non-interactive -d 'Do not ask questions. Assume user wants to delete instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from destroy" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l non-interactive -d 'Run in non-interactive mode (accepting all defaults)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l quiet -d 'Reduce command verbosity'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l trust-tls-cert -d 'Trust peer certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -l overwrite -d 'Overwrite existing credential file if any'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from link" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l force -d 'Force destroy even if instance is referred to by a project'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from unlink" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s n -l tail -d 'Number of lines to show' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s f -l follow -d 'Show log tail and continue watching for new entries'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from logs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s I -l instance -d 'Instance to resize' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l tier -d 'Cloud instance subscription tier' -r -f -a "pro\t''
free\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l compute-size -d 'The size of compute to be allocated for the Cloud instance in Compute Units' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l storage-size -d 'The size of storage to be allocated for the Cloud instance in Gigabytes' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l non-interactive -d 'Do not ask questions'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from resize" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from backup" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l backup-id -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l source-instance -d 'Name of source instance to restore the backup from' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l latest
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l non-interactive -d 'Do not ask questions'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from restore" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l json -d 'Output in JSON format'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from list-backups" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l to-version -d 'Upgrade specified instance to a specified version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l to-channel -d 'Upgrade specified instance to latest version in the channel' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l to-latest -d 'Upgrade specified instance to latest /version'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l to-nightly -d 'Upgrade specified instance to latest nightly version'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l to-testing -d 'Upgrade specified instance to latest testing version'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s v -l verbose -d 'Verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l force -d 'Force upgrade even if there is no new version'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l force-dump-restore -d 'Force dump-restore during upgrade even if version is compatible'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l force-in-place -d 'Force in-place upgrade method for Cloud instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l non-interactive -d 'Do not ask questions. Assume user wants to upgrade instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from upgrade" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l ignore-pid-check -d 'Do not check if upgrade is in progress'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s y -l no-confirm -d 'Do not ask for confirmation'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from revert" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l user -d 'User to change password for (default obtained from credentials file)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l password -d 'Read password from the terminal rather than generating a new one'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l password-from-stdin -d 'Read password from stdin rather than generating a new one'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l save-credentials -d 'Save new user and password into a credentials file. By default credentials file is updated only if user name matches'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l no-save-credentials -d 'Do not save generated password into a credentials file even if user name matches'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l quiet -d 'Do not print any messages, only indicate success by exit status'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from reset-password" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l json -d 'Output in JSON format (password is included in cleartext)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -l insecure-dsn -d 'Output a DSN with password in cleartext'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from credentials" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "create" -d 'Initialize a new Gel instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "list" -d 'Show all instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "status" -d 'Show status of an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "start" -d 'Start an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "stop" -d 'Stop an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "restart" -d 'Restart an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "destroy" -d 'Destroy an instance and remove the data'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "link" -d 'Link to a remote Gel instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "unlink" -d 'Unlink from a remote Gel instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "logs" -d 'Show logs for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "resize" -d 'Resize an instance (Gel Cloud only)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "backup" -d 'Create a backup for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "restore" -d 'Restore an instance from a backup'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "list-backups" -d 'List backups for an instance'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "upgrade" -d 'Upgrade installations and instances'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "revert" -d 'Revert a major instance upgrade'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "reset-password" -d 'Generate new password for instance user (randomly generated by default)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "credentials" -d 'Display instance credentials (add --json for verbose)'
complete -c edgedb -n "__fish_edgedb_using_subcommand instance; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -f -a "info" -d 'Show locally installed server versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -f -a "install" -d 'Install a server version locally'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -f -a "uninstall" -d 'Uninstall a server version locally'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -f -a "list-versions" -d 'List available and installed versions of the server'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and not __fish_seen_subcommand_from info install uninstall list-versions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l version -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l channel -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l get -d 'Get specific value:' -r -f -a "bin-path\t''
version\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l bin-path -d 'Display only the server binary path (shortcut to --get bin-path)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l json -d 'Output in JSON format'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l latest
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l nightly
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from info" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l version -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l channel -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s i -l interactive
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l nightly
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l channel -d 'Uninstall only versions from a specific channel' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l all -d 'Uninstall all versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l unused -d 'Uninstall unused versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l nightly -d 'Uninstall nightly versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s v -l verbose -d 'Increase verbosity'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from uninstall" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l channel -d 'Show only versions for the specified channel' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l version -d 'Show only versions matching the specified version' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l column -d 'Single column output' -r -f -a "major-version\t''
installed\t''
available\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l installed-only
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l all -d 'Show all versions including older and non-stable channels'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l json -d 'Output in JSON format'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from list-versions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from help" -f -a "info" -d 'Show locally installed server versions'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from help" -f -a "install" -d 'Install a server version locally'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from help" -f -a "uninstall" -d 'Uninstall a server version locally'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from help" -f -a "list-versions" -d 'List available and installed versions of the server'
complete -c edgedb -n "__fish_edgedb_using_subcommand server; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -f -a "list" -d 'List installed extensions'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -f -a "list-available" -d 'List available extensions'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -f -a "install" -d 'Install an extension'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -f -a "uninstall" -d 'Uninstall an extension'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and not __fish_seen_subcommand_from list list-available install uninstall help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l channel -d 'Specify the channel override (stable, testing, or nightly)' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l slot -d 'Specify the slot override (for development use)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from list-available" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l channel -d 'Specify the channel override (stable, testing, or nightly)' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l slot -d 'Specify the slot override (for development use)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l reinstall -d 'Reinstall the extension if it\'s already installed'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from uninstall" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from help" -f -a "list" -d 'List installed extensions'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from help" -f -a "list-available" -d 'List available extensions'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from help" -f -a "install" -d 'Install an extension'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from help" -f -a "uninstall" -d 'Uninstall an extension'
complete -c edgedb -n "__fish_edgedb_using_subcommand extension; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l shell -d 'Shell to print out completions for' -r -f -a "bash\t''
elvish\t''
fish\t''
power-shell\t''
zsh\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l prefix -d 'Install all completions into the prefix' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l home -d 'Install all completions into the prefix'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand _gen_completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -f -a "upgrade" -d 'Upgrade the gel command-line tool'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -f -a "install" -d 'Install the gel command-line tool'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -f -a "init-wsl" -d 'Force WSL initialization'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and not __fish_seen_subcommand_from upgrade install init-wsl help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l to-channel -d 'Upgrade specified instance to specified channel' -r -f -a "stable\t''
testing\t''
nightly\t''"
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s v -l verbose -d 'Enable verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s q -l quiet -d 'Disable progress output'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l force -d 'Force reinstall even if no newer version exists'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l to-nightly -d 'Upgrade to latest nightly version'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l to-stable -d 'Upgrade to latest stable version'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l to-testing -d 'Upgrade to latest testing version'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from upgrade" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l installation-path -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l nightly
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l testing
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s v -l verbose -d 'Enable verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s q -l quiet -d 'Skip printing messages and confirmation prompts'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s y -d 'Disable confirmation prompt, also disables running project init'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l no-modify-path -d 'Do not configure PATH environment variable'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l no-wait-for-exit-prompt -d 'Indicate that gel-init should not issue a "Press Enter to continue" prompt before exiting on Windows. Used when gel-init is invoked from an existing terminal session and not in a new window'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l upgrade -d 'Installation is run from self upgrade command'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from init-wsl" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from help" -f -a "upgrade" -d 'Upgrade the gel command-line tool'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from help" -f -a "install" -d 'Install the gel command-line tool'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from help" -f -a "init-wsl" -d 'Force WSL initialization'
complete -c edgedb -n "__fish_edgedb_using_subcommand cli; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l installation-path -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l nightly
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l testing
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s v -l verbose -d 'Enable verbose output'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s q -l quiet -d 'Skip printing messages and confirmation prompts'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s y -d 'Disable confirmation prompt, also disables running project init'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l no-modify-path -d 'Do not configure PATH environment variable'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l no-wait-for-exit-prompt -d 'Indicate that gel-init should not issue a "Press Enter to continue" prompt before exiting on Windows. Used when gel-init is invoked from an existing terminal session and not in a new window'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l upgrade -d 'Installation is run from self upgrade command'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand _self_install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -f -a "login" -d 'Authenticate to EdgeDB Cloud and remember secret key locally'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -f -a "logout" -d 'Forget the stored access token'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -f -a "secretkey" -d 'Secret key management'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and not __fish_seen_subcommand_from login logout secretkey help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from login" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l all-profiles -d 'Log out from all Cloud profiles'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l force -d 'Force log out from all profiles, even if linked to a project'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l non-interactive -d 'Do not ask questions, assume user wants to log out of all profiles not linked to a project'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l cloud-api-endpoint -d 'Specify the API endpoint. Defaults to the current logged-in server, or <https://api.g.aws.edgedb.cloud> if unauthorized' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l cloud-secret-key -d 'Specify the API secret key to use instead of loading key from a remembered authentication' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l cloud-profile -d 'Specify the authenticated profile. Defaults to "default"' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -f -a "list" -d 'List existing secret keys'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -f -a "create" -d 'Create a new secret key'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -f -a "revoke" -d 'Revoke a secret key'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from secretkey" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from help" -f -a "login" -d 'Authenticate to EdgeDB Cloud and remember secret key locally'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from help" -f -a "logout" -d 'Forget the stored access token'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from help" -f -a "secretkey" -d 'Secret key management'
complete -c edgedb -n "__fish_edgedb_using_subcommand cloud; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l extend-gel-toml -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s m -l migrate -d 'Runs "BRANDING_CLI_CMD migration apply --dev-mode" on changes to schema definitions'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s s -l sync -d 'Runs "BRANDING_CLI_CMD sync" on changes to gel.local.toml'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s v -l verbose
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l no-exit-with-parent -d 'Do not exit when the parent process exits'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand watch" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s I -l instance -d 'Instance name (use gel instance list to list local, remote and Gel Cloud instances available to you)' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l container -d 'Connect to a specific docker container' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l dsn -d 'DSN for Gel to connect to (overrides all other options except password)' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l credentials-file -d 'Path to JSON file to read credentials from' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s H -l host -d 'Gel instance host' -r -f -a "(__fish_print_hostnames)"
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s P -l port -d 'Port to connect to Gel' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l unix-path -d 'A path to a Unix socket for Gel connection' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s u -l user -d 'Gel user name' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s d -l database -d 'Database name to connect to' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s b -l branch -d 'Branch to connect with' -r -f
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l secret-key -d 'Secret key to authenticate with' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l tls-ca-file -d 'Certificate to match server against' -r -F
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l tls-security -d 'Specifications for client-side TLS security mode:' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l tls-server-name -d 'Override server name used for TLS connections and certificate verification' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l wait-until-available -d 'Retry up to WAIT_TIME (e.g. \'30s\') in case Gel connection cannot be established' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l connect-timeout -d 'Fail when no response from Gel for TIMEOUT (default \'10s\'); alternatively will retry if --wait-until-available is also specified' -r
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l docker -d 'Connect to a docker instance. If docker-compose.yaml is present, the instance will be automatically detected. Otherwise, --container must be specified'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l password -d 'Ask for password on terminal (TTY)'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l no-password -d 'Don\'t ask for password'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l password-from-stdin -d 'Read password from stdin rather than TTY (useful for scripts)'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l tls-verify-hostname -d 'Verify server hostname using provided certificate'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l no-tls-verify-hostname -d 'Do not verify server hostname'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -l admin -d 'Connect to a passwordless Unix socket with superuser privileges by default'
complete -c edgedb -n "__fish_edgedb_using_subcommand hash-password" -s h -l help -d 'Print help (see more with \'--help\')'
