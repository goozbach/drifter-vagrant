package Drifter::App::CLI::Cmd::List;
use Moo;
use MooX::Cmd;
 
=for Pod::Coverage execute
=cut

sub execute {
  my ( $self, $args_ref, $chain_ref ) = @_;
  my @chain = @{$chain_ref};
  print "cmd::list execute\n";
}
 
1;
