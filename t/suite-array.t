#!perl

use 5.010001;
use strict;
use warnings;
use Test::More 0.98;
#use Test::Requires 'Class::Build::Array::Glob'; # can't be used
BEGIN {
    unless (eval { require Class::Build::Array::Glob; 1 }) {
        plan skip_all => "Class::Build::Array::Glob not availalbe";
    }
}

use FindBin '$Bin';
use lib "$Bin/lib";

use Local::Node::Array;
use Local::Node::Array::Sub1;
use Local::Node::Array::Sub2;
use Test::Role::TinyCommons::Tree qw(test_role_tinycommons_tree);

test_role_tinycommons_tree(
    class     => 'Local::Node::Array',
    subclass1 => 'Local::Node::Array::Sub1',
    subclass2 => 'Local::Node::Array::Sub2',

    test_fromstruct  => 1,
    test_nodemethods => 1,
);
done_testing;
