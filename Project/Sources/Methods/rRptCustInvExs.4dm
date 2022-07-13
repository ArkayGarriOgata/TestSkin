//%attributes = {"publishedWeb":true}
//Procedure: rRptCustInvExs()  080195  MLB
//•080195  MLB  UPR 213
//rRptCustInvSum  upr1439 2/23/95
C_REAL:C285(r1; r2; r21; r31)
C_TEXT:C284(t2; t2b; t3; t10)
C_BOOLEAN:C305(fSave)
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CustExcessInv")
PRINT SETTINGS:C106
If (ok=1)
	t2:="A R K A Y   P A C K A G I N G"
	t2b:="C U S T O M E R   E X C E S S   I N V E N T O R I E S"
	t3:="All inventory locations, Sorted by Customer Nº"
	dDate:=4D_Current_date
	tTime:=4d_Current_time
	
	
	fSave:=False:C215
	uConfirm("Would you like to also save this report in Excel format?"; "Save file")
	If (ok=1)
		docName:="CustExcessInv_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
		vDoc:=util_putFileName(->docName)
		If (ok=1)
			fSave:=True:C214
		End if 
	End if 
	
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(dDate; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
		SEND PACKET:C103(vDoc; String:C10(tTime; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13))
		SEND PACKET:C103(vDoc; Char:C90(9)+Char:C90(9)+t3+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103(vDoc; "CustID"+Char:C90(9)+"Name"+Char:C90(9)+"CPN"+Char:C90(9)+"Product Description"+Char:C90(9)+"Total Excess"+Char:C90(9))
		SEND PACKET:C103(vDoc; "$ Last Price"+Char:C90(9)+"Extended $"+Char:C90(13)+Char:C90(13))
	End if 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"BH@")
	QUERY SELECTION:C341([Finished_Goods_Locations:35])
	
	qryOpenOrdLines
	CREATE SET:C116([Customers_Order_Lines:41]; "OpenOrders")
	
	
	
	
	SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" Customer Excess Inventories")
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16; >; [Finished_Goods_Locations:35]ProductCode:1; >)
	BREAK LEVEL:C302(2; 1)
	ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9)
	FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "CustExcessInv")
	MESSAGES OFF:C175
	PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
	
	If (fSave)
		CLOSE DOCUMENT:C267(vDoc)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
	End if 
	
	MESSAGES ON:C181
End if 
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
CLEAR SET:C117("OpenOrders")
CLEAR SET:C117("OneCustOrders")
//