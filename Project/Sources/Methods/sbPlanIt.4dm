//%attributes = {"publishedWeb":true}
//(s)bPlanIt

C_TEXT:C284($text)

gEstimateLDWkSh("Wksht")
If (Records in selection:C76([Estimates_Carton_Specs:19])>0)
	$text:="ProductCode"+Char:C90(9)+"Qty1"+Char:C90(9)+"Qty2"+Char:C90(9)+"Qty3"+Char:C90(9)+"Qty4"+Char:C90(9)+"Qty5"+Char:C90(9)+"Qty6"+Char:C90(13)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		FIRST RECORD:C50([Estimates_Carton_Specs:19])
		While (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
			$text:=$text+[Estimates_Carton_Specs:19]ProductCode:5+Char:C90(9)
			$text:=$text+String:C10([Estimates_Carton_Specs:19]Qty1Temp:52)+Char:C90(9)
			$text:=$text+String:C10([Estimates_Carton_Specs:19]Qty2Temp:53)+Char:C90(9)
			$text:=$text+String:C10([Estimates_Carton_Specs:19]Qty3Temp:54)+Char:C90(9)
			$text:=$text+String:C10([Estimates_Carton_Specs:19]Qty4Temp:55)+Char:C90(9)
			$text:=$text+String:C10([Estimates_Carton_Specs:19]Qty5Temp:56)+Char:C90(9)
			$text:=$text+String:C10([Estimates_Carton_Specs:19]Qty6Temp:57)+Char:C90(13)
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
		End while 
		
	Else 
		
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY LONGINT:C221($_Qty1Temp; 0)
		ARRAY LONGINT:C221($_Qty2Temp; 0)
		ARRAY LONGINT:C221($_Qty3Temp; 0)
		ARRAY LONGINT:C221($_Qty4Temp; 0)
		ARRAY LONGINT:C221($_Qty5Temp; 0)
		ARRAY LONGINT:C221($_Qty6Temp; 0)
		
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]ProductCode:5; $_ProductCode; [Estimates_Carton_Specs:19]Qty1Temp:52; $_Qty1Temp; [Estimates_Carton_Specs:19]Qty2Temp:53; $_Qty2Temp; [Estimates_Carton_Specs:19]Qty3Temp:54; $_Qty3Temp; [Estimates_Carton_Specs:19]Qty4Temp:55; $_Qty4Temp; [Estimates_Carton_Specs:19]Qty5Temp:56; $_Qty5Temp; [Estimates_Carton_Specs:19]Qty6Temp:57; $_Qty6Temp)
		
		For ($Iter; 1; Size of array:C274($_ProductCode); 1)
			
			$text:=$text+$_ProductCode{$Iter}+Char:C90(9)
			$text:=$text+String:C10($_Qty1Temp{$Iter})+Char:C90(9)
			$text:=$text+String:C10($_Qty2Temp{$Iter})+Char:C90(9)
			$text:=$text+String:C10($_Qty3Temp{$Iter})+Char:C90(9)
			$text:=$text+String:C10($_Qty4Temp{$Iter})+Char:C90(9)
			$text:=$text+String:C10($_Qty5Temp{$Iter})+Char:C90(9)
			$text:=$text+String:C10($_Qty6Temp{$Iter})+Char:C90(13)
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	$windowTitle:=Get window title:C450
	$winRef:=OpenSheetWindow(->[zz_control:1]; "text_dio"; "Product Codes and Qtys")
	t1:=$text
	DIALOG:C40([zz_control:1]; "text_dio")
	CLOSE WINDOW:C154
	SET WINDOW TITLE:C213($windowTitle)
	
Else 
	uConfirm("Couldn't find any Worksheet records"; "OK"; "Help")
End if 