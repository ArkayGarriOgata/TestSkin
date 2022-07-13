//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/02/13, 14:10:56
// ----------------------------------------------------
// Method: MakeArrayJFMaterials
// Description
// Creates an array of [Job_Forms_Materials]Raw_Matl_Code items.
// For use to see if any changes are made so we can make the
// changes back on [Estimates_Materials]Raw_Matl_code.
// ----------------------------------------------------
// Modified by: Mel Bohince (4/17/14) use selection to array, include <>axlRecNum in sort

C_TEXT:C284($1)
C_LONGINT:C283($i; $numMatl)
C_BOOLEAN:C305($bChanged)

$bChanged:=False:C215  //Assume nothing changed

If ($1="Get")  //Values when the form was opened.
	ARRAY TEXT:C222(<>atSeq; 0)
	ARRAY TEXT:C222(<>atCC; 0)
	ARRAY TEXT:C222(<>atCommKey; 0)
	ARRAY TEXT:C222(<>atRMCode; 0)
	ARRAY REAL:C219(<>arQty; 0)
	ARRAY TEXT:C222(<>atUM; 0)
	ARRAY REAL:C219(<>arCost; 0)
	ARRAY LONGINT:C221(<>axlRecNum; 0)
	ARRAY INTEGER:C220($atSeq; 0)
	
	[Job_Forms:42]cust_id:82:=[Job_Forms:42]cust_id:82  //Force a "Validate" if needed
	DISTINCT VALUES:C339([Job_Forms_Materials:55]Raw_Matl_Code:7; atChoiceList)
	ARRAY TO LIST:C287(atChoiceList; "RMCodes")
	
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]; <>axlRecNum; [Job_Forms_Materials:55]Sequence:3; $atSeq; [Job_Forms_Materials:55]CostCenterID:2; <>atCC; [Job_Forms_Materials:55]Commodity_Key:12; <>atCommKey; [Job_Forms_Materials:55]Raw_Matl_Code:7; <>atRMCode; [Job_Forms_Materials:55]Actual_Qty:14; <>arQty; [Job_Forms_Materials:55]UOM:5; <>atUM; [Job_Forms_Materials:55]Actual_Price:15; <>arCost)
	$numMatl:=Size of array:C274(<>axlRecNum)
	ARRAY TEXT:C222(<>atSeq; $numMatl)
	For ($i; 1; $numMatl)
		<>atSeq{$i}:=String:C10($atSeq{$i})
	End for 
	//For ($i;1;Records in selection([Job_Forms_Materials]))
	//GOTO SELECTED RECORD([Job_Forms_Materials];$i)
	//APPEND TO ARRAY(<>atSeq;String([Job_Forms_Materials]Sequence))
	//APPEND TO ARRAY(<>atCC;[Job_Forms_Materials]CostCenterID)
	//APPEND TO ARRAY(<>atCommKey;[Job_Forms_Materials]Commodity_Key)
	//APPEND TO ARRAY(<>atRMCode;[Job_Forms_Materials]Raw_Matl_Code)
	//APPEND TO ARRAY(<>arQty;[Job_Forms_Materials]Actual_Qty)
	//APPEND TO ARRAY(<>atUM;[Job_Forms_Materials]UOM)
	//APPEND TO ARRAY(<>arCost;[Job_Forms_Materials]Actual_Price)
	//APPEND TO ARRAY(<>axlRecNum;Record number([Job_Forms_Materials]))
	//End for 
	SORT ARRAY:C229(<>atCommKey; <>atRMCode; <>atSeq; <>atCC; <>arQty; <>atUM; <>arCost; <>axlRecNum; >)
	
Else   //Compare, values when the form is saved.
	
	ARRAY TEXT:C222(atSeq; 0)
	ARRAY TEXT:C222(atCC; 0)
	ARRAY TEXT:C222(atCommKey; 0)
	ARRAY TEXT:C222(atRMCode; 0)
	ARRAY REAL:C219(arQty; 0)
	ARRAY TEXT:C222(atUM; 0)
	ARRAY REAL:C219(arCost; 0)
	ARRAY INTEGER:C220($atSeq; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Sequence:3; $atSeq; [Job_Forms_Materials:55]CostCenterID:2; atCC; [Job_Forms_Materials:55]Commodity_Key:12; atCommKey; [Job_Forms_Materials:55]Raw_Matl_Code:7; atRMCode; [Job_Forms_Materials:55]Actual_Qty:14; arQty; [Job_Forms_Materials:55]UOM:5; atUM; [Job_Forms_Materials:55]Actual_Price:15; arCost)
	$numMatl:=Size of array:C274($atSeq)
	ARRAY TEXT:C222(atSeq; $numMatl)
	For ($i; 1; $numMatl)
		atSeq{$i}:=String:C10($atSeq{$i})
	End for   //For ($i;1;Records in selection([Job_Forms_Materials]))  //Get the values now.
	
	//GOTO SELECTED RECORD([Job_Forms_Materials];$i)
	//APPEND TO ARRAY(atSeq;String([Job_Forms_Materials]Sequence))
	//APPEND TO ARRAY(atCC;[Job_Forms_Materials]CostCenterID)
	//APPEND TO ARRAY(atCommKey;[Job_Forms_Materials]Commodity_Key)
	//APPEND TO ARRAY(atRMCode;[Job_Forms_Materials]Raw_Matl_Code)
	//APPEND TO ARRAY(arQty;[Job_Forms_Materials]Planned_Qty)
	//APPEND TO ARRAY(atUM;[Job_Forms_Materials]UOM)
	//APPEND TO ARRAY(arCost;[Job_Forms_Materials]Planned_Cost)
	//End for 
	SORT ARRAY:C229(atCommKey; atRMCode; atSeq; atCC; arQty; atUM; arCost; >)
	
	For ($i; Size of array:C274(<>atRMCode); 1; -1)  //Did anything change?
		If (atRMCode{$i}=<>atRMCode{$i})
			DELETE FROM ARRAY:C228(atSeq; $i)
			DELETE FROM ARRAY:C228(atCC; $i)
			DELETE FROM ARRAY:C228(atCommKey; $i)
			DELETE FROM ARRAY:C228(<>atRMCode; $i)
			DELETE FROM ARRAY:C228(atRMCode; $i)
			DELETE FROM ARRAY:C228(arQty; $i)
			DELETE FROM ARRAY:C228(atUM; $i)
			DELETE FROM ARRAY:C228(arCost; $i)
		End if 
	End for 
	
	If (Size of array:C274(atRMCode)>0)
		JFMaterialsToEstimate
	End if 
	
	ARRAY TEXT:C222(<>atSeq; 0)
	ARRAY TEXT:C222(<>CC; 0)
	ARRAY TEXT:C222(<>atCommKey; 0)
	ARRAY TEXT:C222(<>atRMCode; 0)
	ARRAY REAL:C219(<>arQty; 0)
	ARRAY TEXT:C222(<>atUM; 0)
	ARRAY REAL:C219(<>arCost; 0)
	ARRAY LONGINT:C221(<>axlRecNum; 0)
	ARRAY TEXT:C222(atSeq; 0)
	ARRAY TEXT:C222(atCC; 0)
	ARRAY TEXT:C222(atCommKey; 0)
	ARRAY TEXT:C222(atRMCode; 0)
	ARRAY REAL:C219(arQty; 0)
	ARRAY TEXT:C222(atUM; 0)
	ARRAY REAL:C219(arCost; 0)
End if 