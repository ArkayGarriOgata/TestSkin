//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: sAddCPN2For
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs)
C_LONGINT:C283($FileNum; $FldNum)  //upr1246
C_POINTER:C301($Ptr)  //upr1246

$case:=Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)  //[Estimates_Differentials]diffNum
$form:=[Estimates_DifferentialsForms:47]DiffFormId:3
//QUERY([Estimates_Carton_Specs];[Estimates_Carton_Specs]Estimate_No=(Substring([Estimates_DifferentialsForms]DiffId;1;9));*)  //*Find Estimate Qty worksheet
//QUERY([Estimates_Carton_Specs]; & ;[Estimates_Carton_Specs]diffNum=<>sQtyWorksht)  //(Substring([Estimates_DifferentialsForms]DiffId;10;2)))  `

gEstimateLDWkSh("Wksht")  // Modified by: Mel Bohince (4/24/18)


//*.   Load pick arrays    
ARRAY BOOLEAN:C223(ListBox1; 0)
ARRAY TEXT:C222(aSelected; 0)
ARRAY LONGINT:C221(aLi; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY TEXT:C222(aDesc; 0)
ARRAY TEXT:C222(aOutline; 0)
ARRAY TEXT:C222(aPSpec; 0)
ARRAY INTEGER:C220(aWeek; 0)
ARRAY TEXT:C222(aStock; 0)
ARRAY DATE:C224(aNextRelease; 0)

//SELECTION TO ARRAY([Finished_Goods];aLi;[Finished_Goods]ProductCode;aCPN;[Finished_Goods]CartonDesc;aDesc;[Finished_Goods]OutLine_Num;aOutline;[Finished_Goods]ProcessSpec;aPSpec)
SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]; aLi; [Estimates_Carton_Specs:19]Item:1; aCPN; [Estimates_Carton_Specs:19]ProductCode:5; aDesc; [Estimates_Carton_Specs:19]OutLineNumber:15; aOutline; [Estimates_Carton_Specs:19]ProcessSpec:3; aPSpec)
SORT ARRAY:C229(aCPN; aDesc; aLi; aPSpec; aOutline; >)
$numRecs:=Size of array:C274(aCPN)
ARRAY TEXT:C222(aSelected; $numRecs)
ARRAY INTEGER:C220(aWeek; $numRecs)
ARRAY TEXT:C222(aStock; $numRecs)
ARRAY DATE:C224(aNextRelease; $numRecs)

$winRef:=OpenSheetWindow(->[Finished_Goods:26]; "PickMultiFG")
allowNew:=False:C215
DIALOG:C40([Finished_Goods:26]; "PickMultiFG")  //window previously opened used, & erased
CLOSE WINDOW:C154

If (ok=1)
	$zzz:=0
	//1/4/94 moved next 10 lines out of the loop
	$FileNum:=Table:C252(->[Estimates_Carton_Specs:19])
	$FldNum:=Field:C253(->[Estimates_Carton_Specs:19]Qty1Temp:52)
	$QtyNum:=Num:C11(Request:C163("Which quantity for added items:  1,2,3,4,5,or 6?"; "1"))
	If ((ok=0) | ($QtyNum<1) | ($QtyNum>6))
		BEEP:C151
		BEEP:C151
		$QtyNum:=1
	End if 
	$TheVal:=$FldNum+$QtyNum-1  //the target qty field
	$Ptr:=Field:C253($FileNum; $TheVal)
	
	For ($i; 1; $numRecs)
		If (aSelected{$i}="X")
			$zzz:=$zzz+1
			GOTO RECORD:C242([Estimates_Carton_Specs:19]; aLi{$i})
			//*    Test for sqInches      
			If (Round:C94([Estimates_Carton_Specs:19]SquareInches:16; 4)=Round:C94(0; 4))
				BEEP:C151
				ALERT:C41("WARNING: "+[Estimates_Carton_Specs:19]ProductCode:5+" does not have square inches specified.")
			End if 
			
			//*   Duplicate the cSpec and rekey
			DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
			[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
			[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
			[Estimates_Carton_Specs:19]Quantity_Want:27:=$ptr->
			[Estimates_Carton_Specs:19]Qty1Temp:52:=[Estimates_Carton_Specs:19]Quantity_Want:27
			[Estimates_Carton_Specs:19]Qty2Temp:53:=0
			[Estimates_Carton_Specs:19]Qty3Temp:54:=0
			[Estimates_Carton_Specs:19]Qty4Temp:55:=0
			[Estimates_Carton_Specs:19]Qty5Temp:56:=0
			[Estimates_Carton_Specs:19]Qty6Temp:57:=0
			
			[Estimates_Carton_Specs:19]diffNum:11:=$case
			[Estimates_Carton_Specs:19]ProcessSpec:3:=[Estimates_DifferentialsForms:47]ProcessSpec:23
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_Carton_Specs:19])
			// End if 
			//*    Update the differencials total pieces
			[Estimates_Differentials:38]TotalPieces:8:=[Estimates_Differentials:38]TotalPieces:8+[Estimates_Carton_Specs:19]Quantity_Want:27
			SAVE RECORD:C53([Estimates_Differentials:38])
			//end upr1246
			//*    Create the FormCarton record
			CREATE RECORD:C68([Estimates_FormCartons:48])
			[Estimates_FormCartons:48]Carton:1:=[Estimates_Carton_Specs:19]CartonSpecKey:7  //upr 1246
			[Estimates_FormCartons:48]DiffFormID:2:=$form
			[Estimates_FormCartons:48]ItemNumber:3:=Num:C11([Estimates_Carton_Specs:19]Item:1)  //upr 1365 12/21/94$FormCtnTtl+$zzz
			[Estimates_FormCartons:48]NumberUp:4:=1
			[Estimates_FormCartons:48]NetSheets:7:=[Estimates_DifferentialsForms:47]NumberSheets:4
			[Estimates_FormCartons:48]MakesQty:5:=[Estimates_DifferentialsForms:47]NumberSheets:4
			[Estimates_FormCartons:48]FormWantQty:9:=[Estimates_Carton_Specs:19]Quantity_Want:27
			SAVE RECORD:C53([Estimates_FormCartons:48])
		End if 
	End for 
End if   //ok
//*Restore included selection
RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)
//*prevent foreign key change
If ((Records in selection:C76([Estimates_FormCartons:48])>0) | (Records in selection:C76([Estimates_Machines:20])>0))
	SetObjectProperties(""; ->[Estimates_DifferentialsForms:47]FormNumber:2; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
End if 