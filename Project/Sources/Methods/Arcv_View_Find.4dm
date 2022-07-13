//%attributes = {}
//Method: Arcv_View_Find
//Description:  This method will find a report in current selected table

If (True:C214)  //Initialize
	
	C_TEXT:C284($tFind; $tQuery; $tFieldName)
	C_LONGINT:C283($nTableNumber)
	C_OBJECT:C1216($esRecords)
	C_OBJECT:C1216($eTableSetting)
	
	$tFind:=Get edited text:C655
	
	$tQuery:=CorektBlank
	
	$nTableNumber:=Core_Table_GetTableNumberN(Form:C1466.tTableName)
	
	$esRecords:=New object:C1471()
	
End if   //Done initialize

Case of   //Find
		
	: ($tFind=CorektBlank)
	: (Length:C16($tFind)<3)
		
	Else   //Load
		
		$tQuery:="TableProperty.nTableNumber=="+String:C10($nTableNumber)
		
		$eTableSetting:=ds:C1482.Arcv_Table.query($tQuery).first()  //Get columns
		
		$tFind:=$tFind+"@"
		
		$bfirst:=True:C214
		
		$tQuery:="TableNumber = "+String:C10($nTableNumber)
		
		For each ($tFieldName; $eTableSetting.TableProperty.cFieldName)  //Column
			
			If ($bFirst)
				
				$tQuery:=$tQuery+" AND "+"RecordRow."+$tFieldName+" = "+$tFind
				$bfirst:=False:C215
				
			Else 
				
				$tQuery:=$tQuery+" OR "+"RecordRow."+$tFieldName+" = "+$tFind
				
			End if 
			
		End for each   //Done column
		
		$esRecords:=ds:C1482.Archive.query($tQuery)
		
		Case of   //Fill
				
			: (Not:C34(Is table number valid:C999($nTableNumber)))
			: ($esRecords=Null:C1517)
				
			Else   //Valid
				
				Arcv_View_TableFill($nTableNumber; $esRecords)
				
		End case   //Done fill
		
End case   //Done find

