[![CPAN version](https://badge.fury.io/pl/Business-DK-CPR.svg)](http://badge.fury.io/pl/Business-DK-CPR)
[![Build Status](https://travis-ci.org/jonasbn/bdkcpr.svg?branch=master)](https://travis-ci.org/jonasbn/bdkcpr)
[![Coverage Status](https://coveralls.io/repos/jonasbn/bdkcpr/badge.png)](https://coveralls.io/r/jonasbn/bdkcpr)

# NAME

Business::DK::CPR - Danish CPR (SSN) number generator/validator

# VERSION

This documentation describes version 0.15

# SYNOPSIS

    use Business::DK::CPR qw(validate);

    my $rv;
    eval { $rv = validate(1501721111); };

    if ($@) {
        die "Code is not of the expected format - $@";
    }

    if ($rv) {
        print 'CPR is valid';
    } else {
        print 'CPR is not valid';
    }

    use Business::DK::CPR qw(calculate);

    my @cprs = calculate(150172);

    my $number_of_valid_cprs = calculate(150172);


    #Using with Params::Validate
    #See also examples/

    use Params::Validate qw(:all);
    use Business::DK::CPR qw(validateCPR);

    sub check_cpr {
        validate( @_,
        { cpr =>
            { callbacks =>
                { 'validate_cpr' => sub { validateCPR($_[0]); } } } } );

        print $_[1]." is a valid CPR\n";

    }

# DESCRIPTION

CPR stands for Central Person Registration and is the social security number
used in Denmark.

# SUBROUTINES AND METHODS

All methods are exported by explicit request. None are exported implicitly.

## validate

This function checks a CPR number for validity. It takes a CPR number as
argument and returns:

- 1 (true) for valid male CPR number
- 2 (true) for a valid female CPR number
- 0 (false) for invalid CPR number

It dies if the CPR number is malformed or in any way unparsable, be aware that
the 6 first digits are representing a date (SEE: [\_checkdate](#_checkdate) function below).

In brief, the date indicate the person's birthday, the last 4 digits are
representing a serial number and control cipher.

For a more thorough discussion on the format of CPR numbers please refer to the
[SEE ALSO](#see-also) section.

[validate1968](#validate1968) is the old form of the CPR number. It is validated
using modulus 11.

The new format introduced in 2001 (put to use in 2007, hence the name used
throughout this package) can be validated using [validate2007](#validate2007) and
generate using [generate2007](#generate2007).

The [validate](#validate) subroutine wraps both validators and checks using against both.

The [generate](#generate) subroutine wraps both generators and accumulated the results.

NB! it is possible to make fake CPR numbers that appear valid, please see
MOTIVATION and the ["calculate"](#calculate) function.

[validate](#validate) is also exported as: [validateCPR](#validatecpr), which is less imposing.

## validateCPR

Better name for export. This is just a wrapper for ["validate"](#validate)

## validate1968

Validation against the original CPR algorithm introduced in 1968.

## validate2007

Validation against the CPR algorithm introduced in 2007.

## generate

This is a wrapper around calculate, so the naming is uniform to
[Business::DK::CVR](https://metacpan.org/pod/Business::DK::CVR)

This function takes an integer representing a date and calculates valid CPR
numbers for the specified date. In scalar context returns the number of valid
CPR numbers possible and in list context a list of valid CPR numbers.

If the date is malformed or in any way invalid or unspecified the function dies.

## generate1968

Specialized generator for [validate1968](#validate1968) compatible CPR numbers. See: [generate](#generate)

## generate2007

Specialized generator for [validate2007](#validate2007) compatible CPR numbers. See: [generate](#generate)

## calculate

See [generate](#generate) and [generate1968](#generate1968). This is the old name for [generate1968](#generate1968).
It is just kept for backwards compatibility and it calls [generate](#generate).

## merge

Mimics [Hash::Merge](https://metacpan.org/pod/Hash::Merge)'s [merge](https://metacpan.org/pod/Hash::Merge#merge) function. Takes two references to
hashes and returns a single reference to a hash containing the merge of the two
with the left parameter having precedence. The precedence has not meaning on
the case in this module, but then the behaviour is documented.

# PRIVATE FUNCTIONS

## \_length

This function validates the length of the argument, it dies if the argument
does not fit within the boundaries specified by the arguments provided:

The **\_length** function takes the following arguments:

- number (mandatory), the number to be validated
- length required of number (mandatory)

## \_assertdate

This subroutine takes a digit integer representing a date in the format: DDMMYY.

The date is checked for definedness, contents and length and finally, the
correctness of the date.

The subroutine returns 1 indicating true upon successful assertion or
dies upon failure.

## \_checkdate

This subroutine takes a 6 digit integer representing a date in the format: DDMMYY.

The subroutine returns 1 indicating true upon successful check or
dies upon failure.

## \_assert\_controlnumber

This subroutine takes an 10 digit integer representing a complete CPR.
The CPR is tested for definedness, contents and length.

The subroutine returns 1 indicating true upon successful assertion or
dies upon failure.

# EXPORTS

Business::DK::CPR exports on request:

- [validate](#validate)
- [validateCPR](#validatecpr)
- [validate1968](#validate1968)
- [validate2007](#validate2007)
- [calculate](#calculate)
- [generate](#generate)
- [\_checkdate](#_checkdate)

# DIAGNOSTICS

- 'argument for birthdate should be provided', a data parameter has to be
provided.

    This error is thrown from [\_checkdate](#_checkdate), which is used for all general parameter
    validation.

- 'argument: &lt;birthdate> could not be parsed', the date provided is not
represented by 6 digits (see also below).

    This error is thrown from [\_checkdate](#_checkdate), which is used for all general parameter
    validation.

- 'argument: &lt;birthdate> has to be a valid date in the format: ddmmyy',
the date format used for CPR numbers has to adhere to ddmmyy in numeric format
like so: 311210, day in a two digit representation: 01-31, month also two digit
representation: 01-12 and finally year in a two digit representation: 00-99.

    This error is thrown from [\_checkdate](#_checkdate), which is used for all general parameter
    validation.

- 'Unknown gender: &lt;gender>, assuming no gender', this is just a warning
issued if a call to [generate2007](#generate2007) has not been provided with a gender
parameter

# DEPENDENCIES

- [Business::DK::CVR](https://metacpan.org/pod/Business::DK::CVR)
- [Exporter](https://metacpan.org/pod/Exporter)
- [Carp](https://metacpan.org/pod/Carp)
- [Test::Exception](https://metacpan.org/pod/Test::Exception)
- [Date::Calc](https://metacpan.org/pod/Date::Calc)
- [Tie::IxHash](https://metacpan.org/pod/Tie::IxHash)

# CONFIGURATION AND ENVIRONMENT

This module requires no special configuration or environment.

# INCOMPATIBILITIES

There are no known incompatibilies in this package.

# TODO

- Nothing to do, please refer to the distribution TODO file for the general
wish list and ideas for future expansions and experiments.

# TEST AND QUALITY

The distribution uses the TEST\_AUTHOR environment variable to run some
additional tests, which are interesting to the the author, these can be disabled
by not defining or setting the environment variable to something not positive.

The distribution uses the TEST\_CRITIC environment variable to control
[Perl::Critic](https://metacpan.org/pod/Perl::Critic) tests.

## STANDARD TESTS

Here are listed the standard tests, recommended for all CPAN-like distributions.
The matrix lists what flags are required to run the specific test.

                    NONE TEST_AUTHOR TEST_CRITIC TEST_POD
    --------------- ---- ----------- ----------- --------
    00.load.t         *
    changes.t         *
    critic.t                              *
    kwalitee.t                *
    pod-coverage.t                                   *
    pod.t                                            *
    prerequisites.t           *
    --------------- ---- ----------- ----------- --------

All of the above tests are actually boilerplates and are maintained as separate
components.

## TEST COVERAGE

Coverage of the test suite is at 89.1% for release 0.04, the coverage report
was generated with the TEST\_AUTHOR flag enabled (SEE: [TEST AND QUALITY](#test-and-quality))

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    blib/lib/Business/DK/CPR.pm    74.2   41.9   53.8  100.0  100.0   72.9   70.3
    .../Class/Business/DK/CPR.pm   89.1   85.7   77.8   71.4  100.0   27.1   86.0
    Total                          77.6   50.0   63.6   91.3  100.0  100.0   74.1
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

## PERL::CRITIC

This section describes use of [Perl::Critic](https://metacpan.org/pod/Perl::Critic) from a perspective of documenting
additions and exceptions to the standard use.

- [Perl::Critic::Policy::Miscellanea::ProhibitTies](https://metacpan.org/pod/Perl::Critic::Policy::Miscellanea::ProhibitTies)

    This package utilizes [Tie::IxHash](https://metacpan.org/pod/Tie::IxHash) (SEE: [DEPENDENCIES](#dependencies)), this module
    relies on tie.

- [Perl::Critic::Policy::NamingConventions::NamingConventions::Capitalization](https://metacpan.org/pod/Perl::Critic::Policy::NamingConventions::NamingConventions::Capitalization)

    CPR is an abbreviation for 'Centrale Person Register' (Central Person Register)
    and it is kept in uppercase.

- [Perl::Critic::Policy::NamingConventions::ProhibitMixedCaseSubs](https://metacpan.org/pod/Perl::Critic::Policy::NamingConventions::ProhibitMixedCaseSubs) deprecated by the policy above.
- [Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma)

    Constants are good in most cases, see also:
    [http://logicLAB.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma](http://logicLAB.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma)

- [Perl::Critic::Policy::ValuesAndExpressions::ProhibitMagicNumbers](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::ProhibitMagicNumbers)

    Some values and boundaries are defined for certain intervals of numbers, these
    are currently kept as is. Perhaps with a refactoring of the use of constants to
    use of [Readonly](https://metacpan.org/pod/Readonly) will address this.

# BUGS AND LIMITATIONS

No known bugs at this time.

Business::DK::CPR has some obvious flaws. The package can only check for
validity and format, whether a given CPR has been generated by some random
computer program and just resemble a CPR or whether a CPR has ever been assigned
to a person is not possible without access to central CPR database an access,
which is costly, limited and monitored.

There are no other known limitations apart from the obvious flaws in the CPR
system (See: [SEE ALSO](#see-also)).

# BUG REPORTING

# BUG REPORTING

Please report issue via GitHub

    L<https://github.com/jonasbn/perl-business-dk-cpr/issues>

Alternatively report issues via CPAN RT:

    L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-DK-CPR>

or by sending mail to

    bug-Business-DK-CPR@rt.cpan.org

# SEE ALSO

- [http://www.cpr.dk/](http://www.cpr.dk/)
- [Class::Business::DK::CPR](https://metacpan.org/pod/Class::Business::DK::CPR)
- [Data::FormValidator::Constraints::Business::DK::CPR](https://metacpan.org/pod/Data::FormValidator::Constraints::Business::DK::CPR)
- [Business::DK::PO](https://metacpan.org/pod/Business::DK::PO)
- [Business::DK::CVR](https://metacpan.org/pod/Business::DK::CVR)
- [http://logicLAB.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma](http://logicLAB.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma)

# MOTIVATION

I write business related applications. So I need to be able to validate CPR
numbers once is a while, hence the validation function.

The calculate/generate1968 function is however a different story. When I was in
school we where programming in Comal80 and some of the guys in my school created
lists of CPR numbers valid with their own birthdays. The thing was that if you
got caught riding the train without a valid ticket the personnel would only
check the validity of you CPR number, so all you have to remember was your
birthday and 4 more digits not being the actual last 4 digits of your CPR
number.

I guess this was the first hack I ever heard about and saw - I never tried it
out, but back then it really fascinated me and my interest in computers was
really sparked.

# AUTHOR

- Jonas B., (jonasbn) - `<jonasbn@cpan.org>`

# ACKNOWLEDGEMENTS

- Karen Etheridge (ETHER)
- Neil Bowers (NEILB)

# COPYRIGHT

Business-DK-CPR and related is (C) by Jonas B., (jonasbn) 2006-2020

# LICENSE

Business-DK-CPR is released under the Artistic License 2.0
