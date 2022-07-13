// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 6/27/01  16:56
// ----------------------------------------------------
// Form Method: [QA_Corrective_Actions].Input
// ----------------------------------------------------
// Modified by: Mel Bohince (10/7/21) fix line 48 to app_set_id_as_string (Table(->[QA_Corrective_Actions]))

Case of 
	: (Form event code:C388=On Outside Call:K2:11)
		If (Length:C16(<>jobit)>0)
			[QA_Corrective_Actions:105]Jobit:9:=<>jobit
			<>jobit:=""
			If (Length:C16([QA_Corrective_Actions:105]CustomerPO:12)=0)
				[QA_Corrective_Actions:105]CustomerPO:12:=<>PO
			End if 
			CAR_onEnterJobit
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		C_TEXT:C284(sRecordStatus)  //DJC - 5-17-05
		C_TEXT:C284(<>jobit)
		C_LONGINT:C283(<>pid_CAR)
		
		sRecordStatus:=""  //DJC - 5-17-05
		<>jobit:=""
		<>pid_CAR:=Current process:C322
		$i:=qryJMI([QA_Corrective_Actions:105]Jobit:9)
		$i:=qryFinishedGood([QA_Corrective_Actions:105]Custid:5; [QA_Corrective_Actions:105]ProductCode:7)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[QA_Corrective_Actions:105]Custid:5)
		//RELATE ONE([CorrectiveAction]Location)
		If (User in group:C338(Current user:C182; "RoleManagementTeam")) | (True:C214)  // Modified by: Mel Bohince (9/7/17) everyone
			SetObjectProperties("mgmtApprv@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		Else 
			SetObjectProperties("mgmtApprv@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
		hlCategoryTypes:=0
		ARRAY LONGINT:C221(aListRefStack; 0)
		CAR_getPurchaseOrders("")
		//SAVE LIST(hlCategoryTypes;"CaliperByStock")
		If (CAR_Locations("sizeOf")=0)
			$i:=CAR_Locations("init")
		End if 
		$i:=CAR_Locations("set")
		
		Case of 
			: (Is new record:C668([QA_Corrective_Actions:105]))  //new
				[QA_Corrective_Actions:105]RequestNumber:1:=app_set_id_as_string(Table:C252(->[QA_Corrective_Actions:105]))  //fGetNextID (->[QA_Corrective_Actions];5)
				[QA_Corrective_Actions:105]DateCreated:2:=4D_Current_date
				[QA_Corrective_Actions:105]Author:3:=<>zResp
				[QA_Corrective_Actions:105]CAR_Type:32:="Customer Reply Required"  //DJC - 5-12-05 default for CAR_Type
				[QA_Corrective_Actions:105]DateReported:22:=!00-00-00!  //DJC - 5-16-05
				
				If (User in group:C338(Current user:C182; "RoleQA")) | (True:C214)  // Modified by: Mel Bohince (9/7/17) everyone
					SetObjectProperties("qa@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
					hlCategoryTypes:=CAR_BuildReasonList("init")
					OBJECT SET ENABLED:C1123(bDelete; True:C214)
					OBJECT SET ENABLED:C1123(bRGA; True:C214)
				Else 
					SetObjectProperties("qa@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
					CAR_getCostCenters("")
					OBJECT SET ENABLED:C1123(bDelete; False:C215)
					OBJECT SET ENABLED:C1123(bRGA; False:C215)
				End if 
				
			: (Not:C34(Read only state:C362([QA_Corrective_Actions:105])))  //modify
				CAR_getCostCenters([QA_Corrective_Actions:105]Jobit:9)
				CAR_getPurchaseOrders([QA_Corrective_Actions:105]ProductCode:7)
				If (Size of array:C274(aPO)=1)
					If (Length:C16([QA_Corrective_Actions:105]CustomerPO:12)=0)
						[QA_Corrective_Actions:105]CustomerPO:12:=aPO{1}
					End if 
				End if 
				
				If (User in group:C338(Current user:C182; "RoleQA")) | (True:C214)  // Modified by: Mel Bohince (9/7/17) everyone
					SetObjectProperties("qa@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
					hlCategoryTypes:=CAR_BuildReasonList("init")
					OBJECT SET ENABLED:C1123(bDelete; True:C214)
					OBJECT SET ENABLED:C1123(bRGA; True:C214)
				Else 
					SetObjectProperties("qa@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
					CAR_getCostCenters("")
					OBJECT SET ENABLED:C1123(bDelete; False:C215)
					OBJECT SET ENABLED:C1123(bRGA; False:C215)
					OBJECT SET ENABLED:C1123(bDelete; False:C215)
					OBJECT SET ENABLED:C1123(bPick; False:C215)
					OBJECT SET ENABLED:C1123(bDup; False:C215)
					OBJECT SET ENABLED:C1123(bEmail; False:C215)
					CAR_Locations("size"; 0)
				End if 
				
			Else   //review
				CAR_getCostCenters("")
				OBJECT SET ENABLED:C1123(bRGA; False:C215)
				OBJECT SET ENABLED:C1123(bDelete; False:C215)
				OBJECT SET ENABLED:C1123(bPick; False:C215)
				OBJECT SET ENABLED:C1123(bDup; False:C215)
				OBJECT SET ENABLED:C1123(bEmail; False:C215)
				CAR_Locations("size"; 0)
		End case 
		
		If (([QA_Corrective_Actions:105]DateReported:22#!00-00-00!) & ([QA_Corrective_Actions:105]DateReported:22#<>MAGIC_DATE))  //DJC - 5-16-05
			OBJECT SET ENABLED:C1123(bReportedToCustomer; False:C215)  //its a good date already reported
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]DateReported:22; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
		//set the button text on the internal notes & to dos button
		CAR_Set_InternalNotes_Btn_Txt  //DJC - 5/17/05
		
		READ WRITE:C146([To_Do_Tasks:100])  //mlb 10/19/05
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2="CAR"+[QA_Corrective_Actions:105]RequestNumber:1)
		ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Task:3; >)
		C_LONGINT:C283(hlAssignable)
		hlAssignable:=Load list:C383("ToDoAssignable")
		//set CARType radio button
		CAR_Set_CARType_RadioButton  //DJC - 5/12/05
		
		If (User in group:C338(Current user:C182; "RoleQA_Mgr")) | (True:C214)  // Modified by: Mel Bohince (9/7/17) everyone //DJC - 5/12/05
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]RootCause:17; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]ActionTaken:18; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]CAwho:25; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]CAwhen:26; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]DateEffective:19; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]ApprovalPlantMgr:20; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]ApprovalQAMgr:21; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		Else 
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]RootCause:17; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]ActionTaken:18; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]CAwho:25; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]CAwhen:26; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]DateEffective:19; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]ApprovalPlantMgr:20; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[QA_Corrective_Actions:105]ApprovalQAMgr:21; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		CAR_Button_Clicked("Modify a To Do")
		
	: (Form event code:C388=On Unload:K2:2)
		//CAR_BuildReasonList ("kill")
		CAR_getCostCenters("")
		REDUCE SELECTION:C351([QA_Corrective_ActionsLocations:107]; 0)
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
		
	: (Form event code:C388=On Validate:K2:3)
		REDUCE SELECTION:C351([QA_Corrective_ActionsLocations:107]; 0)
End case 