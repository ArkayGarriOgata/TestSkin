//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/23/10, 10:56:15
// ----------------------------------------------------
// Method: x_find_missing_projects
// Description
// 
//
// Parameters
// ----------------------------------------------------
ALL RECORDS:C47([Customers_Projects:9])
SELECTION TO ARRAY:C260([Customers_Projects:9]id:1; $aPjts)
ARRAY TEXT:C222(aMissingPjts; 0)

ALL RECORDS:C47([Finished_Goods:26])

QUERY BY FORMULA:C48([Finished_Goods:26]; Length:C16([Finished_Goods:26]ProjectNumber:82)=5)
C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
$numRecs:=Records in selection:C76([Finished_Goods:26])

uThermoInit($numRecs; "testing F/G")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If (Length:C16([Finished_Goods:26]ProjectNumber:82)=5)
			$hit:=Find in array:C230($aPjts; [Finished_Goods:26]ProjectNumber:82)
			If ($hit=-1)
				$hit:=Find in array:C230(aMissingPjts; [Finished_Goods:26]ProjectNumber:82)
				If ($hit=-1)
					APPEND TO ARRAY:C911(aMissingPjts; [Finished_Goods:26]ProjectNumber:82)
				End if 
			End if 
		End if 
		
		NEXT RECORD:C51([Finished_Goods:26])
		uThermoUpdate($i)
	End for 
	
Else 
	
	ARRAY TEXT:C222($_ProjectNumber; 0)
	SELECTION TO ARRAY:C260([Finished_Goods:26]ProjectNumber:82; $_ProjectNumber)
	
	For ($i; 1; $numRecs; 1)
		
		If (Length:C16($_ProjectNumber{$i})=5)
			$hit:=Find in array:C230($aPjts; $_ProjectNumber{$i})
			If ($hit=-1)
				$hit:=Find in array:C230(aMissingPjts; $_ProjectNumber{$i})
				If ($hit=-1)
					APPEND TO ARRAY:C911(aMissingPjts; $_ProjectNumber{$i})
				End if 
			End if 
		End if 
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

uThermoClose
//
If (Size of array:C274(aMissingPjts)>0)
	util_array_save(->aMissingPjts)
	ARRAY TEXT:C222(aMissingPjts; 0)
End if 


ALL RECORDS:C47([Finished_Goods_SizeAndStyles:132])
$numRecs:=Records in selection:C76([Finished_Goods_SizeAndStyles:132])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	uThermoInit($numRecs; "testing S&S")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If (Length:C16([Finished_Goods_SizeAndStyles:132]ProjectNumber:2)=5)
			$hit:=Find in array:C230($aPjts; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2)
			If ($hit=-1)
				$hit:=Find in array:C230(aMissingPjts; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2)
				If ($hit=-1)
					APPEND TO ARRAY:C911(aMissingPjts; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2)
				End if 
			End if 
		End if 
		
		NEXT RECORD:C51([Finished_Goods_SizeAndStyles:132])
		uThermoUpdate($i)
	End for 
	
Else 
	
	uThermoInit($numRecs; "testing S&S")
	
	ARRAY TEXT:C222($_ProjectNumber; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_SizeAndStyles:132]ProjectNumber:2; $_ProjectNumber)
	
	For ($i; 1; $numRecs; 1)
		
		If (Length:C16($_ProjectNumber{$i})=5)
			$hit:=Find in array:C230($aPjts; $_ProjectNumber{$i})
			If ($hit=-1)
				$hit:=Find in array:C230(aMissingPjts; $_ProjectNumber{$i})
				If ($hit=-1)
					APPEND TO ARRAY:C911(aMissingPjts; $_ProjectNumber{$i})
				End if 
			End if 
		End if 
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

uThermoClose

If (Size of array:C274(aMissingPjts)>0)
	util_array_save(->aMissingPjts)
	ARRAY TEXT:C222(aMissingPjts; 0)
End if 
