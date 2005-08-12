
use Test;
BEGIN { plan tests => 4 };

use HTML::TagUtil;

print "# Testing HTML::TagUtil...\n";
print "# Testing the tagged function...\n";
ok (HTML::TagUtil::tagged ('<html>hello</html>'));
print "# Testing the opentagged function...\n";
ok (HTML::TagUtil::opentagged ('<html>hello</html>'));
print "# Testing the closetagged function...\n";
ok (HTML::TagUtil::closetagged ('<html>hello</html>'));
print "# Testing the tagpos function...\n";
ok (HTML::TagUtil::tagpos ('<html>hello</html>', 'html', 0));



