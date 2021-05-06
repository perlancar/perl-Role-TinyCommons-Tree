package Role::TinyCommons::Tree::FromStruct;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;
use Role::Tiny::With;

with 'Role::TinyCommons::Tree::NodeMethods';

BEGIN {
    no strict 'refs';
    require Code::Includable::Tree::FromStruct;
    for (grep {/\A[a-z]\w+\z/} keys %Code::Includable::Tree::FromStruct::) {
        *{$_} = \&{"Code::Includable::Tree::FromStruct::$_"};
    }
}

1;
# ABSTRACT: Role that provides methods to build tree object from data structure

=head1 MIXED IN ROLES

L<Role::TinyCommons::Tree::NodeMethods>


=head1 PROVIDED METHODS

=head2 new_from_struct($struct) => obj

Construct a tree object from a data structure C<$struct>. The data structure
must be a hash. Its keys must contain zero or more attributes to set the
attributes of the to-be-created tree node. Keys that begin with underscore
(C<_>), however, contains special instructions.

Example usage:

 my $family_tree = My::Person->new_from_struct({
     name => 'Andi', age => 64, _children => [
         {name => 'Budi', age => 30},
         {name => 'Cinta', _class => 'My::MarriedPerson', _children => [
              {name => 'Deni'},
              {name => 'Eno'},
          ]},
     ]});

In this example, C<new_from_struct> will create the first (root) node using:

 My::Person->new(name => 'Andi', age => 64)

To customize how a node is instantiated, there are several ways. First, if you
want to use another class, you can put a C<_class> key in your struct, e.g. C<<
_class => 'My::MarriedPerson' >>. Node will then be created using:

 My::MarriedPerson->new(name => 'Andi', age => 64)

If your constructor method name is not C<new>, you can set that using the
C<_constructor> key.

If your constructor does not accept a list of attribute name and value pairs,
but a hash(ref) of attributes, you can set C<_pass_attributes> to C<hashref>,
and then node will be created using:

 My::Person->new({ name => 'Andi', age => 64 })

Or, if your constructor doesn't take any argument and the attributes are set
using individual accessor methods, you can set the C<_pass_attributes> key to
false and then node will be created using:

 do {
     my $node = My::Person->new;
     $node->name('Andi');
     $node->age(64);
     $node;
 }

Finally, if you need total customization for the constructor and initialization
of your node, you can supply the key C<_instantiate> instead. This should be a
code that instantiate your node. The code will be passed C<($class, \%attrs)>
and should return the newly created node. Example:

 _instantiate => sub {
     my ($class, $attrs) = @_;
     $class->create_person($attrs->{name}, $attrs->{age} // 0);
 }

The C<_children> key (arrayref of structs) instructs how to create children
nodes. This will recursively call C<new_from_struct> for each child. The
parent's C<_constructor>, C<_pass_attributes>, and C<_instantiate> keys will be
set as the default for the child's struct, but of course child can override it
should they want to.

Finally, the children will be connected to their parents and vice versa. And the
final tree object (root node) is returned.

Continuing from the previous example:

 my $family_tree = My::Person->new_from_struct({
     name => 'Andi', age => 64, _children => [
         {name => 'Budi', age => 30},
         {name => 'Cinta', _class => 'My::MarriedPerson', _children => [
              {name => 'Deni'},
              {name => 'Eno'},
          ]},
     ]});

Here are the steps that will be performed (so in essence what C<new_from_struct>
provides is convenience of not having to connect parent and children nodes
manually):

 my $andi = My::Person->new(name => 'Andi', age => 64);

 my $budi  = My::Person->new(name => 'Budi', age => 30);
 $budi->parent($andi);

 my $cinta = My::MarriedPerson->new(name => 'Cinta');
 $cinta->parent($andi);

 $andi->children([$budi, $cinta]);

 # class defaults back to My::Person since _class is not specified and not
 # passed down to children's struct

 my $deni = My::Person->new(name => 'Deni');
 $deni->parent($cinta);

 my $eno = My::Person->new(name => 'Eno');
 $eno->parent($cinta);

 $cinta->children([$deni, $eno]);

 $andi;


=head1 SEE ALSO

L<Code::Includable::Tree::FromStruct> if you want to use the routines in this
module without consuming a role.

L<Role::TinyCommons::Tree::FromObjArray> if you want to build a tree of objects
from a nested array of objects.

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>
