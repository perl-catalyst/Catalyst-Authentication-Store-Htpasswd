#!/usr/bin/perl

package Catalyst::Plugin::Authentication::Store::Htpasswd::User;
use base qw/Catalyst::Plugin::Authentication::User Class::Accessor::Fast/;

use strict;
use warnings;

BEGIN { __PACKAGE__->mk_accessors(qw/file name/) }

sub new {
	my ( $class, $name, $file ) = @_;

	bless {
		name => $name,
		file => $file,
	}, $class;
}

sub supported_features {
	return {
		password => {
			self_check => 1,
		}
	};
}

sub check_password {
	my ( $self, $password ) = @_;

	return $self->file->htCheckPassword( $self->name, $password );
}

sub roles {
	my $self = shift;
	split( ",", $self->info_string );
}

sub info_string {
	my $self = shift;
	$self->file->fetchInfo( $self->name );
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


