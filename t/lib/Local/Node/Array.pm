package # hide from PAUSE
    Local::Node::Array;

use Class::Build::Array::Glob;

has id       => (is=>'rw');
has parent   => (is=>'rw');
has children => (is=>'rw', glob=>1);

use Role::Tiny::With;

with 'Role::TinyCommons::Tree::Node';
with 'Role::TinyCommons::Tree::NodeMethods';
with 'Role::TinyCommons::Tree::FromStruct';

1;
