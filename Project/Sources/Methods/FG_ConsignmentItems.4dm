//%attributes = {"publishedWeb":true}
//FG_ConsignmentItems
//cache spl items so they can be hilited

C_TEXT:C284($1; $2)
C_BOOLEAN:C305($0)

$0:=False:C215

Case of 
	: ($1="is")
		$hit:=Find in array:C230(<>FGwarehouseProgram; $2)
		If ($hit>-1)
			$0:=True:C214
		End if 
		
	: ($1="init")
		If (Size of array:C274(<>FGwarehouseProgram)=0)
			//zwStatusMsg ("Please Wait";"Looking for Warehouse Program items")
			//READ ONLY([Finished_Goods])
			//QUERY([Finished_Goods];[Finished_Goods]WarehouseProgram=True)
			//SELECTION TO ARRAY([Finished_Goods]ProductCode;◊FGwarehouseProgram)
			//REDUCE SELECTION([Finished_Goods];0)
			//zwStatusMsg ("";"")
		End if 
		
End case 