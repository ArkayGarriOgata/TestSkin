//%attributes = {}
//Mehtod: UrWk_Dcmt_WorkStation
//Description:  This method will create a document for all user information on 
// _______


If (True:C214)  //Initialize
	
	C_LONGINT:C283($nUsers; $nNumberOfUsers)
	C_TEXT:C284($tTab)
	C_TEXT:C284($tCR)
	C_TEXT:C284($tBlank)
	C_TIME:C306($hDocumentReference)
	
	$tBlank:=""
	$tTab:=Char:C90(Tab:K15:37)
	$tCR:=Char:C90(Carriage return:K15:38)
	
End if   //Done Initialize

$hDocumentReference:=Create document:C266($tBlank)

If (OK=1)  //Ok to create document
	
	SEND PACKET:C103($hDocumentReference; "Machine Name"+$tTab)  //Send Titles
	SEND PACKET:C103($hDocumentReference; "Account Name"+$tTab)
	SEND PACKET:C103($hDocumentReference; "User Name"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Model"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Processor"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Cores"+$tTab)
	SEND PACKET:C103($hDocumentReference; "CPU Threads"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Physical Memory"+$tTab)
	SEND PACKET:C103($hDocumentReference; "OS Version"+$tTab)
	SEND PACKET:C103($hDocumentReference; "OS Language"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Platform"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Recorded On"+$tTab)
	SEND PACKET:C103($hDocumentReference; "Recorded At"+$tCR)
	
	READ ONLY:C145([User_Workstation:95])
	
	ALL RECORDS:C47([User_Workstation:95])
	
	$nNumberOfUsers:=Records in selection:C76([User_Workstation:95])
	
	For ($nUser; 1; $nNumberOfUsers)  //Loop thru users
		
		GOTO SELECTED RECORD:C245([User_Workstation:95]; $nUser)
		
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.accountName+$tTab)
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.machineName+$tTab)
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.userName+$tTab)
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.model+$tTab)
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.processor+$tTab)
		SEND PACKET:C103($hDocumentReference; String:C10([User_Workstation:95]SystemInformation:2.cores)+$tTab)
		SEND PACKET:C103($hDocumentReference; String:C10([User_Workstation:95]SystemInformation:2.cpuThreads)+$tTab)
		SEND PACKET:C103($hDocumentReference; String:C10([User_Workstation:95]SystemInformation:2.physicalMemory)+$tTab)
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.osVersion+$tTab)
		SEND PACKET:C103($hDocumentReference; [User_Workstation:95]SystemInformation:2.osLanguage+$tTab)
		SEND PACKET:C103($hDocumentReference; String:C10([User_Workstation:95]Platform:5)+$tTab)
		SEND PACKET:C103($hDocumentReference; String:C10([User_Workstation:95]RecordedOn:3)+$tTab)
		SEND PACKET:C103($hDocumentReference; String:C10([User_Workstation:95]RecordedAt:4)+$tCR)
		
	End for   //Done looping thru users
	
	CLOSE DOCUMENT:C267($hDocumentReference)
	
End if   //Done ok to create the document
