//%attributes = {"publishedWeb":true}
//uChkButton: Check Button from (L)[Control]Sel.Month
If (rb1=1)
	fPrtFlg:=False:C215
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		While (Month of:C24([Finished_Goods_Transactions:33]XactionDate:3)#<>ayMonth) & (Not:C34(End selection:C36([Raw_Materials_Transactions:23])))
			NEXT RECORD:C51([Finished_Goods_Transactions:33])
		End while 
		If (Month of:C24([Finished_Goods_Transactions:33]XactionDate:3)=<>ayMonth)
			fPrtFlg:=True:C214
		End if 
		
	Else 
		
		C_LONGINT:C283($record_number)
		
		ARRAY DATE:C224($_XactionDate_Month; 0)
		ARRAY LONGINT:C221($_Finished_Goods_Transactions; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]; $_Finished_Goods_Transactions; [Finished_Goods_Transactions:33]XactionDate:3; $_XactionDate_Month)
		C_BOOLEAN:C305($Exist)
		
		For ($Iter; 1; Size of array:C274($_Finished_Goods_Transactions); 1)
			
			If (Month of:C24($_XactionDate_Month{$Iter})=<>ayMonth)
				
				If ($Exist=False:C215)
					
					$Exist:=True:C214
					$record_number:=$_Finished_Goods_Transactions{$Iter}
					
				End if 
			End if 
		End for 
		
		If ($_record_number>0)
			fPrtFlg:=True:C214
			GOTO SELECTED RECORD:C245([Finished_Goods_Transactions:33]; $_record_number)
		End if 
		
	End if   // END 4D Professional Services : January 2019 First record
	
End if 