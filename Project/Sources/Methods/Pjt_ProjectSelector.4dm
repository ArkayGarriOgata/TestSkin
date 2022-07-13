//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 3/24/00
// ----------------------------------------------------
// Method: Pjt_ProjectSelector
// Description:
// Hieracheical list to navigate projects
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>pjt_picker; pjt_picker; pjtItemSelected; $newPosition)

Case of 
	: ($1="clicked")
		<>pjtId:=""
		pjtItemSelected:=Selected list items:C379(pjt_picker)
		GET LIST ITEM:C378(pjt_picker; pjtItemSelected; $refNum; $project; $sublist)
		If ($refNum>=0)  //customers have negative refs
			ControlCtrLoadTabs(True:C214)  // Added by: Mark Zinke (4/15/13) Large list.
			GOTO RECORD:C242([Customers_Projects:9]; $refNum)
			pjtId:=[Customers_Projects:9]id:1
			Pjt_setReferId(pjtId)
			pjtName:=$project
			pjtCustid:=[Customers_Projects:9]Customerid:3
			pjtCustName:=[Customers_Projects:9]CustomerName:4
			zwStatusMsg("PROJECT"; "Gathering info, Please Wait...")
			
			QUERY:C277([Customers:16]; [Customers:16]ID:1=pjtCustid)
			zwStatusMsg("PROJECT:"; $project+" displayed")
			OBJECT SET ENABLED:C1123(*; "customerSelected@"; False:C215)
			OBJECT SET ENABLED:C1123(*; "projectSelected@"; True:C214)
			SetObjectProperties("pjtData@"; -><>NULL; True:C214)
			
			If (User in group:C338(Current user:C182; "RolePlanner"))
				SetObjectProperties("planner@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("planner@"; -><>NULL; False:C215)
			End if 
			
			If (User in group:C338(Current user:C182; "SalesManager"))
				SetObjectProperties("acctMgr@"; -><>NULL; True:C214)
				SetObjectProperties("planner@"; -><>NULL; True:C214)
			Else 
				SetObjectProperties("acctMgr@"; -><>NULL; False:C215)
			End if 
			
			OBJECT SET ENABLED:C1123(bTeam; True:C214)
			SetObjectProperties(""; ->bTeam; True:C214; "Project Team")
			
			READ ONLY:C145([Finished_Goods_Color_SpecMaster:128])
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4=pjtId)
			FORM GOTO PAGE:C247(ppHome)
			SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 1)
			
		Else   //name selected
			ControlCtrLoadTabs(False:C215)  // Added by: Mark Zinke (4/15/13) Small list.
			REDUCE SELECTION:C351([Customers_Projects:9]; 0)
			REDUCE SELECTION:C351([Estimates:17]; 0)
			REDUCE SELECTION:C351([Job_Forms:42]; 0)
			REDUCE SELECTION:C351([Customers_Orders:40]; 0)
			REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
			REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
			REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
			REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
			REDUCE SELECTION:C351([Finished_Goods_Color_SpecMaster:128]; 0)
			REDUCE SELECTION:C351([Finished_Goods_Color_SpecSolids:129]; 0)
			pjtCustid:=String:C10($refNum*-1; "00000")
			pjtCustName:=$project
			pjtId:=""
			pjtName:=""
			
			If (Not:C34(Is a list:C621($sublist)))  //get the projects if any
				QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]Customerid:3=pjtCustid)
				If (Records in selection:C76([Customers_Projects:9])>0)
					SELECTION TO ARRAY:C260([Customers_Projects:9]; $aRecNo; [Customers_Projects:9]Name:2; $aPjt)
					SORT ARRAY:C229($aPjt; $aRecNo; >)
					$subList:=utl_ListNew
					For ($pjt; 1; Size of array:C274($aRecNo))
						APPEND TO LIST:C376($subList; $aPjt{$pjt}; $aRecNo{$pjt})
					End for 
					SET LIST ITEM:C385(pjt_picker; $refNum; pjtCustName; $refNum; $subList; True:C214)
					SET LIST ITEM:C385(<>pjt_picker; $refNum; pjtCustName; $refNum; $subList; False:C215)
					//REDRAW LIST(pjt_picker)
					zwStatusMsg("PROJECT"; "Select a project for "+$project)
				Else 
					zwStatusMsg("PROJECT"; "Create a project for "+$project)
				End if 
			End if 
			
			QUERY:C277([Customers:16]; [Customers:16]ID:1=pjtCustid)
			OBJECT SET ENABLED:C1123(*; "customerSelected@"; True:C214)
			OBJECT SET ENABLED:C1123(*; "projectSelected@"; False:C215)
			SetObjectProperties("pjtData@"; -><>NULL; False:C215)
			
			If (User in group:C338(Current user:C182; "SalesManager"))
				OBJECT SET ENABLED:C1123(bTeam; True:C214)
				SetObjectProperties(""; ->bTeam; True:C214; "Customer Team")
			Else 
				OBJECT SET ENABLED:C1123(bTeam; False:C215)
			End if 
			SetObjectProperties("acctMgr@"; -><>NULL; False:C215)
			FORM GOTO PAGE:C247(ppCust)
			SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 11)
		End if 
		
	: ($1="construct")  //maintain a master and a copy for current process
		C_LONGINT:C283(pjt_picker; $cust; $custRef)
		If (Is a list:C621(pjt_picker))
			CLEAR LIST:C377(pjt_picker)
		End if 
		
		If (True:C214)
			ARRAY TEXT:C222(<>aCustid; 0)
		Else 
			If (Size of array:C274(<>aCustid)>0)
				If (User in group:C338(Current user:C182; "ProjectsManager"))
					CONFIRM:C162("Refresh customers?"; "Refresh"; "Cancel")
					If (ok=1)
						ARRAY TEXT:C222(<>aCustid; 0)
					End if 
				End if 
			End if 
		End if 
		
		If (Size of array:C274(<>aCustid)=0)
			<>pjt_picker:=utl_ListNew
			READ ONLY:C145([Customers:16])
			If (User in group:C338(Current user:C182; "ProjectsManager"))
				uConfirm("Show which customers?"; "Mine"; "All")
				If (ok=1)
					app_Log_Usage("log"; "ProjectsManager"; "mine")
					SET WINDOW TITLE:C213("Project Control Center - Mine")
					$numCust:=User_AllowedRecords(Table name:C256(->[Customers:16]))
					//QUERY([CustomerBookings];[CustomerBookings]FiscalYear=2000)
					//uRelateSelect (->[CUSTOMER]ID;->[CustomerBookings]Custid)
				Else 
					app_Log_Usage("log"; "ProjectsManager"; "all")
					SET WINDOW TITLE:C213("Project Control Center - All")
					ALL RECORDS:C47([Customers:16])
				End if 
			Else 
				$numCust:=User_AllowedRecords(Table name:C256(->[Customers:16]))
			End if 
			
			SELECTION TO ARRAY:C260([Customers:16]ID:1; <>aCustid; [Customers:16]Name:2; $aCustName)
			REDUCE SELECTION:C351([Customers:16]; 0)
			SORT ARRAY:C229($aCustName; <>aCustid; >)
			For ($cust; 1; Size of array:C274(<>aCustid))
				$custRef:=Num:C11(<>aCustid{$cust})*-1
				APPEND TO LIST:C376(<>pjt_picker; $aCustName{$cust}; $custRef)
			End for 
			pjt_picker:=utl_ListNew(<>pjt_picker)
			SET LIST PROPERTIES:C387(pjt_picker; 0)
		Else 
			pjt_picker:=utl_ListNew(<>pjt_picker)
			SET LIST PROPERTIES:C387(pjt_picker; 0)
			
			//REDRAW LIST(pjt_picker)
		End if 
		
	: ($1="insertProject")  //Insert it and make a new leaf 
		$refNum:=Num:C11(pjtCustid)*-1
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]Customerid:3=pjtCustid)
		If (Records in selection:C76([Customers_Projects:9])>0)
			SELECTION TO ARRAY:C260([Customers_Projects:9]; $aRecNo; [Customers_Projects:9]Name:2; $aPjt)
			SORT ARRAY:C229($aPjt; $aRecNo; >)
			$subList:=utl_ListNew
			For ($pjt; 1; Size of array:C274($aRecNo))
				APPEND TO LIST:C376($subList; $aPjt{$pjt}; $aRecNo{$pjt})
			End for 
			SET LIST ITEM:C385(pjt_picker; $refNum; pjtCustName; $refNum; $subList; True:C214)
			SET LIST ITEM:C385(<>pjt_picker; $refNum; pjtCustName; $refNum; $subList; False:C215)
		End if 
		
		SELECT LIST ITEMS BY REFERENCE:C630(pjt_picker; $2->)
		//REDRAW LIST(pjt_picker)
		GOTO RECORD:C242([Customers_Projects:9]; $2->)
		
		OBJECT SET ENABLED:C1123(*; "customerSelected@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "projectSelected@"; True:C214)
		SetObjectProperties("pjtData@"; -><>NULL; True:C214)
		If (User in group:C338(Current user:C182; "AccountManager"))
			SetObjectProperties("acctMgr@"; -><>NULL; True:C214)
		Else 
			SetObjectProperties("acctMgr@"; -><>NULL; False:C215)
		End if 
		
	: ($1="insertCustomer")
		OBJECT SET ENABLED:C1123(*; "customerSelected@"; True:C214)
		OBJECT SET ENABLED:C1123(*; "projectSelected@"; False:C215)
		SetObjectProperties("pjtData@"; -><>NULL; False:C215)
		SetObjectProperties("acctMgr@"; -><>NULL; False:C215)
End case 