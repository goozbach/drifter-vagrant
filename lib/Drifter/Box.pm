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
);

has description => (
    is => 'rw',
);

has versions => (
    is => 'rw',
    isa => ArrayOfDrifterVersions,
    default => sub { []; },
);

sub load_from_file {
    my $self = shift;
    my $filename = shift;
    print "loading from file $filename\n";
}

sub add_version {
    my $self = shift;
    my $boxfile = shift;
    print "adding version of $boxfile\n";
    my $newvers = Drifter::Box::Version->new();
    push($self->versions, $newvers);
}

sub list_versions {
    my $self = shift;
    print "listing versions in $self\n";
}

1;
