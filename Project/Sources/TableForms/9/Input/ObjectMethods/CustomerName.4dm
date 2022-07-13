READ ONLY:C145([Customers:16])
ARRAY TEXT:C222(aBrand; 0)
[Customers_Projects:9]Customerid:3:=""

If (Length:C16([Customers_Projects:9]CustomerName:4)=5)  //id entered?
	$numCust:=qryCustomer(->[Customers:16]ID:1; [Customers_Projects:9]CustomerName:4)
	If ($numCust=1)
		[Customers_Projects:9]Customerid:3:=[Customers:16]ID:1
		[Customers_Projects:9]CustomerName:4:=[Customers:16]Name:2
	End if 
End if 

If ([Customers_Projects:9]CustomerName:4#[Customers:16]Name:2)
	$numCust:=qryCustomer(->[Customers:16]Name:2; [Customers_Projects:9]CustomerName:4)
	If ($numCust=0)
		$numCust:=qryCustomer(->[Customers:16]Name:2; ([Customers_Projects:9]CustomerName:4+"@"))
	End if 
End if 

Case of 
	: ($numCust=0)
		BEEP:C151
		ALERT:C41([Customers_Projects:9]CustomerName:4+" is not a registered customer in aMs.")
		[Customers_Projects:9]Customerid:3:="00000"
		
	: ($numCust=1)
		[Customers_Projects:9]Customerid:3:=[Customers:16]ID:1
		[Customers_Projects:9]CustomerName:4:=[Customers:16]Name:2
		uBuildBrandList(->[Customers_Projects:9]CustomerLine:5)
		
	Else 
		$recNo:=fPickList(->[Customers:16]ID:1; ->[Customers:16]Name:2; ->[Customers:16]ParentCorp:19; ([Customers_Projects:9]CustomerName:4+"@"))
		If ($recNo>-1)
			GOTO RECORD:C242([Customers:16]; $recNo)
			[Customers_Projects:9]Customerid:3:=[Customers:16]ID:1
			[Customers_Projects:9]CustomerName:4:=[Customers:16]Name:2
			uBuildBrandList(->[Customers_Projects:9]CustomerLine:5)
		Else 
			[Customers_Projects:9]Customerid:3:=""
			[Customers_Projects:9]CustomerName:4:=""
		End if 
End case 
//