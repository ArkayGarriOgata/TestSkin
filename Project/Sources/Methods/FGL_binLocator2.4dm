//%attributes = {"publishedWeb":true}
//PM: FGL_binLocator2() -> 
//@author Mel - 5/8/03  10:45

//PM: RM_binLocator() -> 
//@author mlb - 4/29/03  16:32

ARRAY TEXT:C222(aShelf1; 14)
For ($i; 1; Size of array:C274(aShelf1))
	aShelf1{$i}:=70*"-"
End for 

ARRAY TEXT:C222(aShelf2; 14)
For ($i; 1; Size of array:C274(aShelf2))
	aShelf2{$i}:=70*"-"
End for 

ARRAY TEXT:C222(aShelf3; 14)
For ($i; 1; Size of array:C274(aShelf3))
	aShelf3{$i}:=70*"-"
End for 

ARRAY TEXT:C222(aShelf4; 14)
For ($i; 1; Size of array:C274(aShelf4))
	aShelf4{$i}:=70*"-"
End for 

ARRAY TEXT:C222(aShelf0; 14)
For ($i; 1; Size of array:C274(aShelf0))
	aShelf0{$i}:=70*"-"
End for 

If (Count parameters:C259=1)
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$1)
End if 

utl_LogIt("init")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
		$row:=0
		$col:=0
		$shelf:=0
		$bin:=Replace string:C233([Finished_Goods_Locations:35]Location:2; "R"; "")
		$bin:=Substring:C12($bin; 4)
		$hyf:=Position:C15("-"; $bin)
		$row:=Num:C11(Substring:C12($bin; 1; $hyf-1))
		$bin:=Substring:C12($bin; $hyf+1)
		$hyf:=Position:C15("-"; $bin)
		$col:=Num:C11(Substring:C12($bin; 1; $hyf-1))
		$shelf:=Num:C11(Substring:C12($bin; $hyf+1))
		Case of 
			: ($shelf=1)
				$shelfPtr:=->aShelf1
			: ($shelf=2)
				$shelfPtr:=->aShelf2
			: ($shelf=3)
				$shelfPtr:=->aShelf3
			: ($shelf=4)
				$shelfPtr:=->aShelf4
			Else 
				$shelfPtr:=->aShelf0
				$row:=1
				$col:=1
		End case 
		
		$currently:=$shelfPtr->{$row}[[$col]]
		
		Case of 
			: ($currently="-")  //m t
				$shelfPtr->{$row}[[$col]]:="1"  //$shelf
				
			Else 
				$shelfPtr->{$row}[[$col]]:=String:C10(Num:C11($shelfPtr->{$row}[[$col]])+1; "0")
		End case 
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	
Else 
	ARRAY TEXT:C222($_Location; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $_Location)
	
	For ($i; 1; Size of array:C274($_Location); 1)
		$row:=0
		$col:=0
		$shelf:=0
		$bin:=Replace string:C233($_Location{$i}; "R"; "")
		$bin:=Substring:C12($bin; 4)
		$hyf:=Position:C15("-"; $bin)
		$row:=Num:C11(Substring:C12($bin; 1; $hyf-1))
		$bin:=Substring:C12($bin; $hyf+1)
		$hyf:=Position:C15("-"; $bin)
		$col:=Num:C11(Substring:C12($bin; 1; $hyf-1))
		$shelf:=Num:C11(Substring:C12($bin; $hyf+1))
		Case of 
			: ($shelf=1)
				$shelfPtr:=->aShelf1
			: ($shelf=2)
				$shelfPtr:=->aShelf2
			: ($shelf=3)
				$shelfPtr:=->aShelf3
			: ($shelf=4)
				$shelfPtr:=->aShelf4
			Else 
				$shelfPtr:=->aShelf0
				$row:=1
				$col:=1
		End case 
		
		$currently:=$shelfPtr->{$row}[[$col]]
		
		Case of 
			: ($currently="-")  //m t
				$shelfPtr->{$row}[[$col]]:="1"  //$shelf
				
			Else 
				$shelfPtr->{$row}[[$col]]:=String:C10(Num:C11($shelfPtr->{$row}[[$col]])+1; "0")
		End case 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

utl_LogIt("the (shelf) is in parens, - means empty or n/a"; 0)
utl_LogIt("(0)      1         2         3         4         5         6         7"; 0)
utl_LogIt("1234567890123456789012345678901234567890123456789012345678901234567890"; 0)
For ($i; 1; Size of array:C274(aShelf0))
	utl_LogIt(aShelf0{$i}+String:C10($i; "00"); 0)
End for 

utl_LogIt("(1)      1         2         3         4         5         6         7"; 0)
utl_LogIt("1234567890123456789012345678901234567890123456789012345678901234567890"; 0)
For ($i; 1; Size of array:C274(aShelf1))
	utl_LogIt(aShelf1{$i}+String:C10($i; "00"); 0)
End for 

utl_LogIt("(2)      1         2         3         4         5         6         7"; 0)
utl_LogIt("1234567890123456789012345678901234567890123456789012345678901234567890"; 0)
For ($i; 1; Size of array:C274(aShelf2))
	utl_LogIt(aShelf2{$i}+String:C10($i; "00"); 0)
End for 

utl_LogIt("(3)      1         2         3         4         5         6         7"; 0)
utl_LogIt("1234567890123456789012345678901234567890123456789012345678901234567890"; 0)
For ($i; 1; Size of array:C274(aShelf3))
	utl_LogIt(aShelf3{$i}+String:C10($i; "00"); 0)
End for 

utl_LogIt("(4)      1         2         3         4         5         6         7"; 0)
utl_LogIt("1234567890123456789012345678901234567890123456789012345678901234567890"; 0)
For ($i; 1; Size of array:C274(aShelf4))
	utl_LogIt(aShelf4{$i}+String:C10($i; "00"); 0)
End for 

utl_LogIt("show")
utl_LogIt("init")