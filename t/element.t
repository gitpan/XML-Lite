####################################################################################:mode=perl:
# General tests of XML::Lite::Element methods
#
# TODO: White box assertion test

$^W = 1;
use strict;
use Test;

BEGIN { $|=1; plan test => 23; }
$@ = undef;

eval "use XML::Lite";
ok( !$@ );

# Reading an XML file 
my $xml;
eval { $xml = new XML::Lite( \*DATA ) };
ok( !$@ && defined $xml );

#use Data::Dumper;
#warn "\n\n" . Dumper( $xml->{tree} ) . "\n\n";
#warn "\n\n" . $xml->_dump_tree . "\n";

# Find element to play with 
my $elm = $xml->elements_by_name( 'list' );
unless( defined $elm ) {
	ok( 0 );
	# Fail all $elm tests unless $elm is defined
	ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 );
} else {
	ok( 1 );

	# Verify element content 
	ok( $elm->get_content, '
		This is a list of enties.
		<item key="first">List item entry</item>
		<item key="second">Another list item entry</item>
		<item key="third">Final list item entry</item>
	' );
	
	# Attributes of an element 
	my %attrs = $elm->attributes();
	ok( %attrs );
	
	# Verify attributes 
	ok( %attrs && $attrs{type} eq 'properties' );
	
	# Attribute by name 
	my $val = $elm->attribute( 'type' );
	ok( defined $val );
	
	# Verify named attribute 
	ok( $val eq 'properties' );
	
	# Getting child list
	my @children = $elm->get_children();
	if( @children == 3 ) {
		ok( 1 );
		# Verfiy children
		ok( $children[0]->get_content(), 'List item entry' );
		ok( $children[1]->get_content(), 'Another list item entry' );
		ok( $children[2]->get_content(), 'Final list item entry' );
	} else {
		warn "Had " . @children . " children, expected 3.\n";
		ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 );
	} # end if
	
	# Getting text 
	my $t = $elm->get_text();
	ok( $t, '
		This is a list of enties.
		
		
		
	' ) ||
		 warn "Got '$t' as text.\n";

} # end if

#
# Find the root element to play with, too
# Any methods that deal with ->{parent} need to be
# tested on $root (which has no parent)
# 
my $root = $xml->root_element();
unless( defined $root ) {
	warn "Could not get root element.\n";
	ok( 0 );
	# Fail all $root tests, too
	ok( 0 );
} else {
	my @children = $root->get_children();
	if( @children == 3 ) {
		ok( 1 );
		# Verfiy children
		ok( $children[0]->get_name(), 'object' ) || warn "First child is <" . $children[0]->get_name . ">.\n";
		ok( $children[1]->get_name(), 'list' ) || warn "Second child is <" . $children[1]->get_name . ">.\n";
		ok( $children[2]->get_name(), 'data' ) || warn "Third child is <" . $children[2]->get_name . ">.\n";
	} else {
		warn "Had " . @children . " children, expected 3.\n";
		ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 );
	} # end if
} # end if

#
# Do some test on CDATA-containing elements too.
#
$elm = $xml->elements_by_name( 'data' );
if( defined $elm ) {
	ok( 1 );
	# Verify CDATA content
	my $c = $elm->get_content;
	ok( $c, '
	<![CDATA[
	~!@#$%^&*()_+`1234567890-=
	QWERTYUIOP{}|qwertyuiop[]\
	ASDFGHJKL:"asdfghjkl;\'
	ZXCVBNM<>?zxcvbnm,./
	]]>
	' ) || warn "Got '$c' for CDATA content.\n";
} else {
	warn "Could not get <data> element.\n";
	ok( 0 ); ok( 0 );
} # end if

#
# Also test content-managing methods on an element with no content
#
$elm = $xml->elements_by_name( 'object' );
if( defined $elm ) {
	ok( 1 );

	# Try content 
	my $c = $elm->get_content;
	ok( $c, '' ) || warn "Got '$c' for <object> content.\n";
	
	# Try children 
	my @c = $elm->get_children;
	ok( @c, 0 ) || warn "Got @c children for <object>.\n";
	
	# Try text 
	$c = $elm->get_text;
	ok( $c, '' ) || warn "Got '$c' for <object> text.\n";
	
} else {
	warn "Could not get <object> element.\n";
	ok( 0 ); ok( 0 ); ok( 0 ); ok( 0 );
} # end if

###############################################
# This is the data used for the tests
###############################################

__END__
<?xml version="1.0"?>
<document type="test" description="Test for XML::Lite methods">
	A test of the XML::Lite::Element object
	<object name="alice"/>
	<list type="properties">
		This is a list of enties.
		<item key="first">List item entry</item>
		<item key="second">Another list item entry</item>
		<item key="third">Final list item entry</item>
	</list>
	<data>
	<![CDATA[
	~!@#$%^&*()_+`1234567890-=
	QWERTYUIOP{}|qwertyuiop[]\
	ASDFGHJKL:"asdfghjkl;'
	ZXCVBNM<>?zxcvbnm,./
	]]>
	</data>
</document>

