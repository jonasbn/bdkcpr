package Class::Business::DK::CPR;

# $Id$

use strict;
use warnings;
use Class::InsideOut qw( private register id );
use Carp qw(croak);
use English qw(-no_match_vars);

use Business::DK::CPR qw(validate1968 validate2007);

our $VERSION = '0.01';

private number => my %number;     # read-only accessor: number()
private gender => my %gender;     # read-only accessor: gender()
private algorithm => my %algorithm;     # read-only accessor: algorithm()

sub new {
    my ($class, $number) = @_;
    
    my $self = \( my $scalar );
    
    bless $self, $class;
    
    register( $self );
    
    if ($number) {
        $self->set_number($number);
    } else {
        croak 'You must provide a CPR number';
    }

    return $self;
}

sub number { $number{ id $_[0] } }

sub get_number { $number{ id $_[0] } }

sub set_number {
    my ($self, $unvalidated_cpr) = @_;
    
    my $rv = 0;
    my @algorithms;
    
    if ($unvalidated_cpr) {
        eval { $rv = validate1968($unvalidated_cpr); 1; };

        if ( $rv && $rv % 2 ) {
            push @algorithms, '1968';
        } elsif ($rv) {
            push @algorithms, '1968';
        }

        eval { $rv = validate2007($unvalidated_cpr); 1; };

        if ( $rv && $rv % 2 ) {
            push @algorithms, '2007';
        } elsif ($rv) {
            push @algorithms, '2007'; 
        }    
        
        if ($EVAL_ERROR or not $rv) {
            croak 'Invalid CPR number parameter';
        
        } else {
            
            $number{ id $self } = $unvalidated_cpr;
            $gender{ id $self } = $rv;
            $algorithm{ id $self } = (join ', ', @algorithms);
            
            return 1;
        }
    } else {
        croak 'You must provide a CPR number';
    }
}

sub gender { $gender{ id $_[0] } }

sub get_gender { $gender{ id $_[0] } }

sub algorithm { $algorithm{ id $_[0] } }

sub get_algorithm { $algorithm{ id $_[0] } }

1;

__END__

=pod

=head1 NAME

Class::Business::DK::CPR - Danish CPR number class 

=head1 VERSION

The documentation describes version 0.01 of Class::Business::DK::CPR

=head1 SYNOPSIS

    use Class::Business::DK::CPR;

    my $cvr = Class::Business::DK::CPR->new(1501729473);

=head1 DESCRIPTION

This module exposes a set of subroutines which are compatible with
L<Data::FormValidator>. The module implements contraints as specified in
L<Data::FormValidator::Constraints>.

=head1 SUBROUTINES AND METHODS

=head2 new

This is the constructor, it takes a single mandatory parameter, which should be
a valid CPR number, if the parameter provided is not valid, the constructor
dies.

=head2 get_number

This method/accessor returns the CPR number associated with the object.

=head2 number

Alias for the L</get_number> accessor, see above.

=head2 set_number

This method/mutator sets the a CPR number for a given CPR object, it takes a
single mandatory parameter, which should be a valid CPR number, returns true (1)
upon success else it dies.

=head2 algorithm

Accessor returning a string representing what algorithms used to validate the CPR object.

=head2 get_algorithm

See L</algorithm>

=head2 gender

Accessor returning an integer representing the gender indicated by the CPR object.

=over

=item * 1, male

=item * 1, female

=back

=head2 get_gender

See L</gender>

=head1 DIAGNOSTICS

=over

=item * You must provide a CPR number, thrown by L</set_number> and L</new> if
no argument is provided.

=item * Invalid CPR number parameter, thrown by L</new> and L</set_number> if
the provided argument is not a valid CPR number.

=back

=head1 CONFIGURATION AND ENVIRONMENT

The module requires no special configuration or environment to run.

=head1 DEPENDENCIES

=over

=item * L<Class::InsideOut>

=item * L<Business::DK::CPR>

=back

=head1 INCOMPATIBILITIES

The module has no known incompatibilities.

=head1 BUGS AND LIMITATIONS

The module has no known bugs or limitations

=head1 TEST AND QUALITY

Coverage of the test suite is at 98.3%

=head1 TODO

=over

=item * Please refer to the TODO file

=back

=head1 SEE ALSO

=over

=item * L<Business::DK::CPR>

=back

=head1 BUG REPORTING

Please report issues via CPAN RT:

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-DK-CPR

or by sending mail to

  bug-Business-DK-CPR@rt.cpan.org
  
=head1 AUTHOR

Jonas B. Nielsen, (jonasbn) - C<< <jonasbn@cpan.org> >>

=head1 COPYRIGHT

Business-DK-CPR and related is (C) by Jonas B. Nielsen, (jonasbn) 2006-2009

=head1 LICENSE

Business-DK-CPR and related is released under the artistic license

The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution
(http://www.perl.com/language/misc/Artistic.html).

=cut
