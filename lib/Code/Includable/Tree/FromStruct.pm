package Code::Includable::Tree::FromStruct;

# DATE
# VERSION

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
            push @children, new_from_struct(
                $role_class,
                {%$child_struct, _parent => $node},
            );
        }
        $node->children(@children);
    }

    $node;
}

1;
# ABSTRACT: Routine to build tree object from struct

=for Pod::Coverage .+

The routines in this module can be imported manually to your tree class/role.
The only requirement is that your tree class supports C<parent> and C<children>
methods.

The routines can also be called as a normal function call, with your tree node
object as the first argument, e.g.:

 new_from_struct($class, $struct)
