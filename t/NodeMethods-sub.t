#!perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin/lib";

require Code::Includable::Tree::NodeMethods;

use Test::More 0.98;
use TN;
use TN1;
use TN2;

my $tree = TN->new_from_struct({
    id => 'root', _children => [
        {id => 'a1', _children => [
            {id => 'b11'},
            {id => 'b12', _class=>'TN2'},
            {id => 'b13', _class=>'TN2'},
            {id => 'b14', _class=>'TN1'},
            {id => 'b15'},
        ]},
        {id => 'a2', _children => [
            {id => 'b21', _class => 'TN2', _children => [
                {id => 'c211', _class => 'TN1'},
            ]},
        ]},
    ],
});

my %n; # nodes, key=id, val=obj
Code::Includable::Tree::NodeMethods::walk($tree, sub { $n{$_[0]{id}} = $_ });

is_deeply([Code::Includable::Tree::NodeMethods::descendants($tree)],
          [@n{qw/a1 a2 b11 b12 b13 b14 b15 b21 c211/}], "descendants");

is_deeply(Code::Includable::Tree::NodeMethods::first_node($tree, sub { $_[0]{id} eq 'b1' }),
          $n{b1}, "first_node");

ok( Code::Includable::Tree::NodeMethods::is_first_child($n{a1}), "is_first_child [1]");
ok(!Code::Includable::Tree::NodeMethods::is_first_child($n{a2}), "is_first_child [2]");
ok(!Code::Includable::Tree::NodeMethods::is_first_child($tree ), "is_first_child [3]");

goto DONE_TESTING;

ok(!Code::Includable::Tree::NodeMethods::is_last_child($n{a1}), "is_last_child [1]");
ok( Code::Includable::Tree::NodeMethods::is_last_child($n{a2}), "is_last_child [2]");
ok(!Code::Includable::Tree::NodeMethods::is_last_child($tree ), "is_last_child [3]");

ok(!Code::Includable::Tree::NodeMethods::is_only_child($n{a1} ), "is_only_child [1]");
ok( Code::Includable::Tree::NodeMethods::is_only_child($n{b21}), "is_only_child [2]");
ok(!Code::Includable::Tree::NodeMethods::is_only_child($tree  ), "is_only_child [3]");

ok( Code::Includable::Tree::NodeMethods::is_nth_child($n{a1}, 1), "is_nth_child [1]");
ok(!Code::Includable::Tree::NodeMethods::is_nth_child($n{a1}, 2), "is_nth_child [2]");
ok( Code::Includable::Tree::NodeMethods::is_nth_child($n{a2}, 2), "is_nth_child [3]");

ok(!Code::Includable::Tree::NodeMethods::is_nth_last_child($n{a1}, 1), "is_nth_last_child [1]");
ok( Code::Includable::Tree::NodeMethods::is_nth_last_child($n{a1}, 2), "is_nth_last_child [2]");
ok(!Code::Includable::Tree::NodeMethods::is_nth_last_child($n{a2}, 2), "is_nth_last_child [3]");

ok( Code::Includable::Tree::NodeMethods::is_first_child_of_type($n{b11}), "is_first_child_of_type [1]");
ok( Code::Includable::Tree::NodeMethods::is_first_child_of_type($n{b12}), "is_first_child_of_type [2]");
ok(!Code::Includable::Tree::NodeMethods::is_first_child_of_type($n{b13}), "is_first_child_of_type [3]");
ok( Code::Includable::Tree::NodeMethods::is_first_child_of_type($n{b14}), "is_first_child_of_type [4]");
ok(!Code::Includable::Tree::NodeMethods::is_first_child_of_type($n{b15}), "is_first_child_of_type [4]");

ok(!Code::Includable::Tree::NodeMethods::is_last_child_of_type($n{b11}), "is_last_child_of_type [1]");
ok(!Code::Includable::Tree::NodeMethods::is_last_child_of_type($n{b12}), "is_last_child_of_type [2]");
ok( Code::Includable::Tree::NodeMethods::is_last_child_of_type($n{b13}), "is_last_child_of_type [3]");
ok( Code::Includable::Tree::NodeMethods::is_last_child_of_type($n{b14}), "is_last_child_of_type [4]");
ok( Code::Includable::Tree::NodeMethods::is_last_child_of_type($n{b15}), "is_last_child_of_type [5]");

ok( Code::Includable::Tree::NodeMethods::is_nth_child_of_type($n{b11}, 1), "is_nth_child_of_type [1]");
ok(!Code::Includable::Tree::NodeMethods::is_nth_child_of_type($n{b11}, 2), "is_nth_child_of_type [2]");
ok( Code::Includable::Tree::NodeMethods::is_nth_child_of_type($n{b12}, 1), "is_nth_child_of_type [3]");
ok(!Code::Includable::Tree::NodeMethods::is_nth_child_of_type($n{b12}, 2), "is_nth_child_of_type [4]");

ok(!Code::Includable::Tree::NodeMethods::is_nth_last_child_of_type($n{b11}, 1), "is_nth_last_child_of_type [1]");
ok( Code::Includable::Tree::NodeMethods::is_nth_last_child_of_type($n{b11}, 2), "is_nth_last_child_of_type [2]");
ok(!Code::Includable::Tree::NodeMethods::is_nth_last_child_of_type($n{b12}, 1), "is_nth_last_child_of_type [3]");
ok( Code::Includable::Tree::NodeMethods::is_nth_last_child_of_type($n{b12}, 2), "is_nth_last_child_of_type [4]");

ok(!Code::Includable::Tree::NodeMethods::is_only_child_of_type($n{b11}), "is_only_child_of_type [1]");
ok( Code::Includable::Tree::NodeMethods::is_only_child_of_type($n{b14}), "is_only_child_of_type [2]");

is_deeply(Code::Includable::Tree::NodeMethods::prev_sibling($n{b11}), undef, "prev_sibling [1]");
is_deeply(Code::Includable::Tree::NodeMethods::prev_sibling($n{b13}), $n{b12}, "prev_sibling [2]");
is_deeply(Code::Includable::Tree::NodeMethods::prev_sibling($n{b15}), $n{b14}, "prev_sibling [3]");

is_deeply(Code::Includable::Tree::NodeMethods::next_sibling($n{b11}), $n{b12}, "next_sibling [1]");
is_deeply(Code::Includable::Tree::NodeMethods::next_sibling($n{b13}), $n{b14}, "next_sibling [2]");
is_deeply(Code::Includable::Tree::NodeMethods::next_sibling($n{b15}), undef, "next_sibling [3]");

is_deeply([Code::Includable::Tree::NodeMethods::prev_siblings($n{b11})], [], "prev_siblings [1]");
is_deeply([Code::Includable::Tree::NodeMethods::prev_siblings($n{b13})], [$n{b11}, $n{b12}], "prev_siblings [2]");

is_deeply([Code::Includable::Tree::NodeMethods::next_siblings($n{b13})], [$n{b14}, $n{b15}], "next_siblings [1]");
is_deeply([Code::Includable::Tree::NodeMethods::next_siblings($n{b15})], [], "next_siblings [2]");

DONE_TESTING:
done_testing;
