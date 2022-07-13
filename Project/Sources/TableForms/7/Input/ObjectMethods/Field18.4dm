//(S) [VENDOR]Std_Terms
//5/4/95 phone conversation
[Vendors:7]ModFlag:21:=True:C214
Case of   //5/4/95  v
	: (Self:C308->="1/3@") | (Self:C308->="On Rec@")
		[Vendors:7]Std_Discount:14:=0
		[Vendors:7]Within:29:=0
		[Vendors:7]NetDue:30:=0
	: (Position:C15("net"; Self:C308->)>0)  //selected item contains the word net (ie 1% 10 - net 45)
		$Prev:=1
		$Pos:=Position:C15("%"; Self:C308->)
		
		If ($Pos>0)
			[Vendors:7]Std_Discount:14:=Num:C11(Substring:C12(Self:C308->; $Prev; $Pos-1))
		Else 
			[Vendors:7]Std_Discount:14:=0
		End if 
		$Prev:=$Pos+1
		$Pos:=Position:C15("-"; Self:C308->)
		
		If ($Pos>0)
			[Vendors:7]Within:29:=Num:C11(Substring:C12(Self:C308->; $Prev; ($Pos-$Prev)))
		Else 
			[Vendors:7]Within:29:=0
		End if 
		$Pos:=Position:C15("Net"; Self:C308->)
		
		If ($Pos>0)
			[Vendors:7]NetDue:30:=Num:C11(Substring:C12(Self:C308->; $Pos+3; Length:C16(Self:C308->)))
		Else 
			[Vendors:7]NetDue:30:=0
		End if 
	Else   //no 'net' & not undesiferable
		$Prev:=1
		$Pos:=Position:C15("%"; Self:C308->)
		
		If ($Pos>0)
			[Vendors:7]Std_Discount:14:=Num:C11(Substring:C12(Self:C308->; $Prev; $Pos-1))
		Else 
			[Vendors:7]Std_Discount:14:=0
		End if 
		$Prev:=$Pos+1
		$Pos:=Position:C15("-"; Self:C308->)
		
		If ($Pos>0)
			[Vendors:7]Within:29:=Num:C11(Substring:C12(Self:C308->; $Prev; ($Pos-$Prev)))
		Else 
			[Vendors:7]Within:29:=Num:C11(Substring:C12(Self:C308->; $Prev))
		End if 
		[Vendors:7]NetDue:30:=45
End case   //5/4/95 ^
//eos