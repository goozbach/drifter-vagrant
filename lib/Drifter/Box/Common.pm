package Drifter::Box::Common;
use Moo;
use Drifter::Types -all;
use Types::URI -all;
use namespace::clean;

=method uriroot

Set or return the 'uriroot' attribute

    my $uriroot = $obj->uriroot(); # return attribute
    $obj->uriroot('http://example.com/drifter/'); # set attribute

=cut

has uriroot =>(
    is => 'rw',
    isa => Uri,
);

=method parent()

Optional

A reference to the parent object which contains this provider

Should only be set once

=cut
has _parentset => (
    is => 'rw',
    isa => Bool,
    default => sub { 0; },
);

has _parent => (
    is => 'rw',
);

sub parent {
    my $self = shift;
    if (@_) {
      if ($self->{_parentset}) {
        die "unable to change read-only 'parent' attribute";
      } else {
        $self->{_parent} = shift;
        $self->{_parentset} = 1;
      }
    }
    return $self->{_parent};
}

1;
