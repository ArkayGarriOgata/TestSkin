[Raw_Materials:21]ReceiptUOM:9:=Substring:C12(util_ComboBoxAction(->aUOM1; aUOM1{0}); 1; 4)  //(s) aUOM [poitems]input
If (Length:C16([Raw_Materials:21]ReceiptUOM:9)=0)
	[Raw_Materials:21]ReceiptUOM:9:=Old:C35([Raw_Materials:21]ReceiptUOM:9)
End if 