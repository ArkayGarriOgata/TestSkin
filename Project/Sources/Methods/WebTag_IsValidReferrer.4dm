//%attributes = {"publishedWeb":true}
// _______
// Method: WebTag_IsValidReferrer   ( ) ->
// By: (phil)footprints @ 07/02/20, 10:50:41
// Description
// call by 4D Tag in the HTML
// ----------------------------------------------------
// Modified by: Mel Bohince (11/24/21) always return true so ip of ams server doesn't matter

C_BOOLEAN:C305($0)
$0:=True:C214  // Modified by: Mel Bohince (11/24/21) always return true so ip of ams server doesn't matter


//$0:=False

//C_TEXT($aMsServersIP)  // Modified by: Mel Bohince (7/2/20) replace literal with descriptive var
//$aMsServersIP:="@192.168.1.62@"

//ARRAY TEXT($sttFields;0)
//ARRAY TEXT($sttValues;0)

//WEB GET HTTP HEADER($sttFields;$sttValues)

//$i:=Find in array($sttFields;"Host")
//If ($i>0)
//If (($sttValues{$i}="@arkayportal@") | ($sttValues{$i}=$aMsServersIP))
//$0:=True
//End if 
//End if 
//
