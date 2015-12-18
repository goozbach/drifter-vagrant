#!/usr/bin/env perl
package Drifter::Box;

use strict;
use warnings;

use Moo;
use namespace::clean;
use Drifter::Box::Version;
use Drifter::Types -all;

# ABSTRACT: A perl object class for managing Vagrant box metadata 

=head1 SYNOPSIS

Create new Vagrant box metadata

    my $obj = Drifter::Box->new(
        filename => '/some/filename',
        name     => 'foo',
        description => 'The foo vagrant box',
        short_description => 'foo box',
        versions => [ $arrayref_of_drifter_box_version_objects ],
    );
    $obj->write();

or read an existing Vagrant box metadata

    my $obj2 = Drifter::Box->new('/some/other/filename');
    my $versions = $obj2->versions();

=cut

=for Pod::Coverage BUILDARGS

=cut 
sub BUILDARGS {
    my $class = shift;

    if ( @_ == 1 && ! ref $_[0] ) {
        return { filename => $_[0] };
    }
    return $class->SUPER::BUILDARGS(@_);
    
}

=method filename()

Returns value of read-only 'filename' attribute

=cut

has filename => (
    is => 'ro',
    required => 1
);

=method name()

Set or return the 'name' attribute

    $obj->name('bar');       # set attribute
    my $name = $obj->name(); # return attribute

=cut

has name => (
    is => 'rw',
    isa => Str,
);

=method description()

Set or return the 'description' attribute

    $obj->description('bar vagrant box');  # set attribute
    my $description = $obj->description(); # return attribute

=cut

has description => (
    is => 'rw',
    isa => Str,
);

=method short_description()

Set or return the 'short_description' attribute

    $obj->short_description('bar vagrant box'); # set attribute
    my $shortdesc = $obj->short_description();        # return attribute

=cut

has short_description => (
    is => 'rw',
    isa => Str,
);

=method versions()

Set or return the 'versions' attribute

    my $versions = $obj->versions(); # return attribute

Although you can do this, you probabally want to use L</"add_version">
method instead.  Takes an arrayref of L<Drifter::Box::Version> objects.

    $obj->($version_arrayref); # set attribute

=cut

has versions => (
    is => 'rw',
    isa => ArrayOfDrifterVersions,
    default => sub { []; },
);

=method add_version()

Push a L<Drifter::Box::Version> object to the 'versions' attribute array.

    my $vers = Drifter::Box::Version->new(
        version => '2.0.0',
        description => 'foob 2.0.0',
        providers => [ $prov, ],
    );
    $obj->add_version($vers);

=cut

sub add_version {
    my $self = shift;
    my $myversion = shift;
    push($self->versions, $myversion);
}

1;
