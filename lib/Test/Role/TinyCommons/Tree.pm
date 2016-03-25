package Test::Role::TinyCommons::Tree;

use strict;
use warnings;
use Test::Exception;
use Test::More 0.98;

sub test_role_tinycommons_tree {
    my %args = @_;

    my $c  = $args{class};
    my $c1 = $args{subclass1};
    my $c2 = $args{subclass2};

    subtest "Role::TinyCommons::Tree::Node" => sub {
        my $pnode  = $c->new;
        my $cnode1 = $c->new;
        my $cnode2 = $c->new;
        lives_ok {
            $cnode1->parent($pnode);
            $cnode2->parent($pnode);
            $pnode->children([$cnode1, $cnode2]);
        } "set parent & children";
        is_deeply($cnode1->parent, $pnode, "get parent (1)");
        is_deeply($cnode2->parent, $pnode, "get parent (1)");
        my @children = $pnode->children;
        @children = @{$children[0]}
            if @children==1 && ref($children[0]) eq 'ARRAY';
        is_deeply(\@children, [$cnode1, $cnode2], "get children");
    };

    subtest "Role::TinyCommons::Tree::NodeMethods" => sub {
        my $tree;

        $tree = $c->new

            _from_struct({
            id => 'root', _children => [
                {id => 'a1', _children => [
                    {id => 'b11'},
                    {id => 'b12', _class=>$c2},
                    {id => 'b13', _class=>$c2},
                    {id => 'b14', _class=>'TN1'},
                    {id => 'b15'},
                ]},
                {id => 'a2', _children => [
            {id => 'b21', _class => 'TN2', _children => [
                {id => 'c211', _class => 'TN1'},
            ]},
        ]},
    ],

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

1;
# ABSTRACT: Test suite for Role::TinyCommons::Tree

=head1 DESCRIPTION

This module provides a test suite for roles in Role::TinyCommons::Tree
distribution.


=head1 FUNCTIONS

=head2 test_role_tinycommons_tree(%args)

Test a class against roles in Role::TinyCommons::Tree distribution.

To run the tests, you need to provide a class name to test in C<class>. You have
to load the class yourself. The class must at least consume the role
L<Role::TinyCommons::Tree::Node> (and other roles too, if you want to test the
other roles). You also need to provide two subclasses names in C<subclass1> and
C<subclass2>. They must be subclass of the main class, and one must not be
subclasses of the other. You are also responsible to load these two subclasses.

Options:

=over

=item * class* => str

The main class to test.

=item * subclass1* => str

=item * subclass2* => str

=item * test_fromstruct => bool (default: 0)

Whether to test class against L<Role::TinyCommons::Tree::FromStruct>. If you
enable this, your class must consume the role.

=back
