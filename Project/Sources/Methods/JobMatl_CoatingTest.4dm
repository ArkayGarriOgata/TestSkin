//%attributes = {}

// Method: JobMatl_CoatingTest ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 07/11/14, 13:15:20
// ----------------------------------------------------
// Description
// see if a multiple for coatings based on sheets can work
//
// ----------------------------------------------------

C_TEXT:C284($t)
$t:=Char:C90(9)

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	//find some closed jobs
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>!2014-04-01!)
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJF)
	
	//find coatings issued
	QUERY WITH ARRAY:C644([Job_Forms_Materials:55]JobForm:1; $aJF)
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="03@")
	
	
Else 
	
	QUERY BY FORMULA:C48([Job_Forms_Materials:55]; \
		([Job_Forms:42]ClosedDate:11>!2014-04-01!)\
		 & ([Job_Forms_Materials:55]Commodity_Key:12="03@")\
		)
	
	
End if   // END 4D Professional Services : January 2019 query selection
utl_LogIt("init")

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Materials:55])

uThermoInit($numRecs; "Reporting Records")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		If ([Job_Forms_Materials:55]JobForm:1="94197.04")
			TRACE:C157
		End if 
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms_Materials:55]JobForm:1; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Sequence:13=[Job_Forms_Materials:55]Sequence:3; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Commodity_Key:22="03@")
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$actQty:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)*-1
		Else 
			$actQty:=-1
		End if 
		
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms_Materials:55]JobForm:1; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Sequence:3=[Job_Forms_Materials:55]Sequence:3)
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			$sheets:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
			$sheets:=$sheets+Sum:C1([Job_Forms_Machine_Tickets:61]Waste_Units:9)
		Else 
			$sheets:=-1
		End if 
		
		$testQty:=Round:C94($actQty*1000/$sheets; 2)
		
		utl_LogIt([Job_Forms_Materials:55]JobForm:1+"."+String:C10([Job_Forms_Materials:55]Sequence:3; "000")+$t+[Job_Forms_Materials:55]Raw_Matl_Code:7+$t+String:C10([Job_Forms_Materials:55]Planned_Qty:6)+$t+String:C10($actQty)+$t+String:C10($testQty)+$t+String:C10($sheets))
		
		NEXT RECORD:C51([Job_Forms_Materials:55])
		uThermoUpdate($i)
	End for 
	
Else 
	
	ARRAY TEXT:C222($_JobForm; 0)
	ARRAY INTEGER:C220($_Sequence; 0)
	ARRAY TEXT:C222($_Raw_Matl_Code; 0)
	ARRAY REAL:C219($_Planned_Qty; 0)
	
	
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]JobForm:1; $_JobForm; \
		[Job_Forms_Materials:55]Sequence:3; $_Sequence; \
		[Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code; \
		[Job_Forms_Materials:55]Planned_Qty:6; $_Planned_Qty)
	
	
	For ($i; 1; $numRecs; 1)
		If ($break)
			$i:=$i+$numRecs
		End if 
		If ($_JobForm{$i}="94197.04")
			TRACE:C157
		End if 
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=$_JobForm{$i}; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Sequence:13=$_Sequence{$i}; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Commodity_Key:22="03@")
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$actQty:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)*-1
		Else 
			$actQty:=-1
		End if 
		
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$_JobForm{$i}; *)
		QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Sequence:3=$_Sequence{$i})
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			$sheets:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
			$sheets:=$sheets+Sum:C1([Job_Forms_Machine_Tickets:61]Waste_Units:9)
		Else 
			$sheets:=-1
		End if 
		
		$testQty:=Round:C94($actQty*1000/$sheets; 2)
		
		utl_LogIt($_JobForm{$i}+"."+String:C10($_Sequence{$i}; "000")+$t+$_Raw_Matl_Code{$i}+$t+String:C10($_Planned_Qty{$i})+$t+String:C10($actQty)+$t+String:C10($testQty)+$t+String:C10($sheets))
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 

uThermoClose




utl_LogIt("show")