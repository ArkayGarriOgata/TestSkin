// _______
// Method: [Customers_ReleaseSchedules].ReleaseMgmt   ( ) ->
//Layout Proc.: ReleaseMgmt()  022597  MLB
//•022597  MLB  optimize and haup v roan 
// Modified by: Mel Bohince (2/26/13)don't use avail inventory for color
// Added by: Mel Bohince (6/28/19) require numeric char in PO

Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Customers_Order_Lines:41]OrderLine:3#[Customers_ReleaseSchedules:46]OrderLine:4)
			RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)  //2/16/95
		End if 
		
		$ifForcast:=-(Light blue:K11:8+(256*0))
		$hasInventory:=-(Dark green:K11:10+(256*0))  //green text
		$isLaunch:=-(Orange:K11:3+(256*0))
		$isLaunchOK:=-(Green:K11:9+(256*0))
		$isLastRelease:=-(Red:K11:4+(256*0))  //red text
		$isNormal:=-(Black:K11:16+(256*0))  //blck text
		$isConsignment:=-(Brown:K11:14+(256*0))
		$isWarehouse:=-(Purple:K11:5+(256*0))
		$isPending:=-(Blue:K11:7+(256*0))
		$isNotBooked:=-(Light grey:K11:13+(256*0))
		$dim:=-(Grey:K11:15+(256*0))
		$mustship:=-(Red:K11:4+(256*0))
		
		Core_ObjectSetColor("*"; "@"; $isNormal; True:C214)
		Core_ObjectSetColor("*"; "Q@"; $isNormal; True:C214)
		
		If ([Customers_ReleaseSchedules:46]LastRelease:20)
			Core_ObjectSetColor("*"; "a@"; $isLastRelease; True:C214)
		End if 
		
		If (Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; 1)="<")  //forcast symbol
			Core_ObjectSetColor("*"; "a@"; $ifForcast; True:C214)
		End if 
		
		If (FG_ConsignmentItems("is"; [Customers_ReleaseSchedules:46]ProductCode:11))
			Core_ObjectSetColor("*"; "a@"; $isConsignment; True:C214)
		Else 
			If ([Customers_ReleaseSchedules:46]PayU:31=1)
				Core_ObjectSetColor("*"; "a@"; $isConsignment; True:C214)
			End if 
		End if 
		
		
		If (FG_LaunchItem("is"; [Customers_ReleaseSchedules:46]ProductCode:11))
			If (FG_LaunchItem("hold"; [Customers_ReleaseSchedules:46]ProductCode:11))
				Core_ObjectSetColor("*"; "L@"; $isLaunch; True:C214)
			Else 
				Core_ObjectSetColor("*"; "L@"; $isLaunchOK; True:C214)
			End if 
		End if 
		
		
		Case of 
			: (Position:C15("!"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
				Core_ObjectSetColor("*"; "L@"; $isLastRelease; True:C214)
			: (Position:C15("%"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
				Core_ObjectSetColor("*"; "L@"; $isLaunch; True:C214)
			: (Position:C15("$"; [Customers_ReleaseSchedules:46]Expedite:35)>0)
				Core_ObjectSetColor("*"; "L@"; $isLaunchOK; True:C214)
		End case 
		
		If ([Customers_ReleaseSchedules:46]MustShip:53)
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Date:5; $mustship; True:C214)
			OBJECT SET FONT STYLE:C166([Customers_ReleaseSchedules:46]Sched_Date:5; Bold:K14:2)
		Else 
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Date:5; $isNormal; True:C214)
			OBJECT SET FONT STYLE:C166([Customers_ReleaseSchedules:46]Sched_Date:5; Plain:K14:1)
		End if 
		
		If (cbCalcInv=1)  //verbose inventory
			$fg_key:=[Customers_ReleaseSchedules:46]CustID:12+":"+[Customers_ReleaseSchedules:46]ProductCode:11
			r2:=FG_Inventory_Array("lookupFG"; $fg_key)
			r3:=FG_Inventory_Array("lookupEX"; $fg_key)
			
			Case of   //location indicators, do them in this order
				: (FG_Inventory_Array("lookupOS"; $fg_key)>0)
					sStatus:="X"
					
				: (FG_Inventory_Array("lookupPlant"; $fg_key)>0)
					sStatus:="P"
					
				: (FG_Inventory_Array("lookupVista"; $fg_key)>0)
					sStatus:="V"
					
				Else 
					sStatus:=""
			End case 
			
		Else   //don't calc inventory
			r2:=0
			r3:=0
			sStatus:=""
		End if   //inventory
		
		// Modified by: Mel Bohince (2/26/13)don't use avail inventory for color
		If ([Customers_ReleaseSchedules:46]THC_State:39=0)
			Core_ObjectSetColor("*"; "Q@"; $hasInventory)
		End if 
		
		//
		If ([Customers_ReleaseSchedules:46]B_O_L_pending:45>0) & ([Customers_ReleaseSchedules:46]B_O_L_number:17=0)
			Core_ObjectSetColor("*"; "a@"; $isPending; True:C214)
			Core_ObjectSetColor("*"; "L@"; $isPending; True:C214)
			Core_ObjectSetColor("*"; "Q@"; $isPending; True:C214)
		End if 
		
		//If ([Finished_Goods]WarehouseProgram)
		//SET COLOR(*;"L@";$isWarehouse)
		//End if 
		
		If (cbOpenJobs=1)
			tText:=JMI_plannedProduction([Customers_ReleaseSchedules:46]ProductCode:11; [Customers_ReleaseSchedules:46]OrderLine:4)
		Else 
			tText:="rel# "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1; "#### ###")
		End if   //show open jobs
		
		If (cbTooling=1)
			t10:=FG_NeedTooling([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
		Else 
			t10:=""
		End if 
		
		If (Position:C15([Customers_Order_Lines:41]Status:9; " Accepted Budgeted ")=0)  //forcast symbol
			Core_ObjectSetColor("*"; "a@"; $dim; True:C214)
			Core_ObjectSetColor("*"; "Q@"; $isNotBooked; True:C214)
			Core_ObjectSetColor("*"; "L@"; $dim; True:C214)
		End if 
		
		If (util_isOnlyAlpha([Customers_Order_Lines:41]PONumber:21))  // Added by: Mel Bohince (6/28/19) require numeric char in PO
			If (util_isOnlyAlpha([Customers_ReleaseSchedules:46]CustomerRefer:3))  //maybe the release is cool
				Core_ObjectSetColor("*"; "a@"; $dim; True:C214)
				Core_ObjectSetColor("*"; "Q@"; $isNotBooked; True:C214)
				Core_ObjectSetColor("*"; "L@"; $dim; True:C214)
			End if 
		End if 
		
	: (Form event code:C388=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Customers_ReleaseSchedules:46]; "clickedIncluded")
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties("SameDestination"; -><>NULL; True:C214; ShipToButtonText)
		SetObjectProperties("WaitingMode"; -><>NULL; True:C214; WaitingModeButtonText)
		
End case 

app_basic_list_form_method