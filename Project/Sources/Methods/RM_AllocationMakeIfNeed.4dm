//%attributes = {"publishedWeb":true}
//PM:  RM_AllocationMakeIfNeed()  082400  mlb
//Create an allocation if one is needed for board, sensors, coldfoil, {corrugate}
// Modified by: Mel Bohince (10/01/13) create RM_AllocateRM to handle sensors and coldfoil
// Modified by: Mel Bohince (10/30/13) include coldfoils budgeted as commodity 05 as well as the correct 09
// Modified by: Mel Bohince (9/11/15) look at rm xfers before creating new alloc
// OBSOLETE OBSOLETE OBSOLETEModified by: MelvinBohince (3/28/22) OBSOLETE date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations

C_DATE:C307($today; $dateNeeded)
C_LONGINT:C283($i; $numMJ)

READ WRITE:C146([Raw_Materials_Allocations:58])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Jobs:15])
READ ONLY:C145([Raw_Materials:21])
READ ONLY:C145([Job_Forms_Materials:55])

$today:=4D_Current_date
$dateNeeded:=<>MAGIC_DATE  //default need date 

//first do board since uom can be tricky
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12="01@"; *)  //Boards
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Actual_Qty:14=0; *)  //this is only a guess if GetActuals has never run on this job
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7#"")
$numMJ:=Records in selection:C76([Job_Forms_Materials:55])

uThermoInit($numMJ; "Creating Board Allocations")

For ($i; 1; $numMJ)
	GOTO SELECTED RECORD:C245([Job_Forms_Materials:55]; $i)
	uThermoUpdate($i)
	$continue:=False:C215
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Materials:55]JobForm:1)
	If (Records in selection:C76([Job_Forms:42])>0)
		If ([Job_Forms:42]Status:6#"C@")  //closed or complete
			If ([Job_Forms:42]ClosedDate:11=!00-00-00!)
				If ([Job_Forms:42]Completed:18=!00-00-00!)
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Materials:55]JobForm:1)
					If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
						Case of 
							: ([Job_Forms_Master_Schedule:67]Printed:32=!2001-01-01!)
								$continue:=True:C214
							: ([Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
								$continue:=False:C215
							: ([Job_Forms_Master_Schedule:67]GlueReady:28#!00-00-00!)
								$continue:=False:C215
							Else 
								$continue:=True:C214
								If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
									$dateNeeded:=[Job_Forms_Master_Schedule:67]PressDate:25
								Else 
									$dateNeeded:=<>MAGIC_DATE
								End if 
						End case 
					End if 
				End if 
			End if 
		End if   //[Material_Job]Raw_Matl_Code;[Material_Job]Planned_Qty    
	End if 
	
	If ($continue)  //uncompleted job
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
		If (Records in selection:C76([Raw_Materials:21])=0)
			$continue:=False:C215
		End if 
	End if 
	
	If ($continue)  //valid RM code
		$qty:=0
		If ([Job_Forms:42]ShortGrain:48)
			$length:=[Job_Forms:42]Width:23
		Else 
			$length:=[Job_Forms:42]Lenth:24
		End if 
		Case of 
			: ([Job_Forms_Materials:55]UOM:5="MSF")
				//$qty:=1000*[Material_Job]Planned_Qty/([JobForm]Width/12)
				$qty:=[Job_Forms:42]EstGrossSheets:27*($length/12)
				$uom:="LF"
				
			: ([Job_Forms_Materials:55]UOM:5="LF")
				$qty:=[Job_Forms_Materials:55]Planned_Qty:6
				
			: ([Job_Forms_Materials:55]UOM:5="SHT")
				$qty:=[Job_Forms_Materials:55]Planned_Qty:6*($length/12)
				$uom:="LF"
				
			Else 
				$qty:=[Job_Forms:42]EstGrossSheets:27*($length/12)
		End case 
		
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=[Job_Forms_Materials:55]JobForm:1; *)
		QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13="01@")
		If (Records in selection:C76([Raw_Materials_Allocations:58])=0)  // create
			// Modified by: Mel Bohince (9/11/15) 
			//look to see if there were any issues to this job
			READ ONLY:C145([Raw_Materials_Transactions:23])
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms_Materials:55]JobForm:1; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Commodity_Key:22=[Job_Forms_Materials:55]Commodity_Key:12)
			If (Records in selection:C76([Raw_Materials_Transactions:23])=0)
				
				CREATE RECORD:C68([Raw_Materials_Allocations:58])
				[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=[Job_Forms_Materials:55]Raw_Matl_Code:7
				[Raw_Materials_Allocations:58]commdityKey:13:=[Job_Forms_Materials:55]Commodity_Key:12
				RELATE ONE:C42([Job_Forms:42]JobNo:2)
				[Raw_Materials_Allocations:58]CustID:2:=[Jobs:15]CustID:2
				[Raw_Materials_Allocations:58]JobForm:3:=[Job_Forms_Materials:55]JobForm:1
				[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty
				[Raw_Materials_Allocations:58]Date_Allocated:5:=[Job_Forms:42]NeedDate:1
				[Raw_Materials_Allocations:58]ModDate:8:=$today
				[Raw_Materials_Allocations:58]ModWho:9:="xBA"
				[Raw_Materials_Allocations:58]zCount:10:=1
				[Raw_Materials_Allocations:58]UOM:11:=[Job_Forms_Materials:55]UOM:5
				SAVE RECORD:C53([Raw_Materials_Allocations:58])
				
			End if 
			
		Else   //see if adequite
			$safetyFactor:=1.2*$qty
			Case of 
				: ([Raw_Materials_Allocations:58]Qty_Allocated:4<$qty)
					[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty
					[Raw_Materials_Allocations:58]ModDate:8:=$today
					[Raw_Materials_Allocations:58]ModWho:9:="xB<"
					[Raw_Materials_Allocations:58]zCount:10:=1
					SAVE RECORD:C53([Raw_Materials_Allocations:58])
					
				: ([Raw_Materials_Allocations:58]Qty_Allocated:4>$safetyFactor)
					[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty
					[Raw_Materials_Allocations:58]ModDate:8:=$today
					[Raw_Materials_Allocations:58]ModWho:9:="xB>"
					[Raw_Materials_Allocations:58]zCount:10:=1
					SAVE RECORD:C53([Raw_Materials_Allocations:58])
			End case 
			
			If ([Raw_Materials_Allocations:58]Raw_Matl_Code:1#[Job_Forms_Materials:55]Raw_Matl_Code:7)
				[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=[Job_Forms_Materials:55]Raw_Matl_Code:7
				[Raw_Materials_Allocations:58]ModDate:8:=$today
				[Raw_Materials_Allocations:58]ModWho:9:=Substring:C12([Raw_Materials_Allocations:58]ModWho:9; 1; 3)+"+"
				SAVE RECORD:C53([Raw_Materials_Allocations:58])
			End if 
		End if 
		UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
	End if 
End for   //board

uThermoClose

//now do coldfoil and sensors
RM_Cold_Foil("init")  // Modified by: Mel Bohince (10/30/13) include coldfoils budgeted as commodity 05 as well as the correct 09
//QUERY([Job_Forms_Materials];[Job_Forms_Materials]Commodity_Key="12@";*)  //Sensors
//QUERY([Job_Forms_Materials]; | ;[Job_Forms_Materials]Commodity_Key="09@";*)  // Added by: Mark Zinke (9/26/13)  //Cold Foil
//QUERY([Job_Forms_Materials]; | ;[Job_Forms_Materials]Commodity_Key="05@";*)  // Modified by: Mel Bohince (10/25/13) consider spl leaf also
//QUERY([Job_Forms_Materials]; & ;[Job_Forms_Materials]Actual_Qty=0;*)
//QUERY([Job_Forms_Materials]; & ;[Job_Forms_Materials]Raw_Matl_Code#"")
//$numMJ:=Records in selection([Job_Forms_Materials])

ARRAY TEXT:C222($jfm_form; 0)
ARRAY TEXT:C222($jfm_commodity; 0)
ARRAY TEXT:C222($jfm_rm; 0)
ARRAY REAL:C219($jfm_qty; 0)
ARRAY TEXT:C222($jfm_uom; 0)
Begin SQL
	select JobForm, Commodity_Key, Raw_Matl_Code, Planned_Qty, UOM 
	from Job_Forms_Materials
	where (Commodity_Key like '05-SP%' or Commodity_Key like '09%' or Commodity_Key like '12%') and Actual_Qty = 0 and Raw_Matl_Code <>'' 
	and JobForm in 
	(select JobFormID from Job_Forms where Status not like  'C%' and Completed < '01/01/01' and Completed < '01/01/01' )
	into :$jfm_form, :$jfm_commodity, :$jfm_rm, :$jfm_qty, :$jfm_uom
End SQL
$numMJ:=Size of array:C274($jfm_form)

uThermoInit($numMJ; "Creating SensorLabel & ColdFoil Allocations")

For ($i; 1; $numMJ)
	uThermoUpdate($i)
	//GOTO SELECTED RECORD([Job_Forms_Materials];$i)
	$continue:=True:C214
	If ($jfm_commodity{$i}="05@")  //9 is a sure thing, 5 is a maybe
		If (RM_Cold_Foil("find"; $jfm_rm{$i})=-1)  //test if was in better query
			$continue:=False:C215
		End if 
	End if 
	
	If ($continue)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jfm_form{$i})  //check status of form
		If (Records in selection:C76([Job_Forms:42])>0)
			
			If ([Job_Forms:42]Status:6#"C@")  //not closed or complete, this is redundant, but wtf, its cheap
				If ([Job_Forms:42]ClosedDate:11=!00-00-00!)  //no closed date (belt)
					If ([Job_Forms:42]Completed:18=!00-00-00!)  // no complete date (suspenders)
						QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jfm_form{$i})  //get ndate needed
						If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
							If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
								$dateNeeded:=[Job_Forms_Master_Schedule:67]PressDate:25
							Else 
								$dateNeeded:=<>MAGIC_DATE
							End if 
						End if 
						
						RELATE ONE:C42([Job_Forms:42]JobNo:2)
						RM_AllocateRM($jfm_form{$i}; $dateNeeded; [Jobs:15]CustID:2; $jfm_rm{$i}; $jfm_commodity{$i}; $jfm_qty{$i}; $jfm_uom{$i})
						
					End if 
				End if 
			End if 
		End if 
	End if 
End for 

uThermoClose

