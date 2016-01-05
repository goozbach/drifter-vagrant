#!/usr/bin/perl
use Test::More tests => 20;
use Scalar::Util 'refaddr';

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

$prov->parent(\$vers);

is($prov->parent(), \$vers, 'parent and original match') or diag ("first: $prov->parent(), vers: $vers");

isa_ok( $vers, 'Drifter::Box::Version', 'version object');

is( $vers->status, 'active', 'status auto-set to active');

$vers->status('inactive');

is( $vers->status, 'inactive', 'status changed to inactive');

my $vers2 = Drifter::Box::Version->new(
    version => '1.0.0',
    description => 'blarg 1.0.0',
    description_html => '<h1>blarg 1.0.0</h1>',
    description_mark => '#blarg 1.0.0',
    providers => [ $prov, ],
    status => 'inactive',
);

ok(!eval{$prov->parent(\$vers2)},'trying to set already set parent');

isa_ok( $vers2, 'Drifter::Box::Version', 'version object');

is( $vers2->status, 'inactive', 'status set to inactive on new()');

# description getters

my $desc2 = $vers2->description();
is( $desc2, 'blarg 1.0.0', 'raw description get' ) or diag explain $desc2;

my $desc3 = $vers2->description_html();
is( $desc3, '<h1>blarg 1.0.0</h1>', 'html description get' ) or diag explain $desc3;

my $desc4 = $vers2->description_markdown();
is( $desc4, '#blarg 1.0.0', 'markdown description get' ) or diag explain $desc4;

# description setters

$vers2->description('floob 1.0.0');
is( $vers2->description(), 'floob 1.0.0', 'raw description set' ) or diag explain $vers2->description();

$vers2->description_html('<h1>floob 1.0.0</h1>');
is( $vers2->description_html(), '<h1>floob 1.0.0</h1>', 'html description set' ) or diag explain $vers2->description_html();

$vers2->description_markdown('#floob 1.0.0');
is( $vers2->description_markdown(), '#floob 1.0.0', 'markdown description set' ) or diag explain $vers2->description_markdown();

# invalid setting tests

ok(!eval{$vers2->status('flarg')},'trying to set invalid on status');
ok(!eval{
    my $vers3 = Drifter::Box::Version->new(
        version => '1.0.0',
        description => 'blarg 1.0.0',
        providers => [ $prov, ],
        status => 'blarg',
    );
  }, 'trying to set invalid status on new()');


# add provider check
can_ok($vers2, 'add_provider');

my $start_provs = scalar @{ $vers2->providers() };

my $prov2 = Drifter::Box::Version::Provider->new(
    name => 'virtualbox',
    url  => URI->new('http://example.com/blarg/virtualbox/1.0.0.box'),
    checksum_type => 'sha256',
    checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
);

$vers2->add_provider($prov2);

my $end_provs = scalar @{ $vers2->providers() };

is ($start_provs + 1, $end_provs, 'number of providers increased');

TODO: {
    local $TODO = 'not yet implemented';
}
1;
