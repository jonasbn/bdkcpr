# $Id: pod.t,v 1.1 2007-03-13 19:40:15 jonasbn Exp $ 

use Test::More;

eval "use Test::Pod 1.14";
plan skip_all => 'Test::Pod 1.14 required' if $@;
plan skip_all => 'set TEST_POD to enable' unless $ENV{TEST_POD};

all_pod_files_ok();
