//%attributes = {}
// -------
// Method: PF_JobsCreate   ( ) ->
// By: Mel Bohince @ 10/10/17, 14:37:48
// Description
// see also PF_JobsCreateNoUI
// ----------------------------------------------------

C_BOOLEAN:C305($err)
C_TEXT:C284($printflow_volumn; $printflow_inbox_path)
C_DATE:C307($exported)

$err:=util_MountNetworkDrive("PrintFlow")

ARRAY TEXT:C222($aVolumes; 0)
VOLUME LIST:C471($aVolumes)
If (Find in array:C230($aVolumes; "PrintFlow")>-1)
	$printflow_volumn:="PrintFlow:"
	$printflow_inbox_path:=$printflow_volumn+"XmlInbox:"  //this is what PF_connector expects
	If (Test path name:C476($printflow_inbox_path)#Is a folder:K24:2)
		CREATE FOLDER:C475($printflow_inbox_path)
	Else 
		ok:=1
	End if 
	
Else 
	$printflow_inbox_path:=util_DocumentPath("get")
	$printflow_inbox_path:=Request:C163("Path (like-> PrintFlow:)"; $printflow_inbox_path; "Export"; "Cancel")
End if 

If (ok=1)
	C_LONGINT:C283($i; $numJobBags)
	$numJobBags:=Records in set:C195("UserSet")
	If ($numJobBags#0)  //bSelect button from selectionList layout   
		
		
		CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "CurrentSel")  //• 5/7/97 cs `•020499  MLB  chg to cut
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
			uThermoInit($numJobBags; "Exporting XML...")
			For ($i; 1; $numJobBags)
				USE SET:C118("UserSet")
				GOTO SELECTED RECORD:C245([Job_Forms_Master_Schedule:67]; $i)
				$exported:=PF_JobformToXML([Job_Forms_Master_Schedule:67]JobForm:4; $printflow_inbox_path)
				If ($exported#!00-00-00!)
					[Job_Forms_Master_Schedule:67]Exported_PrintFlow:89:=$exported
					SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
				End if 
				uThermoUpdate($i)
			End for 
			uThermoClose
			
		Else 
			
			ARRAY LONGINT:C221($_record_number; 0)
			USE SET:C118("UserSet")
			LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Master_Schedule:67]; $_record_number)
			
			uThermoInit($numJobBags; "Exporting XML...")
			For ($i; 1; $numJobBags)
				GOTO RECORD:C242([Job_Forms_Master_Schedule:67]; $_record_number{$i})
				$exported:=PF_JobformToXML([Job_Forms_Master_Schedule:67]JobForm:4; $printflow_inbox_path)
				If ($exported#!00-00-00!)
					[Job_Forms_Master_Schedule:67]Exported_PrintFlow:89:=$exported
					SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
				End if 
				uThermoUpdate($i)
			End for 
			uThermoClose
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		USE NAMED SELECTION:C332("CurrentSel")  //• 5/7/97 cs   
		ON EVENT CALL:C190("")
		
		uConfirm("xml files saved to "+$printflow_inbox_path; "Awesome"; "Where?")
		
	Else 
		BEEP:C151
		ALERT:C41("Select the forms that you wish to export.")
	End if 
	
End if 
//EOS