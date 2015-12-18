package Drifter::Lib;

use Moo;
use strict;
use warnings;
use namespace::clean;

use JSON_File;
use File::Find;
use Digest::SHA;

use vars qw/*name *dir *prune $config/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

# ABSTRACT: A library for managing Drifter:: objects

has checksum => (
    is => 'rw',
    default => 'sha256',
);

# update versions
sub update_versions {
  print "running update_versions\n";
}

sub split_names {
  my $self = shift;
  # pass in a file string
  # returns ( provider, name, version
  my ( $provider, $name, $version );
}

# wanted for box file
sub _boxwant {
  # only want json files
  /^.*\.box\z/s
  || return;
  # TODO re-variableize
  my $sha = Digest::SHA->new('sha256');
  $sha->addfile($_);
  my $digest = $sha->hexdigest;
  print "\t\tfound box $name, dig $digest\n";
}

# wanted for config file
sub _metawant {
  # only want json files
  /^.*\.json\z/s
  || return;

  # do your work here
  tie ( my %foo, 'JSON_File', $_);

  print "filename: $name\n\t";
  print $foo{'description'};
  print "\n";
  File::Find::find({wanted => \&_boxwant}, '.');
}

sub run{
  my $self = shift;
  my $startpath = shift;
  # start metadata file search
  File::Find::find({wanted => \&_metawant}, $startpath);
}

1;
