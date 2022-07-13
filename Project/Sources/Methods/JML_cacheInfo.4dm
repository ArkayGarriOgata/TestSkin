//%attributes = {"publishedWeb":true}
//PM: JML_cacheInfo() -> 
//@author mlb - 3/22/02  13:30
// Modified by: Mel Bohince (10/31/17) add D/C (ready to glue)
// Modified by: MelvinBohince (1/20/22) direct JML field access instead of cache
// Modified by: MelvinBohince (1/27/22) return this as a menu item in Press menu

C_TEXT:C284($1; $2)
C_TEXT:C284($0; tText)
C_LONGINT:C283($i; $numJML; $3)

Case of 
	: ($1="jobRef")
		$i:=Find in array:C230(<>aJML; $2)
		$0:=String:C10($i)
		
	: ($1="init")  //OBSOLETE// Modified by: MelvinBohince (1/20/22) direct JML field access instead of cache
		If (True:C214)
			//cache was disables (1/20/22), menu was put back
		Else 
			While (Semaphore:C143("$JMLcacheInit"))
				DELAY PROCESS:C323(Current process:C322; 10)
			End while 
			NewWindow(350; 75; 6; -724; "Please Wait")
			MESSAGE:C88(Char:C90(13)+"   Updating information found"+Char:C90(13)+"      on the Job Master Log.")
			zwStatusMsg("Please Wait..."; "Caching Job Master Log info. Looking for Launch Jobs")
			$boolean:=FG_LaunchItem("init")
			READ ONLY:C145([Job_Forms:42])
			READ ONLY:C145([Job_Forms_Master_Schedule:67])
			If (<>cacheJMLts=0)
				zwStatusMsg("Please Wait..."; "Caching Job Master Log info. Initiating")
				JML_cacheInit
				
			Else   //prior cache
				zwStatusMsg("Please Wait..."; "Caching Job Master Log info. Looking for changes")
				JML_cacheUpdate
				zwStatusMsg("JML Cache"; "Updated")
			End if 
			<>cacheJMLts:=TSTimeStamp
			zwStatusMsg("Finished"; "Caching Job Master Log info.")
			CLOSE WINDOW:C154
			CLEAR SEMAPHORE:C144("$JMLcacheInit")
		End if 
		
		PS_CallProcesses
		
	: ($1="REV")  // Modified by: MelvinBohince (1/20/22) 
		$0:=String:C10([Job_Forms_Master_Schedule:67]OrigRevDate:20; System date short:K1:1)
		
	: ($1="D/C")  // Modified by: MelvinBohince (1/20/22)   
		$0:=String:C10([Job_Forms_Master_Schedule:67]GlueReady:28; System date short:K1:1)
		
	: ($1="BAGGOT")  // Modified by: MelvinBohince (1/20/22) 
		$0:=String:C10([Job_Forms_Master_Schedule:67]DateBagReceived:48; System date short:K1:1)
		
	: ($1="BAGOK")  // Modified by: MelvinBohince (1/20/22) 
		$0:=String:C10([Job_Forms_Master_Schedule:67]DateBagApproved:49; System date short:K1:1)
		
	: ($1="STKGOT")
		$0:=String:C10([Job_Forms_Master_Schedule:67]DateStockRecd:17; System date short:K1:1)
		
	: ($1="STKSHT")
		$0:=String:C10([Job_Forms_Master_Schedule:67]DateStockSheeted:47; System date short:K1:1)
		
	: ($1="PRINTED")  // Modified by: MelvinBohince (1/20/22) 
		$0:=String:C10([Job_Forms_Master_Schedule:67]Printed:32; System date short:K1:1)
		
		
	: ($1="BAGRTN")  // Modified by: MelvinBohince (1/20/22) 
		$0:=String:C10([Job_Forms_Master_Schedule:67]DateBagReturned:52; System date short:K1:1)
		
	: ($1="WIP")  // Modified by: MelvinBohince (1/20/22) 
		$0:=String:C10([Job_Forms_Master_Schedule:67]DateWIPreceived:53; System date short:K1:1)
		
		
		///production schedule fields
	: ($1="PRESHEETED")
		$0:=String:C10([ProductionSchedules:110]PreSheetedStock:81; System date short:K1:1)  //◊aPlatesDone{$i} 
		
	: ($1="PLATES")
		$0:=String:C10([ProductionSchedules:110]PlatesReady:18; System date short:K1:1)  //◊aPlatesDone{$i}    
		
	: ($1="CYREL")
		$0:=String:C10([ProductionSchedules:110]CyrelsReady:19; System date short:K1:1)  //◊aCyrelDone{$i}
		
	: ($1="INK")
		$0:=String:C10([ProductionSchedules:110]InkReady:20; System date short:K1:1)  //$0:=String(◊aInkDone{$i};Short )    
		
	: ($1="PDF")
		$0:=String:C10([ProductionSchedules:110]NormalizedPDF:82; System date short:K1:1)
		
	: ($1="DIE_STAMP")
		$0:=String:C10([ProductionSchedules:110]StampingDies:28; System date short:K1:1)
		
	: ($1="DIE_EMBOSS")
		$0:=String:C10([ProductionSchedules:110]EmbossingDies:29; System date short:K1:1)
		
	: ($1="LEAF")
		$0:=String:C10([ProductionSchedules:110]Leaf:30; System date short:K1:1)
		
	: ($1="DIE_FILE")
		$0:=String:C10([ProductionSchedules:110]DateDieFilesReady:46; System date short:K1:1)
		
	: ($1="LOCKED")
		$0:=String:C10([ProductionSchedules:110]JobLockedUp:27; System date short:K1:1)
		
	: ($1="STRIPPER")
		$0:=String:C10([ProductionSchedules:110]FemaleStripperBoard:26; System date short:K1:1)
		
	: ($1="INHOUSE")
		$0:=String:C10([ProductionSchedules:110]InHouse:32; System date short:K1:1)
		
	: ($1="TOOLING")
		$0:=String:C10([ProductionSchedules:110]ToolingSent:39; System date short:K1:1)
		
	: ($1="STD")
		$0:=String:C10([ProductionSchedules:110]StandardsSent:40; System date short:K1:1)
		
	: ($1="REQ")
		$0:=[ProductionSchedules:110]RequisitionNum:33
		
	: ($1="PO")
		$0:=[ProductionSchedules:110]PurchaseOrder:34
		
	: ($1="WIPOUT")
		$0:=String:C10([ProductionSchedules:110]WIPsentSheets:35)
		
	: ($1="WIPBACK")
		$0:=String:C10([ProductionSchedules:110]WIPreturnedSheets:37)
		
	: ($1="COUNTERS")
		$0:=String:C10([ProductionSchedules:110]DateCountersRecd:41; System date short:K1:1)
		
	: ($1="BLANKER")
		$0:=String:C10([ProductionSchedules:110]DateBlankerRecd:42; System date short:K1:1)
		
	: ($1="FILM_STAMP")
		$0:=String:C10([ProductionSchedules:110]DateFilmStampingRcd:43; System date short:K1:1)
		
	: ($1="FILM_EMB")
		$0:=String:C10([ProductionSchedules:110]DateFilmEmbossRcd:44; System date short:K1:1)
		
	: ($1="DIE_BOARD")
		$0:=String:C10([ProductionSchedules:110]DateDieBoardRecd:45; System date short:K1:1)
		
	: ($1="LATISEALED")
		$0:=String:C10([ProductionSchedules:110]DateLatisealed:47; System date short:K1:1)
		
	: ($1="WINDOWS")
		$0:=String:C10([ProductionSchedules:110]DateWindowsCut:48; System date short:K1:1)
		
	: ($1="ADHESIVE")
		$0:=String:C10([ProductionSchedules:110]DateAdhesiveOK:49; System date short:K1:1)
		
	: ($1="LAMINATE")
		$0:=String:C10([ProductionSchedules:110]DateLaminateOK:50; System date short:K1:1)
		
	: ($1="DYLUX")
		$0:=String:C10([ProductionSchedules:110]DateDyluxChecked:75; System date short:K1:1)
		
	: ($1="eBAG")
		If (Count parameters:C259=3)
			$i:=$3
		Else 
			$i:=Find in array:C230(<>aJML; $2)
		End if 
		If ($i>-1)
			$0:="1"  //String(Num(◊aeBag{$i}))
		Else 
			$0:=""
		End if 
		
End case 