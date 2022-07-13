//%attributes = {"publishedWeb":true}
//rRptCustInvSum  upr1439 2/23/95
//121300 mlb exclude B&H
C_REAL:C285(r1; r2; r3)
C_TEXT:C284(t2; t2b; t3; t10)
C_BOOLEAN:C305(fSave)
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods:26])
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CustInvSummary")
PRINT SETTINGS:C106
If (ok=1)
	t2:="A R K A Y   P A C K A G I N G"
	t2b:="C U S T O M E R   I N V E N T O R Y   S U M M A R I Z E D"
	t3:="All inventory locations, Sorted by Customer Nº"
	dDate:=4D_Current_date
	tTime:=4d_Current_time
	
	
	fSave:=False:C215
	uConfirm("Would you like to also save this report in Excel format?"; "Save file"; "Don't save")
	If (ok=1)
		docName:="CustInvSummary_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
		vDoc:=util_putFileName(->docName)
		If (ok=1)
			fSave:=True:C214
		End if 
	End if 
	
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(dDate; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
		SEND PACKET:C103(vDoc; String:C10(tTime; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13))
		SEND PACKET:C103(vDoc; Char:C90(9)+Char:C90(9)+t3+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103(vDoc; "Customer"+Char:C90(9)+"Qty of Cartons"+Char:C90(9)+"$ Planned Cost"+Char:C90(9))
		SEND PACKET:C103(vDoc; "$ Last Price"+Char:C90(9)+"Notes"+Char:C90(9)+Char:C90(13)+Char:C90(13))
	End if 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0; *)
	QUERY:C277([Finished_Goods_Locations:35];  & [Finished_Goods_Locations:35]Location:2#"BH@")
	QUERY SELECTION:C341([Finished_Goods_Locations:35])
	
	
	
	SET WINDOW TITLE:C213(fNameWindow(->[Finished_Goods_Locations:35])+" Customer Inventory Summary")
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16; >; [Finished_Goods_Locations:35]ProductCode:1; >; [Finished_Goods_Locations:35]JobForm:19; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; r2; r3)
	FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "CustInvSummary")
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
//