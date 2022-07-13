//%attributes = {"publishedWeb":true}
//JML_findJobByFG

C_TEXT:C284($1)
C_LONGINT:C283($0)

$0:=0
$numJMI:=qryJMI("@"; 0; $1)
If ($numJMI>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		util_outerJoin(->[Job_Forms_Master_Schedule:67]JobForm:4; ->[Job_Forms_Items:44]JobForm:1)
		QUERY SELECTION:C341([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
		
	Else 
		//you need to see line 7 before validate this
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Master_Schedule:67])+" file. Please Wait...")
		QUERY BY FORMULA:C48([Job_Forms_Master_Schedule:67]; \
			([Job_Forms_Items:44]JobForm:1="@")\
			 & ([Job_Forms_Items:44]ProductCode:3=$1)\
			 & ([Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Items:44]JobForm:1)\
			 & ([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)\
			)
		
		zwStatusMsg(""; "")
	End if   // END 4D Professional Services : January 2019 query selection
	
	$0:=Records in selection:C76([Job_Forms_Master_Schedule:67])
End if 