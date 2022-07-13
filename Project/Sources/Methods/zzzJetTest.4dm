//%attributes = {}


//C_LONGINT($vlPict;$vPictCount;$vPictRef;$vTotal)
//C_LONGINT($isObs)
//C_TEXT($vPictName)
//C_POINTER($vPointer)
//C_PICTURE($vpPict)
//ARRAY TEXT($arrPictNames;0)
//ARRAY LONGINT($arrPictRefs;0)

//$vTotal:=0
//PICTURE LIBRARY LIST($arrPictRefs;$arrPictNames)
//$vPictCount:=Size of array($arrPictRefs)
//If ($vPictCount>0)
//For ($vlPict;1;$vPictCount)  // for each picture
//$vPictRef:=$arrPictRefs{$vlPict}
//$vPictName:=$arrPictNames{$vlPict}
//GET PICTURE FROM LIBRARY($arrPictRefs{$vlPict};$vpPict)
//$vPointer:=->$vpPict  // pass a pointer
//$isObs:=AP Is Picture Deprecated ($vPointer)
//If ($isObs=1)  // if format is obsolete
//CONVERT PICTURE($vPointer->;".PNG")  // conversion to png
//  // and saving in library
//SET PICTURE TO LIBRARY($vPointer->;$vPictRef;$vPictName)
//$vTotal:=$vTotal+1
//End if 
//End for 
//ALERT(String($vTotal)+" picture(s) out of "+String($vPictCount)+" were converted to png.")
//Else 
//ALERT("The picture library is empty.")
//End if 
