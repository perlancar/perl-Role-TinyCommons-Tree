package Role::TinyCommons::TreeNode;

# DATE
# VERSION

use Role::Tiny;

requires 'parent';
requires 'children';

1;
# ABSTRACT: Role for a tree node object

=head1 DESCRIPTION


=head1 REQUIRED METHODS

=head2 parent => obj

=head2 children => list of obj|arrayref of obj


=head1 PROVIDE METHODS

=head1 SEE ALSO

L<Role::TinyCommons>
