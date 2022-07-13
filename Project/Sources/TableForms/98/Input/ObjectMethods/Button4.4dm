If ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)  //(FG_PrepServiceManditoriesSet )
	//[FG_Specification]DateSubmitted:=4D_Current_date
	//bSubmit:=1
	SAVE RECORD:C53([Finished_Goods_Specifications:98])
	FG_PrepServiceSetFGrecord([Finished_Goods_Specifications:98]ControlNumber:2)
	
	FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "PrepWorkOrder")
	
	xText:=""
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		SELECTION TO ARRAY:C260([Prep_Charges:103]QuantityQuoted:2; $aQty; [Prep_Charges:103]PrepItemNumber:4; $aItem)
		SET QUERY LIMIT:C395(1)
		For ($i; 1; Size of array:C274($aQty))
			If ($aQty{$i}>0)
				QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=$aItem{$i})
				xText:=xText+String:C10($aQty{$i})+"    "+[Prep_CatalogItems:102]Description:2+Char:C90(13)
			End if 
		End for 
		SET QUERY LIMIT:C395(0)
		REDUCE SELECTION:C351([Prep_CatalogItems:102]; 0)
		
	Else 
		
		ARRAY LONGINT:C221($_record_number; 0)
		ARRAY TEXT:C222($_Description; 0)
		ARRAY REAL:C219($_QuantityQuoted; 0)
		ARRAY TEXT:C222($_PrepItemNumber; 0)
		
		SELECTION TO ARRAY:C260([Prep_Charges:103]; $_record_number)
		
		QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]QuantityQuoted:2>0)
		GET FIELD RELATION:C920([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
		SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; Automatic:K51:4; Do not modify:K51:1)
		SELECTION TO ARRAY:C260([Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; \
			[Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; \
			[Prep_CatalogItems:102]Description:2; $_Description)
		SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
		
		For ($i; 1; Size of array:C274($_QuantityQuoted))
			
			xText:=xText+String:C10($_QuantityQuoted{$i})+"    "+$_Description{$i}+Char:C90(13)
		End for 
		
		CREATE SELECTION FROM ARRAY:C640([Prep_Charges:103]; $_record_number)
		
	End if   // END 4D Professional Services : January 2019 
	
	RELATE MANY:C262([Finished_Goods_Specifications:98]Ink:24)
	ORDER BY:C49([Finished_Goods_Specs_Inks:188]; [Finished_Goods_Specs_Inks:188]Side:2; >; [Finished_Goods_Specs_Inks:188]Rotation:1; >)
	
	LOAD RECORD:C52([Finished_Goods:26])
	PRINT RECORD:C71([Finished_Goods_Specifications:98])
	FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "List")
	//tickle the record so 
	[Finished_Goods_Specifications:98]CommentsFromQA:53:=[Finished_Goods_Specifications:98]CommentsFromQA:53+" "
	
Else 
	BEEP:C151
	ALERT:C41("Can't print without a ticking Submit."+Char:C90(13)+Char:C90(13)+"To Submit, all sliders must be"+" set to 'No' or some value and the 'If so:s' are filled in."; "Fix")
End if 