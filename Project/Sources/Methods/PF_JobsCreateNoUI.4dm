//%attributes = {}
// -------
// Method: PF_JobsCreateNoUI   ( ) ->
// By: Mel Bohince @ 03/28/18, 06:29:45
// Description see also PF_JobsCreate
// send jobs to printflow based on criterion instead of manually picking
//  primarily to be used until workflow is established
// ----------------------------------------------------

C_BOOLEAN:C305($err)
C_TEXT:C284($printflow_volumn; $printflow_inbox_path; $jobform)
C_DATE:C307($exported)
C_LONGINT:C283($job)

$err:=util_MountNetworkDrive("PrintFlow")

ARRAY TEXT:C222($aVolumes; 0)
VOLUME LIST:C471($aVolumes)
If (Find in array:C230($aVolumes; "PrintFlow")>-1)  //&(false)
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

ARRAY TEXT:C222($aJobsToSend; 0)
Begin SQL
	select JobForm from Job_Forms_Master_Schedule 
	where DateComplete < '01/01/01'
	and Exported_PrintFlow < '01/01/01'
	and GlueReady  < '01/01/01'
	and MAD > '01/01/18'
	into :$aJobsToSend
End SQL
//and MAD = '02/14/18'  //for testing
//and MAD > '01/01/18'
For ($job; 1; Size of array:C274($aJobsToSend))
	$jobform:=$aJobsToSend{$job}  //sql doesn't like the array ref
	$exported:=PF_JobformToXML($jobform; $printflow_inbox_path)
	If ($exported#!00-00-00!)
		Begin SQL
			update Job_Forms_Master_Schedule 
			set Exported_PrintFlow = :$exported
			where JobForm = :$jobform
		End SQL
	End if 
End for 

