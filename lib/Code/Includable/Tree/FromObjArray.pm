package Code::Includable::Tree::FromObjArray;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
our $GET_PARENT_METHOD = 'parent';
our $GET_CHILDREN_METHOD = 'children';
our $SET_PARENT_METHOD = 'parent';
our $SET_CHILDREN_METHOD = 'children';

sub __build_subtree {
    my ($parent_node, @obj_array) = ($_[0], @{$_[1] // []});

    my @children;
    while (@obj_array) {
        my $child_node = shift @obj_array;

        # connect child node to its parent
        $child_node->$SET_PARENT_METHOD($parent_node);
        push @children, $child_node;

        # the child has its own children, recurse
        if (@obj_array && ref $obj_array[0] eq 'ARRAY') {
            __build_subtree($child_node, shift(@obj_array));
        }
    }

    # connect parent node to its children
    $parent_node->$SET_CHILDREN_METHOD(\@children);

    # return something useful
    $parent_node;
}

sub new_from_obj_array {
    my $class = shift;
    my $obj_array = shift;

    die "Object array must be a one- or two-element array"
        unless ref $obj_array eq 'ARRAY' && (@$obj_array == 1 || @$obj_array == 2);
    __build_subtree(@$obj_array);
}

1;
# ABSTRACT: Routine to build a tree of objects from a nested array of objects

=for Pod::Coverage .+

The routines in this module can be imported manually to your tree class/role.
The only requirement is that your tree class supports C<parent> and C<children>
methods as described in L<Role::TinyCommons::Tree::Node>.

The full documentation about the routines is in
L<Role::TinyCommons::Tree::FromObjArray>.


=head1 VARIABLES

=head2 $SET_PARENT_METHOD => str (default: parent)

The method name C<parent> to set parent can actually be customized by (locally)
setting this variable.

=head2 $SET_CHILDREN_METHOD => str (default: children)

The method name C<children> to set children can actually be customized by
(locally) setting this variable.


=head1 SEE ALSO

L<Role::TinyCommons::Tree::FromObjArray> if you want to use the routines in this
module via consuming role.

L<Code::Includable::Tree::FromStruct> if you want to build a tree of objects
from a (nested hash) data structure.
