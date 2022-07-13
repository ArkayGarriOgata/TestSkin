//%attributes = {"publishedWeb":true}
//(p) x_LocateOrphans
//$1 - pointer - to file to locat in
//$2 - pointer - field to locat on
//$3 - pointer -field to locate from
//$4 - boolean - reort of dialog (true = dialog)
//this routine locates distinct values of com keys
//which DO NOT exist in the passsed table
//• 6/10/98 cs created

C_POINTER:C301($1; $2; $3; $file; $Field)
ARRAY TEXT:C222($aCommKey; 0)

$File:=$1
$Field:=$2
READ WRITE:C146($File->)
uRelateSelect($Field; $3)
CREATE SET:C116($File->; "OK")
ALL RECORDS:C47($File->)
CREATE SET:C116($File->; "All")
DIFFERENCE:C122("All"; "OK"; "All")
USE SET:C118("all")
DISTINCT VALUES:C339($Field->; $aCommKey)
$insert:=Size of array:C274($aCommKey)
xText:=""

If ($4)  //fix them
	If (Size of array:C274($aCommKey)>0)
		xTitle:="Orphaned Commkeys for "+Table name:C256($File)
		ARRAY TEXT:C222(aText; Size of array:C274($aCommKey))
		ARRAY TEXT:C222(aBullet; 0)
		ARRAY TEXT:C222(aBullet; Size of array:C274(aText))
		
		For ($i; 1; Size of array:C274($aCommKey))
			aText{$i}:=$aCommKey{$i}
		End for 
		ARRAY TEXT:C222($aCommKey; 0)
		
		Repeat 
			uDialog("FixComKeyOrph"; 200; 265; 4; "Fix Disconnected ComKeys")
			
			If (OK=1)
				$Loc:=0
				Repeat 
					$Loc:=Find in array:C230(abullet; "√"; $loc)
					
					If ($Loc>0)
						QUERY:C277($File->; $Field->=aText{$loc})
						
						Repeat 
							APPLY TO SELECTION:C70($File->; $Field->:=String:C10(i4; "00")+"-"+tSubgroup)
						Until (uChkLockedSet($File))
						DELETE FROM ARRAY:C228(aBullet; $Loc; 1)
						DELETE FROM ARRAY:C228(aText; $Loc; 1)
					End if   //$Loc>0
					OK:=1  //insure that ths loop does not reset OK
				Until ($Loc<0)  //all selected items updated
			End if 
		Until (OK=0)  //User canceled dialog
	Else 
		ALERT:C41("Table "+Table name:C256($File)+" has no orphaned Commmkeys")
	End if 
	CONFIRM:C162("Repair another table?"; "Repair"; "Cancel")
	$0:=(ok=1)
	ARRAY TEXT:C222(aText; 0)
Else   //report them  
	xTitle:="Records who's "+Field name:C257($Field)+" does not exist"
	
	For ($i; 1; $Insert)
		ChkxText2Print($aCommKey{$i}+Char:C90(13); Table name:C256($File)+"- No "+Substring:C12(Field name:C257($Field); 1; 5)+String:C10($i))
	End for 
	
	If (xtext#"")
		rPrintText(Table name:C256($File)+" - No "+Substring:C12(Field name:C257($Field); 1; 5)+String:C10($insert+1))
	End if 
	$0:=True:C214
End if 
CLEAR SET:C117("All")
CLEAR SET:C117("OK")