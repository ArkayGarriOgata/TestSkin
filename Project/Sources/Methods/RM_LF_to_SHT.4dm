//%attributes = {}
// -------
// Method: RM_LF_to_SHT   ( ) ->
// By: Mel Bohince @ 02/13/17, 16:53:04
// Description
// convert from LF to SHT
//test the uom on the budget, if LF, convert to sheet
// ----------------------------------------------------
C_LONGINT:C283($0; $qty; $linear_feet; $sheets)
C_BOOLEAN:C305($short_grain)
C_REAL:C285($length; $width)
C_TEXT:C284($jobform; $1; $uom)
$qty:=0
$uom:=""
$short_grain:=False:C215
$length:=0
$width:=0
$linear_feet:=0
$sheets:=0

If (Count parameters:C259=1)  //| True
	$jobform:=$1
	//$jobform:="98529.01"
	
	Begin SQL
		select Planned_Qty, UOM from Job_Forms_Materials where JobForm = :$jobform and (Commodity_Key like '01%' or Commodity_Key like '20%') into :$qty, :$uom
	End SQL
	
	Case of 
		: ($uom="LF")  //conversion needed
			$linear_feet:=$qty
			
			Begin SQL
				select Width, Lenth, ShortGrain from Job_Forms where JobFormID = :$jobform into :$width, :$length, :$short_grain
			End SQL
			
			If ($short_grain)
				$length:=$width
			End if 
			
			$sheet_length:=$length/12  //12 inches in a foot
			
			$sheets:=Int:C8($linear_feet/$sheet_length)
			
		: ($uom="SHT")  //no conversion needed
			$sheets:=$qty
			
		Else   //MSF? unexpected uom for 
			$sheets:=-1
	End case 
	
End if 

$0:=$sheets
