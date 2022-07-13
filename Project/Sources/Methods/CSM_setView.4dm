//%attributes = {}
// Method: CSM_setView () -> 
// ----------------------------------------------------
// by: mel: 03/11/04, 12:21:49
// ----------------------------------------------------
// based on: rfc_setView () -> 
//based on: FG_PrepServiceSetView() -> 

zwStatusMsg("Searching"; "Please Wait...")

C_LONGINT:C283($1; $tabNumber; $itemRef)
C_TEXT:C284($itemText)
C_POINTER:C301($2; $orderBy)

CUT NAMED SELECTION:C334([Finished_Goods_Color_SpecMaster:128]; "hold")
If (Count parameters:C259=2)
	$tabNumber:=$1
	$orderBy:=$2
Else 
	$tabNumber:=Selected list items:C379(iJMLTabs)
	Case of 
		: ($itemText="Planning")
			$orderBy:=->[Finished_Goods_Color_SpecMaster:128]DateApproved:18
		: (b4=1)
			$orderBy:=->[Finished_Goods_Color_SpecMaster:128]projectId:4
		: (b5=1)
			$orderBy:=->[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19
		: (b6=1)
			$orderBy:=->[Finished_Goods_Color_SpecMaster:128]name:2
	End case 
End if 

If (Count parameters:C259=0)  //*The Search
	GET LIST ITEM:C378(iJMLTabs; $tabNumber; $itemRef; $itemText)  //list = RFC_tabs
	Case of 
		: ($itemText="Find...")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128])
			
		: ($itemText="Planning")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]DateSubmitted:19=!00-00-00!)
			
		: ($itemText="Ink Making")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]DateSubmitted:19#!00-00-00!; *)
			QUERY:C277([Finished_Goods_Color_SpecMaster:128];  & ; [Finished_Goods_Color_SpecMaster:128]DateDone:20=!00-00-00!)
			
		: ($itemText="To Send")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]DateDone:20#!00-00-00!; *)
			QUERY:C277([Finished_Goods_Color_SpecMaster:128];  & ; [Finished_Goods_Color_SpecMaster:128]DateSent:21=!00-00-00!)
			
		: ($itemText="Customer")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]DateSent:21#!00-00-00!; *)
			QUERY:C277([Finished_Goods_Color_SpecMaster:128];  & ; [Finished_Goods_Color_SpecMaster:128]DateReturned:22=!00-00-00!)
			
		: ($itemText="Returned")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]DateReturned:22#!00-00-00!)
			
		Else 
			//USE SET("anyPressDate")
			//QUERY SELECTION([FG_Specification];[FG_Specification]ServiceRequested=$itemText)
			
	End case 
	
Else 
	USE NAMED SELECTION:C332("hold")
End if 

//*The sort

If (Records in selection:C76([Finished_Goods_Color_SpecMaster:128])>0)
	SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
	ORDER BY:C49([Finished_Goods_Color_SpecMaster:128]; $orderBy->; >)
	
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
Else 
	BEEP:C151
End if 

zwStatusMsg("Done"; "")

CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "CurrentSet")
winTitle:=$itemText+" "+fNameWindow(->[Finished_Goods_Color_SpecMaster:128])
SET WINDOW TITLE:C213(winTitle)