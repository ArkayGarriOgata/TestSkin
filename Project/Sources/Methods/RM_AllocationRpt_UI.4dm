//%attributes = {}
// _______
// Method: RM_AllocationRpt_UI( ) -> document
// By: Mel Bohince @ 11/03/21, 08:42:24
// Description
// user interface to RM_AllocationRpt_EOS
// ----------------------------------------------------
// Modified by: Mel Bohince (11/16/21) include plastic with board
// Modified by: MelvinBohince (2/8/22) give cold foil (9) its own method

C_TEXT:C284($commodity; $fileTitle; $csvText)
SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window

$commodity:=Request:C163("Which commodity code?(1=board&plastic,20=plastic;9=coldfoil,12=sensors or like 01-inv or 09-gold)"; "1"; "Ok"; "Cancel")
If (ok=1)
	//append type of run to file name
	Case of 
		: (Num:C11($commodity)=1)
			$fileTitle:="SUBSTRATE_"  // Modified by: Mel Bohince (11/16/21) include plastic with board
		: (Num:C11($commodity)=20)
			$fileTitle:="PLASTIC_"
		: (Num:C11($commodity)=9)
			$fileTitle:="COLDFOIL_"
		: (Num:C11($commodity)=12)
			$fileTitle:="SENSORS_"
		Else 
			$fileTitle:="ERROR_"
	End case 
	
	If (Length:C16($commodity)=1)  //looking for 2 digits prefix in a commodity key
		$commodity:="0"+$commodity
	End if 
	$commodity:=$commodity+"@"  //get all subgroups
	
	If (Num:C11($commodity)=9)  // Modified by: MelvinBohince (2/8/22) give cold foil (9) its own method
		$csvText:=RM_AllocationColdFoilRpt_EOS
	Else 
		$csvText:=RM_AllocationRpt_EOS($commodity)
	End if 
	
	//save the text to a document
	C_TEXT:C284($docName)
	C_TIME:C306($docRef)
	
	$docName:="ALLOCATION_"+$fileTitle+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	$docRef:=util_putFileName(->$docName)  //path prepended on docName
	CLOSE DOCUMENT:C267($docRef)
	
	TEXT TO DOCUMENT:C1237($docName; $csvText)
	CLOSE DOCUMENT:C267($docRef)
	//open it
	BEEP:C151
	$err:=util_Launch_External_App($docName)
	
End if   //ok

