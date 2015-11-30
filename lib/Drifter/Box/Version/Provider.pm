package Drifter::Box::Version::Provider;

use Moo;
use strict;
use warnings;
use namespace::clean;
use Drifter::Types -all;
use Types::URI -all;

has name => (
    is => 'rw',
    isa => Str,
    required => 1,
);

has url => (
    is => 'rw',
    # TODO figure this out; isa => URI,
    #coerce => 1,
    required => 1,
);

has checksum_type => (
    is => 'rw',
    required => 1,
    default => sub { 'sha1' },
);

has checksum => (
    is => 'rw',
    required => 1,
);

1;
