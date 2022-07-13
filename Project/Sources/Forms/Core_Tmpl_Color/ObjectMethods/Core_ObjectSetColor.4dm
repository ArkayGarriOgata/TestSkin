//Uncomment the color combination you would like to test

C_POINTER:C301($ptColor)
C_LONGINT:C283($nBackground; $nForeground; $nColor)

//$nBackground:=White  
//$nBackground:=Yellow 
//$nBackground:=Orange     
//$nBackground:=Red       
//$nBackground:=Purple     
//$nBackground:=Dark Blue 
//$nBackground:=Blue        
//$nBackground:=Light Blue   
//$nBackground:=Green      
//$nBackground:=Dark Green   
//$nBackground:=Dark Brown   
//$nBackground:=Dark Grey   
//$nBackground:=Light grey
//$nBackground:=Brown      
//$nBackground:=Grey   
//$nBackground:=Black
//$nBackground:=96

//$nForeground:=White  
//$nForeground:=Yellow 
//$nForeground:=Orange  
//$nForeground:=Red 
//$nForeground:=Purple 
//$nForeground:=Dark blue
//$nForeground:=Blue
//$nForeground:=Light blue 
//$nForeground:=Green  
//$nForeground:=Dark green
//$nForeground:=Dark brown
//$nForeground:=Dark grey
//$nForeground:=Light grey
//$nForeground:=Brown
//$nForeground:=Grey
//$nForeground:=Black

$nColor:=-($nForeground+(256*$nBackground))

$ptColor:=OBJECT Get pointer:C1124(Object named:K67:5; "Core_Tmpl_tColor")

$ptColor->:=String:C10($nColor)

//Core_ObjectSetColor ($ptColor;-(Orange+(256*209)))

OBJECT SET RGB COLORS:C628($ptColor->; 16711680; 16769023)

//Core_ObjectSetColor ($ptColor;$nColor)
