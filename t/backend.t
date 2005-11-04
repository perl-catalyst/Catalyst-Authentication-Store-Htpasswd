#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Path::Class;

use File::Temp qw/tempfile/;

my $m; BEGIN { use_ok($m = "Catalyst::Plugin::Authentication::Store::Htpasswd::Backend") }

(undef, my $tmp) = tempfile();

my $passwd = Apache::Htpasswd->new({ passwdFile => "$tmp" });

$passwd->htpasswd("user", "s3cr3t");


can_ok($m, "new");
isa_ok(my $o = $m->new( $passwd ), $m);

can_ok($m, "file");
isa_ok( $o->file, "Apache::Htpasswd");


can_ok( $m, "user_supports");
ok( $m->user_supports(qw/password self_check/), "user_supports self check" );

can_ok($m, "get_user");
isa_ok( my $u = $o->get_user("user"), "Catalyst::Plugin::Authentication::Store::Htpasswd::User");
isa_ok( $u, "Catalyst::Plugin::Authentication::User");

can_ok( $u, "supports");
ok( $u->supports(qw/password self_check/), "htpasswd users check their own passwords");

can_ok( $u, "check_password");
ok( $u->check_password( "s3cr3t" ), "password is s3cr3t");


