####################################################################################:mode=perl:
# Test different ways of creating an XML::Lite object
#
# TODO: White box assertion testing

$^W = 1;
use strict;
use Test;

BEGIN { $|=1; plan test => 9; }
$@ = undef;

eval "use XML::Lite";
ok( !$@ );

my $xml;
# Reading an XML file with single argument constructor
eval { $xml = new XML::Lite( 'po.xml' ) };
ok( !$@ && defined $xml );

# Reading an XML file with named argument constructor
eval { $xml = new XML::Lite( xml => 'po.xml' ) };
ok( !$@ && defined $xml );

# Reading an XML file with named '-' argument constructor
eval { $xml = new XML::Lite( -xml => 'po.xml' ) };
ok( !$@ && defined $xml );

# Reading an XML file with handle reference
eval { $xml = new XML::Lite( \*DATA ) };
ok( !$@ && defined $xml );

# Reading an XML file with an IO::Handle object
eval "use IO::Handle";
if( $@ ) {
	ok( 0 );
} else {
	ok( 1 );
	my $io = new IO::File( 'po.xml' );
	if( defined $io ) {
		ok( $io );
		eval { $xml = new XML::Lite( $io ) };
		ok( !$@ && defined $xml );
	} else {
		ok( 0 );
	} # end if
} # end if

# Reading an XML file with a scalar value
$xml = eval { new XML::Lite( '
<?xml version="1.0"?>
<document type="test" description="Test for XML::Lite methods">
	A test of the XML::Lite method interface
	<object name="alice" />
	<list type="properties">
		<item key="first">List item entry</item>
	</list>
</document>
' ) };
ok( !$@ && defined $xml );



__END__
<?xml version="1.0"?>
<document type="test" description="Test for XML::Lite methods">
	A test of the XML::Lite method interface
	<object name="alice" />
	<list type="properties">
		<item key="first">List item entry</item>
	</list>
</document>

