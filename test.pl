#!/usr/bin/perl -w

use strict;

my %ext2type;
my %seentype;
my %toplevel;

my %good_toplevel = map { $_ => 1 }
  qw(application audio chemical image message model multipart text video
     x-conference x-epoc);

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

my $dupe_error = 0;
if (@dupes) {
  print STDERR "Error: duplicate mapping: ", $_, "\n" for @dupes;
  $dupe_error++;
}
  print "No duplicate mappings found.\n" unless $dupe_error;

my $toplevel_error = 0;
for my $toplevel (keys %toplevel) {
  unless (exists $good_toplevel{$toplevel}) {
    print STDERR "Error: bad top level type: ", $toplevel, "\n";
    $toplevel_error++;
  }
}
print "No bad top level types found.\n" unless $toplevel_error;

exit $dupe_error + $toplevel_error ? 1 : 0;
