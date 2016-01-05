package Drifter::Box::Version::Provider;

use Moo;
use strict;
use warnings;
use namespace::clean;
use Drifter::Types -all;
use Types::URI -all;

# ABSTRACT: A perl object class for managing Vagrant box version metadata 
#
=head1 SYNOPSIS

Sub-object for L<Drifter::Box::Version> object

    my $prov = Drifter::Box::Version::Provider->new(
        name => 'virtualbox',
        url  => URI->new('http://example.com/blarg/virtualbox/1.0.0.box'),
        # or url  => 'http://example.com/blarg/virtualbox/1.0.0.box',
        checksum_type => 'sha256',
        checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    );

=cut

=method name()

Set or read the name attribute

    my $name = $prov->name();
    $prov->name('virtualbox');

=cut

has name => (
    is => 'rw',
    isa => Str,
    required => 1,
    #TODO? make a constraint to limit providers?
);

=method url()

Set or read the url attribute

    my $url = $prov->url();
    $prov->url(URI->new('http://www.example.com/version/1.2.3/virtualbox/foo.box'));

=cut

has url => (
    is => 'rw',
    isa => Uri,
    coerce => 1,
    required => 1,
);

=method checksum_type()

Set or read the checksum_type attribute

    my $type = $prov->checksum_type();
    $prov->checksum_type('sha512');

Checksum type should be one of the L<Crypt::Digest#FUNCTIONS>
functions that Vagrant supports.

=cut

has checksum_type => (
    is => 'rw',
    required => 1,
    default => sub { 'sha1' },
);

=method checksum()

Set or read the checksum attribute

    my $sum = $prov->checksum();
    $prov->checksum('cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e');

Checksum type should be one of the L<Crypt::Digest#FUNCTIONS>
functions that Vagrant supports.

=cut

has checksum => (
    is => 'rw',
    required => 1,
);

=method uriroot

Set or return the 'uriroot' attribute

    my $uriroot = $obj->uriroot(); # return attribute
    $obj->uriroot('http://example.com/drifter/'); # set attribute

=cut

has uriroot =>(
    is => 'rw',
    isa => Uri,
);

=method parent()

Optional

A reference to the parent object which contains this provider

Should only be set once

=cut
has _parentset => (
    is => 'rw',
    isa => Bool,
    default => sub { 0; },
);

has _parent => (
    is => 'rw',
);

sub parent {
    my $self = shift;

    if (@_) {
      if ($self->{_parentset}) {
        die "unable to change read-only 'parent' attribute";
      } else {
        $self->{_parent} = shift;
        $self->{_parentset} = 1;
      }
    }
    return $self->{_parent};
}

=method update_checksum()

Update the checksum of the provider file

    $prov->update_checksum(TYPE)

TYPE should be one of the L<Crypt::Digest#FUNCTIONS>
functions that Vagrant supports.

=cut

sub update_checksum {
    my $self = shift;
    my $checktype = shift;
    print "update checksum with type $checktype\n";
    #TODO
}

1;
