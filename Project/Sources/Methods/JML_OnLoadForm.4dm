//%attributes = {"publishedWeb":true}
//Procedure: JML_OnLoadForm  012298  MLB
//trimdown the layout proc
//•021898  MLB  strip out old code
// Modified by: Mel Bohince (6/12/15) add sales rep to email
// Modified by: Garri Ogata (9/8/21) bDeleteRec change to bDelete

C_TEXT:C284(plannerOnRecord; custServiceRep; coordinator; salesrep)
ARRAY TEXT:C222(aMfgPlant; 0)

zwStatusMsg("Job Mstr Log"; "Opening record "+[Job_Forms_Master_Schedule:67]JobForm:4)
sAction:="Modify"  //•2/21/97 cs done so that user can double click on FG included   
MESSAGES OFF:C175

SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]PlannerReleased:14; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]eBag:61; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]RepeatJob:27; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]MAD:21; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]OrigRevDate:20; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]PressDate:25; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]DateClosingMet:23; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]LocationOfMfg:30; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]Operations:36; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]WeekNumber:38; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]DurationPrinting:37; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]ProjectNumber:26; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)

SetObjectProperties(""; ->tHold; False:C215)  // Modified by: Mark Zinke (5/6/13)

OBJECT SET ENABLED:C1123(bDelete; False:C215)  // Modified by: Garri Ogata (9/8/21)
OBJECT SET ENABLED:C1123(bPressPicker; False:C215)
OBJECT SET ENABLED:C1123(bRevisedpicker; False:C215)
OBJECT SET ENABLED:C1123(bMADpicker; False:C215)
OBJECT SET ENABLED:C1123(bPlnRelPicker; False:C215)
OBJECT SET ENABLED:C1123(bChgStock; False:C215)
OBJECT SET ENABLED:C1123(bReOpen; False:C215)
tHold:=""

READ ONLY:C145([Estimates:17])  //*Load the Estimate
QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=[Job_Forms_Master_Schedule:67]ProjectNumber:26)
plannerOnRecord:=""
custServiceRep:=""
coordinator:=""
salesrep:=""

READ ONLY:C145([Customers:16])
QUERY:C277([Customers:16]; [Customers:16]Name:2=[Job_Forms_Master_Schedule:67]Customer:2)
If (Records in selection:C76([Customers:16])>0)
	plannerOnRecord:=[Customers:16]PlannerID:5
	custServiceRep:=[Customers:16]CustomerService:46
	coordinator:=[Customers:16]SalesCoord:45
	salesrep:=[Customers:16]SalesmanID:3
End if 

If (Length:C16(plannerOnRecord)>0) | ([Job_Forms_Master_Schedule:67]Customer:2=<>CombinedCustomerName)
	If (<>zResp=plannerOnRecord) | (Current user:C182="Designer") | ([Job_Forms_Master_Schedule:67]Customer:2=<>CombinedCustomerName)
		SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]PlannerReleased:14; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]RepeatJob:27; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bPlnRelPicker; True:C214)
	End if 
End if 

If (User in group:C338(Current user:C182; "MAD Date Input"))  //RoleOperations is in this group
	SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]MAD:21; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bMADpicker; True:C214)
	OBJECT SET ENABLED:C1123(bReOpen; True:C214)
End if 

If (User in group:C338(Current user:C182; "JobGateKeeper")) | (Current user:C182="Designer")
	SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]DateClosingMet:23; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
End if 

If (User in group:C338(Current user:C182; "RoleOperations")) | (Current user:C182="Designer")
	SetObjectProperties(""; ->[Job_Forms_Master_Schedule:67]PressDate:25; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bPressPicker; True:C214)
	OBJECT SET ENABLED:C1123(bRevisedpicker; True:C214)  //now No Print button
	ARRAY TEXT:C222(aMfgPlant; 0)
	LIST TO ARRAY:C288("Locations"; aMfgPlant)
	OBJECT SET ENABLED:C1123(bDelete; True:C214)  // Modified by: Garri Ogata (9/8/21)
	OBJECT SET ENABLED:C1123(bChgStock; True:C214)
End if 

//• 2/21/97 mods for upr 1848 - change in tracking of artwork
$EndString:=Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; Length:C16([Job_Forms_Master_Schedule:67]JobForm:4)-1)
If ($EndString="00") | ($EndString="**")  //*  if this is a planed not an actual job yet
	READ ONLY:C145([Estimates_Carton_Specs:19])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Job_Forms_Master_Schedule:67]ProjectNumber:26+"@"; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Estimates_Carton_Specs:19]ProductCode:5; 1)
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
		QUERY:C277([Finished_Goods:26]; [Estimates_Carton_Specs:19]Estimate_No:2=[Job_Forms_Master_Schedule:67]ProjectNumber:26+"@"; *)  //find Estimate Qty worksheet
		QUERY:C277([Finished_Goods:26];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	CREATE SET:C116([Finished_Goods:26]; "ToProduce")
	CREATE SET:C116([Finished_Goods:26]; "Hold")  //• 3/11/97 used to return FG selection if report printed from art screen  
	uClearSelection(->[Estimates_Carton_Specs:19])
	
Else   //*  This is a job now
	READ WRITE:C146([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
	$custid:=[Job_Forms_Items:44]CustId:15  //• mlb - 3/22/02  16:52
	READ WRITE:C146([Finished_Goods:26])
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 1)
		If ([Job_Forms_Master_Schedule:67]Customer:2#<>CombinedCustomerName)  // • mel (4/5/05, 11:36:28)
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$custid)  //• mlb - 3/22/02  16:52
		End if 
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
		RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
		If ([Job_Forms_Master_Schedule:67]Customer:2#<>CombinedCustomerName)  // • mel (4/5/05, 11:36:28)
			QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$custid)  //• mlb - 3/22/02  16:52
		End if 
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	CREATE SET:C116([Finished_Goods:26]; "ToProduce")
	CREATE SET:C116([Finished_Goods:26]; "Hold")  //• 3/11/97 used to return FG selection if report printed from art screen
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Job_Forms_Items:44])
		
	Else 
		
		// we have line 107
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	READ ONLY:C145([Job_Forms:42])
	RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
	Core_ObjectSetColor(->tHold; -(Red:K11:4+(256*White:K11:1)))
	Case of 
		: (Position:C15("hold"; [Job_Forms:42]Status:6)>0)
			tHold:="HOLD"
			SetObjectProperties(""; ->tHold; True:C214)  // Modified by: Mark Zinke (5/6/13)
		: (Position:C15("kill"; [Job_Forms:42]Status:6)>0)
			tHold:="KILL"
			SetObjectProperties(""; ->tHold; True:C214)  // Modified by: Mark Zinke (5/6/13)
		: (Position:C15("WIP"; [Job_Forms:42]Status:6)>0)
			tHold:="WIP"
			SetObjectProperties(""; ->tHold; True:C214; ""; True:C214; Green:K11:9; White:K11:1)  // Modified by: Mark Zinke (5/6/13)
		Else 
			tHold:=""
			SetObjectProperties(""; ->tHold; False:C215)  // Modified by: Mark Zinke (5/6/13)
	End case 
	READ ONLY:C145([Jobs:15])
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
End if 

ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)  //•031397  mBohince  

If (FORM Get current page:C276=2)
	READ WRITE:C146([To_Do_Tasks:100])
	QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))
	ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2; >; [To_Do_Tasks:100]Task:3; >)
Else 
	REDUCE SELECTION:C351([To_Do_Tasks:100]; 0)
End if 

rb1:=1
rb2:=0
If (Length:C16([Job_Forms_Master_Schedule:67]JobForm:4)=8) & (Substring:C12([Job_Forms_Master_Schedule:67]JobForm:4; 7; 2)#"**")
	rb2:=1
	rb1:=0
	READ ONLY:C145([JTB_Job_Transfer_Bags:112])
	QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3=[Job_Forms_Master_Schedule:67]JobForm:4)
	tText:=""
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		For ($i; 1; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
			tText:=tText+"JTB: "+[JTB_Job_Transfer_Bags:112]ID:1+" at "+[JTB_Job_Transfer_Bags:112]Location:4+"  "
			NEXT RECORD:C51([JTB_Job_Transfer_Bags:112])
		End for 
		
	Else 
		
		
		ARRAY TEXT:C222($_ID; 0)
		ARRAY TEXT:C222($_Location; 0)
		
		SELECTION TO ARRAY:C260([JTB_Job_Transfer_Bags:112]ID:1; $_ID; [JTB_Job_Transfer_Bags:112]Location:4; $_Location)
		
		For ($i; 1; Size of array:C274($_ID); 1)
			tText:=tText+"JTB: "+$_ID{$i}+" at "+$_Location{$i}+"  "
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	<>jobform:=[Job_Forms_Master_Schedule:67]JobForm:4
Else 
	<>jobform:=""
End if 

JML_setColors  //(12)

If ([Job_Forms_Master_Schedule:67]ProjectNumber:26="")  //this is required for keying these related records
	OBJECT SET ENABLED:C1123(b1Edit; False:C215)
	OBJECT SET ENABLED:C1123(b2New; False:C215)
	OBJECT SET ENABLED:C1123(b2Edit; False:C215)
	OBJECT SET ENABLED:C1123(b4New; False:C215)
	OBJECT SET ENABLED:C1123(b4Edit; False:C215)
End if 

If (iMode=3)
	DISABLE MENU ITEM:C150(4; 2)
	DISABLE MENU ITEM:C150(4; 3)
	DISABLE MENU ITEM:C150(4; 4)
	DISABLE MENU ITEM:C150(4; 5)
	DISABLE MENU ITEM:C150(5; 1)
	DISABLE MENU ITEM:C150(5; 2)
	DISABLE MENU ITEM:C150(4; 6)
	DISABLE MENU ITEM:C150(4; 1)
	OBJECT SET ENABLED:C1123(bRefresh; False:C215)
	OBJECT SET ENABLED:C1123(bSave; False:C215)
	OBJECT SET ENABLED:C1123(b1Edit; False:C215)
	OBJECT SET ENABLED:C1123(b2New; False:C215)
	OBJECT SET ENABLED:C1123(b2Edit; False:C215)
	OBJECT SET ENABLED:C1123(b4New; False:C215)
	OBJECT SET ENABLED:C1123(b4Edit; False:C215)
	
Else 
	ENABLE MENU ITEM:C149(4; 2)
	ENABLE MENU ITEM:C149(4; 3)
	ENABLE MENU ITEM:C149(4; 4)
	ENABLE MENU ITEM:C149(4; 5)
	ENABLE MENU ITEM:C149(5; 1)
	ENABLE MENU ITEM:C149(5; 2)
	ENABLE MENU ITEM:C149(4; 6)
	ENABLE MENU ITEM:C149(4; 1)
End if 