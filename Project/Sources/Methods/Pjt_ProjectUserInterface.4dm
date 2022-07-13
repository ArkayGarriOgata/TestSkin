//%attributes = {"publishedWeb":true}
//PM:  Pjt_ProjectUserInterface  3/10/00  mlb
//present a control center for projects

C_TEXT:C284($1)

If (Count parameters:C259=0)
	zwStatusMsg("PROJECT"; "Loading the Command Center... ")
	
	$id:=uSpawnProcess("Pjt_ProjectUserInterface"; 64000; "Project Control Center"; True:C214; True:C214; "construct")
	If (False:C215)  //insider reference
		Pjt_ProjectUserInterface
	End if 
	
Else 
	zSetUsageLog(->[Customers_Projects:9]; "PjtCtr"; ""; 0)
	MESSAGES OFF:C175
	<>iMode:=2
	<>filePtr:=->[Customers_Projects:9]
	uSetUp(1)
	
	C_LONGINT:C283($time; $state)
	C_TEXT:C284($procName)
	PROCESS PROPERTIES:C336(Current process:C322; $procName; $state; $time)
	C_LONGINT:C283(tc_PjtControlCtr; pjtWindow)  //tab control
	C_LONGINT:C283(ppHome; ppReq; ppRFC; ppPrep; ppEst; ppOrd; ppJob; ppJPSI; ppCust; ppColor; ppFG)
	ppHome:=1
	//ppReq:=2
	ppPrep:=2
	ppEst:=3
	ppOrd:=4
	ppJob:=5
	ppJPSI:=6
	ppCust:=7
	ppColor:=8
	ppFG:=9
	ppRFC:=10
	
	pjtWindow:=OpenFormWindow(->[Customers_Projects:9]; "ControlCtr")
	
	READ WRITE:C146([Customers_Projects:9])
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Estimates:17])
	READ ONLY:C145([Finished_Goods_Specifications:98])
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Customers_Orders:40])
	READ ONLY:C145([Customers_Order_Lines:41])
	READ ONLY:C145([Job_Forms:42])
	READ ONLY:C145([Customers_Contacts:52])
	READ ONLY:C145([JPSI_Job_Physical_Support_Items:111])
	READ ONLY:C145([JTB_Job_Transfer_Bags:112])
	READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
	READ ONLY:C145([ProductionSchedules_BlockTimes:136])
	READ ONLY:C145([Users_Record_Accesses:94])  // Modified by: Mel Bohince (1/28/20) 
	
	Pjt_ProjectCollection("LoadList")
	zwStatusMsg("PROJECT"; "Click a '+' by the customer's name to see its projects")
	FORM SET INPUT:C55([Customers_Projects:9]; "ControlCtr")
	ADD RECORD:C56([Customers_Projects:9]; *)
	UNLOAD RECORD:C212([Customers_Projects:9])
	
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Estimates:17]; 0)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
	REDUCE SELECTION:C351([Customers_Contacts:52]; 0)
	REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
	REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
	REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
	REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
	REDUCE SELECTION:C351([Customers:16]; 0)
	REDUCE SELECTION:C351([ProductionSchedules_BlockTimes:136]; 0)
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	
	CLOSE WINDOW:C154
End if 