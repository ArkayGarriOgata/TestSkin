//%attributes = {"publishedWeb":true}
//gSelectFG
//allow user to select from multiple finished goods
//$1 customer ID to find FGs for

$CustId:=$1

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$CustId)
ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
If (Records in selection:C76([Finished_Goods:26])>0)
	
	$winRef:=NewWindow(700; 480; 6; 8; "Select an FG Item to Order")
	Repeat 
		DISPLAY SELECTION:C59([Finished_Goods:26])
		Case of 
			: (Records in set:C195("UserSet")=0)
				uConfirm("You Need to Select ONE Finished Good item to Place on the Order."+<>sCr+"Do You Want to Try Again?"; "Try Again"; "Stop")
			: (Records in set:C195("UserSet")>1)
				uConfirm("You May Select ONLY ONE Finished Good item to Place on the Order."+<>sCr+"Do You Want to Try Again?"; "Try Again"; "Stop")
			Else 
				USE SET:C118("UserSet")
				OK:=0
		End case 
	Until (OK=0) | (Records in set:C195("UserSet")=1)
	CLOSE WINDOW:C154($winRef)
	
Else 
	BEEP:C151
	ALERT:C41("No Finished Good records found for this customer.")
End if 