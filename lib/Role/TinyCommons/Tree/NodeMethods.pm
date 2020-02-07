package Role::TinyCommons::Tree::NodeMethods;

# DATE
# VERSION

use Role::Tiny;
use Role::Tiny::With;

with 'Role::TinyCommons::Tree::Node';

BEGIN {
    no strict 'refs';
    require Code::Includable::Tree::NodeMethods;
    for (grep {/\A[a-z]\w+\z/} keys %Code::Includable::Tree::NodeMethods::) {
        *{$_} = \&{"Code::Includable::Tree::NodeMethods::$_"};
    }
}

1;
# ABSTRACT: Role that provides tree node methods

=head1 DESCRIPTION


=head1 REQUIRED ROLES

L<Role::TinyCommons::Tree::Node>


=head1 PROVIDED METHODS

#INSERT_BLOCK: Code::Includable::Tree::NodeMethods methods


=head1 SEE ALSO

L<Code::Includable::Tree::FromStruct> if you want to use the routines in this
module without consuming a role.

L<Role::TinyCommons::Tree::Node>

L<Role::TinyCommons>
