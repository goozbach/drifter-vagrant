#!/usr/bin/perl
use Test::More tests => 10;

BEGIN {
  use_ok('Drifter::Box::Version');
  use_ok('Drifter::Box::Version::Provider');
};
use strict;
use warnings;

my $prov = Drifter::Box::Version::Provider->new(
    name => 'virtualbox',
    url  => URI->new('http://example.com/blarg/virtualbox/1.0.0.box'),
    checksum_type => 'sha256',
    checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
);

isa_ok( $prov, 'Drifter::Box::Version::Provider', 'provider object');

my $vers = Drifter::Box::Version->new(
    version => '1.0.0',
    description => 'blarg 1.0.0',
    providers => [ $prov, ],
);

isa_ok( $vers, 'Drifter::Box::Version', 'version object');

is( $vers->status, 'active', 'status auto-set to active');

$vers->status('inactive');

is( $vers->status, 'inactive', 'status changed to inactive');

my $vers2 = Drifter::Box::Version->new(
    version => '1.0.0',
    description => 'blarg 1.0.0',
    providers => [ $prov, ],
    status => 'inactive',
);

isa_ok( $vers2, 'Drifter::Box::Version', 'version object');

is( $vers2->status, 'inactive', 'status set to inactive on new()');

ok(!eval{$vers2->status('flarg')},'trying to set invalid on status');
ok(!eval{
    my $vers3 = Drifter::Box::Version->new(
        version => '1.0.0',
        description => 'blarg 1.0.0',
        providers => [ $prov, ],
        status => 'blarg',
    );
  }, 'trying to set invalid status on new()');


