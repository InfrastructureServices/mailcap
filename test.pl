#!/usr/bin/perl -w

use strict;

my %ext2type;
my %seentype;
my %toplevel;

while (<>) {
  chomp;
  /^\s*(#|$)/ && next;

  $_ = lc($_);
  my ($type, @exts) = split;
  $seentype{$type}++;
  my $toplevel = (split(/\//, $type))[0];
  $toplevel{$toplevel}++;

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

print "Top level types:\n";
for my $toplevel (sort keys %toplevel) {
  printf "%16s: %d\n", $toplevel, $toplevel{$toplevel};
}
printf "%d types, %d extensions\n",
  scalar keys %seentype, scalar keys %ext2type;
if (@dupes) {
  print STDERR "Error: duplicate mapping: ", $_, "\n" for @dupes;
  exit 1;
}
print "No duplicate mappings found.\n";
