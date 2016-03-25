package Code::Includable::Tree::FromStruct;

# DATE
# VERSION

sub new_from_struct {
    my $class = shift;
    my $struct = shift;

    my $wanted_class = $struct->{_class} || $class;

    # options that will be passed to children nodes (although children nodes can
    # override these with their own)
    my $pass_attributes = $struct->{_pass_attributes};
    $pass_attributes = 'hash' if !defined $pass_attributes;
    my $constructor = $struct->{_constructor} || "new";
    my $instantiate = $struct->{_instantiate};

    my %attrs = map { $_ => $struct->{$_} } grep {!/^_/} keys %$struct;

    my $node;
    if ($instantiate) {
        $node = $instantiate->($wanted_class, \%attrs);
    } else {
        if (!$pass_attributes) {
            $node->$wanted_class->$constructor();
            for (keys %attrs) {
                $node->$_->($attrs{$_});
            }
        } elsif ($pass_attributes eq 'hash') {
            $node = $wanted_class->$constructor(%attrs);
        } elsif ($pass_attributes eq 'hashref') {
            $node = $wanted_class->$constructor(\%attrs);
        } else {
            die "Invalid _pass_attributes value '$pass_attributes'";
        }
    }

    # connect node to parent
    $node->parent($struct->{_parent}) if $struct->{_parent};

    # create children
    if ($struct->{_children}) {
        my @children;
        for my $child_struct (@{ $struct->{_children} }) {
            push @children, new_from_struct(
                $class,
                {
                    # default for children nodes
                    _constructor => $constructor,
                    _pass_attributes => $pass_attributes,
                    _instantiate => $instantiate,

                    %$child_struct,

                    _parent => $node,
                },
            );
        }
        # connect node to children
        $node->children(\@children);
    }

    $node;
}

1;
# ABSTRACT: Routine to build tree object from data structure

=for Pod::Coverage .+

The routines in this module can be imported manually to your tree class/role.
The only requirement is that your tree class supports C<parent> and C<children>
methods as described in L<Role::TinyCommons::Tree::Node>.

The routines can also be called as a normal function call, with your tree node
object as the first argument, e.g.:

 new_from_struct($class, $struct)

The full documentation about the routines is in
L<Role::TinyCommons::Tree::FromStruct>.


=head1 SEE ALSO

L<Role::TinyCommons::Tree::FromStruct> if you want to use the routines in this
module via consuming role.
