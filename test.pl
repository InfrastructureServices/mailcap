#!/usr/bin/perl -w

use strict;

my %ext2type;
my %seentype;

while (<>) {
  chomp;
  /^\s*(#|$)/ && next;

  $_ = lc($_);
  my ($type, @exts) = split;
  $seentype{$type}++;

  for my $ext (@exts) {
    $ext2type{$ext} ||= [];
    push @{$ext2type{$ext}}, $type;
  }
}

my @dupes;
for my $ext (sort keys %ext2type) {
  my $types = $ext2type{$ext};
  next if scalar @$types < 2;
  push @dupes, sprintf "%s => %s", $ext, join(", ", sort @$types);
}
for my $type (sort keys %seentype) {
  my $count = $seentype{$type};
  next if $count < 2;
  push @dupes, sprintf "%s (%d)", $type, $count;
}

printf "%d types, %d extensions\n",
  scalar keys %seentype, scalar keys %ext2type;
if (@dupes) {
  print STDERR "Error: duplicate mapping: ", $_, "\n" for @dupes;
  exit 1;
}
print "Success, no duplicate mappings found.\n";
