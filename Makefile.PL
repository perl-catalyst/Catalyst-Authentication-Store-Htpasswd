use strict;
use inc::Module::Install;

name 'Catalyst-Authenticaton-Store-Htpasswd';
all_from 'lib/Catalyst/Authentication/Store/Htpasswd.pm';

requires 'Catalyst::Plugin::Authentication' => '0.10006';
requires 'Authen::Htpasswd' => '0.13';
requires 'Class::Accessor::Fast';
requires 'Crypt::PasswdMD5';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::use::ok';

WriteAll;  
