//%attributes = {"publishedWeb":true}
//(p) rRmPickLstBatch
//Prints a listing of all the scheduled RMs for any batch inks included as part
//of the specified Job form
//• 5/6/97 cs  created
//see also rRmPickList
//assumes Batch Inks [material job]records are in memory
//Note: sState is a reused var - char2 - used for bullet on report
//   sHead1 is a reused var - char15 - used for Barcode PO Number
//  sQtyTitle(1&2) are reused vars - char20 -used for displaying quantities.

C_LONGINT:C283($i; $MaxLines; $Lines; $BinIndex)

xText:=""  //tiny note on components when batch ink printed
$MaxLines:=Int:C8((550-(80+20))/20)  //(550 max pixels - (header+footer))/detail size = Max lines
t3:="Raw Material Pick List for Batch Inks"
iPage:=1

ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1; >; [Job_Forms_Materials:55]Sequence:3; >)
$i:=Records in selection:C76([Job_Forms_Materials:55])
ARRAY INTEGER:C220($aSeq; $i)  //set up arrays for data to process
ARRAY REAL:C219($aPlannedQty; $i)
ARRAY TEXT:C222($aUOM; $i)
ARRAY TEXT:C222($aJobForm; $i)
ARRAY TEXT:C222($aRmCode; $i)
ARRAY TEXT:C222($aCommKey; $i)
SELECTION TO ARRAY:C260([Job_Forms_Materials:55]JobForm:1; $aJobForm; [Job_Forms_Materials:55]Sequence:3; $aSeq; [Job_Forms_Materials:55]Raw_Matl_Code:7; $aRmCode; [Job_Forms_Materials:55]Planned_Qty:6; $aPlannedQty; [Job_Forms_Materials:55]UOM:5; $aUOM; [Job_Forms_Materials:55]Commodity_Key:12; $aCommKey)

//locate componets for RMs in Job
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials_Components:60]Parent_Raw_Matl:1; ->[Job_Forms_Materials:55]Raw_Matl_Code:7; 0)  //get components  
	
Else 
	
	ARRAY TEXT:C222($_Raw_Matl_Code; 0)
	DISTINCT VALUES:C339([Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code)
	QUERY WITH ARRAY:C644([Raw_Materials_Components:60]Parent_Raw_Matl:1; $_Raw_Matl_Code)
	
End if   // END 4D Professional Services : January 2019 query selection

$i:=Records in selection:C76([Raw_Materials_Components:60])
ARRAY TEXT:C222($aCompRmCode; $i)
ARRAY TEXT:C222($aParentRm; $i)
ARRAY TEXT:C222($aCompUom; $i)
ARRAY REAL:C219($aCompQty; $i)
SELECTION TO ARRAY:C260([Raw_Materials_Components:60]Parent_Raw_Matl:1; $aParentRm; [Raw_Materials_Components:60]Compnt_Raw_Matl:2; $aCompRmCode; [Raw_Materials_Components:60]QtyIssued:3; $aCompQty; [Raw_Materials_Components:60]UM:4; $aCompUom)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CREATE SET:C116([Raw_Materials_Components:60]; "Components")
	
	
Else 
	
	//we don't change it
	
End if   // END 4D Professional Services : January 2019 query selection
//get Commodity key for each parent Rm
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials_Components:60]Parent_Raw_Matl:1; 0)
	
Else 
	ARRAY TEXT:C222($_Parent_Raw_Matl; 0)
	DISTINCT VALUES:C339([Raw_Materials_Components:60]Parent_Raw_Matl:1; $_Parent_Raw_Matl)
	QUERY WITH ARRAY:C644([Raw_Materials:21]Raw_Matl_Code:1; $_Parent_Raw_Matl)
	
End if   // END 4D Professional Services : January 2019 query selection
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CREATE SET:C116([Raw_Materials:21]; "Parent")
	USE SET:C118("Components")  //return component list - may get lost through auto rel to Raw Material
	
Else 
	//i don' use it
	
End if   // END 4D Professional Services : January 2019 query selection

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials_Components:60]Compnt_Raw_Matl:2; 0)
	
	
Else 
	
	ARRAY TEXT:C222($_Compnt_Raw_Matl; 0)
	DISTINCT VALUES:C339([Raw_Materials_Components:60]Compnt_Raw_Matl:2; $_Compnt_Raw_Matl)
	QUERY WITH ARRAY:C644([Raw_Materials:21]Raw_Matl_Code:1; $_Compnt_Raw_Matl)
	
	
End if   // END 4D Professional Services : January 2019 query selection
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	CREATE SET:C116([Raw_Materials:21]; "Comps")
	UNION:C120("Comps"; "Parent"; "Comps")  //union to get list of all raw materials to be printed
	USE SET:C118("Comps")
	CLEAR SET:C117("Comps")
	CLEAR SET:C117("Parent")
	
Else 
	
	For ($Iter; 1; Size of array:C274($_Parent_Raw_Matl); 1)
		If (Find in array:C230($_Compnt_Raw_Matl; $_Parent_Raw_Matl{$Iter})<0)
			APPEND TO ARRAY:C911($_Compnt_Raw_Matl; $_Parent_Raw_Matl{$Iter})
		End if 
	End for 
	QUERY WITH ARRAY:C644([Raw_Materials:21]Raw_Matl_Code:1; $_Compnt_Raw_Matl)
	
	
End if   // END 4D Professional Services : January 2019 query selection

ARRAY TEXT:C222($aCommKey; Records in selection:C76([Raw_Materials:21]))
ARRAY TEXT:C222($aRawRmCode; Records in selection:C76([Raw_Materials:21]))
SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $aRawRmCode; [Raw_Materials:21]Commodity_Key:2; $aCommKey)
//locate Bins for components
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	USE SET:C118("Components")
	CLEAR SET:C117("Components")
	
Else 
	
	//we don't change it
	
End if   // END 4D Professional Services : January 2019

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	uRelateSelect(->[Raw_Materials_Locations:25]Raw_Matl_Code:1; ->[Raw_Materials_Components:60]Compnt_Raw_Matl:2; 0)
	
	
Else 
	
	ARRAY TEXT:C222($_Compnt_Raw_Matl; 0)
	DISTINCT VALUES:C339([Raw_Materials_Components:60]Compnt_Raw_Matl:2; $_Compnt_Raw_Matl)
	QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]Raw_Matl_Code:1; $_Compnt_Raw_Matl)
	
End if   // END 4D Professional Services : January 2019 query selection
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)
$i:=Records in selection:C76([Raw_Materials_Locations:25])
ARRAY TEXT:C222($aBinRmCode; $i)
ARRAY TEXT:C222($aLocation; $i)
ARRAY REAL:C219($aQtyOh; $i)
ARRAY TEXT:C222($aPoNum; $i)
SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Raw_Matl_Code:1; $aBinRmCode; [Raw_Materials_Locations:25]Location:2; $aLocation; [Raw_Materials_Locations:25]QtyOH:9; $aQtyOh; [Raw_Materials_Locations:25]POItemKey:19; $aPoNum)
uClearSelection(->[Raw_Materials:21])
uClearSelection(->[Raw_Materials_Components:60])
uClearSelection(->[Raw_Materials_Locations:25])
uClearSelection(->[Job_Forms_Materials:55])

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
	sRmCode:=$aRmCode{$i}  //Batch ink RM code
	
	$RmIndex:=Find in array:C230($aRawRmCode; sRmCode)
	If ($RmIndex>0)  //should alway be    
		sCommKey:=$aCommKey{$RmIndex}
	Else 
		sCommKey:=""
	End if 
	$CurrentRm:=sRmCode  //save currently printing [material job]RMcode
	sQtyTitle1:=String:C10($aPlannedQty{$i}; "##,###,##0.00")
	sUOM:=$aUOM{$i}
	sSeqNumber:=String:C10($aSeq{$i})
	sState:="•"  //reused existing 2 character var,  all are batch inks
	xText:="Batch Ink"
	sLocation:=""  //clear these since we are not reprinting
	sPoNum:=""
	sQtyTitle2:=""
	
	If ($Lines+2>$MaxLines)  //if this line + first component would be too much for page
		If ($Lines+1<=$MaxLines)  //space for footer placement, if needed
			Print form:C5([Job_Forms_Materials:55]; "RmPickList.s")  //print a space      
		End if 
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")  //print footer
		PAGE BREAK:C6(>)  //start new page
		iPage:=iPage+1
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.h")  //print header
		$Lines:=0  //reset line counter
	End if 
	Print form:C5([Job_Forms_Materials:55]; "RmPickList.d")  //this is the Ink Being printed
	$Lines:=$Lines+1  //add to lines printed
	
	//start printing components    
	$ParIndex:=Find in array:C230($aParentRm; $CurrentRm)  //locate Printing Ink in Parent Rm Array, this is index into Components
	Repeat   //Repeat until all parent Rms for this ink have been printed
		If ($ParIndex>0)  //there is a Parent RMcode
			sRmCode:=$aCompRmCode{$ParIndex}
			sQtyTitle1:=String:C10($aCompQty{$ParIndex}; "##,###,##0.00")
			sUOM:=$aCompUOM{$ParIndex}
			sSeqNumber:=""
			sState:=""  //reused existing 2 character var,  components not batch inks
			xText:="Batch Ink "+$CurrentRm+" Component"
			
			$RmIndex:=Find in array:C230($aRawRmCode; sRmCode)  //locate rm in Rawmaterial rmcode array use to access comodity key
			If ($RmIndex>0)
				sCommKey:=$aCommKey{$RmIndex}
			Else 
				sCommkey:=""
			End if 
			$BinIndex:=Find in array:C230($aBinRmCode; sRmCode)  //locate the component in the Bins
		Else 
			$BinIndex:=-1  //force failure of next test
		End if 
		$LongDetail:=True:C214
		$ParIndex:=Find in array:C230($aParentRm; $CurrentRm; $ParIndex+1)  //locate next occurance of Parent RM 
		
		//start locating/printing Bins for each component
		Repeat 
			If ($BinIndex>0)  //there is one or more Bins for this component        
				sLocation:=$aLocation{$BinIndex}
				sPoNum:=$aPoNum{$BinIndex}
				sQtyTitle2:=String:C10($aQtyOh{$BinIndex}; "##,###,##0.00")
				$BinIndex:=Find in array:C230($aBinRmCode; sRmCode; $BinIndex+1)
			Else   //print long detail if there are NO locations (space for hand writing info)
				sLocation:="No Inventory"
				sPoNum:=""
				sQtyTitle2:=""
			End if 
			
			If ($Lines+1>$MaxLines)  //if this line would be too much for page
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")  //print footer
				PAGE BREAK:C6(>)  //start new page
				iPage:=iPage+1
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.h")  //print header
				$Lines:=0  //reset line counter
			End if 
			
			If ($LongDetail)  //if this is the first time this Rm is being printed, print details of RM
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.d")
				$LongDetail:=False:C215
			Else   //esle just print location info
				Print form:C5([Job_Forms_Materials:55]; "RmPickList.d2")
			End if 
			$Lines:=$Lines+1  //add to lines printed
		Until ($BinIndex<0)  //print location info until no more locations found   
	Until ($ParIndex<0)
	
	If ($Lines+2>$MaxLines)  //if this line would be too much for page
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")  //print footer
		PAGE BREAK:C6(>)  //start new page
		iPage:=iPage+1
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.h")  //print header
		$Lines:=0  //reset line counter
	Else 
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.s")  // space seperate the inks
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.s")  // space seperate the inks
		$Lines:=$Lines+2  //add to lines printed
	End if 
End for 

If ($Lines<$MaxLines)  //finish last page
	For ($i; 1; ($MaxLines-$Lines))
		Print form:C5([Job_Forms_Materials:55]; "RmPickList.s")
	End for 
End if 
Print form:C5([Job_Forms_Materials:55]; "RmPickList.f")
PAGE BREAK:C6  //send entire document to printed