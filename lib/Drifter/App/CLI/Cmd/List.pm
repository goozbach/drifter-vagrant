package Drifter::App::CLI::Cmd::List;
use Moo;
use MooX::Cmd;
 
# gets executed on "myapp command" but not on "myapp command command"
# there MyApp::Cmd::Command still gets instantiated and for the chain
=for Pod::Coverage execute
=cut

sub execute {
  my ( $self, $args_ref, $chain_ref ) = @_;
  my @chain = @{$chain_ref};
  print "cmd::list execute\n";
}
 
1;
