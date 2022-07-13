$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		C_TEXT:C284(sCustid)  // Added by: Mark Zinke (12/20/12)
		util_alternateBackground(226; 255; 223; 255; 255; 255)
		Core_ObjectSetColor("*"; "a@"; -(Black:K11:16+(256*0)); True:C214)
		
		If ([Customers_ReleaseSchedules:46]LastRelease:20)
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Date:5; -(3+(256*0)); True:C214)
			Core_ObjectSetColor(->[Customers_ReleaseSchedules:46]Sched_Qty:6; -(3+(256*0)); True:C214)
		End if 
		
		If ([Customers_ReleaseSchedules:46]CustID:12#sCustid) & ([Customers_ReleaseSchedules:46]CustID:12#"")
			$r:=251  //light yellow
			$v:=244
			$b:=154
			$rvb:=($r*256*256)+($v*256)+$b
			OBJECT SET RGB COLORS:C628(*; "BackRect"; 127; $rvb)
		End if 
		
		If ([Customers_ReleaseSchedules:46]THC_State:39=0)
			Core_ObjectSetColor("*"; "a@"; -(Dark green:K11:10+(256*0)); True:C214)
		End if 
		
		If ([Customers_ReleaseSchedules:46]B_O_L_pending:45>0) & ([Customers_ReleaseSchedules:46]B_O_L_number:17=0)
			Core_ObjectSetColor("*"; "a@"; -(Blue:K11:7+(256*0)); True:C214)
		End if 
		
	: ($e=On Clicked:K2:4)
		
		C_OBJECT:C1216($oSum)
		
		$oSum:=New object:C1471()
		
		$oSum.pValue:=->[Customers_ReleaseSchedules:46]Sched_Qty:6
		$oSum.pTotal:=->FnGd_nAskMe_SumScheduled
		$oSum.tSet:="Customers_ReleaseSchedules"
		
		Core_Math_Sum($oSum)
		
	: ($e=On Double Clicked:K2:5)
		GET HIGHLIGHTED RECORDS:C902([Customers_ReleaseSchedules:46]; "Customers_ReleaseSchedules")
		CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "holdRel")
		USE SET:C118("Customers_ReleaseSchedules")
		pattern_PassThru(->[Customers_ReleaseSchedules:46])
		ViewSetter(2; ->[Customers_ReleaseSchedules:46])
		USE NAMED SELECTION:C332("holdRel")
End case 
