uConfirm("Create a New BOL?"; "Yes"; "Cancel")
If (ok=1)
	QUERY:C277([WMS_InternalBOLs:163]; [WMS_InternalBOLs:163]loaded:9=False:C215; *)
	QUERY:C277([WMS_InternalBOLs:163];  & ; [WMS_InternalBOLs:163]canPurge:10=False:C215)
	If (Records in selection:C76([WMS_InternalBOLs:163])>0)
		SELECTION TO ARRAY:C260([WMS_InternalBOLs:163]; $aRecNo; [WMS_InternalBOLs:163]bol_number:2; $aBOLs)
		SORT ARRAY:C229($aBOLs; $aRecNo; <)
		$unusedBOL:=$aBOLs{1}
		uConfirm($unusedBOL+" is already to print."; "Print "+String:C10(Num:C11($unusedBOL)); "Another New")
		If (ok=1)
			GOTO RECORD:C242([WMS_InternalBOLs:163]; $aRecNo{1})
			ONE RECORD SELECT:C189([WMS_InternalBOLs:163])
			CREATE SET:C116([WMS_InternalBOLs:163]; "$ListboxSet")
			
			IBOL_IntraPlanTransfer("print_bol")
			
			ALL RECORDS:C47([WMS_InternalBOLs:163])
			ORDER BY:C49([WMS_InternalBOLs:163]; [WMS_InternalBOLs:163]bol_number:2; <)
			
		Else 
			uConfirm("Are you sure you want a New BOL?"; "Yes"; "Cancel")
			If (ok=1)
				IBOL_IntraPlanTransfer("new_bol")
			End if 
		End if 
		
	Else 
		IBOL_IntraPlanTransfer("new_bol")
	End if 
	
End if   //confirm new
