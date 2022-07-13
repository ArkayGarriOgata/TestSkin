//%attributes = {"executedOnServer":true}
// -------
// Method: Job_SubformsOnServer   ( ) ->
// By: Mel Bohince @ 05/11/18, 13:52:05
// Description
// see props, run on server
// build array structure to display subform on client
// ----------------------------------------------------

C_POINTER:C301($ptrBlob; $2)
C_TEXT:C284($1; $jobform)

If (Count parameters:C259>0)
	$jobform:=$1
	$ptrBlob:=$2
Else 
	C_BLOB:C604($objData)
	SET BLOB SIZE:C606($objData; 0)
	$ptrBlob:=->$objData
	$jobform:="99796.03"
End if 

SET BLOB SIZE:C606($ptrBlob->; 0)

//find the net sheets so subform ratios can be calculated
C_LONGINT:C283($jobformNetSheets)
Begin SQL
	select EstNetSheets from Job_Forms 
	where JobFormID = :$jobform
	into :$jobformNetSheets
End SQL


//get the machine budget
ARRAY LONGINT:C221(aSeq; 0)
ARRAY TEXT:C222(aCC; 0)
ARRAY LONGINT:C221(aQtyGross; 0)
ARRAY LONGINT:C221(aEmbossing; 0)

Begin SQL
	select Sequence, CostCenterID, Planned_Qty, Flex_field1 from Job_Forms_Machines 
	where JobForm = :$jobform order by Sequence
	into :aSeq, :aCC, :aQtyGross, :aEmbossing
End SQL
//use words  not numbers
$handLabor:=" 501 503 505 "
For ($i; 1; Size of array:C274(aSeq))
	$budCC:=aCC{$i}
	Case of   //see uInit_CostCenterGroups
		: (Position:C15($budCC; <>SHEETERS)>0)
			aCC{$i}:="SHEETING"
		: (Position:C15($budCC; <>PRESSES)>0)
			aCC{$i}:="PRINTING"
		: (Position:C15($budCC; <>LAMINATERS)>0)
			aCC{$i}:="LAMINATING"
		: (Position:C15($budCC; <>STAMPERS)>0) | (Position:C15($budCC; <>EMBOSSERS)>0)
			If (aEmbossing{$i}>0)
				aCC{$i}:="EMBOSSING"
			Else 
				aCC{$i}:="STAMPING"
			End if 
		: (Position:C15($budCC; <>BLANKERS)>0)
			aCC{$i}:="DIE CUT"
		: (Position:C15($budCC; $handLabor)>0)
			aCC{$i}:="HAND LABOR"
		: (Position:C15($budCC; <>GLUERS)>0)
			aCC{$i}:="GLUING"
		: (False:C215)  // for "Find in Database"
			$desc:=CostCtr_Description_Tweak(->aCC{$i})
		Else 
			aCC{$i}:="???"
	End case 
	
End for 


//find the subforms, netsheets and ratio per subform
ARRAY LONGINT:C221(aSubform; 0)
ARRAY REAL:C219(aRatio; 0)
ARRAY LONGINT:C221(aQtyNetSheets; 0)
ARRAY LONGINT:C221($ItemSubForm; 0)
ARRAY LONGINT:C221($NumUp; 0)
ARRAY LONGINT:C221($Yield; 0)
ARRAY LONGINT:C221($netSheets; 0)

Begin SQL
	select SubFormNumber, NumberUp, Qty_Yield from Job_Forms_Items 
	where JobForm = :$jobform order by SubFormNumber
	into :$ItemSubForm, :$NumUp, :$Yield
End SQL

ARRAY LONGINT:C221($netSheets; Size of array:C274($ItemSubForm))  //see also JBNSubformRatio
For ($i; 1; Size of array:C274($Yield))
	$netSheets{$i}:=$Yield{$i}/$NumUp{$i}  //should match the netsheets entered in the estimate but not transfered here unfortunately
	$hit:=Find in array:C230(aSubForm; $ItemSubForm{$i})  //add to subform table if first encounter
	If ($hit=-1)  // add the row
		APPEND TO ARRAY:C911(aSubForm; $ItemSubForm{$i})
		APPEND TO ARRAY:C911(aQtyNetSheets; $netSheets{$i})
		APPEND TO ARRAY:C911(aRatio; ($netSheets{$i}/$jobformNetSheets))
	Else   //check that net sheets are consistent
		If (aQtyNetSheets{$hit}#$netSheets{$i})
			ALERT:C41("Planned net sheets looks wrong on subform "+String:C10($ItemSubForm{$i}))
		End if 
	End if 
End for 

//get the recorded machinetickets' good counts and consolidate by subform
ARRAY LONGINT:C221($MT_Seq; 0)
ARRAY LONGINT:C221($MT_Subform; 0)
ARRAY LONGINT:C221($MT_Good; 0)
Begin SQL
	select Sequence, Subform, Good_Units from Job_Forms_Machine_Tickets 
	where JobForm = :$jobform order by Sequence, Subform
	into :$MT_Seq, :$MT_Subform, :$MT_Good
End SQL

ARRAY TEXT:C222(aMT_SeqSF; 0)
ARRAY LONGINT:C221(aMT_SeqSFqty; 0)
For ($mt; 1; Size of array:C274($MT_Seq))
	$seqSubForm:=String:C10($MT_Seq{$mt}; "000")+String:C10($MT_Subform{$mt}; "00")
	$hit:=Find in array:C230(aMT_SeqSF; $seqSubForm)
	If ($hit=-1)
		APPEND TO ARRAY:C911(aMT_SeqSF; $seqSubForm)
		APPEND TO ARRAY:C911(aMT_SeqSFqty; 0)
		$hit:=Size of array:C274(aMT_SeqSF)
	End if 
	aMT_SeqSFqty{$hit}:=aMT_SeqSFqty{$hit}+$MT_Good{$mt}
End for 

//VARIABLE TO BLOB($jobformNetSheets;$ptrBlob->;*)
ARRAY LONGINT:C221(aJFM_seq; 0)
ARRAY TEXT:C222(aJFM_comm; 0)
ARRAY TEXT:C222(aJFM_RM; 0)
ARRAY LONGINT:C221(aJFM_rotation; 0)
ARRAY TEXT:C222(aJFM_SF; 0)
//Alpha20_2 has the rotation tag
Begin SQL
	select  Sequence, Commodity_Key, Raw_Matl_Code, Real2, Alpha20_2 from Job_Forms_Materials 
	where JobForm = :$jobform and Commodity_Key not like '04%' order by Sequence, Alpha20_2
	into :aJFM_seq, :aJFM_comm, :aJFM_RM, :aJFM_rotation, :aJFM_SF
End SQL

ARRAY LONGINT:C221(aJMI_item; 0)
ARRAY TEXT:C222(aJMI_CPN; 0)
ARRAY TEXT:C222($aOrderItem; 0)
ARRAY LONGINT:C221(aJMI_SF; 0)
ARRAY DATE:C224(aJMI_HRD; 0)
ARRAY DATE:C224(aJMI_REL; 0)
Begin SQL
	select  ItemNumber, ProductCode, SubFormNumber, MAD, OrderItem from Job_Forms_Items 
	where JobForm = :$jobform order by ItemNumber, SubFormNumber
	into :aJMI_item, :aJMI_CPN, :aJMI_SF, :aJMI_HRD, :$aOrderItem
End SQL
$items:=Size of array:C274(aJMI_item)
ARRAY DATE:C224(aJMI_REL; $items)
For ($i; 1; $items)
	aJMI_REL{$i}:=JMI_get1stRelease($aOrderItem{$i}; aJMI_CPN{$i})
End for 

VARIABLE TO BLOB:C532(aSeq; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aCC; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aQtyGross; $ptrBlob->; *)

VARIABLE TO BLOB:C532(aSubForm; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aQtyNetSheets; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aRatio; $ptrBlob->; *)

VARIABLE TO BLOB:C532(aMT_SeqSF; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aMT_SeqSFqty; $ptrBlob->; *)

VARIABLE TO BLOB:C532(aJFM_seq; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJFM_comm; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJFM_RM; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJFM_rotation; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJFM_SF; $ptrBlob->; *)

VARIABLE TO BLOB:C532(aJMI_item; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJMI_CPN; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJMI_SF; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJMI_HRD; $ptrBlob->; *)
VARIABLE TO BLOB:C532(aJMI_REL; $ptrBlob->; *)



