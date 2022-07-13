//◊iLayout:=4601  `(LP) [ReleaseSchedule]'Input
//4/25/95 this is so sales can use Askme
//5/4/95 add brand to release for Shipment qty by cust and brand rpt
//•061495  MLB  UPR 176 add count
//•092695  MLB  UPR 1729
//•101095  MLB  default the payU state
//•022597  MLB  clear some selections
//•102297  MLB  Chg Defaut to THC state
// Modified by: Mel Bohince (12/6/13) send email when a release inside the planning fence changes date.
// Modified by: Mel Bohince (9/13/16) warn if manually marking RFM as sent on unapproved launch item

Case of 
	: (Form event code:C388=On Load:K2:1)
		wWindowTitle("push"; "Release "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+" on "+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+" for orderline "+[Customers_ReleaseSchedules:46]OrderLine:4)
		BeforeRelease
		If (<>FloatingAlert_PID>0)
			HIDE PROCESS:C324(<>FloatingAlert_PID)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		Rel_ScheduleChgWarning(Old:C35([Customers_ReleaseSchedules:46]Sched_Date:5); [Customers_ReleaseSchedules:46]Sched_Date:5)  // Modified by: Mel Bohince (12/6/13) 
		uUpdateTrail(->[Customers_ReleaseSchedules:46]ModDate:18; ->[Customers_ReleaseSchedules:46]ModWho:19)
		// Modified by: Mel Bohince (3/3/15)  this could be more granular, whatever:
		// Modified by: Mel Bohince (9/30/15) made more granular, snap
		$dateChg:=(Old:C35([Customers_ReleaseSchedules:46]Sched_Date:5)#[Customers_ReleaseSchedules:46]Sched_Date:5)
		$qtyChg:=(Old:C35([Customers_ReleaseSchedules:46]Sched_Qty:6)#[Customers_ReleaseSchedules:46]Sched_Qty:6)
		If ($dateChg) | ($qtyChg)
			[Customers_ReleaseSchedules:46]THC_State:39:=9
			[Customers_ReleaseSchedules:46]THC_Date:38:=!00-00-00!
			[Customers_ReleaseSchedules:46]THC_Qty:37:=0
		End if 
		// Modified by: Mel Bohince (9/13/16) warn if manually marking RFM as sent on unapproved launch item
		If ([Customers_ReleaseSchedules:46]user_date_1:48#!00-00-00!) & (Old:C35([Customers_ReleaseSchedules:46]user_date_1:48)=!00-00-00!)
			If (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))
				If (qryLaunch("NotApproved")>0)
					uConfirm("RFM shouldn't be sent on unapproved Launch."; "Send"; "Clear")
					If (ok=0)
						[Customers_ReleaseSchedules:46]user_date_1:48:=!00-00-00!
					End if 
				End if 
			End if 
		End if 
		
		// Modified by: Mel Bohince (6/21/17) take out of trigger, only register human changes
		C_DATE:C307($fence)
		$fence:=Add to date:C393(4D_Current_date; 0; 0; 5)  // Modified by: Mel Bohince (6/8/17) 
		If ([Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")  //not a forecast
			If (Length:C16([Customers_ReleaseSchedules:46]CustomerRefer:3)>0)  //has a po
				If ([Customers_ReleaseSchedules:46]CustomerRefer:3#"NO_ORDERLINE")
					If ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)  //not already shipped
						If ([Customers_ReleaseSchedules:46]Sched_Date:5<=$fence) & ([Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
							If ([Customers_ReleaseSchedules:46]THC_State:39=0)  //has inventory
								If ([Customers_ReleaseSchedules:46]Shipto:10#"N/A") & ([Customers_ReleaseSchedules:46]Shipto:10#"00000")  //has a shipto
									$err:=Shuttle_Register("release"; ""; [Customers_ReleaseSchedules:46]ReleaseNumber:1)
								End if 
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
End case 
//EOP