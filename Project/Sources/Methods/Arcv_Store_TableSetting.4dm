//%attributes = {}
//Method:  Arcv_Store_TableSetting({nTable})
//Description:  This method will ask for the fields to display as columns

If (True:C214)  //Initialize
	C_LONGINT:C283($1; $nTable)
	
	C_TEXT:C284($tPicked; $tFieldName; $tSelected)
	
	C_OBJECT:C1216($oPick)
	C_OBJECT:C1216($oTableProperty)
	
	C_OBJECT:C1216($enArcvTable)
	
	C_COLLECTION:C1488($cFieldName)
	
	ARRAY TEXT:C222($atSource; 0)
	ARRAY TEXT:C222($atSelected; 0)
	
	ARRAY TEXT:C222($atFieldName; 0)
	
	If (Count parameters:C259=1)
		
		$nTable:=$1
		
	Else 
		
		$nTable:=Core_Application_GetTableN
		
	End if 
	
	$cFieldName:=New collection:C1472()
	
	$oPick:=New object:C1471()
	
	$oPick.tPicked:=CorektBlank
	$oPick.bPickMultiple:=True:C214
	$oPick.tFind:="Field name"
	
	$enArcvTable:=New object:C1471()
	
End if   //Done initialize

Case of   //Table
		
	: (Not:C34(Is table number valid:C999($ntable)))
		
	Else   //Table exists
		
		Core_Field_FillName($nTable; ->$atFieldName)
		
		SORT ARRAY:C229($atFieldName; >)
		
		If (Arcv_Tabl_ExistsB($nTable; ->$cFieldName))  //Table settings
			
			For each ($tFieldName; $cFieldName)  //Fieldname
				
				$tPicked:=$tPicked+$tFieldName+CorektPipe
				
			End for each   //Done fieldname
			
			$tPicked:=Substring:C12($tPicked; 1; Length:C16($tPicked)-1)
			
			$oPick.tPicked:=$tPicked
			
		End if   //Done table settings
		
		$tSelected:=Core_Dialog_PickT(->$atFieldName; $oPick)
		
		If ($tSelected#CorektBlank)  //Selected
			
			$oTableProperty:=New object:C1471()
			
			$oTableProperty.nTableNumber:=$nTable
			
			$tSelected:="pk_id"+CorektPipe+$tSelected  //Add pk_id as the first column
			
			$oTableProperty.cFieldName:=Split string:C1554($tSelected; CorektPipe; sk trim spaces:K86:2)
			
			$enArcvTable:=ds:C1482.Arcv_Table.new()
			
			$enArcvTable.TableProperty:=$oTableProperty
			
			$enArcvTable.save()
			
		End if   //Done selected
		
End case   //Done table

$0:=$nTable