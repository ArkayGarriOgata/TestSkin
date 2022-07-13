//%attributes = {"publishedWeb":true}
//(P) fFillPage(page size;used pixel count): Fills up page with bl

C_LONGINT:C283($1; $2; $pageSize; $PixelsLeft; $Increment; $0; $3)  //layout size to use, power of 2
C_BOOLEAN:C305($stop)
C_TEXT:C284($Layout)

If (Count parameters:C259>2)  //use new formFeed
	PAGE BREAK:C6(>)
Else   //use old method  
	$pageSize:=$1
	$pixelsLeft:=$pageSize-$2
	While ($pixelsLeft>0)
		Case of 
			: ($pixelsLeft=1)  //Min layout
				Print form:C5([zz_control:1]; "BlankPix1")
				$pixelsLeft:=0
			: ($pixelsLeft>=512)  //Max layout
				Print form:C5([zz_control:1]; "BlankPix512")
				$pixelsLeft:=$pixelsLeft-512
			Else 
				$Increment:=256
				Repeat 
					$stop:=($pixelsLeft\$Increment=1)
					If (Not:C34($stop))
						$Increment:=$Increment/2
					End if 
				Until ($stop)
				$Layout:="BlankPix"+String:C10($Increment)
				Print form:C5([zz_control:1]; $Layout)
				$pixelsLeft:=$pixelsLeft-$Increment
		End case 
	End while 
End if 

$0:=0