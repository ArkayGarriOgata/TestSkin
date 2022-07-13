//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/16/11, 10:49:46
// ----------------------------------------------------
// Method: Rama_PS_Gluers
// Description
// like PS_Gluers but limited to rama cpns
// ----------------------------------------------------
//#################
//#################
//#################button disabled, this code hasn't be retrofitted to newer glue schd
//#################
//#################

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaGS; $winRef)

If (Count parameters:C259=0)
	If (<>pid_RamaGS=0)
		app_Log_Usage("log"; "RAMA"; "Rama_PS_Gluers")
		<>pid_RamaGS:=New process:C317("Rama_PS_Gluers"; <>lMinMemPart; "Rama Glue Schedule"; "init")
		If (False:C215)
			Rama_PS_Gluers
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaGS)
		BRING TO FRONT:C326(<>pid_RamaGS)
	End if 
	
Else 
	//SET MENU BAR("Scheduling_full")
	$winRef:=Open form window:C675([ProductionSchedules:110]; "GlueSchedule"; Plain form window:K39:10)
	SET WINDOW TITLE:C213("Rama/Cayey Gluing Schedule"; $winRef)
	MESSAGE:C88("Please Wait, loading glue schedule...")
	
	//Rama_Find_CPNs ("query";->[Job_Forms_Items]ProductCode)
	//
	//QUERY SELECTION([Job_Forms_Items];[Job_Forms_Items]Qty_Actual=0;*)
	//QUERY SELECTION([Job_Forms_Items]; | ;[Job_Forms_Items]Priority<0;*)
	//QUERY SELECTION([Job_Forms_Items]; & ;[Job_Forms_Items]Glued=!00/00/00!;*)
	//QUERY SELECTION([Job_Forms_Items]; & ;[Job_Forms_Items]Completed=!00/00/00!;*)
	//QUERY SELECTION([Job_Forms_Items]; & ;[Job_Forms_Items]OrderItem#"Killed";*)
	//QUERY SELECTION([Job_Forms_Items]; & ;[Job_Forms_Items]FormClosed=False)
	//CREATE SET([Job_Forms_Items];"<>All_Glue_Items")
	
	//Rama_Find_CPNs ("inventory")
	
	If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=("@RAMA@"); *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43="000@")  //only interested in the gaylords
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aFLAT_PAQ)  //find the jobits of the flat packed
		
		QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $aFLAT_PAQ)
		
	Else 
		
		QUERY:C277([Job_Forms_Items:44]; [Finished_Goods_Locations:35]Location:2=("@RAMA@"); *)
		QUERY:C277([Job_Forms_Items:44]; [Finished_Goods_Locations:35]skid_number:43="000@")  //only interested in the gaylords
		
	End if   // END 4D Professional Services : January 2019 
	
	//CREATE SET([Job_Forms_Items];"Flat_Items")
	CREATE SET:C116([Job_Forms_Items:44]; "<>All_Glue_Items")
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Gluer:47="")
	
	ARRAY TEXT:C222($aGluerName; Records in selection:C76([Job_Forms_Items:44]))
	For ($i; 1; Size of array:C274($aGluerName))
		$aGluerName{$i}:="9PR"
	End for 
	
	ARRAY TO SELECTION:C261($aGluerName; [Job_Forms_Items:44]Gluer:47)
	USE SET:C118("<>All_Glue_Items")
	
	
	
	//("All_Glue_Items";"Flat_Items";"All_Glue_Items")
	//USE SET("All_Glue_Items")
	//CLEAR SET("Flat_Items")
	
	//CREATE EMPTY SET([Job_Forms_Items];"Current_Glue_Items")
	//arrays used for caching
	C_BOOLEAN:C305(<>gluer_cache_empty)  // just load it once
	<>gluer_cache_empty:=True:C214
	//cached arrays for related tables
	//job master log
	ARRAY TEXT:C222(aJML_jobform; 0)
	ARRAY DATE:C224(aJML_glue_ready; 0)
	ARRAY DATE:C224(aJML_printed; 0)
	ARRAY TEXT:C222(aJML_glue_readyYN; 0)
	ARRAY TEXT:C222(aJML_printedYN; 0)
	//customer name
	ARRAY TEXT:C222(aCustomer; 0)
	ARRAY TEXT:C222(aCustomerName; 0)
	//finished goods
	ARRAY TEXT:C222(aFinishedGoodKey; 0)
	ARRAY TEXT:C222(aFinishedGoodGlueType; 0)
	ARRAY TEXT:C222(aFinishedGoodLine; 0)
	ARRAY TEXT:C222(aFinishedGoodOR; 0)
	//via release table to fg during nitely batch
	ARRAY DATE:C224(aFinishedGoodNextRel; 0)
	ARRAY LONGINT:C221(aFinishedGoodNextQty; 0)
	
	rb1:=1
	rb2:=0
	rb3:=0
	PSG_UI_SetRowStyles
	
	FORM SET INPUT:C55([ProductionSchedules:110]; "GlueSchedule")
	ADD RECORD:C56([ProductionSchedules:110]; *)
	CLOSE WINDOW:C154($winRef)
	FORM SET INPUT:C55([ProductionSchedules:110]; "Input")
	
	CLEAR SET:C117("<>All_Glue_Items")
	//CLEAR SET("Current_Glue_Items")
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	PSG_UI_SetRowStyles
	<>pid_RamaGS:=0
End if 