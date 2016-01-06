package Drifter::App::CLI;
use Moo;
use MooX::Cmd;

=for Pod::Coverage execute
=cut

sub execute {
  my ( $self, $args_ref, $chain_ref ) = @_;
  my @extra_argv = @{$args_ref};
  my @chain = @{$chain_ref};
  print "app::cli execute\n";
}
 
1;
