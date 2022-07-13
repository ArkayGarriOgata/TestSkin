//%attributes = {"publishedWeb":true}
//PM: util_findColor(textDesc) -> color text
//@author mlb - 7/6/01  11:45
//try to parse a color and adjective from a text desc
C_TEXT:C284($0)
C_TEXT:C284($desc; $1; knownColors; knownAdjectives)
$desc:=$1
$desc:=Replace string:C233($desc; "."; " ")
$desc:=Replace string:C233($desc; "("; " ")
$desc:=Replace string:C233($desc; ")"; " ")

If (Length:C16(knownColors)=0)
	knownColors:=" red green blue yellow brown black white pearl silver gold cyan MAGENTA"
	knownColors:=knownColors+" gray grey pink BRONZE tan orange varnish vanilla"
	knownColors:=knownColors+" MAROON BEIGE purple ivory CHAMPAGNE Reflex rust"
	knownColors:=knownColors+" copper pewter coating teal violet peach fushia LAVENDER"
	knownColors:=knownColors+" coral mauve amber OCHRE raisin buff cream wine Khaki bone"
	knownColors:=knownColors+" grn org brn blk wht gry yel varn burg gol purp"
	
	ARRAY TEXT:C222(aKnownAbrevs; 11)
	ARRAY TEXT:C222(aKnownAbrevsColor; 11)
	aKnownAbrevs{1}:="grn"
	aKnownAbrevsColor{1}:="green"
	aKnownAbrevs{2}:="org"
	aKnownAbrevsColor{2}:="orange"
	aKnownAbrevs{3}:="brn"
	aKnownAbrevsColor{3}:="brown"
	aKnownAbrevs{4}:="blk"
	aKnownAbrevsColor{4}:="black"
	aKnownAbrevs{5}:="wht"
	aKnownAbrevsColor{5}:="white"
	aKnownAbrevs{6}:="gry"
	aKnownAbrevsColor{6}:="gray"
	aKnownAbrevs{7}:="yel"
	aKnownAbrevsColor{7}:="yellow"
	aKnownAbrevs{8}:="varn"
	aKnownAbrevsColor{8}:="varnish"
	aKnownAbrevs{9}:="burg"
	aKnownAbrevsColor{9}:="burgondy"
	aKnownAbrevs{10}:="purp"
	aKnownAbrevsColor{10}:="purple"
	aKnownAbrevs{11}:="gol"
	aKnownAbrevsColor{11}:="gold"
	
	knownAdjectives:=" lt pale uv tint sparkle dk satin matte warm med aq cool "
End if 

C_TEXT:C284($0; $color; $adjective)
$color:=""
$adjective:=""

$result:=util_TextParser(5; $desc; 32; 13)
For ($i; 1; Size of array:C274(aParseArray))
	$find:=" "+aParseArray{$i}+" "
	If (Position:C15($find; knownAdjectives)>0)
		If (Length:C16($adjective)>0)
			$adjective:=$adjective+" "
		End if 
		$adjective:=$adjective+Uppercase:C13(aParseArray{$i})
		
	Else 
		If (Position:C15($find; knownColors)>0)
			If (Length:C16($color)>0)
				$color:=$color+" "
			End if 
			$find:=aParseArray{$i}
			$hit:=Find in array:C230(aKnownAbrevs; $find)
			If ($hit>-1)
				$find:=aKnownAbrevsColor{$hit}
			End if 
			$color:=$color+Uppercase:C13($find)
		End if 
	End if 
	
End for 

$result:=util_TextParser

If (Length:C16($adjective)>0)
	$color:=Substring:C12(($adjective+" "+$color); 1; 20)
End if 

$0:=Substring:C12($color; 1; 20)
//