//%attributes = {"publishedWeb":true}
//PM: Email_Opt_Help() -> 
//@author mlb - 4/17/01  13:00

C_TEXT:C284($cr; $q)
ARRAY TEXT:C222($actionRequested; 8)  // see also EMAIL_Fetcher

$cr:=Char:C90(13)
$q:=Char:C90(34)
//mime headers
$boundary:=$cr+"--ams_mime_boundary"+$cr
emailHeader:="multipart/alternative; boundary="+$q+"ams_mime_boundary"+$q
$textHeader:="Content-Type: text/plain; charset=us-ascii"+$cr+$cr
$htmlHeader:="Content-Type: text/html; charset=us-ascii"+$cr+$cr

emailHeader:=$htmlHeader

$actionRequested{1}:="Help - Show available services"
$actionRequested{2}:="Subscriptions - Show mailings lists that are published"
$actionRequested{3}:="Subscribe - Register with a  mailing list (list name in the body)"
$actionRequested{4}:="Unsubscribe - Stop receiving a mailing list (list name in the body)"
$actionRequested{5}:="New Users - Refresh allowed clients"
$actionRequested{6}:="AskMe -Detail data on a product (product code in the body)"
$actionRequested{7}:="WEB RFQ - Request for Quotation see <http://www.arkay.com/Index/RFQ.html>"
$actionRequested{8}:="--------"

emailResponse:=$cr+"Available Service Options:"+$cr+$cr
For ($j; 1; Size of array:C274($actionRequested))
	emailResponse:=emailResponse+$actionRequested{$j}+$cr+$cr
End for 

emailResponse:=emailResponse+$cr
emailResponse:=emailResponse+"Enter the Service Option in your email's subject. "
emailResponse:=emailResponse+"If required, enter the body information on the first line "
emailResponse:=emailResponse+"of your email's body."+$cr
emailResponse:=$boundary+$textHeader+emailResponse

$html:="<html><head><title>Hello Mail</title></head><body>"
$html:=$html+"<B>Available Service Options:</B><OL>"
For ($j; 1; Size of array:C274($actionRequested))
	$html:=$html+"<LI>"+$actionRequested{$j}
End for 
$html:=$html+"</OL>"
$html:=$html+"<P>"+"Enter the Service Option in your email's subject. "
$html:=$html+"If required, enter the body information on the first line "
$html:=$html+"of your email's body."+"</P>"
$html:=$html+"</body></html>"

emailResponse:=emailResponse+$boundary+$htmlHeader+$html+$cr+$boundary+"--"