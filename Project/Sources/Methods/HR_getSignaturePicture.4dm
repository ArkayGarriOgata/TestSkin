//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/26/05, 16:02:09
// ----------------------------------------------------
// Method: HR_getSignaturePicture({initials})->pict
// Description
//provide a way to get the sigs without losing the currently selected user rec
// init with HR_getSignaturePicture to load sigs in array
//use like HR_getSignaturePicture("mlb") to get sig pict if exists
// 
// ----------------------------------------------------

C_TEXT:C284($1)
C_POINTER:C301($2)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

Case of 
	: (Not:C34(User in group:C338(Current user:C182; "RolePayRoll")))
		//don't load sigs
		
	: (Count parameters:C259=0)  //start a server process
		If (Size of array:C274(<>UserInitials)=0)  //initial
			$pid:=New process:C317("HR_getSignaturePicture"; <>lMinMemPart; "Load Signatures"; "init")
			If (False:C215)
				HR_getSignaturePicture
			End if 
		End if 
		
	: (Count parameters:C259=1)  //initialize signature array
		READ ONLY:C145([Users:5])
		QUERY:C277([Users:5]; [Users:5]DOT:30=!00-00-00!; *)
		QUERY:C277([Users:5];  & ; [Users:5]hasSignature:58>0)
		$numRecs:=Records in selection:C76([Users:5])
		If ($numRecs>0)
			zwStatusMsg("Load Sigs"; String:C10($numRecs)+" signatures available.")
			ARRAY TEXT:C222(<>UserInitials; 0)
			ARRAY PICTURE:C279(<>Signatures; 0)
			ARRAY TEXT:C222(<>UserInitials; $numRecs)
			ARRAY PICTURE:C279(<>Signatures; $numRecs)
			//SELECTION TO ARRAY([USER]Initials;◊UserInitials;[USER]Signature;◊Signatures)
			
			$break:=False:C215
			uThermoInit($numRecs; "Loading Signatures")
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($i; 1; $numRecs)
					If ($break)
						$i:=$i+$numRecs
					End if 
					<>UserInitials{$i}:=[Users:5]Initials:1
					<>Signatures{$i}:=[Users:5]Signature:13
					NEXT RECORD:C51([Users:5])
					uThermoUpdate($i)
				End for 
				
				
			Else 
				
				SELECTION TO ARRAY:C260([Users:5]Initials:1; $_Initials; [Users:5]Signature:13; $_Signature)
				
				For ($i; 1; $numRecs; 1)
					
					<>UserInitials{$i}:=$_Initials{$i}
					<>Signatures{$i}:=$_Signature{$i}
					uThermoUpdate($i)
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 First record
			uThermoClose
			REDUCE SELECTION:C351([Users:5]; 0)
			zwStatusMsg("Load Sigs"; String:C10(Size of array:C274(<>UserInitials))+" signatures loaded.")
			
		Else   //no sigs found
			ARRAY TEXT:C222(<>UserInitials; 1)
			ARRAY PICTURE:C279(<>Signatures; 1)
		End if 
		
	: (Count parameters:C259=2)
		$i:=Find in array:C230(<>UserInitials; $1)
		If ($i>-1)
			$2->:=<>Signatures{$i}
		Else 
			$2->:=<>nilPicture  //see uInitInterPrsVar
		End if 
End case 