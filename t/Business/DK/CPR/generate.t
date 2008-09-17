# $Id: calculate.t,v 1.1 2006/02/20 21:38:48 jonasbn Exp $

use strict;
use Test::More tests => 10000;
use Test::Exception;

#Test 1, load test
use_ok('Business::DK::CPR', qw(generate validate2001));

#Test 2
dies_ok{generate()} 'no arguments';

#Test 3
dies_ok{generate(1501721)} 'too long';

#Test 4
is(generate(150172, 'female'), 4996, 'Valid female serial numbers series 1, 2 and 3, scalar context');

#Test 5
is(generate(150172, 'male'), 4997, 'Valid male serial numbers series 1, 2 and 3, scalar context');

#Test 6
is(generate(150172), 9993, 'Valid male and female serial numbers series 1, 2 and 3, scalar context');


#Test 5
ok(my @cprs = generate(150172), 'Valid male and female serial numbers series 1, 2 and 3, list context');

foreach (@cprs) {
	ok(validate2001($_), "Validating: $_");
}
