//%attributes = {}
// (PM) DB_ExecuteQuery 

C_LONGINT:C283($vl_Rowset; $vl_ColumnCount; $vl_RowCount; $vl_StartTime; $vl_EndTime; $i)
C_TEXT:C284($vt_ColumnName; $vt_VariableName)
C_POINTER:C301($vp_Variable; $vp_Header)

C_LONGINT:C283(vl_Header1; vl_Header2; vl_Header3; vl_Header4; vl_Header5; vl_Header6; vl_Header7; vl_Header8; vl_Header9; vl_Header10)
C_LONGINT:C283(vl_Header11; vl_Header12; vl_Header13; vl_Header14; vl_Header15; vl_Header16; vl_Header17; vl_Header18; vl_Header19; vl_Header20)

ARRAY TEXT:C222(at_Column1; 0)
ARRAY TEXT:C222(at_Column2; 0)
ARRAY TEXT:C222(at_Column3; 0)
ARRAY TEXT:C222(at_Column4; 0)
ARRAY TEXT:C222(at_Column5; 0)
ARRAY TEXT:C222(at_Column6; 0)
ARRAY TEXT:C222(at_Column7; 0)
ARRAY TEXT:C222(at_Column8; 0)
ARRAY TEXT:C222(at_Column9; 0)
ARRAY TEXT:C222(at_Column10; 0)
ARRAY TEXT:C222(at_Column11; 0)
ARRAY TEXT:C222(at_Column12; 0)
ARRAY TEXT:C222(at_Column13; 0)
ARRAY TEXT:C222(at_Column14; 0)
ARRAY TEXT:C222(at_Column15; 0)
ARRAY TEXT:C222(at_Column16; 0)
ARRAY TEXT:C222(at_Column17; 0)
ARRAY TEXT:C222(at_Column18; 0)
ARRAY TEXT:C222(at_Column19; 0)
ARRAY TEXT:C222(at_Column20; 0)

// Remove all existing columns
//$vl_ColumnCount:=Get number of listbox columns(ab_QueryResultListBox)
//For ($i;1;$vl_ColumnCount)
//DELETE LISTBOX COLUMN(ab_QueryResultListBox;1)
//End for 

vt_Messages:=""

// If we have a connection open
If (vl_Connection#0)
	// Execute the query
	$vl_StartTime:=Milliseconds:C459
	//$vl_Rowset:=MySQL Select (conn_id;vt_Query)
	$vl_EndTime:=Milliseconds:C459
	
	// Get the number of rows returned
	//$vl_RowCount:=MySQL Get Row Count ($vl_Rowset)
	vt_Messages:="Execution time : "+String:C10($vl_EndTime-$vl_StartTime)+" milliseconds.   Rows found : "+String:C10($vl_RowCount)
	
	// Get the number of columns (only 20 will be displayed)
	//$vl_ColumnCount:=MySQL Get Column Count ($vl_Rowset)
	If ($vl_ColumnCount>20)
		$vl_ColumnCount:=20
	End if 
	
	$vl_StartTime:=Milliseconds:C459
	
	// Retrieve the column data and add the column to the listbox
	For ($i; 1; $vl_ColumnCount)
		//$vt_ColumnName:=MySQL Get Column Name ($vl_Rowset;$i)
		$vt_VariableName:="at_Column"+String:C10($i)
		$vp_Variable:=Get pointer:C304($vt_VariableName)
		//MySQL Column To Array ($vl_Rowset;"";$i;$vp_Variable->)
		
		$vt_VariableName:="vl_Header"+String:C10($i)
		$vp_Header:=Get pointer:C304($vt_VariableName)
		//INSERT LISTBOX COLUMN(ab_QueryResultListBox;$i;"Column_"+$vt_ColumnName;$vp_Variable->;"Header_"+$vt_ColumnName;$vp_Header->)
		OBJECT SET TITLE:C194($vp_Header->; $vt_ColumnName)
		OBJECT SET FONT:C164($vp_Variable->; "Lucida Grande")
		OBJECT SET FONT SIZE:C165($vp_Variable->; 13)
		OBJECT SET FONT:C164($vp_Header->; "Lucida Grande")
		OBJECT SET FONT SIZE:C165($vp_Header->; 13)
		
	End for 
	
	$vl_EndTime:=Milliseconds:C459
	vt_Messages:=vt_Messages+"   Display time : "+String:C10($vl_EndTime-$vl_StartTime)+" milliseconds."
	
	// Clean up memory
	//MySQL Delete Row Set ($vl_Rowset)
	
End if 

// Make sure that at least one column is displayed (it looks better)
//$vl_ColumnCount:=Get number of listbox columns(ab_QueryResultListBox)
//If ($vl_ColumnCount=0)
//
//$vp_Variable:=->at_Column1
//$vp_Header:=->vl_Header1
//INSERT LISTBOX COLUMN(ab_QueryResultListBox;$i;"Column_"+$vt_ColumnName;$vp_Variable->;"Header_"+$vt_ColumnName;$vp_Header->)
//BUTTON TEXT($vp_Header->;"")
//
//End if 