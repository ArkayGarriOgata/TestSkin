//%attributes = {"publishedWeb":true}
//PM:  JOB_getMaterialBudget  2/21/01  mlb
// Modified by: Mel Bohince (11/18/13)  chk array rather the query which for most commodities will never hit


C_LONGINT:C283($xlJobID; $1)

$xlJobID:=$1

If (Count parameters:C259>2)  //Revising, so blank out existing data
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$3)
	If (Records in selection:C76([Job_Forms_Materials:55])>0)
		DELETE SELECTION:C66([Job_Forms_Materials:55])
	End if 
End if 

READ ONLY:C145([Raw_Materials_Components:60])  // Modified by: Mel Bohince (11/18/13)  chk array rather the query
ALL RECORDS:C47([Raw_Materials_Components:60])  // this could be made into a interprocess array and done once per session
DISTINCT VALUES:C339([Raw_Materials_Components:60]Parent_Raw_Matl:1; $aRM_ComponentParents)  //132 items as of 11/18/13

QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=$2+"@")
$numRecs:=Records in selection:C76([Estimates_Materials:29])
For ($i; 1; $numRecs)
	GOTO SELECTED RECORD:C245([Estimates_Materials:29]; $i)
	//If [Raw_Materials_Components]Parent_Raw_Matl put in the [Raw_Materials_Components]Compnt_Raw_Matls.
	// so that issuing has a place to issue too.
	//QUERY([Raw_Materials_Components];[Raw_Materials_Components]Parent_Raw_Matl=[Estimates_Materials]Raw_Matl_Code)  // Added by: Mark Zinke (11/7/13) 
	//If (Records in selection([Raw_Materials_Components])>0)  // Added by: Mark Zinke (11/7/13) 
	If (Find in array:C230($aRM_ComponentParents; [Estimates_Materials:29]Raw_Matl_Code:4)=-1)  // Modified by: Mel Bohince (11/18/13)  chk array rather the query
		JOB_CreateJobFormsMaterialsRec($xlJobID; [Estimates_Materials:29]Raw_Matl_Code:4)  //not a parent component, the normal case
		
	Else   //create the parent and the components
		JOB_CreateJobFormsMaterialsRec($xlJobID; [Estimates_Materials:29]Raw_Matl_Code:4)  // Modified by: Mel Bohince (11/18/13) add the parent
		
		QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=[Estimates_Materials:29]Raw_Matl_Code:4)
		For ($j; 1; Records in selection:C76([Raw_Materials_Components:60]))
			GOTO SELECTED RECORD:C245([Raw_Materials_Components:60]; $j)
			JOB_CreateJobFormsMaterialsRec($xlJobID; [Raw_Materials_Components:60]Compnt_Raw_Matl:2; [Estimates_Materials:29]Raw_Matl_Code:4)
		End for 
	End if 
End for 