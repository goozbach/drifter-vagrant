package Drifter::Box::Version;

use Moo;
use strict;
use warnings;
use namespace::clean;
use Drifter::Types -all;
use Drifter::Box::Version::Provider;

has version => (
    is => 'rw',
);

has providers => (
    is => 'rw',
    isa => ArrayOfDrifterProviders,
    default => sub { []; },
);

has status => (
    is => 'rw',
    isa => Str,
    default => sub { 'active' },
    # TODO add inactive/active contstraint
);

has description => (
    is => 'rw',
    isa => Hash,
);

sub add_provider {
    my $self = shift;
    print "Adding provider for $_\n";
}

1;
