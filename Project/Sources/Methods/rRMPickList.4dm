//%attributes = {"publishedWeb":true}
//(p) rRmPickList
//$1 - (optional) string Jobform ID to print
//$2 (optional) Record Number
//Prints a listing of all scheduled RMs for a specified job form
//may also print the scheduled RMs for any batch inks included as part
//of the specified Job form
//differnet from old Piclklist in  2 ways, 1- batch inks, 2 - printlayout
//see also rRmPickLstBatch
//• 5/6/97 cs  created
//Note: sState is a reused var - char2 - used for bullet on report
//   sHead1 is a reused var - char15 - used for Barcode PO Number
//  sQtyTitle(1&2) are reused vars - char20 -used for displaying quantities.

C_BOOLEAN:C305($OK; $HasBatch)
C_TEXT:C284($1; $JobForm; sRmCode; sQtyTItle1; sQytTitle2; SJFNUMBER)
C_TIME:C306(tTime)  //time printed on report
C_DATE:C307(dAsOf)  //date printed on report
C_TEXT:C284(t3; xText; sCommKey)  //title of report
C_LONGINT:C283($i; $MaxLines; $Lines; $BinIndex; iPage)
C_TEXT:C284(sSeqNumber)
C_TEXT:C284(sUOM)
C_TEXT:C284(sState)
C_TEXT:C284(sPoNum)

MESSAGES OFF:C175

xText:=""  //tiny note on components when batch ink printed
dAsof:=4D_Current_date
tTime:=4d_Current_time
$HasBatch:=False:C215
$MaxLines:=Int:C8((550-(80+20))/20)  //(550 max pixels - (header+footer))/detail size = Max lines
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CREATE SET:C116([Job_Forms_Materials:55]; "Starting")
	
Else 
	
	ARRAY LONGINT:C221($_Starting; 0)
	LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Materials:55]; $_Starting)
	
	
End if   // END 4D Professional Services : January 2019 query selection

If (Count parameters:C259=1)  //called from jobbag printing
	fBatch:=False:C215
	$JobForm:=$1
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$JobForm)
	If (Records in selection:C76([Job_Forms_Materials:55])>0)
		$OK:=True:C214
		uMsgWindow("Printing Raw Material Pick List...")
		DELAY PROCESS:C323(Current process:C322; 3*60)
		CLOSE WINDOW:C154
		util_PAGE_SETUP(->[Job_Forms_Materials:55]; "RmPickList.h")  //setup page print properties
	Else 
		$OK:=False:C215
	End if 
Else   //called with No parameters - from 'Pick' button on RM pallete
	ON EVENT CALL:C190("eCancelPrint")
	util_PAGE_SETUP(->[Job_Forms_Materials:55]; "RmPickList.h")  //setup page print properties
	PRINT SETTINGS:C106  //let user cancel    
	fBatch:=False:C215
	$OK:=True:C214 & (OK=1)
End if 

If ($OK)  //if there were records located
	t3:="Raw Material Pick List"
	ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1; >; [Job_Forms_Materials:55]Sequence:3; >)
	$i:=Records in selection:C76([Job_Forms_Materials:55])
	ARRAY INTEGER:C220($aSeq; $i)  //set up arrays for data to process
	ARRAY REAL:C219($aPlannedQty; $i)
	ARRAY TEXT:C222($aUOM; $i)
	ARRAY TEXT:C222($aJobForm; $i)
	ARRAY TEXT:C222($aRmCode; $i)
	ARRAY LONGINT:C221($aRecNum; $i)
	//copy data from selection into arrays
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]; $aRecNum; [Job_Forms_Materials:55]JobForm:1; $aJobForm; [Job_Forms_Materials:55]Sequence:3; $aSeq; [Job_Forms_Materials:55]Raw_Matl_Code:7; $aRmCode; [Job_Forms_Materials:55]Planned_Qty:6; $aPlannedQty; [Job_Forms_Materials:55]UOM:5; $aUOM)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Job_Forms_Materials:55]Raw_Matl_Code:7; 0)  //locate raw materials for the planned items
		CREATE SET:C116([Raw_Materials:21]; "Raw")
		QUERY SELECTION:C341([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="02@"; *)  //locate any raw materials which are inks
		RM_ColdFoilQuery("Selection")  // Added by: Mark Zinke (1/23/14) Replaced line below.
		//QUERY SELECTION([Raw_Materials]; | ;[Raw_Materials]Commodity_Key="09@")
		uRelateSelect(->[Raw_Materials_Components:60]Parent_Raw_Matl:1; ->[Raw_Materials:21]Raw_Matl_Code:1; 0)  //look for components - determines that these are batch ink(s)
		
	Else 
		
		RELATE ONE SELECTION:C349([Job_Forms_Materials:55]; [Raw_Materials:21])
		CREATE SET:C116([Raw_Materials:21]; "Raw")
		QUERY SELECTION:C341([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2="02@"; *)
		QUERY SELECTION:C341([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="09@"; *)
		QUERY SELECTION:C341([Raw_Materials:21];  | ; [Raw_Materials:21]Description:4="@cold foil@")
		ARRAY TEXT:C222($_Raw_Matl_Code; 0)
		DISTINCT VALUES:C339([Raw_Materials:21]Raw_Matl_Code:1; $_Raw_Matl_Code)
		QUERY WITH ARRAY:C644([Raw_Materials_Components:60]Parent_Raw_Matl:1; $_Raw_Matl_Code)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Records in selection:C76([Raw_Materials_Components:60])>0)  //there is one or more batch ink
		ARRAY TEXT:C222($aComponent; Records in selection:C76([Raw_Materials_Components:60]))  //place the components into an array for later processing
		SELECTION TO ARRAY:C260([Raw_Materials_Components:60]Parent_Raw_Matl:1; $aComponent)
		$HasBatch:=True:C214
	Else 
		ARRAY TEXT:C222($aComponent; 0)  //create array for later use (cause 'for' loop to skip)
		$HasBatch:=False:C215
	End if 
	uClearSelection(->[Raw_Materials_Components:60])
	
	USE SET:C118("Raw")
	$i:=Records in selection:C76([Raw_Materials:21])
	ARRAY TEXT:C222($aCommKey; $i)  //get the Raw Material's Commodity key
	ARRAY TEXT:C222($aRawRmCode; $i)
	SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $aRawRmCode; [Raw_Materials:21]Commodity_Key:2; $aCommKey)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		
		USE SET:C118("Raw")
		CLEAR SET:C117("Raw")
		
	Else 
		
		CLEAR SET:C117("Raw")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials:21]Raw_Matl_Code:1; 0)  //locate bin records
		
		
	Else 
		RELATE MANY SELECTION:C340([Raw_Materials_Locations:25]Raw_Matl_Code:1)
		
	End if   // END 4D Professional Services : January 2019 query selection
	$i:=Records in selection:C76([Raw_Materials_Locations:25])
	ARRAY TEXT:C222($aBinRmCode; $i)
	ARRAY TEXT:C222($aLocation; $i)
	ARRAY REAL:C219($aQtyOh; $i)
	ARRAY TEXT:C222($aPoNum; $i)
	SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Raw_Matl_Code:1; $aBinRmCode; [Raw_Materials_Locations:25]Location:2; $aLocation; [Raw_Materials_Locations:25]QtyOH:9; $aQtyOh; [Raw_Materials_Locations:25]POItemKey:19; $aPoNum)
	uClearSelection(->[Raw_Materials:21])
	uClearSelection(->[Job_Forms_Materials:55])  //clear selections
	uClearSelection(->[Raw_Materials_Components:60])
	uClearSelection(->[Raw_Materials_Locations:25])
	iPage:=1
	
	For ($i; 1; Size of array:C274($aJobForm))  //print in loop
		Case of 
			: ($i=1)  //print initial header      
				$CurrentJob:=$aJobForm{$i}
				sJobForm:=$CurrentJob
				sJFNumber:=sJobForm
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.h")
				
			: ($CurrentJob#$aJobForm{$i})  //this is a new jobform
				For ($j; 1; ($MaxLines-$Lines))  //print spaces to get footer in correct location
					Print form:C5([Job_Forms_Materials:55]; "RmPickList.s")
				End for 
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")  //print footer for page
				PAGE BREAK:C6(>)  //start new page
				iPage:=iPage+1
				$Lines:=0  //reset lines printed
				$CurrentJob:=$aJobForm{$i}  //reset current jobform ID
				sJobForm:=$CurrentJob
				sJFNumber:=sJobForm
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.h")  //print new header    
			Else   //just printing details, do nothing here
		End case 
		sRmCode:=$aRmCode{$i}
		
		$RawIndex:=Find in array:C230($aRawRmcode; sRmCode)
		If ($RawIndex>0)  //this should always be true
			sCommKey:=$aCommKey{$Rawindex}
		Else 
			sCommKey:=""
		End if 
		sQtyTitle1:=String:C10($aPlannedQty{$i}; "##,###,##0.00")
		sUOM:=$aUOM{$i}
		sSeqNumber:=String:C10($aSeq{$i})
		
		If (Find in array:C230($aComponent; sRmCode)>0)  //if this is a batch ink flag it
			sState:="•"  //reused existing 2 character var
		Else 
			sState:=""
		End if 
		$BinIndex:=Find in array:C230($aBinRmCode; sRmCode)
		$LongDetail:=True:C214
		Repeat 
			If ($BinIndex>0)
				sLocation:=$aLocation{$BinIndex}
				sPoNum:=$aPoNum{$BinIndex}
				sJFNumber:=sPoNum
				sQtyTitle2:=String:C10($aQtyOh{$BinIndex}; "##,###,##0.00")
				$BinIndex:=Find in array:C230($aBinRmCode; sRmCode; $BinIndex+1)
			Else   //print long detail if there are NO locations (space for hand writing info)
				sLocation:="No Inventory"
				sPoNum:=""
				sJFNumber:=sPoNum
				sQtyTitle2:=""
			End if 
			
			If ($Lines+1>$MaxLines)  //if this line would be too much for page
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")  //print footer
				PAGE BREAK:C6(>)  //start new page
				iPage:=iPage+1
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.h")  //print header
				$Lines:=0  //reset line counter
			Else 
				
				If ($LongDetail)  //if this is the first time this Rm is being printed, print details of RM
					Print form:C5([Job_Forms_Materials:55]; "RmPickList.d")
					$LongDetail:=False:C215
				Else   //esle just print location info
					Print form:C5([Job_Forms_Materials:55]; "RmPickList.d2")
				End if 
				$Lines:=$Lines+1  //add to lines printed
			End if 
		Until ($BinIndex<0)  //print location info until no more locations found
		
		If (Not:C34(<>fContinue))
			$i:=Size of array:C274($aJobForm)+1
		End if 
	End for 
	
	If ($Lines<$MaxLines)  //finish last page
		For ($i; 1; ($MaxLines-$Lines))
			Print form:C5([Job_Forms_Materials:55]; "RmPickList.s")
		End for 
	End if 
	Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")
	
	If ($HasBatch) & (<>fContinue)
		PAGE BREAK:C6(>)  //keep report as one document
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE EMPTY SET:C140([Job_Forms_Materials:55]; "BatchInk")
			$BatchIndex:=0
			For ($i; 1; Size of array:C274($aComponent))  //for each component determine if there is a Material Job record for it
				$BatchIndex:=Find in array:C230($aRmCode; $aComponent{$i}; $BatchIndex+1)
				
				If ($BatchIndex>0)  //there is a material job record
					GOTO RECORD:C242([Job_Forms_Materials:55]; $aRecNum{$BatchIndex})  //get it
					ADD TO SET:C119([Job_Forms_Materials:55]; "BatchInk")  //add to set to print for batch inks
				End if 
			End for 
			USE SET:C118("BatchInk")
			CLEAR SET:C117("BatchInk")
			
		Else 
			
			ARRAY LONGINT:C221($_BatchInk; 0)
			
			$BatchIndex:=0
			For ($i; 1; Size of array:C274($aComponent))  //for each component determine if there is a Material Job record for it
				
				$BatchIndex:=Find in array:C230($aRmCode; $aComponent{$i}; $BatchIndex+1)
				
				If ($BatchIndex>0)  //there is a material job record
					
					APPEND TO ARRAY:C911($_BatchInk; $aRecNum{$BatchIndex})
					
				End if 
			End for 
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Materials:55]; $_BatchInk)
			
			
		End if   // END 4D Professional Services : January 2019 
		
		rRmPickLstBatch  //print batch inks pick list
	Else 
		PAGE BREAK:C6  //send entire document to printer  
	End if   //has batch
End if   //$OK

If (Count parameters:C259=0)  //this was called from Pick button, if called from JobBag, on event already on
	If (Not:C34(<>fContinue))  //reset ◊fContinue
		<>fContinue:=True:C214
	End if 
	ON EVENT CALL:C190("")  //reset on event call
End if 
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	USE SET:C118("Starting")  //return original seletin of Material Job
	CLEAR SET:C117("Starting")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Job_Forms_Materials:55]; $_Starting)
	
End if   // END 4D Professional Services : January 2019 query selection

MESSAGES ON:C181