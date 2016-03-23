package Role::TinyCommons::Tree::FromStruct;

# DATE
# VERSION

use Role::Tiny;

BEGIN {
    no strict 'refs';
    require Code::Includable::Tree::FromStruct;
    for (grep {/\A[a-z]\w+\z/} keys %Code::Includable::Tree::FromStruct::) {
        *{$_} = \&{"Code::Includable::Tree::FromStruct::$_"};
    }
}

1;
# ABSTRACT: Role that provides methods to build tree object from data structure

=head1 PROVIDED METHODS

=head2 new_from_struct($struct) => obj

Construct a tree object from a data structure C<$struct>. Structure must be a
hash. Node object will be constructed using:

 $class->new(%args)

where role consumer's class will be used as the new node object's class, unless
there's a key called C<_class> to set the class. C<%args> will be taken from the
hash's keys that are not prefixed with underscore. Node's children can be
specified in the C<_children> key and the value is array of structures.

Example:

 my $family_tree = My::Person->new_from_struct({
     name => 'Andi', _children => [
         {name => 'Budi', age => 30},
         {name => 'Cinta', _class => 'My::MarriedPerson', _children => [
              {name => 'Deni'},
              {name => 'Eno'},
          ]},
     ]});


=head1 SEE ALSO

L<Code::Includable::Tree::FromStruct> if you want to use the routines in this
module without consuming a role.

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>
