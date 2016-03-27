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

If you need to build a tree or connect nodes, then the method must accept an
optional argument to set value:

 $obj->parent($parent)

=head2 children => list of obj|arrayref of obj

If you need to build a tree or connect nodes, then the method must accept an
optional argument to set value:

 $obj->children(\@children)

For flexibility, it is allowed to return arrayref or list of children nodes.


=head1 SEE ALSO

L<Role::TinyCommons>
