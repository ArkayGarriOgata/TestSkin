//%attributes = {"publishedWeb":true}
// doReviewRecord()
//see also doNewRecord, doModifyRecord
// Modified by: Mel Bohince (3/6/14) don't comment out 3rd argv
C_LONGINT:C283($winRef)

uSetUp(1; 1)
READ ONLY:C145(filePtr->)
windowTitle:=" Reviewing records"

If (<>PassThrough)
	useFindWidget:=False:C215  // Added by: Mel Bohince (6/12/19) 
	USE SET:C118("◊PassThroughSet")
	NumRecs1:=Records in selection:C76(filePtr->)
	CLEAR SET:C117("◊PassThroughSet")
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	CREATE SET:C116(filePtr->; "CurrentSet")
End if 

// ///Window
Case of   //•061695  MLB  UPR 1636
	: (filePtr=(->[Job_Forms:42]))
		Case of 
			: (<>JFActivity=1)  //• 10/21/97 cs open window ONCE
				$winRef:=OpenFormWindow(filePtr; "InputBudget"; ->windowTitle)
				
			: (<>JFActivity=2)  //• 10/21/97 cs open window ONCE  
				$winRef:=OpenFormWindow(filePtr; "InputActual2"; ->windowTitle)
				
			: (<>JFActivity=4)  //1/23/95 upr 167
				$winRef:=OpenFormWindow(filePtr; "ProductionClose"; ->windowTitle)
				
			Else 
				$winRef:=OpenFormWindow(filePtr; "Input"; ->windowTitle)
		End case 
		
	Else 
		$winRef:=OpenFormWindow(filePtr; "*"; ->windowTitle)  // Modified by: Mel Bohince (3/6/14) don't comment out 3rd argv
End case 

Case of 
	: (filePtr=(->[Purchase_Orders:11]))
		READ ONLY:C145([Purchase_Orders_Items:12])
		READ ONLY:C145([Purchase_Orders_Chg_Orders:13])
		
	: (filePtr=(->[Finished_Goods:26]))
		$boolean:=FG_LaunchItem("init")
		READ ONLY:C145([Finished_Goods_Classifications:45])  // Modified by: Mel Bohince (12/11/20) 
		READ ONLY:C145([Finished_Goods_Locations:35])  // Modified by: Mel Bohince (12/11/20) 
		
	: (filePtr=(->[Customers_ReleaseSchedules:46]))
		fLoop:=False:C215
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		
	: (filePtr=(->[Jobs:15]))
		CostCtrCurrent("init"; "00/00/00")
		
	: (filePtr=(->[Job_Forms:42]))
		CostCtrCurrent("init"; "00/00/00")
		Case of 
			: (<>JFActivity=3)  //form review
				READ ONLY:C145([Jobs:15])
				
			: (<>JFActivity=4)  //1/23/95 upr 167
				CostCtrCurrent("init"; "00/00/00")
				
		End case 
End case 

Case of 
	: (<>PassThrough)  //skip the search stuff    
		<>PassThrough:=False:C215
		OK:=1
		
		Case of 
			: (filePtr=(->[Users_Record_Accesses:94]))
				ORDER BY:C49([Users_Record_Accesses:94]; [Users_Record_Accesses:94]TableName:2; >; [Users_Record_Accesses:94]PrimaryKey:3; >)
				
		End case 
		
	Else 
		NumRecs1:=fSelectBy  //generic search equal or range on any four fields
		
		SET WINDOW TITLE:C213(fNameWindow(filePtr)+": "+String:C10(NumRecs1)+" Reviewing records")
		
End case 

If (OK=1)  //perform search
	Repeat 
		bModMany:=False:C215
		
		If (<>SCROLLING)
			bModMany:=True:C214
			DISPLAY SELECTION:C59(filePtr->)
			bModMany:=False:C215
			If (Records in selection:C76(filePtr->)=1)
				bdone:=1
			End if 
			
		Else 
			bModMany:=True:C214
			DISPLAY SELECTION:C59(filePtr->; Multiple selection:K50:3; False:C215; *)
			If (NumRecs1=1)
				bdone:=1
			End if 
			bModMany:=False:C215
		End if 
	Until (bdone>=1)
End if   //ok search
CLOSE WINDOW:C154($winRef)
uSetUp(0; 0)

Case of   //•031397  mBohince  entire case
	: (filePtr=(->[Estimates:17]))
		uClearEstimates
		<>Activitiy:=0
		thisActivity:="other"
		
	: (filePtr=(->[Customers_Orders:40]))
		fLoop:=False:C215
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		uClearSelection(->[Customers_Order_Lines:41])  //•022597  MLB  chg unloads to clear
		uClearSelection(->[Customers_ReleaseSchedules:46])
		uClearSelection(->[Estimates:17])
		
	: (filePtr=(->[Job_Forms:42]))
		If (<>JFActivity=4)
			//CostCtrCurrent ("kill")
		End if 
		<>JFActivity:=0
		uClearSelection(->[Jobs:15])  //•031397  mBohince  and the lines below as well
		uClearSelection(->[Job_Forms_Items:44])
		uClearSelection(->[Job_Forms_Machine_Tickets:61])
		uClearSelection(->[Job_Forms_Materials:55])
		uClearSelection(->[Job_Forms_Machines:43])
		uClearSelection(->[Job_Forms_CloseoutSummaries:87])
		uClearSelection(->[Finished_Goods_Transactions:33])
		uClearSelection(->[Raw_Materials_Transactions:23])
		
	: (filePtr=(->[Customers_Order_Change_Orders:34]))
		fChg:=False:C215
		fLoop:=False:C215
		
	Else 
		uClearSelection(filePtr)
End case 

uWinListCleanup  //• 7/23/97 cs 