package Code::Includable::Tree::NodeMethods;

# DATE
# VERSION

# we must contain no other functions

use Scalar::Util ();

# like children, but always return list
sub _children_as_list {
    my $self = shift;
    my @c = $self->children;
    @c = @{$c[0]} if @c==1 && ref($c[0]) eq 'ARRAY';
    @c;
}

sub descendants {
    my $self = shift;
    my @c = _children_as_list($self);
    (@c, map { descendants($_) } @c);
}

sub walk {
    my ($self, $code) = @_;
    for (descendants($self)) {
        $code->($_);
    }
}

sub first_node {
    my ($self, $code) = @_;
    for (descendants($self)) {
        return $_ if $code->($_);
    }
    undef;
}

sub is_first_child {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = _children_as_list($parent);
    @c && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[0]);
}

sub is_last_child {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = _children_as_list($parent);
    @c && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[-1]);
}

sub is_only_child {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = _children_as_list($parent);
    @c==1;# && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[0]);
}

sub is_nth_child {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = _children_as_list($parent);
    @c >= $n && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[$n-1]);
}

sub is_nth_last_child {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my @c = _children_as_list($parent);
    @c >= $n && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[-$n]);
}

sub is_first_child_of_type {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } _children_as_list($parent);
    @c && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[0]);
}

sub is_last_child_of_type {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } _children_as_list($parent);
    @c && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[-1]);
}

sub is_only_child_of_type {
    my $self = shift;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } _children_as_list($parent);
    @c == 1; # && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[0]);
}

sub is_nth_child_of_type {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } _children_as_list($parent);
    @c >= $n && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[$n-1]);
}

sub is_nth_last_child_of_type {
    my ($self, $n) = @_;
    my $parent = $self->parent;
    return 0 unless $parent;
    my $type = ref($self);
    my @c = grep { ref($_) eq $type } _children_as_list($parent);
    @c >= $n && Scalar::Util::refaddr($self) == Scalar::Util::refaddr($c[-$n]);
}

sub prev_sibling {
    my $self = shift;
    my $parent = $self->parent or return undef;
    my $refaddr = Scalar::Util::refaddr($self);
    my @c = _children_as_list($parent);
    for my $i (1..$#c) {
        if (Scalar::Util::refaddr($c[$i]) == $refaddr) {
            return $c[$i-1];
        }
    }
    undef;
}

sub prev_siblings {
    my $self = shift;
    my $parent = $self->parent or return ();
    my $refaddr = Scalar::Util::refaddr($self);
    my @c = _children_as_list($parent);
    for my $i (1..$#c) {
        if (Scalar::Util::refaddr($c[$i]) == $refaddr) {
            return @c[0..$i-1];
        }
    }
    ();
}

sub next_sibling {
    my $self = shift;
    my $parent = $self->parent or return undef;
    my $refaddr = Scalar::Util::refaddr($self);
    my @c = _children_as_list($parent);
    for my $i (0..$#c-1) {
        if (Scalar::Util::refaddr($c[$i]) == $refaddr) {
            return $c[$i+1];
        }
    }
    undef;
}

sub next_siblings {
    my $self = shift;
    my $parent = $self->parent or return ();
    my $refaddr = Scalar::Util::refaddr($self);
    my @c = _children_as_list($parent);
    for my $i (0..$#c-1) {
        if (Scalar::Util::refaddr($c[$i]) == $refaddr) {
            return @c[$i+1 .. $#c];
        }
    }
    ();
}

1;
# ABSTRACT: Tree node routines

=for Pod::Coverage .+

=head1 DESCRIPTION

The routines in this module can be imported manually to your tree class/role.
The only requirement is that your tree class supports C<parent> and C<children>
methods.

The routines can also be called as a normal function call, with your tree node
object as the first argument, e.g.:

 next_siblings($node)