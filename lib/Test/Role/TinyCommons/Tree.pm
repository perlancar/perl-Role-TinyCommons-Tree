package Test::Role::TinyCommons::Tree;

use strict;
use warnings;
use Test::Exception;
use Test::More 0.98;

use Exporter qw(import);
our @EXPORT_OK = qw(test_role_tinycommons_tree);

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

        my $ea = $args{fromstruct_extra_attribute} || 'id';

        $tree = $c->new_from_struct({
            ( _instantiate => $args{code_instantiate} ) x
                !!$args{code_instantiate},

            $ea => 'root', _children => [
                {$ea => 'a1', _children => [
                    {$ea => 'b11'},
                    {$ea => 'b12', _class=>$c2},
                    {$ea => 'b13', _class=>$c2},
                    {$ea => 'b14', _class=>$c1},
                    {$ea => 'b15'},
                ]},
                {$ea => 'a2', _children => [
                    {$ea => 'b21', _class => $c2, _children => [
                        {$ea => 'c211', _class => $c1},
                    ]},
                ]},
            ],
        });
    } if $args{test_fromstruct};
}

=begin comment

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

=end comment

=cut

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

In addition to that, your class must also have another extra attribute (by
default named C<id>, but configurable using the C<fromstruct_extra_attribute>
argument). This attribute is used for testing and must hold an integer.

If that attribute needs to be set during construction, and your constructor does
not accept name-value pairs (C<< $class->new(id => ...) >>), or if your
constructor is not named C<new>, then you'll need to supply C<code_instantiate>
which will be passed C<<($class, \%attrs)>> so you can instantiate your object
yourself.

=item * fromstruct_extra_attribute => str

Required if you enable C<test_fromstruct> (see C<test_fromstruct>).

=item * code_instantiate => code

Required if your constructor does not accept name-value pairs (C<<
$class->new(id => ...) >>), or if your constructor is not named C<new>. Code
will be supplied C<< ($class, \%attrs) >> and must return an object.

=back
