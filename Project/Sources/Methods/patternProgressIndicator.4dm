//%attributes = {}
// _______
// Method: patternProgressIndicator   ( ) ->
// By: Mel Bohince @ 06/26/20, 05:58:24
// Description
// loop inside an iteration
// ----------------------------------------------------

If (True:C214)  //sample collection to iterate
	C_COLLECTION:C1488($outerLoop_c)
	$outerLoop_c:=New collection:C1472
	$outerLoop_c.push("one")
	$outerLoop_c.push("two")
	$outerLoop_c.push("three")
	$outerLoop_c.push("four")
	$outerLoop_c.push("five")
	$outerLoop_c.push("six")
End if 

C_LONGINT:C283($outerBar; $outerLoop; $out)
$outerBar:=Progress New  //new progress bar
Progress SET TITLE($outerBar; "Outer Loop Indicator")  //optional init of the thermoeters title
Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration

C_LONGINT:C283($innerBar; $innerLoop; $in)  //this could also be called repeativly inside the loop if the quit is also moved inside
$innerBar:=Progress New  //new progress bar
Progress SET BUTTON ENABLED($innerBar; False:C215)  // no stop button 

$out:=0  //init a counter for status message
$outerLoop:=$outerLoop_c.length  //set a limit for status message
C_BOOLEAN:C305($continueInteration)
$continueInteration:=True:C214  //option to break out of ForEach

For each ($outItem; $outerLoop_c) While ($continueInteration)
	
	$out:=$out+1  //update a counter
	Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
	Progress SET TITLE($outerBar; "Step: "+$outItem)  //optional update of the thermoeters title
	Progress SET MESSAGE($outerBar; String:C10($out; "^^^^^")+" of "\
		+String:C10($outerLoop; "^^^^^")+" @ "+String:C10(100*$out/$outerLoop; "###%"))  //optional verbose status
	
	$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
	If ($continueInteration)  //respect the cancel if necessary
		
		Progress SET TITLE($innerBar; "Substeps for Step "+String:C10($out))
		$innerLoop:=50
		For ($in; 1; $innerLoop)
			Progress SET PROGRESS($innerBar; $in/$innerLoop)  //update the thermometer
			Progress SET MESSAGE($innerBar; String:C10($in)+"/"+String:C10($innerLoop))  //optional verbose status
			//-------
			DELAY PROCESS:C323(Current process:C322; 2)  //do something
			//-------
		End for 
		
	Else   //bailed
		ALERT:C41("Aborted before working on item "+String:C10($out)+": "+$outItem)  //optional debrief
	End if   //$continueInteration
	
End for each   //item in the outer collection
//cleanup
Progress QUIT($innerBar)  //remove the thermometer
Progress QUIT($outerBar)  //remove the thermometer

If (True:C214)  //see the ole school:
	uThermoInit(10*$outerLoop; "looping")
	For ($out; 1; $outerLoop)
		uThermoUpdate($out)
	End for 
	uThermoClose
End if 
