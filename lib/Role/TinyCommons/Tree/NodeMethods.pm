package Role::TinyCommons::Tree::NodeMethods;

# DATE
# VERSION

use Role::Tiny;
use Role::Tiny::With;
use Scalar::Util 'refaddr';

with 'Role::TinyCommons::Tree::Node';

# like children, but always return list
sub _children_as_list {
    my $self = shift;
    my @c = $self->children;
    @c = @{$c[0]} if @c==1 && ref($c[0]) eq 'ARRAY';
    @c;
}

sub descendants {
    my $self = shift;
    my @c = $self->_children_as_list;
    (@c, map { $_->descendants } @c);
}

sub is_first_child {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = $parent->_children_as_list;
    @c && refaddr($self) == refaddr($c[0]);
}

sub is_last_child {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = $parent->_children_as_list;
    @c && refaddr($self) == refaddr($c[-1]);
}

sub is_only_child {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = $parent->_children_as_list;
    @c==1;# && refaddr($self) == refaddr($c[0]);
}

sub is_nth_child {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = $parent->_children_as_list;
    @c >= $n && refaddr($self) == refaddr($c[$n-1]);
}

sub is_nth_last_child {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = $parent->_children_as_list;
    @c >= $n && refaddr($self) == refaddr($c[-$n]);
}

sub is_first_child_of_type {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } $parent->_childen_as_list;
    @c && refaddr($self) == refaddr($c[0]);
}

sub is_last_child_of_type {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } $parent->_childen_as_list;
    @c && refaddr($self) == refaddr($c[-1]);
}

sub is_only_child_of_type {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } $parent->_childen_as_list;
    @c == 1; # && refaddr($self) == refaddr($c[0]);
}

sub is_nth_child_of_type {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } $parent->_childen_as_list;
    @c >= $n && refaddr($self) == refaddr($c[$n-1]);
}

sub is_nth_last_child_of_type {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } $parent->_childen_as_list;
    @c >= $n && refaddr($self) == refaddr($c[-$n]);
}

sub prev_sibling {
    my $self = shift;
    my $parent = $self->parent or return undef;
    my $refaddr = refaddr($self);
    my @c = $parent->_childen_as_list;
    for my $i (1..$#c) {
        if (refaddr($c[$i]) == $refaddr) {
            return $c[$i-1];
        }
    }
    undef;
}

sub prev_siblings {
    my $self = shift;
    my $parent = $self->parent or return ();
    my $refaddr = refaddr($self);
    my @c = $parent->_childen_as_list;
    for my $i (1..$#c) {
        if (refaddr($c[$i]) == $refaddr) {
            return @c[0..$i-1];
        }
    }
    ();
}

sub next_sibling {
    my $self = shift;
    my $parent = $self->parent or return undef;
    my $refaddr = refaddr($self);
    my @c = $parent->_childen_as_list;
    for my $i (0..$#c-1) {
        if (refaddr($c[$i]) == $refaddr) {
            return $c[$i-1];
        }
    }
    undef;
}

sub next_siblings {
    my $self = shift;
    my $parent = $self->parent or return ();
    my $refaddr = refaddr($self);
    my @c = $parent->_childen_as_list;
    for my $i (0..$#c-1) {
        if (refaddr($c[$i]) == $refaddr) {
            return @c[$i+1 .. $#c];
        }
    }
    ();
}

1;
# ABSTRACT: Role that provides tree node methods

=head1 DESCRIPTION


=head1 REQUIRED ROLES

L<Role::TinyCommons::Tree::Node>


=head1 PROVIDED METHODS

=head2 descendants => list

Return children and their children, recursively.

=head2 is_first_child => bool

Return true if node is the first child of its parent.

=head2 is_last_child => bool

Return true if node is the last child of its parent.

=head2 is_only_child => bool

Return true if node is the only child of its parent.

=head2 is_nth_child => bool

Return true if node is the I<n>th child of its parent.

=head2 is_nth_last_child => bool

Return true if node is the I<n>th last child of its parent.

=head2 is_first_child_of_type => bool

Return true if node is the first child (of its type) of its parent. For example,
if the parent's children are ():

 node1(T1) node2(T2) node3(T1) node4(T2)

Both C<node1> and C<node2> are first children of their respective type.

=head2 is_last_child_of_type => bool

=head2 is_nth_child_of_type => bool

=head2 is_nth_last_child_of_type => bool

=head2 prev_sibling => obj

=head2 prev_siblings => list

=head2 next_sibling => obj

=head2 next_siblings => list


=head1 SEE ALSO

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>
