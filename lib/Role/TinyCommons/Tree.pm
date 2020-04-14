package Role::TinyCommons::Tree;

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Roles related to object tree

=head1 DESCRIPTION

This distribution provides several roles you can use to create a tree class. The
roles are designed for maximum reusability and minimum clashes with your
existing class.

To create a tree class, all you need to do is apply the
L<Role::TinyCommons::Tree::Node> role:

 use Role::Tiny::With;
 with 'Role::TinyCommons::Tree::Node';

The Tree::Node common role just requires you to have two methods: C<parent>
(which should return parent node object) and C<children> (which should return a
list or arrayref of children node objects).

Utility methods such as C<descendants>, C<walk>, C<is_first_child> and so on are
separated to L<Role::TinyCommons::Tree::NodeMethods> which you can apply if you
want.

The actual methods in Role::TinyCommons::Tree::NodeMethods are actually
implemented in L<Code::Includable::Tree::NodeMethods>, so you can import them to
your class manually or just call the routines as a normal function call if you
do not want to involve L<Role::Tiny>. See an example of this usage in
L<Data::CSel>.


=head1 SEE ALSO

There are some other general purpose tree modules CPAN, for example
L<Tree::Simple> or L<Data::Tree>, but at the time of this writing there isn't a
tree role.
