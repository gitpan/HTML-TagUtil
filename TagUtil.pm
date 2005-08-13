package HTML::TagUtil;

##HTML::TagUtil

use 5.008001; #Need 5.8.1.
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use HTML::TagUtil ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
tagged
opentagged
closetagged
tagpos
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } ); #allow all public methods to export.

our @EXPORT = qw(
tagged	
opentagged
closetagged
tagpos
);

our $VERSION = '1.42';

#class attributes.


#$file will someday be available for checking. 
my $file;


###########################
#####Class Constructor#####
###########################

sub new (;) {
   my $self = {};
   $file = shift;
   bless $self, 'HTML::TagUtil';
   return $self;
}   

####################################
##########PRIVATE METHODS###########
####################################

##
## Private method that does the actual matching for tagged.
##

sub _is_fully_tagged {
   my $arg = shift || $_;
   if ($arg =~ /<(([a-zA-Z])+((\s+\w+)=?("?\w+"?)?){0,})( (\/)?)?\s*>.*<\/(([a-zA-Z])+((\s+\w+)=?("?\w+"?)?){0,})( (\/)?)?\s*/) {
      return 1;
   } else {
      return 0;
   }
}   

##
## Private method that matches for opentagged.
## 

sub _is_open_tagged {
   my $arg = shift || $_;
   if ($arg =~ /<(([a-zA-Z])+((\s+\w+)=?("?\w+"?)?){0,})( (\/)?)?\s*>/) {
      return 1;
   } else {
      return 0;
   }
}   

## 
## Private method that matches for closetagged.
##

sub _is_close_tagged {
   my $arg = shift || $_;
   if ($arg =~ /<\/([a-zA-Z])+\s*>/) {
      return 1;
   } else {
      return 0;
   }
}

##
## Private method that matches for empty.
##

sub _is_empty_element {
   my $arg = shift || $_;
   if ($arg =~ /<(([a-zA-Z])+((\s+\w+)=?("?.+"?)?){0,})(\s*\/)\s*>/) {
      return 1;
    } else {
      return 0;
   }
}   


####################################
##########PUBLIC METHODS############
####################################

sub tagged {
   my $self = shift;
   my $string = shift || $_; #string to look at.
   ##check to see if it has both a start tag and an end tag.
   if (_is_fully_tagged ($string)) {
      ##set some variables just in case.
      my $tag       = $1;
      my $element   = $2;
      my $fullattr  = $3;
      my $attrname  = $4;
      my $attrvalue = $5;
      return 1;
   } else {
      return 0;
   }   
}

sub opentagged {
   my $self = shift;
   my $string = shift || $_; #string to look at.
   ##check to see if it at least has a start tag.
   if (_is_open_tagged ($string)) {
      ##regexp vars.
      my $tag       = $1;
      my $element   = $2;
      my $fullattr  = $3;
      my $attrname  = $4;
      my $attrvalue = $5;
      return 1;
   } else {
      return 0;
   }
}   

sub closetagged {
   my $self = shift;
   my $string = shift || $_; #string to look at.
   ##check to see if it at least has an end tag.
   if (_is_close_tagged ($string)) {
    return 1;
   } else {
    return 0;
   }
} 

sub tagpos {
   my $self = shift;
   my $string = shift || $_; #string to look at.
   my $tag = shift || $_;
   my $offset = shift || 0;
   $tag = '<' . $tag . '>' if ($tag !~ /(<(([a-zA-Z])+((\s+\w+)=?("?\w+"?)?){0,})( (\/)?)?\s*>|<\/([a-zA-Z])+\s*>)/);
   return index ($string, $tag, $offset) + 1;
}

sub empty {
   my $self = shift;
   my $string = shift || $_;
   if (_is_empty_element ($string)) {
      return 1;
   } else {
      return 0;
   }
}   
  
1;

__END__

=head1 NAME

HTML::TagUtil - Perl Utility for HTML tags

=head1 SYNOPSIS

  use HTML::TagUtil;
  $_ = "<i>Now!</i>";
  
  my $tagger = HTML::TagUtil->new();
  print "Tagged!"       if ($tagger->tagged());
  print "Open Tagged!"  if ($tagger->opentagged());
  print "Close Tagged!" if ($tagger->closetagged());

=head1 DESCRIPTION

HTML::TagUtil is a perl module providing a
Object-Oriented interface to
getting information about HTML/SGML/XML
tags and their attributes and content.

=head1 METHODS

=over 3

=item new

B<new> is the constructor for HTML::TagUtil.
it can be called like this:
 my $tagger = new HTML::TagUtil ();
 my $tagger = HTML::TagUtil->new();

also, you can supply an optional
argument as the string to use if none is given
to one of the methods. if you do not
supply it here, it defaults to the default variable
($_) here and everywhere else.

=item $tagger->tagged

B<tagged> checks to see if a string has both an end tag and a start tag in it.
if it does, it returns true,
if not, it returns false.
a few examples would be: 

 $_ = "<html>html stuff</html>";
 print "Tagged" if ($tagger->tagged); #prints "Tagged"
 $_ = "<html>html stuff";
 print "Tagged" if ($tagger->tagged); #prints nothing.
 $_ = "html stuff</html>";
 print "Tagged" if ($tagger->tagged); #prints nothing.
 $_ = "<html blah="blah_blah">html stuff</html>";
 print "Tagged" if ($tagger->tagged); #prints "Tagged"

tagged can handle attributes and empty elements.

=item $tagger->opentagged

B<opentagged> checks to see if a string has one or more start tags in it,
ignoring whether it has an end tag in it or not.
if it does have a start tag, it returns true.
otherwise, it returns false.
some examples are:

 $_ = "<html>stuff";
 print "Open Tagged" if ($tagger->opentagged); #prints "Open Tagged"
 $_ = "<html>stuff</html>";
 print "Open Tagged" if ($tagger->opentagged); #prints "Open Tagged"
 $_ = "stuff</html>";
 print "Open Tagged" if ($tagger->openedtagged); prints nothing
 $_ = "<html some="cool" attributes="yes">stuff";
 print "Open Tagged" if ($tagger->opentagged); #prints "Open Tagged"
 
opentagged can handle attributes as well as empty elements.

=item $tagger->closetagged

B<closetagged> checks to see if a string has one or more end tags in it,
ignoring whether it has a start tag or not.
if it does have an end tag, it returns true,
otherwise, it returns false.
some examples are:

 $_ = "stuff</html>";
 print "Close Tagged" if ($tagger->closetagged); #prints "Closed Tagged" 
 $_ = "<html>stuff</html>";
 print "Close Tagged" if ($tagger->closetagged); #prints "Closed Tagged"
 $_ = "<html>stuff";
 print "Closed Tagged" if ($tagger->closetagged); #prints nothing.
 $_ = "stuff</html stuff="cool">";
 print "Closed Tagged" if ($tagger->closetagged); #prints nothing.

closedtagged can not handle attributes or empty elements.
because end tags can't have attributes or be empty.

=item $tagger->tagpos

B<tagpos> returns the position that a certain tag is at in
a string, 0 meaning that it is not there, and
1 meaning the first position in the string and so on.
It will add the < and the > on to the tag you specify if you do
not.
some examples are:

 $_ = "<html>stuff</html>"; 
 my $pos = $tagger->tagpos ($_, '<html>', 0);
 print $pos; #prints "1"
 $_ = "<html>stuff</html>";
 my $pos = $tagger->tagpos ($_, 'html', 0);
 print $pos; #prints "1" because the < and > get added on to the 'html'.
 $_ = "stuff<html>";
 my $pos = $tagger->tagpos ($_, '<html>', 0);
 print $pos; #prints "6" because counting starts from one for this.
 $_ = "stuff<html>";
 my $pos = $tagger->tagpos ($_, 'html', 0);
 print $pos; #prints "6" again because counting starts from one for this.
 
 tagpos can handle anything that is surrounded by < and >.

=item $tagger->empty

B<empty> checks to see if the specified string contains
an empty element in it. That is, one that ends with " />".
it returns true if it does have one in it, or false otherwise.
some examples would be:

 $_ = "<img />";
 print "Empty" if (empty); #prints "Empty"
 $_ = "<img/>";
 print "Empty" if (empty); #prints "Empty"
 $_ = "<img></img>";
 print "Empty" if (empty); #prints nothing
 $_ = "<img src=\"http://www.example.com/cool.gif\" />";
 print "Empty" if (empty); #prints "Empty"
 
empty can handle attributes and varying amounts of space before
the end tag.

=back

=head1 EXPORT

 tagged
 opentagged
 closetagged

=head1 BUGS

none known.

=head1 SEE ALSO

L<HTML::Parser>
L<HTML::Tagset>

HTML::TagUtil's website is L<http://www.x-tac.net/html-util.htm/>

=head1 AUTHOR

<nightcat>, E<lt>nightcat@crocker.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by <nightcat>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
