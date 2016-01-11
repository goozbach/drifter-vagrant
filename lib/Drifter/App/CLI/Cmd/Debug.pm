package Drifter::App::CLI::Cmd::Debug;
use Moo;
use MooX::Cmd;

use Drifter::Box;
use Drifter::Box::Version;
use Drifter::Box::Version::Provider;
use feature 'say';
use Data::Dumper;

# ABSTRACT: drifter: Vagrant metadata management command line tool
# PODNAME: drifter

=for Pod::Coverage execute
=cut

sub execute {
  my ( $self, $args_ref, $chain_ref ) = @_;
  my @chain = @{$chain_ref};

  my $prov = Drifter::Box::Version::Provider->new(
      name => 'virtualbox',
      url  => 'http://example.com/blarg/virtualbox/1.0.0.box',
      checksum_type => 'sha256',
      checksum => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
  );
  
  my $vers = Drifter::Box::Version->new(
      version => '1.0.0',
      description => 'blarg 1.0.0',
      description_html => '<h1>blarg 1.0.0</h1>',
      description_mark => '#blarg 1.0.0',
      providers => [ $prov, ],
      status => 'inactive',
  );
  
  $prov->parent(\$vers);
  
  my $box = Drifter::Box->new(
      filename => 'scratch/drifter.box',
      name     => 'blarg',
      description => 'The blarg vagrant box',
      short_description => 'blarg',
      versions => [ $vers ],
  );
  
  $vers->parent(\$box);
  
  say Dumper $box;
  
  say "===========\n";
  
  say $vers->description_markdown();

}

1;
