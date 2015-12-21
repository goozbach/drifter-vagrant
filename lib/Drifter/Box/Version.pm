package Drifter::Box::Version;

use Moo;
use strict;
use warnings;
use namespace::clean;
use Drifter::Types -all;
use Drifter::Box::Version::Provider;
use List::MoreUtils qw(natatime);

=for Pod::Coverage BUILDARGS
=cut

sub BUILDARGS {
    my ($class, @args) = @_;

    my $itr = natatime 2, @args;

    print "building vers obj with:\n";
    while (my ($key, $val) = $itr->()) {
        # do my fixing of description keys here
        print "\t$key, $val\n";
    }
    
    return { @args };
}

# ABSTRACT: A perl object class for managing Vagrant box version metadata 

=head1 SYNOPSIS

Sub-object for L<Drifter::Box> object

    my $vers2 = Drifter::Box::Version->new(
        version => '1.0.0',
        description => 'foob 1.0.0',
        providers => [ $prov, ],
    );

=cut

=method version()

Version string

    $obj->version('0.0.1');  # set attribute
    my $vers = $obj->version(); # return attribute

=cut

has version => (
    is => 'rw',
);

=method providers()

Arrayref of L<Drifter::Box::Version::Provider> objects.

    my $vers = $obj->version(); # return attribute

Although you can do this, you probabally want to use L</"add_provider">
method instead.  Takes an arrayref of L<Drifter::Box::Version::Provider> objects.

    $obj->providers($arrayref_of_providers); # set attribute

=cut

has providers => (
    is => 'rw',
    isa => ArrayOfDrifterProviders,
    default => sub { []; },
);

=method status()

Status of the Version sub-object, is one of 'active' or 'inactive'

    $obj->status('active');      # set attribute
    my $status = $obj->status(); # return attribute

=cut

has status => (
    is => 'rw',
    default => sub { 'active' },
    isa => sub {
        die "only 'active' or 'inactive' are allowed as a status" unless $_[0] =~ /^(active|inactive)$/i;
    },
);

has _description => (
    is => 'rw',
    isa => Dict[raw=> Optional[Str], markdown=>Optional[Str], html=>Optional[Str]],
);

# TODO add methods for description, description_html, and description_markdown

=method description

Returns or sets the raw description

    my $desc = $obj->description()
    $obj->description('version 1.0.0 of blarg vagrant box');

=cut

sub description {
    my $self = shift;
    if (@_) {
        $self->_description->{'raw'} = shift;
    }
    return $self->_description->{'raw'};
}

=method add_provider

Push a L<Drifter::Box::Version::Provider> to the 'providers' array.

    my $prov = Drifter::Box::Version::Provider->new(
        name => 'virtualbox',
        url  => 'http://example.com/blarg/virtualbox/1.0.0.box',
        checksum_type => 'sha256',
        checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    );
    $vers->add_provider($prov);

=cut

sub add_provider {
    my $self = shift;
    # todo check arg is a provider object
    print "Adding provider for $_\n";
}

1;
