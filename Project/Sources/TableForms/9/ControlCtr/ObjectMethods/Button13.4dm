Pjt_setReferId(pjtId)

zwStatusMsg("ADD TO PJT"; "Find the SizeAndStyle to include in this project.")
READ WRITE:C146([Finished_Goods_SizeAndStyles:132])
QUERY:C277([Finished_Goods_SizeAndStyles:132])
If (ok=1)
	
	If (Pjt_AddToProjectLimitor(->[Finished_Goods_SizeAndStyles:132]))
		uConfirm("Change "+String:C10(Records in selection:C76([Finished_Goods_SizeAndStyles:132]))+" records to project number "+pjtId)
		If (ok=1)
			//see if project name matches a brand
			$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
			SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
			QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=pjtCustid; *)
			QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=pjtName)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			If ($numFound>0)
				$newLine:=pjtName
			Else 
				$newLine:=""
			End if 
			
			$oldPjt:=[Finished_Goods_SizeAndStyles:132]ProjectNumber:2
			APPLY TO SELECTION:C70([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2:=pjtId)
			FIRST RECORD:C50([Finished_Goods_SizeAndStyles:132])
			APPLY TO SELECTION:C70([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]CustID:52:=pjtCustid)
			If (Length:C16($newLine)>0)
				FIRST RECORD:C50([Finished_Goods_SizeAndStyles:132])
				APPLY TO SELECTION:C70([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]Line:11:=$newLine)
			End if 
			
			zwStatusMsg("ADD TO PJT"; String:C10(Records in selection:C76([Finished_Goods_SizeAndStyles:132]))+" SizeAndStyle moved from project "+$oldPjt+" to "+pjtId)
		End if 
		
	End if 
	
Else 
	zwStatusMsg("ADD TO PJT"; "Query cancelled")
End if 

QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2=pjtId)
ORDER BY:C49([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1; >)
//