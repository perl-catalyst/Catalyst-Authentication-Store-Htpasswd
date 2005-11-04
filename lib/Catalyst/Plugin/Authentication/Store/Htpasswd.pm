#!/usr/bin/perl

package Catalyst::Plugin::Authentication::Store::Htpasswd;

use strict;
use warnings;

use Catalyst::Plugin::Authentication::Store::Htpasswd::Backend;

sub setup {
    my $c = shift;

    $c->default_auth_store(
        Catalyst::Plugin::Authentication::Store::Htpasswd::Backend->new(
            $c->config->{authentication}{htpasswd}
        )
    );

	$c->NEXT::setup(@_);
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Plugin::Authentication::Store::Htpasswd - Authentication
database in C<<$c->config>>.

=head1 SYNOPSIS

    use Catalyst qw/
      Authentication
      Authentication::Store::Htpasswd
      Authentication::Credential::Password
      /;

    __PACKAGE__->config->{authentication}{htpasswd} = "...";

    sub login : Global {
        my ( $self, $c ) = @_;

        $c->login( $c->req->param("login"), $c->req->param("password"), );
    }

=head1 DESCRIPTION

This plugin uses C<Apache::Htpasswd> to let your application use C<.htpasswd>
files for it's authentication storage.

=head1 METHODS

=over 4

=item setup

This method will popultate C<< $c->config->{authentication}{store} >> so that
L<Catalyst::Plugin::Authentication/default_auth_store> can use it.

=back

=head1 CONFIGURATION

=over 4

=item $c->config->{authentication}{htpasswd}

The path to the htpasswd file.

=back

=cut


