//%attributes = {"publishedWeb":true}
//PM: CAR_setView() -> 
//@author mlb - 7/19/01  10:53
//DJC - 5-5-05 - made changes to Tab Queries

C_LONGINT:C283($1; $tabNumber; $itemRef)
C_TEXT:C284($itemText)
C_POINTER:C301($2; $orderBy)

zwStatusMsg("Searching"; "Please Wait...")

CUT NAMED SELECTION:C334([QA_Corrective_Actions:105]; "hold")

If (Count parameters:C259=2)
	$tabNumber:=$1
	$orderBy:=$2
Else 
	$tabNumber:=Selected list items:C379(iJMLTabs)
	Case of 
		: (b1=1)
			$orderBy:=->[QA_Corrective_Actions:105]CostCenter:14
		: (b2=1)
			$orderBy:=->[QA_Corrective_Actions:105]Reason:16
		: (b3=1)
			$orderBy:=->[QA_Corrective_Actions:105]FGKey:8
		: (b4=1)
			$orderBy:=->[QA_Corrective_Actions:105]RequestNumber:1
		: (b5=1)
			$orderBy:=->[QA_Corrective_Actions:105]Location:6
		: (b6=1)
			$orderBy:=->[QA_Corrective_Actions:105]Plant:13
		: (b7=1)
			$orderBy:=->[QA_Corrective_Actions:105]RGA:4
	End case 
End if 

If (Count parameters:C259=0)  //search
	GET LIST ITEM:C378(iJMLTabs; $tabNumber; $itemRef; $itemText)
	
	Case of 
		: ($itemText="All")  //Tab 6 `DJC - 5-5-05
			ALL RECORDS:C47([QA_Corrective_Actions:105])
			
			//: ($itemText="RGA Given")`Old Tab 1
			//QUERY([CorrectiveAction];[CorrectiveAction]RGA#"")
		: ($itemText="Mine")  //default on load Tab 1
			//authors self created CARs and also must be open
			QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]Author:3=<>zResp; *)
			QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]ApprovalQAMgr:21="")
			
		: ($itemText="Need Corrective Action")  //Tab 3
			//QUERY([CorrectiveAction];[CorrectiveAction]CAwho="")
			//either Root Cause or Corrective Action Taken are blank as per Angela Simmons
			QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]ActionTaken:18="")
			
		: ($itemText="Open")  //Tab 2
			//QUERY([CorrectiveAction];[CorrectiveAction]ApprovalPlantMgr="";*)
			QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]ApprovalQAMgr:21="")
			//QUERY([QA_Corrective_Actions]; | ;[QA_Corrective_Actions]RGA="")
			
		: ($itemText="Need Reported")  //Tab 4
			//Date Reported Blank - as per Angela Simmons
			QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]DateReported:22=!00-00-00!; *)
			QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]CAR_Type:32="Customer Reply Required")
			//QUERY([CorrectiveAction]; & ;[CorrectiveAction]ApprovalQAMgr#"")
			
		: ($itemText="Completed")  //Tab 5
			//and no open ToDos - code to be added later
			QUERY:C277([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]DateEffective:19#!00-00-00!)
			QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]DateReported:22#!00-00-00!; *)
			QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]RootCause:17#""; *)
			QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]ActionTaken:18#""; *)
			//QUERY([CorrectiveAction]; & ;[CorrectiveAction]ApprovalPlantMgr#"";*)
			QUERY:C277([QA_Corrective_Actions:105];  & ; [QA_Corrective_Actions:105]ApprovalQAMgr:21#"")
			
		Else 
			QUERY:C277([QA_Corrective_Actions:105])  //Tab 7 FIND
	End case 
	
	Case of 
		: (i1=1) & (i2=1)
			//don't restrict
		: (i1=1)
			QUERY SELECTION:C341([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]Plant:13="Hauppauge")
			
		: (i2=1)
			QUERY SELECTION:C341([QA_Corrective_Actions:105]; [QA_Corrective_Actions:105]Plant:13="Roanoke")
			
		Else 
			//both off, dont restrict
	End case 
	
Else 
	USE NAMED SELECTION:C332("hold")
End if 

If (Records in selection:C76([QA_Corrective_Actions:105])>0)
	ORDER BY:C49([QA_Corrective_Actions:105]; $orderBy->; <)
	lastTab:=$tabNumber
Else 
	BEEP:C151
End if 

//GetRelatedCustRec4OutputForm   `DJC 5-4-05

zwStatusMsg("Done"; "")

CREATE SET:C116([QA_Corrective_Actions:105]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([QA_Corrective_Actions:105]; "CurrentSet")
SET WINDOW TITLE:C213(fNameWindow(->[QA_Corrective_Actions:105]))