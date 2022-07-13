//%attributes = {}
// Method: rfc_setView () -> 
// ----------------------------------------------------
// by: mel: 03/04/04, 14:35:57
// ----------------------------------------------------
// Description:
// 
// Updates:
//based on: FG_PrepServiceSetView() -> 
// Modified by: Mel Bohince (6/28/16) move date fwd, brian really doesn't use

zwStatusMsg("Searching"; "Please Wait...")

C_LONGINT:C283($1; $tabNumber; $itemRef)
C_TEXT:C284($itemText)
C_POINTER:C301($2; $orderBy)

CUT NAMED SELECTION:C334([Finished_Goods_SizeAndStyles:132]; "hold")
If (Count parameters:C259=2)
	$tabNumber:=$1
	$orderBy:=$2
Else 
	$tabNumber:=Selected list items:C379(iJMLTabs)
	Case of 
		: (b4=1)
			$orderBy:=->[Finished_Goods_SizeAndStyles:132]DateWanted:42
		: (b5=1)
			$orderBy:=->[Finished_Goods_SizeAndStyles:132]DateSubmitted:5
		: (b6=1)
			$orderBy:=->[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1
		: (b7=1)
			$orderBy:=->[Finished_Goods_SizeAndStyles:132]Priority:47
	End case 
End if 

If (Count parameters:C259=0)  //*The Search
	GET LIST ITEM:C378(iJMLTabs; $tabNumber; $itemRef; $itemText)  //list = RFC_tabs
	
	Case of 
		: ($itemText="Find...")
			QUERY:C277([Finished_Goods_SizeAndStyles:132])
			
		: ($itemText="Planning")  //some old imported data doesn't follow the expected workflow
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateSubmitted:5=!00-00-00!; *)
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]DateApproved:8=!00-00-00!; *)
			//QUERY([Finished_Goods_SizeAndStyles]; & ;[Finished_Goods_SizeAndStyles]DateGlueApproved=!00-00-00!;*)
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!)
			//QUERY([Finished_Goods_SizeAndStyles]; & ;[Finished_Goods_SizeAndStyles]DateCreated>!2018-01-01!)
			
		: ($itemText="Construction")
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!; *)
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!)
			
		: ($itemText="Brian")
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]Brian_Approval:60=!00-00-00!; *)
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53#"001"; *)
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]DateDone:6>!2018-11-11!; *)  // Modified by: Mel Bohince (6/28/16) move date fwd, brian really doesn't use
			// Modified by: Mel Bohince (3/20/15) remove next line
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]AdditionalRequest:54=0)  // Modified by: Mel Bohince (5/8/14) 
			
		: ($itemText="Done")
			//QUERY([Finished_Goods_SizeAndStyles];[Finished_Goods_SizeAndStyles]Brian_Approval#!00-00-00!;*)
			//QUERY([Finished_Goods_SizeAndStyles]; | ;[Finished_Goods_SizeAndStyles]DateDone<!2014-04-02!)
			QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]DateDone:6#!00-00-00!)
			
		: ($itemText="Approved")
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateApproved:8#!00-00-00!)
			
		Else 
			QUERY:C277([Finished_Goods_SizeAndStyles:132])
	End case 
	
Else 
	USE NAMED SELECTION:C332("hold")
End if 

//*The sort
If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
	If (cbShowMine=1)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]CreatedBy:57=<>zResp)
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
	End if 
	SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
	ORDER BY:C49([Finished_Goods_SizeAndStyles:132]; $orderBy->; >)
	SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
Else 
	BEEP:C151
End if 

zwStatusMsg("Done"; "")

CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "CurrentSet")
winTitle:=$itemText+" "+fNameWindow(->[Finished_Goods_SizeAndStyles:132])
SET WINDOW TITLE:C213(winTitle)