//%attributes = {}
// -------
// Method: Job_SaveToJSONfile   ( ) ->
// By: Mel Bohince @ 04/26/17, 15:37:50
// Description
// use to set up a mongodb import
// ----------------------------------------------------

READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Materials:55])

C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)
$title:=""
$text:=""
$docName:="JobSpecs"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".json"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"Closed"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Complete"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"Kill"; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5#"020@")
		CREATE SET:C116([Job_Forms:42]; "openJobs")
		
		C_LONGINT:C283($i; $numRecs)
		C_BOOLEAN:C305($break)
		
		$break:=False:C215
		$numRecs:=Records in selection:C76([Job_Forms:42])
		
		uThermoInit($numRecs; "Updating Records")
		For ($i; 1; $numRecs)
			USE SET:C118("openJobs")
			GOTO SELECTED RECORD:C245([Job_Forms:42]; $i)
			
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$text:=$text+api_Jobs([Job_Forms:42]JobFormID:5)+" \r"  //$eol
			
			If (Length:C16($text)>25000)
				SEND PACKET:C103($docRef; $text)
				$text:=""
			End if 
			
			uThermoUpdate($i)
		End for 
		
		uThermoClose
		CLEAR SET:C117("openJobs")
		
		SEND PACKET:C103($docRef; $text)
		
		CLOSE DOCUMENT:C267($docRef)
		
	Else 
		
		ARRAY TEXT:C222($_JobFormID; 0)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"Closed"; *)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"Complete"; *)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"Kill"; *)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5#"020@")
		SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $_JobFormID)
		
		C_LONGINT:C283($i; $numRecs)
		C_BOOLEAN:C305($break)
		
		$break:=False:C215
		$numRecs:=Size of array:C274($_JobFormID)
		
		uThermoInit($numRecs; "Updating Records")
		For ($i; 1; $numRecs)
			
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$text:=$text+api_Jobs($_JobFormID{$i})+" \r"  //$eol
			
			If (Length:C16($text)>25000)
				SEND PACKET:C103($docRef; $text)
				$text:=""
			End if 
			
			uThermoUpdate($i)
		End for 
		
		uThermoClose
		SEND PACKET:C103($docRef; $text)
		
		CLOSE DOCUMENT:C267($docRef)
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	BEEP:C151
End if 