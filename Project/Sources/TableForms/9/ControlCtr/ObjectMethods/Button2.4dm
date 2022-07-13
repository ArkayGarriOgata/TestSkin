Pjt_setReferId(pjtId)
zwStatusMsg("ADD TO PJT"; "Find the Finished Goods to include in this project.")
READ WRITE:C146([Finished_Goods:26])
QUERY:C277([Finished_Goods:26])
If (ok=1)
	
	If (Pjt_AddToProjectLimitor(->[Finished_Goods:26]))
		uConfirm("Change "+String:C10(Records in selection:C76([Finished_Goods:26]))+" records to project number "+pjtId)
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
			
			$oldPjt:=[Finished_Goods:26]ProjectNumber:82
			APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]ProjectNumber:82:=pjtId)
			
			FIRST RECORD:C50([Finished_Goods:26])
			APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]CustID:2:=pjtCustid)
			
			FIRST RECORD:C50([Finished_Goods:26])
			APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47:=(pjtCustid+":"+[Finished_Goods:26]ProductCode:1))
			
			If (Length:C16($newLine)>0)
				FIRST RECORD:C50([Finished_Goods:26])
				APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]Line_Brand:15:=$newLine)
			End if 
			
			zwStatusMsg("ADD TO PJT"; "Product Code "+[Finished_Goods:26]ProductCode:1+" moved from project "+$oldPjt+" to "+pjtId)
		End if 
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProjectNumber:82=pjtId)
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47; >)
	End if 
	
Else 
	zwStatusMsg("ADD TO PJT"; "Query cancelled")
End if 

//