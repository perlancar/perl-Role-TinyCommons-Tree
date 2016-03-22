package Role::TinyCommons::Tree::NodeMethods;

# DATE
# VERSION

use Role::Tiny;
use Role::Tiny::With;

with 'Role::TinyCommons::Tree::Node';

BEGIN {
    no strict 'refs';
    require Code::Includable::Tree::NodeMethods;
    for (grep {/\A\w+\z/} keys %Code::Includable::Tree::NodeMethods::) {
        *{$_} = \&{"Code::Includable::Tree::NodeMethods::$_"};
    }
}

1;
# ABSTRACT: Role that provides tree node methods

=head1 DESCRIPTION


=head1 REQUIRED ROLES

L<Role::TinyCommons::Tree::Node>


=head1 PROVIDED METHODS

=head2 descendants => list

Return children and their children, recursively.

=head2 walk($code)

=head2 first_node($code) => obj|undef

=head2 is_first_child => bool

Return true if node is the first child of its parent.

=head2 is_last_child => bool

Return true if node is the last child of its parent.

=head2 is_only_child => bool

Return true if node is the only child of its parent.

=head2 is_nth_child($n) => bool

Return true if node is the I<n>th child of its parent (starts from 1 not 0, so
C<is_first_child> is equivalent to C<is_nth_child(1)>).

=head2 is_nth_last_child($n) => bool

Return true if node is the I<n>th last child of its parent.

=head2 is_first_child_of_type => bool

Return true if node is the first child (of its type) of its parent. For example,
if the parent's children are ():

 node1(T1) node2(T2) node3(T1) node4(T2)

Both C<node1> and C<node2> are first children of their respective type.

=head2 is_last_child_of_type => bool

=head2 is_only_child_of_type => bool

=head2 is_nth_child_of_type($n) => bool

=head2 is_nth_last_child_of_type($n) => bool

=head2 prev_sibling => obj

=head2 prev_siblings => list

=head2 next_sibling => obj

=head2 next_siblings => list


=head1 SEE ALSO

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>
