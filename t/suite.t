#!perl

use 5.010001;
use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin/lib";

use Local::Node;
use Local::Node1;
use Local::Node2;
use Test::Role::TinyCommons::Tree qw(test_role_tinycommons_tree);

test_role_tinycommons_tree(
    class     => 'Local::Node',
    subclass1 => 'Local::Node1',
    subclass2 => 'Local::Node2',

    test_fromstruct => 1,
    fromstruct_extra_attribute => 'id',
);
done_testing;
