package Role::TinyCommons::Tree::FromStruct;

# DATE
# VERSION

use Role::Tiny;

sub new_from_struct {
    my $role_class = shift;
    my $struct = shift;

    my $wanted_class = $struct->{_class} || $role_class;

    my @args;
    if ($struct->{_args}) {
        @args = @{ $struct->{_args} };
    } else {
        @args = map { $_ => $struct->{$_} } grep {!/^_/} keys %$struct;
    }

    my $constructor = $struct->{_constructor} || "new";

    my $node = $wanted_class->$constructor(@args);

    $node->parent($struct->{_parent}) if $struct->{_parent};

    if ($struct->{_children}) {
        my @children;
        for my $child_struct (@{ $struct->{_children} }) {
            push @children, $role_class->new_from_struct(
                {%$child_struct, _parent => $node},
            );
        }
        $node->children(@children);
    }

    $node;
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

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>
