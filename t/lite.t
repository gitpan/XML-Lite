####################################################################################:mode=perl:
# Test the methods in the XML::Lite object
#
# TODO: White box assertion testing

$^W = 1;
use strict;
use Test;

BEGIN { $|=1; plan test => 8; }
$@ = undef;

eval "use XML::Lite";
ok( !$@ );

# Get some XML 
my $xml;
eval { $xml = new XML::Lite( \*DATA ) };
ok( !$@ && defined $xml );

# Finding root element 
my $root = $xml->root_element();
if( defined $root ) {
	ok( 1 );
	# Verify root element
	ok( $root->name, 'document' );
} else {
	warn "Could not find a root element.\n";
	ok( 0 ); ok( 0 );
} # end if

# Find element by name 
my $elm = $xml->elements_by_name( 'object' );
if( defined $elm ) {
	ok( 1 );
	# Verify named element
	ok( $elm->name, 'object' );
} else {
	warn "Could not find an element named 'object.'\n";
	ok( 0 ); ok( 0 );
} # end if

# Multiple elements by name 
my @elms = $xml->elements_by_name( 'item' );
if( @elms == 3 ) { 
	ok( 1 );
	# Verify named elements
	ok( $elms[0]->get_content eq 'List item entry' &&
		 $elms[1]->get_content eq 'Another list item entry' &&
		 $elms[2]->get_content eq 'Final list item entry' 
	);
} else {
	warn "elements_by_name('item') had " . @elms . " entries.\n";
	ok( 0 ); ok( 0 );
} # end if


__END__
<?xml version="1.0"?>
<document type="test" description="Test for XML::Lite methods">
	A test of the XML::Lite method interface
	<object name="alice" />
	<list type="properties">
		<item key="first">List item entry</item>
		<item key="second">Another list item entry</item>
		<item key="third">Final list item entry</item>
	</list>
</document>

