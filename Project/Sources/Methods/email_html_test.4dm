//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/12/09, 13:07:43
// ----------------------------------------------------
// Method: email_html_test
// ----------------------------------------------------

C_TEXT:C284($cr; $q)
ARRAY TEXT:C222($actionRequested; 8)  // see also EMAIL_Fetcher

$cr:=Char:C90(13)
$q:=Char:C90(34)
//mime headers

emailHeader:="Content-Type: text/html; charset=us-ascii"+$cr+$cr

$actionRequested{1}:="Help - Show available services"
$actionRequested{2}:="Subscriptions - Show mailings lists that are published"
$actionRequested{3}:="Subscribe - Register with a  mailing list (list name in the body)"
$actionRequested{4}:="Unsubscribe - Stop receiving a mailing list (list name in the body)"
$actionRequested{5}:="New Users - Refresh allowed clients"
$actionRequested{6}:="AskMe -Detail data on a product (product code in the body)"
$actionRequested{7}:="WEB RFQ - Request for Quotation see <http://www.arkay.com/Index/RFQ.html>"
$actionRequested{8}:="--------"

$html:="<html><head><title>Hello Mail</title></head><body>"
$html:=$html+"<B>Available Service Options:</B><OL>"
For ($j; 1; Size of array:C274($actionRequested))
	$html:=$html+"<LI><a href="+$q+"google.com"+$q+">"+$actionRequested{$j}+"</a>"
End for 
$html:=$html+"</OL>"
$html:=$html+"<P>"+"Enter the Service Option in your email's subject. "
$html:=$html+"If required, enter the body information on the first line "
$html:=$html+"of your email's body."+"</P>"
$html:=$html+"</body></html>"

emailResponse:=$html