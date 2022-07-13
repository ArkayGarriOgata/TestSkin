//%attributes = {}
// -------
// Method: api_Milestones   ( ) ->
// By: Mel Bohince @ 06/09/17, 11:45:02
// Description
// based on api_jobs
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements)
C_TEXT:C284($jobform; $1; $0; $res; $salerep; $coord; $plnr)
C_OBJECT:C1216($obj_by_value)
C_BOOLEAN:C305($debug)
$debug:=False:C215
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([ProductionSchedules:110])
READ ONLY:C145([Customers_ReleaseSchedules:46])

If (Count parameters:C259=0) & (Not:C34($debug))  //rtn a collection
	
Else   //got me some params
	
	If (Not:C34($debug))
		$jobform:=$1
	Else 
		$jobform:="98808.01"  //"98707.01"  //"98626.01" 
	End if 
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
	If (Records in selection:C76([Job_Forms:42])=1)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform)
		
		C_OBJECT:C1216($Job)
		OB SET:C1220($Job; "jobform"; $jobform)
		OB SET:C1220($Job; "customer"; CUST_getName([Job_Forms:42]cust_id:82))
		OB SET:C1220($Job; "line"; [Job_Forms:42]CustomerLine:62)
		OB SET:C1220($Job; "project"; Pjt_getName([Job_Forms:42]ProjectNumber:56))
		Cust_getTeam([Job_Forms:42]cust_id:82; ->$salerep; ->$coord; ->$plnr)
		OB SET:C1220($Job; "planner"; User_GetName($plnr))
		OB SET:C1220($Job; "netsheets"; [Job_Forms:42]EstNetSheets:28)
		OB SET:C1220($Job; "sheetsize"; (String:C10([Job_Forms:42]Width:23)+" x "+String:C10([Job_Forms:42]Lenth:24)+" "+(Num:C11([Job_Forms:42]ShortGrain:48)*" SHORT GRAIN")))
		OB SET:C1220($Job; "version"; String:C10([Job_Forms:42]VersionDate:58; Internal date short special:K1:4)+"v"+String:C10([Job_Forms:42]VersionNumber:57))
		
		OB SET:C1220($Job; "released"; String:C10([Job_Forms:42]PlnnerReleased:59; Internal date short special:K1:4))
		OB SET:C1220($Job; "needed"; String:C10([Job_Forms:42]NeedDate:1; Internal date short special:K1:4))
		OB SET:C1220($Job; "lead_have_ready"; String:C10([Job_Forms_Master_Schedule:67]MAD:21; Internal date short special:K1:4))
		OB SET:C1220($Job; "first_release"; String:C10([Job_Forms_Master_Schedule:67]FirstReleaseDat:13; Internal date short special:K1:4))
		OB SET:C1220($Job; "gateway_deadline"; String:C10([Job_Forms_Master_Schedule:67]GateWayDeadLine:42; Internal date short special:K1:4))
		OB SET:C1220($Job; "gateway_met"; String:C10([Job_Forms_Master_Schedule:67]DateClosingMet:23; Internal date short special:K1:4))
		OB SET:C1220($Job; "final_art"; String:C10([Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; Internal date short special:K1:4))
		OB SET:C1220($Job; "final_oks"; String:C10([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18; Internal date short special:K1:4))
		
		OB SET:C1220($Job; "bag_received"; String:C10([Job_Forms_Master_Schedule:67]DateBagReceived:48; Internal date short special:K1:4))
		OB SET:C1220($Job; "bag_approved"; String:C10([Job_Forms_Master_Schedule:67]DateBagApproved:49; Internal date short special:K1:4))
		OB SET:C1220($Job; "bag_returned"; String:C10([Job_Forms_Master_Schedule:67]DateBagReturned:52; Internal date short special:K1:4))
		
		OB SET:C1220($Job; "stock_due"; String:C10([Job_Forms_Master_Schedule:67]DateStockDue:16; Internal date short special:K1:4))
		OB SET:C1220($Job; "stock_received"; String:C10([Job_Forms_Master_Schedule:67]DateStockRecd:17; Internal date short special:K1:4))
		OB SET:C1220($Job; "started"; String:C10([Job_Forms:42]StartDate:10; Internal date short special:K1:4))
		OB SET:C1220($Job; "sheeted"; String:C10([Job_Forms_Master_Schedule:67]DateStockSheeted:47; Internal date short special:K1:4))
		OB SET:C1220($Job; "printed"; String:C10([Job_Forms_Master_Schedule:67]Printed:32; Internal date short special:K1:4))
		OB SET:C1220($Job; "glue_ready"; String:C10([Job_Forms_Master_Schedule:67]GlueReady:28; Internal date short special:K1:4))
		OB SET:C1220($Job; "complete"; String:C10([Job_Forms:42]Completed:18; Internal date short special:K1:4))
		OB SET:C1220($Job; "closed"; String:C10([Job_Forms:42]ClosedDate:11; Internal date short special:K1:4))
		//$res:=JSON Stringify($Job)
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			//get items
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7; >)
				For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
					$firstRel:=JMI_get1stRelease
					OB SET:C1220($item; "item"; [Job_Forms_Items:44]ItemNumber:7; "cpn"; [Job_Forms_Items:44]ProductCode:3; "have_ready"; String:C10([Job_Forms_Items:44]MAD:37; Internal date short special:K1:4); "first_release"; String:C10($firstRel; Internal date short special:K1:4); "glued"; String:C10([Job_Forms_Items:44]Glued:33; Internal date short special:K1:4))
					$obj_by_value:=OB Copy:C1225($item)
					APPEND TO ARRAY:C911($items; $obj_by_value)
					NEXT RECORD:C51([Job_Forms_Items:44])
				End for 
				OB SET ARRAY:C1227($Job; "items"; $items)
			End if 
			
			//get route
			C_OBJECT:C1216($operation)
			ARRAY OBJECT:C1221($route; 0)
			
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=($jobform+"@"))
			If (Records in selection:C76([ProductionSchedules:110])>0)
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8; >)
				For ($i; 1; Records in selection:C76([ProductionSchedules:110]))
					OB SET:C1220($operation; "sequence"; Substring:C12([ProductionSchedules:110]JobSequence:8; 10; 3); "c/c"; [ProductionSchedules:110]CostCenter:1; "planned_start"; String:C10([ProductionSchedules:110]StartDate:4; Internal date short special:K1:4); "planned_time"; String:C10([ProductionSchedules:110]StartTime:5; HH MM:K7:2); "duration"; String:C10([ProductionSchedules:110]DurationSeconds:9; HH MM:K7:2))
					//
					// see PS_SetReadyColors and JML_cacheInfo for tooling dates
					
					$obj_by_value:=OB Copy:C1225($operation)
					APPEND TO ARRAY:C911($route; $obj_by_value)
					
					NEXT RECORD:C51([ProductionSchedules:110])
				End for 
				
				OB SET ARRAY:C1227($Job; "route"; $route)
				
			End if 
			
		Else 
			
			//get items
			ARRAY OBJECT:C1221($items; 0)
			C_OBJECT:C1216($item)
			
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]ItemNumber:7; $_ItemNumber; [Job_Forms_Items:44]ProductCode:3; $_ProductCode; [Job_Forms_Items:44]MAD:37; $_MAD; [Job_Forms_Items:44]Glued:33; $_Glued; [Job_Forms_Items:44]OrderItem:2; $_OrderItem)
				
				SORT ARRAY:C229($_ItemNumber; $_ProductCode; $_MAD; $_Glued; $_OrderItem; >)
				For ($i; 1; Size of array:C274($_ItemNumber); 1)
					
					$firstRel:=<>MAGIC_DATE
					$jmi_peg:=$_OrderItem{$i}
					$thisCPN:=$_ProductCode{$i}
					
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$jmi_peg; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
					
					If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$thisCPN; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
					End if 
					
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						ORDER BY:C49([Customers_ReleaseSchedules:46]Sched_Date:5; >)
						$firstRel:=[Customers_ReleaseSchedules:46]Sched_Date:5
						
					End if 
					
					OB SET:C1220($item; "item"; $_ItemNumber{$i}; "cpn"; $_ProductCode{$i}; "have_ready"; String:C10($_MAD{$i}; Internal date short special:K1:4); "first_release"; String:C10($firstRel; Internal date short special:K1:4); "glued"; String:C10($_Glued{$i}; Internal date short special:K1:4))
					$obj_by_value:=OB Copy:C1225($item)
					APPEND TO ARRAY:C911($items; $obj_by_value)
				End for 
				OB SET ARRAY:C1227($Job; "items"; $items)
			End if 
			
			//get route
			C_OBJECT:C1216($operation)
			ARRAY OBJECT:C1221($route; 0)
			
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=($jobform+"@"))
			If (Records in selection:C76([ProductionSchedules:110])>0)
				SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $_JobSequence; [ProductionSchedules:110]CostCenter:1; $_CostCenter; [ProductionSchedules:110]StartDate:4; $_StartDate; [ProductionSchedules:110]StartTime:5; $_StartTime; [ProductionSchedules:110]DurationSeconds:9; $_Duration)
				
				SORT ARRAY:C229($_JobSequence; $_CostCenter; $_StartDate; $_StartTime; $_Duration; >)
				For ($i; 1; Size of array:C274($_JobSequence); 1)
					OB SET:C1220($operation; "sequence"; Substring:C12($_JobSequence{$i}; 10; 3); "c/c"; $_CostCenter{$i}; "planned_start"; String:C10($_StartDate{$i}; Internal date short special:K1:4); "planned_time"; String:C10($_StartTime{$i}; HH MM:K7:2); "duration"; String:C10($_Duration{$i}; HH MM:K7:2))
					$obj_by_value:=OB Copy:C1225($operation)
					APPEND TO ARRAY:C911($route; $obj_by_value)
				End for 
				
				OB SET ARRAY:C1227($Job; "route"; $route)
				
			End if 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		$res:=JSON Stringify:C1217($Job; *)
		If ($debug)
			utl_LogIt("init")
			utl_LogIt($res)
			utl_LogIt("show")
		Else 
			$0:=$res
		End if 
		
	Else 
		$res:="404 "+$jobform+" not found"
	End if 
	
End if   //count parameters

REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)

