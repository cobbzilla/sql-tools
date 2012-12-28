#!/usr/bin/perl

##############################################################################################
# Remove drop/create/alter statements for certain tables from a SQL DDL script
#
# Usage: cat your-sql-file.sql | scrub-schema.pl table1 table2 table3 ... > scrubbed.sql
#
# This code is available under the Apache License, version 2, available at the link below.
# http://www.apache.org/licenses/LICENSE-2.0.html
##############################################################################################

sub skipBlock {
  my $skippingCreate = 0;
  for my $table (@ARGV) {
    if (/\s*$_[0].*\s$table \(/) {
      $skippingCreate = 1;
      while ( $skippingCreate ) {
        while (<STDIN>) {
          if (/\);/) {
            $skippingCreate = 0; break;
          }
        }
      }
    }
  }
}

while (<STDIN>) {

  if (/\s*drop table/) {
    my $skipDrop = 0;
    for my $table (@ARGV) {
      if (/\s*drop table.*\s$table;/) {
        $skipDrop = 1; break;
      }
    }
    if ( $skipDrop ) {
      $skipDrop = 0; next;
    }

  } elsif (/\s*create table/) {
      &skipBlock("create table");

  } elsif (/\s*alter table/) {
      &skipBlock("alter table");
  }
  print;

}
