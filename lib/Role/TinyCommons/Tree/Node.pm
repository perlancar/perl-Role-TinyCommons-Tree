package Role::TinyCommons::Tree::Node;

# DATE
# VERSION

use Role::Tiny;

requires 'parent';
requires 'children';

1;
# ABSTRACT: Role for a tree node object

=head1 DESCRIPTION

To minimize clash, utility methods are separated into a separate role
L<Role::TinyCommons::Tree::NodeMethods>.


=head1 REQUIRED METHODS

=head2 parent => obj

This must be an accessor, i.e. it must be able to set parent attribute using:

 $obj->parent($parent)

=head2 children => list of obj|arrayref of obj

This must be an accessor, i.e. it must be able to set children attribute using:

 $obj->children([$child1, ...])

But for flexibility, it is allowed to return arrayref or list.


=head1 SEE ALSO

L<Role::TinyCommons>
