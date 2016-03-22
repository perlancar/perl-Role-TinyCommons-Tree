#!perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin/lib";

use Test::More 0.98;
use TN;
use TN2;

my $tree = TN->new_from_struct({
    id => 'root', _children => [
        {id=>'a', _class => 'TN2'},
        {id=>'b', _children => [
            {id => 'c'},
            {id => 'd'},
        ]},
    ]});

my $exp_tree = do {
    my $root = TN->new(id=>'root', children=>[]);
    my $a = TN2->new(id=>'a', parent=>$root, children=>[]);
    my $b = TN ->new(id=>'b', parent=>$root, children=>[]);
    my $c = TN ->new(id=>'c', parent=>$b, children=>[]);
    my $d = TN ->new(id=>'d', parent=>$b, children=>[]);
    $root->children($a, $b);
    $b->children($c, $d);
    $root;
};

is_deeply($tree, $exp_tree) or do {
    diag "tree: ", explain $tree;
    diag "expected tree: ", explain $exp_tree;
};

# XXX test _args
# XXX test _constructor

done_testing;
