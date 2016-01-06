package Drifter::Box::Version;

use Moo;
use strict;
use warnings;
use namespace::clean;
use Drifter::Types -all;
use Types::URI -all;
use Drifter::Box::Version::Provider;
use List::MoreUtils qw(natatime);

use Data::Dumper;

=for Pod::Coverage BUILDARGS
=cut

my $verbose;

sub BUILDARGS {
    my ($class, @args) = @_;

    my @intargs;

    my $intdesc = {};
    my $itr = natatime 2, @args;

    print "building vers obj with:\n" if $verbose;
    while (my ($key, $val) = $itr->()) {
        # do my fixing of description keys here
        print "\t$key, $val\n" if $verbose;
        if ($key eq 'description'){
          $intdesc->{'raw'} = $val;
        } elsif ($key eq 'description_html') {
          $intdesc->{'html'} = $val;
        } elsif ($key eq 'description_mark'){
          $intdesc->{'markdown'} = $val;
        } else {
          push (@intargs, ($key, $val));
        }
    }
    push (@intargs, ('_description', $intdesc));
    
    return { @intargs };
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

=method description

Returns or sets the raw description

    my $desc = $obj->description()
    $obj->description('version 1.0.0 of blarg vagrant box');

=cut

sub description {
    my $self = shift;
    print "I'm in description $self" if $verbose;
    print Dumper $self if $verbose;
    if (@_) {
        $self->{_description}{'raw'} = shift;
    }
    return $self->{_description}{'raw'};
}

=method description_html

Returns or sets the html description

    my $desc = $obj->description_html()
    $obj->description('<h1>version 1.0.0 of blarg vagrant box</h1>');

=cut

sub description_html {
    my $self = shift;
    print "I'm in description_html $self" if $verbose;
    print Dumper $self if $verbose;
    if (@_) {
        $self->{_description}{'html'} = shift;
    }
    return $self->{_description}{'html'};
}

=method description_markdown

Returns or sets the markdown description

    my $desc = $obj->description_markdown()
    $obj->description_markdown('#version 1.0.0 of blarg vagrant box');

=cut

sub description_markdown {
    my $self = shift;
    print "I'm in description markdown $self" if $verbose;
    print Dumper $self if $verbose;
    if (@_) {
        $self->{_description}{'markdown'} = shift;
    }
    return $self->{_description}{'markdown'};
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
    my $prov = shift;

    unless ($prov->isa('Drifter::Box::Version::Provider')) {
        die "add_provder error: not a Drifter::Box::Version::Provider reference or object";
    }
    push(@{$self->providers}, $prov);
}

1;
