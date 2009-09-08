#!/usr/bin/perl -w

use strict;

my %types;
my $ntypes = 0;

while (<>) {
  chomp;
  /^\s*(#|$)/ && next;

  $_ = lc($_);
  my ($type, @exts) = split;
  $ntypes++;

  for my $ext (@exts) {
    $types{$ext} ||= [];
    push @{$types{$ext}}, $type;
  }
}

my @dupes;
while (my ($ext, $types) = each %types) {
  next if scalar @$types < 2;
  push @dupes, sprintf "%s => %s", $ext, join(", ", sort @$types);
}

printf "%d types, %d extensions\n", $ntypes, scalar keys %types;
if (@dupes) {
  print STDERR "Error: duplicate mapping: ", $_, "\n" for sort @dupes;
  exit 1;
}
print "Success, no duplicate mappings found.\n";
