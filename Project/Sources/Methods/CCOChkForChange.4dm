//%attributes = {"publishedWeb":true}
//(p) CCOChkforChange
//This routine checks the CCo entered lines for multiple changes 
//IF the ORDER has started shipping.
//returns either -1 (everything OK)
//or item no with which a problem has occured
//• 5/22/97 cs created upr 1882

C_LONGINT:C283($TooMany; $Changes; $Count; $0)

RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
//ALL SUBRECORDS([Customers_Order_Change_Orders]OrderChg_Items)  `get all changed items
QUERY SELECTION:C341([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]OldProductCode:9#"")
//FIRST SUBRECORD([Customers_Order_Change_Orders]OrderChg_Items)  `start at the first one
$Changes:=0
$TooMany:=-1
$Count:=Records in selection:C76([Customers_Order_Changed_Items:176])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; $Count)  // verify that only ONE change occured by comparing all NEWs to OLDs
		
		$Changes:=$Changes+Num:C11(Not:C34([Customers_Order_Changed_Items:176]OldQty:2=[Customers_Order_Changed_Items:176]NewQty:4))
		$Changes:=$Changes+Num:C11(Not:C34([Customers_Order_Changed_Items:176]OldPrice:3=[Customers_Order_Changed_Items:176]NewPrice:5))
		
		If ($Changes>1)  //if more than one change occured, fail rountine
			$TooMany:=[Customers_Order_Changed_Items:176]ItemNo:1
			$i:=$Count+1
		Else   //continue processing
			$Changes:=0
			NEXT RECORD:C51([Customers_Order_Changed_Items:176])
		End if 
	End for 
	
Else 
	
	SELECTION TO ARRAY:C260([Customers_Order_Changed_Items:176]OldQty:2; $_OldQty; [Customers_Order_Changed_Items:176]NewQty:4; $_NewQty; [Customers_Order_Changed_Items:176]OldPrice:3; $_OldPrice; [Customers_Order_Changed_Items:176]NewPrice:5; $_NewPrice; [Customers_Order_Changed_Items:176]ItemNo:1; $_ItemNo)
	
	For ($i; 1; $Count)
		
		$Changes:=$Changes+Num:C11(Not:C34($_OldQty{$i}=$_NewQty{$i}))
		$Changes:=$Changes+Num:C11(Not:C34($_OldPrice{$i}=$_NewPrice{$i}))
		
		If ($Changes>1)
			$TooMany:=$_ItemNo{$i}
			$i:=$Count+1
		Else 
			$Changes:=0
			
		End if 
	End for 
	
End if   // END 4D Professional Services : January 2019 First record


$0:=$TooMany