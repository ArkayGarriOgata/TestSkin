If (Form event code:C388=On Display Detail:K2:22)
	If ([Job_Forms_Items:44]Qty_Want:24#0)
		r5:=Round:C94((([Job_Forms_Items:44]Qty_Yield:9-[Job_Forms_Items:44]Qty_Want:24)/[Job_Forms_Items:44]Qty_Want:24)*100; 1)
	Else 
		r5:=0
	End if 
	
	r6:=0
	r7:=0
	r8:=0
	r9:=0
	//For ($i;1;Size of array(aXferType))
	//If (ainteger{$i}=[JobMakesItem]ItemNumber)
	//If (aLoc{$i}="fg:@")
	//Case of 
	//: (aVia{$i}="cc:@")
	//r6:=r6+aXferQty{$i}
	//: (aVia{$i}="ex:@")
	//r6:=r6+aXferQty{$i}
	//: (aVia{$i}="xc:@")
	//r6:=r6+aXferQty{$i}
	//End case 
	//End if 
	
	//If (aLoc{$i}="sc:@")
	//Case of 
	//: (aVia{$i}="ex:@")
	//r8:=r8+aXferQty{$i}
	//End case 
	//End if 
	//End if 
	//End for 
	
	If ([Job_Forms_Items:44]Qty_Want:24#0)
		If ([Job_Forms_Items:44]Qty_Good:10#0)
			r7:=Round:C94((([Job_Forms_Items:44]Qty_Good:10-[Job_Forms_Items:44]Qty_Want:24)/[Job_Forms_Items:44]Qty_Want:24)*100; 1)
		Else 
			r7:=Round:C94((([Job_Forms_Items:44]Qty_Actual:11-[Job_Forms_Items:44]Qty_Want:24)/[Job_Forms_Items:44]Qty_Want:24)*100; 1)
		End if 
	End if 
	
	r8:=[Job_Forms_Items:44]Qty_Actual:11-[Job_Forms_Items:44]Qty_Good:10
	
	If ([Job_Forms_Items:44]Qty_Actual:11#0)
		r9:=Round:C94((r8/[Job_Forms_Items:44]Qty_Actual:11)*100; 1)
	Else 
		r9:=0
	End if 
End if 
//