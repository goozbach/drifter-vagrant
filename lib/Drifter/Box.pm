package Drifter::Box;

use Moo;
use strict;
use warnings;
use namespace::clean;
use Drifter::Box::Version;
use Drifter::Types -all;

sub BUILDARGS {
    my $class = shift;

    if ( @_ == 1 && ! ref $_[0] ) {
        return { filename => $_[0] };
    }
    return $class->SUPER::BUILDARGS(@_);
    
}

has filename => (
    is => 'ro',
    required => 1
);

has name => (
    is => 'rw',
    isa => Str,
);

has description => (
    is => 'rw',
    isa => Str,
);

has short_description => (
    is => 'rw',
    isa => Str,
);

has versions => (
    is => 'rw',
    isa => ArrayOfDrifterVersions,
    default => sub { []; },
);

sub add_version {
    my $self = shift;
    my $myversion = shift;
    push($self->versions, $myversion);
}

1;
