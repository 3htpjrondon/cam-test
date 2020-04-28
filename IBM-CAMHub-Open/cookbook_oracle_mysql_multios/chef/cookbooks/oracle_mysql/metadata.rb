name             'oracle_mysql'
maintainer       'IBM Corp'
maintainer_email ''
license          'Copyright IBM Corp. 2016, 2018'
issues_url   'https://github.com/IBM-CAMHub-Open/cookbook_oracle_mysql_multios/issues'
source_url   'https://github.com/IBM-CAMHub-Open/cookbook_oracle_mysql_multios'
chef_version '>= 12.5' if respond_to?(:chef_version)
description      'Installs/Configure Oracle MySQL'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.0'
supports 'ubuntu', '>= 14.04'
supports 'ubuntu', '>= 16.04'
supports 'redhat', '>= 6.5'
supports 'redhat', '>= 7.0'

depends 'ibm_cloud_utils'
attribute 'mysql/config/data_dir',
          :default => '/var/lib/mysql',
          :description => 'Directory to store information managed by MySQL server',
          :displayname => 'MySQL Data Directory',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/databases/database_1/database_name',
          :default => 'MyDB',
          :description => 'Create a sample database in MySQL',
          :displayname => 'Sample Database Name',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/databases/database_1/users/user_1/name',
          :default => 'defaultUser',
          :description => 'Name of the first user which is created and allowed to access the created sample database ',
          :displayname => 'First User Name to Access the Sample Database',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/databases/database_1/users/user_1/password',
          :default => '',
          :description => 'Password of the first user',
          :displayname => 'First User Password to Access the Sample Database',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :regex => '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}$',
          :regexdesc => 'Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character from supported list "$@$!%*?&".',
          :required => 'recommended',
          :secret => 'true',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/databases/database_1/users/user_2/name',
          :default => 'defaultUser2',
          :description => 'Name of the second user which is created and allowed to access the created sample database',
          :displayname => 'Second User Name to Access the Sample Database',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/databases/database_1/users/user_2/password',
          :default => '',
          :description => 'Password of the second user',
          :displayname => 'Second User Password to Access the Sample Database',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :regex => '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}$',
          :regexdesc => 'Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character from supported list "$@$!%*?&".',
          :required => 'recommended',
          :secret => 'true',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/engine',
          :default => 'InnoDB',
          :description => 'MySQL database engine',
          :displayname => 'MySQL engine',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/key_buffer_size',
          :default => '16M',
          :description => 'Mysql key buffer size',
          :displayname => 'mysql_key_buffer_size',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/log_file',
          :default => '/var/log/mysqld.log',
          :description => 'Log file configured in MySQL',
          :displayname => 'MySQL Log File',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/max_allowed_packet',
          :default => '8M',
          :description => 'Mysql key buffer size',
          :displayname => 'mysql_max_allowed_packet',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/pid',
          :default => '/var/run/mysqld/mysqld.pid',
          :description => 'MySQL pid file',
          :displayname => 'mysql_pid_file',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/port',
          :default => '3306',
          :description => 'Listen port to be configured in MySQL',
          :displayname => 'MySQL listen port',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/config/socket',
          :default => '/var/run/mysqld/mysql.sock',
          :description => 'MySQL socket',
          :displayname => 'mysql_socket',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/install_from_repo',
          :choice => ['true', 'false'],
          :default => 'true',
          :description => 'Install MySQL from secure repository server or yum repo',
          :displayname => 'Install MySQL from Secure Repository',
          :immutable_after_create => 'true',
          :options => ['true', 'false'],
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/os_users/daemon/comment',
          :default => 'MySQL instance owner',
          :description => 'Comment associated with the MySQL OS user',
          :displayname => 'MySQL OS user description',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/os_users/daemon/gid',
          :default => 'mysql',
          :description => 'Group ID of the default OS user to be used to configure MySQL',
          :displayname => 'Group Name of Default OS User for MySQL',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/os_users/daemon/home',
          :default => '/home/mysql',
          :description => 'Home directory of the default OS user to be used to configure MySQL',
          :displayname => 'Home Directory of Default OS User for MySQL',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/os_users/daemon/ldap_user',
          :choice => ['true', 'false'],
          :default => 'false',
          :description => 'A flag which indicates whether to create the MQ USer locally, or utilise an LDAP based user.',
          :displayname => 'Use LDAP for Authentication',
          :immutable_after_create => 'true',
          :options => ['true', 'false'],
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/os_users/daemon/name',
          :default => 'mysql',
          :description => 'User Name of the default OS user to be used to configure MySQL',
          :displayname => 'User Name of Default OS User for MySQL',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/os_users/daemon/shell',
          :default => '/bin/bash',
          :description => 'Default shell configured on Linux server',
          :displayname => 'OS User Shell',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/root_password',
          :default => '',
          :description => 'The password for the MySQL root user',
          :displayname => 'MySQL root password',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :regex => '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}$',
          :regexdesc => 'Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character from supported list "$@$!%*?&".',
          :required => 'recommended',
          :secret => 'true',
          :selectable => 'true',
          :type => 'string'
attribute 'mysql/version',
          :default => '5.7.17',
          :description => 'MySQL Version to be installed',
          :displayname => 'MySQL Version',
          :immutable_after_create => 'true',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'true',
          :type => 'string'
recipe 'oracle_mysql::cleanup.rb', '
Cleanup recipe (cleanup.rb)
This recipe will remove any temporary installation files created as part of the automation.
'
recipe 'oracle_mysql::config_mysql.rb', '
Installation recipe (install.rb)
This recipe performs the product installation.
'
recipe 'oracle_mysql::default.rb', '
Default recipe (default.rb)
The default recipe for the cookbook. It is recommended to not use the default recipe, but explicitly specify a run_list for the deployment node.
'
recipe 'oracle_mysql::fixpack.rb', '
Fixpack recipe (fixpack.rb)
This recipe performs product fixpack installation.
'
recipe 'oracle_mysql::gather_evidence.rb', '
Evidence gathering recipe (gather_evidence.rb)
This recipe will collect functional product information and store it in an archive.
'
recipe 'oracle_mysql::harden.rb', '
Product hardening recipe (harden.rb)
This recipe performs security hardening tasks.
This custom resource changes the default MySQL root password
'
recipe 'oracle_mysql::install.rb', '
Installation recipe (install.rb)
This recipe performs the product installation.
'
recipe 'oracle_mysql::prereq.rb', '
Prerequisite recipe (prereq.rb)
This recipe configures the operating prerequisites for the product.
Archive names for RHEL6/7 and version separation
'
recipe 'oracle_mysql::service.rb', '
Service control recipe (service.rb)
Enable and start the MySQL service
'
