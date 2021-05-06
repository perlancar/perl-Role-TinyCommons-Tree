package Role::TinyCommons::Tree::FromObjArray;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;
use Role::Tiny::With;

with 'Role::TinyCommons::Tree::NodeMethods';

BEGIN {
    no strict 'refs';
    require Code::Includable::Tree::FromObjArray;
    for (grep {/\A[a-z]\w+\z/} keys %Code::Includable::Tree::FromObjArray::) {
        *{$_} = \&{"Code::Includable::Tree::FromObjArray::$_"};
    }
}

1;
# ABSTRACT: Role that provides methods to build a tree of objects from a nested array of objects

=encoding utf8

=head1 MIXED IN ROLES

L<Role::TinyCommons::Tree::NodeMethods>


=head1 PROVIDED METHODS

=head2 new_from_obj_array($obj_array) => obj

Construct a tree of objects from a nested array of objects C<$obj_array>. The
array must contain the root node object followed by zero or more children node
objects. Each child can be directly followed by an arrayref to specify I<its>
children. Examples:

 [$root_node_obj]                                     # if there are no children nodes

 [$root_node_obj, [$child1_obj, $child2_obj]]         # if root node has two children

 [$root_node_obj, [
   $child1_obj, [$grandchild1_obj, $grandchild2_obj],
   $child2_obj]]                                      # if first child has two children of its own

A more complex example (C<$ABC>, C<$DEF>, and so on are all objects):

 [$ABC, [
   $DEF, [$GHI, $JKL],
   $MNO, [$PQR, [$STU]],
   $VWX
  ]]

The above tree can be visualized as follow:

 $ABC
   ├─$DEF
   │   ├─$GHI
   │   └─$JKL
   ├─$MNO
   │   └─$PQR
   │       └─$STU
   └─$VWX

The objects will be connected to each other by calling their C<parent()> and
C<children()> methods. See L<Role::TinyCommons::Tree::Node> for more details.


=head1 SEE ALSO

L<Code::Includable::Tree::FromStruct> if you want to use the routines in this
module without consuming a role.

L<Role::TinyCommons::Tree::FromObjArray> if you want to build a tree of objects
from a nested array of objects.

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>

The nested array format is inspired by L<Text::Tree::Indented>.
