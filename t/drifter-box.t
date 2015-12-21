#!/usr/bin/perl
use Test::More tests => 16;
BEGIN {
  use_ok('Drifter::Box');
  use_ok('Drifter::Box::Version');
  use_ok('Drifter::Box::Version::Provider');
};

use strict;
use warnings;

use URI;
use File::Temp;
my $fh = File::Temp->new();
my $fh2 = File::Temp->new();

$fh->unlink_on_destroy( 1 );
$fh2->unlink_on_destroy( 1 );

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

my $obj = Drifter::Box->new(
    filename => $fh->filename(),
    name     => 'blarg',
    description => 'The blarg vagrant box',
    short_description => 'blarg',
    versions => [ $vers ],
);

isa_ok ( $obj, 'Drifter::Box', 'box object ' );

is ( $obj->filename(), $fh->filename(), 'obj filename set original');

# test loading from file
my $obj2 = Drifter::Box->new($fh2->filename);

isa_ok ( $obj2, 'Drifter::Box', 'build from filename' );

is ( $obj2->filename(), $fh2->filename(), 'obj2 filename set');

is ( $obj->name(), 'blarg', 'obj name set to blarg');

ok(!eval{$obj2->filename($fh->filename)},'RO test for filename attribute');

# verify change name
$obj->name('foob');

is ( $obj->name(), 'foob', 'obj name set to foob');

# verify obj->description change
$obj->description('the foob vagrant box');
is($obj->description(), 'the foob vagrant box', 'change description');

# verify obj->short_description change
$obj->short_description('foob');
is($obj->short_description(), 'foob', 'change short_description');


# verify obj->versions change
my $start_vers = scalar @{ $obj->versions() };

can_ok($obj, 'add_version');

my $prov2 = Drifter::Box::Version::Provider->new(
    name => 'virtualbox',
    url  => 'http://example.com/blarg/virtualbox/1.0.0.box',
    checksum_type => 'sha256',
    checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
);

my $vers2 = Drifter::Box::Version->new(
    version => '2.0.0',
    description => 'foob 2.0.0',
    providers => [ $prov2, ],
);

$obj->add_version($vers2);

my $end_vers = scalar @{ $obj->versions() };

is ($start_vers + 1, $end_vers, 'number of versions increased');

TODO: {
    local $TODO = "not yet built";
};

1;
__END__
