#!perl

use strict;
use warnings;
use Test::More 0.98;

use FindBin '$Bin';
use lib "$Bin/lib";

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
$tree->walk(sub { $n{$_[0]{id}} = $_ });

is_deeply([$tree->descendants],
          [@n{qw/a1 a2 b11 b12 b13 b14 b15 b21 c211/}], "descendants");

is_deeply($tree->first_node(sub { $_[0]{id} eq 'b1' }),
          $n{b1}, "first_node");

ok( $n{a1}->is_first_child, "is_first_child [1]");
ok(!$n{a2}->is_first_child, "is_first_child [2]");
ok(!$tree ->is_first_child, "is_first_child [3]");

ok(!$n{a1}->is_last_child, "is_last_child [1]");
ok( $n{a2}->is_last_child, "is_last_child [2]");
ok(!$tree ->is_last_child, "is_last_child [3]");

ok(!$n{a1} ->is_only_child, "is_only_child [1]");
ok( $n{b21}->is_only_child, "is_only_child [2]");
ok(!$tree  ->is_only_child, "is_only_child [3]");

ok( $n{a1} ->is_nth_child(1), "is_nth_child [1]");
ok(!$n{a1} ->is_nth_child(2), "is_nth_child [2]");
ok( $n{a2} ->is_nth_child(2), "is_nth_child [3]");

ok(!$n{a1} ->is_nth_last_child(1), "is_nth_last_child [1]");
ok( $n{a1} ->is_nth_last_child(2), "is_nth_last_child [2]");
ok(!$n{a2} ->is_nth_last_child(2), "is_nth_last_child [3]");

ok( $n{b11} ->is_first_child_of_type, "is_first_child_of_type [1]");
ok( $n{b12} ->is_first_child_of_type, "is_first_child_of_type [2]");
ok(!$n{b13} ->is_first_child_of_type, "is_first_child_of_type [3]");
ok( $n{b14} ->is_first_child_of_type, "is_first_child_of_type [4]");
ok(!$n{b15} ->is_first_child_of_type, "is_first_child_of_type [4]");

ok(!$n{b11} ->is_last_child_of_type, "is_last_child_of_type [1]");
ok(!$n{b12} ->is_last_child_of_type, "is_last_child_of_type [2]");
ok( $n{b13} ->is_last_child_of_type, "is_last_child_of_type [3]");
ok( $n{b14} ->is_last_child_of_type, "is_last_child_of_type [4]");
ok( $n{b15} ->is_last_child_of_type, "is_last_child_of_type [5]");

ok( $n{b11} ->is_nth_child_of_type(1), "is_nth_child_of_type [1]");
ok(!$n{b11} ->is_nth_child_of_type(2), "is_nth_child_of_type [2]");
ok( $n{b12} ->is_nth_child_of_type(1), "is_nth_child_of_type [3]");
ok(!$n{b12} ->is_nth_child_of_type(2), "is_nth_child_of_type [4]");

ok(!$n{b11} ->is_nth_last_child_of_type(1), "is_nth_last_child_of_type [1]");
ok( $n{b11} ->is_nth_last_child_of_type(2), "is_nth_last_child_of_type [2]");
ok(!$n{b12} ->is_nth_last_child_of_type(1), "is_nth_last_child_of_type [3]");
ok( $n{b12} ->is_nth_last_child_of_type(2), "is_nth_last_child_of_type [4]");

ok(!$n{b11} ->is_only_child_of_type, "is_only_child_of_type [1]");
ok( $n{b14} ->is_only_child_of_type, "is_only_child_of_type [2]");

is_deeply($n{b11}->prev_sibling, undef, "prev_sibling [1]");
is_deeply($n{b13}->prev_sibling, $n{b12}, "prev_sibling [2]");
is_deeply($n{b15}->prev_sibling, $n{b14}, "prev_sibling [3]");

is_deeply($n{b11}->next_sibling, $n{b12}, "next_sibling [1]");
is_deeply($n{b13}->next_sibling, $n{b14}, "next_sibling [2]");
is_deeply($n{b15}->next_sibling, undef, "next_sibling [3]");

is_deeply([$n{b11}->prev_siblings], [], "prev_siblings [1]");
is_deeply([$n{b13}->prev_siblings], [$n{b11}, $n{b12}], "prev_siblings [2]");

is_deeply([$n{b13}->next_siblings], [$n{b14}, $n{b15}], "next_siblings [1]");
is_deeply([$n{b15}->next_siblings], [], "next_siblings [2]");

done_testing;
