#!/usr/bin/perl

package Catalyst::Plugin::Authentication::Store::Htpasswd::User;
use base qw/Catalyst::Plugin::Authentication::User Class::Accessor::Fast/;

use strict;
use warnings;

BEGIN { __PACKAGE__->mk_accessors(qw/user/) }

use overload '""' => sub { shift->user->username };

sub new {
	my ( $class, $user ) = @_;

	bless { user => $user }, $class;
}

sub supported_features {
	return {
		password => {
			self_check => 1,
		},
		session => 1
	};
}

sub check_password {
	my ( $self, $password ) = @_;

	return $self->user->check_password( $password );
}

sub roles {
	my $self = shift;
	split( ",", $self->user->extra_info );
}

sub for_session {
    my $self = shift;
    return $self->user->username;
}

sub from_session {
    my ($class,$c,$user) = @_;
    return $user;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Plugin::Authentication::Store::Htpasswd::User - A user object
representing an entry in an htpasswd file.

=head1 SYNOPSIS

	use Catalyst::Plugin::Authentication::Store::Htpasswd::User;

=head1 DESCRIPTION

=cut


