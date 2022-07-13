//%attributes = {}
// -------
// Method: aMs_OpenScreenCastWebsite   ( ) ->
// By: Mel Bohince @ 02/20/19, 16:10:47
// Description
// like the name suggests
// ----------------------------------------------------

$url:="https://arkayportal.com/training/"
READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
If (Records in selection:C76([zz_control:1])>0)
	$url:=[zz_control:1]aMsTrainingVidsPath:61
	REDUCE SELECTION:C351([zz_control:1]; 0)
End if 

OPEN URL:C673($url)