//%attributes = {}

// Method: RMX_IssueToJob ({"eBag"}{;jobform_id)  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 10/15/14, 16:40:39
// ----------------------------------------------------
// Description
// create an RM transaction
// ----------------------------------------------------
C_TEXT:C284($1; $2; sJobform)
//select POItemKey, Raw_Matl_Code, Location, cast(QtyOH+ConsignmentQty as varchar)from Raw_Materials_Locations where Raw_Matl_Code in
//(select Raw_Matl_Code from Job_Forms_Materials where Raw_Matl_Code<>'' and JobForm='95075.01')order by Raw_Matl_Code, POItemKey
If (Count parameters:C259=0)  //called from issue button on Job palette choosing expermental mode
	//<>pid_RMX:=0  //for debugging
	
	If (<>pid_RMX=0)  //singleton
		<>pid_RMX:=New process:C317("RMX_IssueToJob"; <>lMidMemPart; "Process's Name"; "init")
		If (False:C215)
			RMX_IssueToJob
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_RMX)
		BRING TO FRONT:C326(<>pid_RMX)
	End if 
	
Else 
	sMsg:=$1
	zSetUsageLog(->[zz_control:1]; "1"; Current method name:C684; 0)
	
	FORM SET INPUT:C55([Raw_Materials_Transactions:23]; "Issue_Dialog")  //insure 
	FORM SET OUTPUT:C54([Raw_Materials_Transactions:23]; "List")  //insure that 'list' is always selected
	READ WRITE:C146([Raw_Materials_Transactions:23])
	READ ONLY:C145([Raw_Material_Labels:171])
	READ ONLY:C145([Job_Forms:42])
	READ ONLY:C145([Job_Forms_Machines:43])
	READ ONLY:C145([Purchase_Orders_Items:12])
	READ ONLY:C145([Raw_Materials_Locations:25])
	READ ONLY:C145([Raw_Materials_Allocations:58])
	READ ONLY:C145([Job_Forms_Materials:55])
	
	
	Case of 
		: (sMsg="init")
			$winRef:=OpenFormWindow(->[Raw_Materials_Transactions:23]; "Issue_Dialog")
			SET MENU BAR:C67(<>defaultMenu)
			sJobform:=""
			
			Repeat 
				ADD RECORD:C56([Raw_Materials_Transactions:23])
			Until (ok=0)
			CLOSE WINDOW:C154($winRef)
			<>pid_RMX:=0
			
		: (sMsg="eBag")  //called from eBag screen with 'Issue Raw Matl' button
			$winRef:=OpenSheetWindow(->[Raw_Materials_Transactions:23]; "Issue_Dialog")  //OpenFormWindow
			If (Count parameters:C259=2)
				sJobform:=$2
			Else   //this would be unusal
				sJobform:=""
			End if 
			READ ONLY:C145([Purchase_Orders_Items:12])
			READ ONLY:C145([Raw_Materials_Locations:25])  // Modified by: Mel Bohince (1/14/20) 
			
			$tabNumber:=Selected list items:C379(ieBagTabs)
			GET LIST ITEM:C378(ieBagTabs; $tabNumber; $itemRef; $itemText)
			iSeq:=Num:C11(Substring:C12($itemText; 1; 3))
			If (iSeq>0)
				sCC:=Substring:C12($itemText; 5; 3)
			Else 
				sCC:=""
			End if 
			ADD RECORD:C56([Raw_Materials_Transactions:23])
			
	End case 
End if 



