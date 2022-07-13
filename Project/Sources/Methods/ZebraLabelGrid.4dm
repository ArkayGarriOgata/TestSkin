//%attributes = {"publishedWeb":true}
//PM: ZebraLabelGrid() -> 
//@author mlb - 11/16/01  14:58
//mlb 11/15/05 allow an optional "tweek" in points to x,y
//  http://labelary.com/viewer.html

C_TEXT:C284($1; $0)
C_LONGINT:C283($i; $cellSize; $x; $2; $y; $3; $gridX; $gridY; $4; $5; $tweekX; $tweekY)  //25= 1/8"  13= 1/16"   1=.005"

Case of 
	: ($1="init")
		
		Case of 
			: (Count parameters:C259=3)  // 1/16 grid on 300dpi
				$gridX:=4*$2  //64
				$gridY:=14*$2  //224
				$cellSize:=Round:C94(1200/$gridX; 0)  //dots 1200 dots is appx 4"
				
			: (Count parameters:C259=2)  // 1/16 grid on 203dpi
				$gridX:=4*$2  //64
				$gridY:=14*$2  //224
				$cellSize:=Round:C94(812/$gridX; 0)  //dots 812 dots is appx 4"
				
			Else   //default  1/8 grid on 203dpi
				$cellSize:=25  //dots
				$gridX:=4*8
				$gridY:=6*8
		End case 
		
		If (Count parameters:C259=2)  //specified 1/16 grid
			
			
		End if 
		
		ARRAY LONGINT:C221(aX; 0)
		ARRAY LONGINT:C221(aX; $gridX)
		ARRAY LONGINT:C221(aY; 0)
		ARRAY LONGINT:C221(aY; $gridY)
		
		For ($i; 1; Size of array:C274(aX))
			aX{$i}:=$i*$cellSize
		End for 
		
		For ($i; 1; Size of array:C274(aY))
			aY{$i}:=$i*$cellSize
		End for 
		
		$0:=String:C10(Size of array:C274(aX))+","+String:C10(Size of array:C274(aY))
		
	: ($1="at")
		$x:=$2
		$y:=$3
		If (Count parameters:C259=5)
			$tweekX:=$4
			$tweekY:=$5
		Else 
			$tweekX:=0
			$tweekY:=0
		End if 
		$0:="^FO"+String:C10(aX{$x}+$tweekX)+","+String:C10(aY{$y}+$tweekY)
End case 