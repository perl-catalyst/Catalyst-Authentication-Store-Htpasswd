#!/usr/bin/perl

package Catalyst::Authentication::Store::Htpasswd;
use base qw/Class::Accessor::Fast/;
use strict;
use warnings;

use Authen::Htpasswd;
use Catalyst::Authentication::Store::Htpasswd::User;
use Scalar::Util qw/blessed/;

our $VERSION = '1.000';

BEGIN { __PACKAGE__->mk_accessors(qw/file/) }

sub new {
    my ($class, $config, $app, $realm) = @_;
    
    my $file = delete $config->{file};
    unless (ref $file) { # FIXME - file not in app..
        my $filename = $app->path_to($file)->stringify;
        die("Cannot find htpasswd file: $filename\n") unless (-r $filename);
        $file = Authen::Htpasswd->new($filename);
    }
    $config->{file} = $file;
    
    bless { %$config }, $class;
}

sub find_user {
    my ($self, $authinfo, $c) = @_;
    # FIXME - change username
    my $htpasswd_user = $self->file->lookup_user($authinfo->{username});
    Catalyst::Authentication::Store::Htpasswd::User->new( $self, $htpasswd_user );
}

sub user_supports {
    my $self = shift;

    # this can work as a class method
    Catalyst::Authentication::Store::Htpasswd::User->supports(@_);
}

sub from_session {
	my ( $self, $c, $id ) = @_;
	$self->find_user( { username => $id } );
}

1;

__END__

=pod

=head1 NAME

Catalyst::Authentication::Store::Htpasswd - L<Authen::Htpasswd> based
user storage/authentication.

=head1 SYNOPSIS

    use Catalyst qw/
      Authentication
    /;

    __PACKAGE__->config(
        authentication => {
            default_realm => 'test',
            realms => {
                test => {
                    credential => {
                        class          => 'Password',
                        password_field => 'password',
                        password_type  => 'self_check',
                    },
                    store => {
                        class => 'Htpasswd',
                        file => 'htpasswd',
                    },
                },
            },
        },   
    );

    sub login : Global {
        my ( $self, $c ) = @_;

        $c->authenticate({ username => $c->req->param("login"), password => $c->req->param("password") });
    }

=head1 DESCRIPTION

This plugin uses C<Authen::Htpasswd> to let your application use C<.htpasswd>
files for it's authentication storage.

=head1 METHODS

=head2 new

Simple constructor, dies if the htpassword file can't be found

=head2 find_user

Looks up the user, and returns a Catalyst::Authentication::Store::Htpasswd::User object.

=head2 user_supports

Delegates to L<Catalyst::Authentication::Store::Htpasswd::User->user_supports|Catalyst::Authentication::Store::Htpasswd::User#user_supports>

=head2 from_session

Delegates the user lookup to C< find_user >

=head1 CONFIGURATION

=head2 file

The path to the htpasswd file, this is taken from the application root.

=head1 AUTHORS

Yuval Kogman C<nothingmuch@woobling.org>

David Kamholz C<dkamholz@cpan.org>

Tomas Doran C<bobtfish@bobtfish.net>

=head1 SEE ALSO

L<Authen::Htpasswd>.

=head1 COPYRIGHT & LICENSE

	Copyright (c) 2005-2008 the aforementioned authors. All rights
	reserved. This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.

=cut


