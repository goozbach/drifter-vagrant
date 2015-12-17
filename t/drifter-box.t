#!/usr/bin/perl
use Test::More tests => 8;
BEGIN { use_ok('Drifter::Box') };

use File::Temp qw(tempfile);

use Drifter::Box;
use Drifter::Box::Version;
use Drifter::Box::Version::Provider;

my $fh = File::Temp->new();

$fh->unlink_on_destroy( 1 );

my $prov = Drifter::Box::Version::Provider->new(
    name => 'virtualbox',
    url  => 'http://example.com/blarg/virtualbox/1.0.0.box',
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
    filename => $filename,
    name     => 'blarg',
    description => 'The blarg vagrant box',
    short_description => 'blarg',
    versions => [ $vers ],
);

isa_ok ( $obj, Drifter::Box, 'box object ' );

TODO: {
    local $TODO = "not yet built";
    can_ok($obj, 'load_from_file');
    can_ok($obj, 'add_version');
    can_ok($obj, 'get_versions');
    can_ok($obj, 'get_versions');
};

1;
__END__
