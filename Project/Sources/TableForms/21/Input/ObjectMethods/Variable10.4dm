//(s) bAcceptRec
//• 12/5/97 cs added code to require color field for inks 

If ([Raw_Materials:21]CommodityCode:26=2) & ([Raw_Materials:21]Flex5:23="")  //• 12/5/97 cs 
	uConfirm("The new Material is an Ink, all Inks require a Color."+Char:C90(13)+Char:C90(13)+"Please Enter a Color for this Ink."; "OK"; "Help")
	GOTO OBJECT:C206([Raw_Materials:21]Flex5:23)
	REJECT:C38
End if 