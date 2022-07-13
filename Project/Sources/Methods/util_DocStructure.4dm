//%attributes = {"publishedWeb":true}
//Procedure: zDocStructure(void)  122198  MLB
// (based on LR p317)
//•122198  MLB  use features of ACI_PACK for relationships
Open window:C153(50; 100; 350; 175; -722; "Documenting Structure")
MESSAGE:C88(Char:C90(13)+" "+"Gather information about this structure...")
C_LONGINT:C283($numFiles; $i; $j; $fieldAttrTy; $fieldLength)  //wDocStructure(void)      
C_LONGINT:C283($relatedFile; $relField; $atts)
C_BOOLEAN:C305($isIndexed)
ARRAY TEXT:C222($aTypeList; 30)
ARRAY INTEGER:C220($aTypeLength; 30)
$aTypeList{0}:="Alpha"
$aTypeLength{0}:=0
$aTypeList{1}:="Real"
$aTypeLength{1}:=10
$aTypeList{2}:="Text"
$aTypeLength{2}:=128
$aTypeList{3}:="Picture"
$aTypeLength{3}:=128
$aTypeList{4}:="Date"
$aTypeLength{4}:=6
$aTypeList{6}:="Boolean"
$aTypeLength{6}:=2
$aTypeList{7}:="Subtable"
$aTypeLength{7}:=128
$aTypeList{8}:="Integer"
$aTypeLength{8}:=2
$aTypeList{9}:="Longint"
$aTypeLength{9}:=4
$aTypeList{11}:="Time"
$aTypeLength{11}:=4
$aTypeList{30}:="BLOB"
$aTypeLength{30}:=512

C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284($choices)
$numFiles:=Get last table number:C254
ARRAY TEXT:C222($aFiles; $numFiles)
ARRAY LONGINT:C221($aNumRecs; $numFiles)
ARRAY LONGINT:C221($aRecSize; $numFiles)
ARRAY LONGINT:C221($aNumIndex; $numFiles)
ARRAY LONGINT:C221($aIndexSize; $numFiles)
ARRAY TEXT:C222($aFields; $numFiles; 0)
ARRAY TEXT:C222($aTypes; $numFiles; 0)
ARRAY INTEGER:C220($aLen; $numFiles; 0)
ARRAY BOOLEAN:C223($aIdx; $numFiles; 0)
ARRAY TEXT:C222($aRelation; $numFiles; 0)
ARRAY TEXT:C222($aFieldAttri; $numFiles; 0)

//utl_Trace

For ($i; 1; $numFiles)
	If (Is table number valid:C999($i))
		GOTO XY:C161(2; 2)
		MESSAGE:C88("Table "+String:C10($i; "^^^")+" of "+String:C10($numFiles; "^^^"))
		$aFiles{$i}:=Table name:C256($i)
		$aNumRecs{$i}:=Records in table:C83(Table:C252($i)->)
		$aNumIndex{$i}:=0
		$numFields:=Get last field number:C255($i)
		ARRAY TEXT:C222($aFields{$i}; $numFields)
		ARRAY TEXT:C222($aTypes{$i}; $numFields)
		ARRAY INTEGER:C220($aLen{$i}; $numFields)
		ARRAY BOOLEAN:C223($aIdx{$i}; $numFields)
		ARRAY TEXT:C222($aRelation{$i}; $numFields)
		ARRAY TEXT:C222($aFieldAttri{$i}; $numFields)
		
		For ($j; 1; $numFields)
			$aFields{$i}{$j}:=Field name:C257($i; $j)
			GET FIELD PROPERTIES:C258($i; $j; $fieldAttrTy; $fieldLength; $isIndexed)
			$aTypes{$i}{$j}:=$aTypeList{$fieldAttrTy}  //$TypeList≤$fieldAttrType+1≥
			If ($fieldAttrTy=0)  //alpha
				$aLen{$i}{$j}:=$fieldLength+1
			Else 
				$aLen{$i}{$j}:=$aTypeLength{$fieldAttrTy}
			End if 
			$aIdx{$i}{$j}:=$isIndexed
			$aNumIndex{$i}:=$aNumIndex{$i}+Num:C11($isIndexed)
			//$err:=Ô11999;25Ô ($i;$j;$relatedFile;$relField;$atts;$choices)
			$fieldInfo:=""
			If ($relatedFile#0)
				$aRelation{$i}{$j}:="["+Table name:C256($relatedFile)+"]"+Field name:C257($relatedFile; $relField)
				$fieldInfo:=$fieldInfo+(Num:C11(bitGet($atts; 5)=0)*"auto 1:m, ")
				$fieldInfo:=$fieldInfo+(bitGet($atts; 0)*"assigns relate value, ")
				$fieldInfo:=$fieldInfo+(Num:C11(bitGet($atts; 6)=0)*"auto m:1, ")
			End if 
			
			$fieldInfo:=$fieldInfo+(bitGet($atts; 8)*"invisible, ")
			$fieldInfo:=$fieldInfo+(Num:C11(bitGet($atts; 10)=0)*"non-enterable, ")
			$fieldInfo:=$fieldInfo+(Num:C11(bitGet($atts; 11)=0)*"can't change, ")
			If (bitGet($atts; 12)=1)
				$fieldInfo:=$fieldInfo+$choices+", "
			End if 
			$fieldInfo:=$fieldInfo+(bitGet($atts; 13)*"manditory, ")
			If ($aTypes{$i}{$j}#"*") & ($aTypes{$i}{$j}#"T")  //not a subfile or text
				$fieldInfo:=$fieldInfo+(bitGet($atts; 15)*"indexed, ")
				$fieldInfo:=$fieldInfo+(bitGet($atts; 14)*"unique, ")
				$fieldInfo:=$fieldInfo+("DC1"*bitGet($atts; 1))+" "
				$fieldInfo:=$fieldInfo+("DC2"*bitGet($atts; 2))
			End if 
			$aFieldAttri{$i}{$j}:=$fieldInfo
		End for 
	End if 
End for 

BEEP:C151
MESSAGE:C88(Char:C90(13)+" "+"Writing file info to 'WATSON.XFIL'...")
util_deleteDocument("WATSON.XFIL")
SET CHANNEL:C77(10; "WATSON.XFIL")
//For ($i;17;19)  `populate entities
SEND PACKET:C103("Table_Number"+$t+"Table_Name"+$t+"RecsInTable"+$cr)
For ($i; 1; $numFiles)
	SEND PACKET:C103(String:C10($i; "0000")+$t+$aFiles{$i}+$t+String:C10($aNumRecs{$i})+$cr)
End for 
SET CHANNEL:C77(11)
MESSAGE:C88(Char:C90(13)+" "+"Writing field info to 'WATSON.XFLD'...")
DELETE DOCUMENT:C159("WATSON.XFLD")
SET CHANNEL:C77(10; "WATSON.XFLD")

SEND PACKET:C103("Table_Num"+$t+"Field_Num"+$t+"Table Name"+$t+"Field_Name"+$t+"Type"+$t+"Size"+$t+"Index"+$t+"Related_to"+$t+"Attributes"+$cr)
For ($i; 1; $numFiles)
	$aRecSize{$i}:=22+(4*(Get last field number:C255($i)))  //fixed header and tags
	$aIndexSize{$i}:=0
	For ($j; 1; Get last field number:C255($i))
		SEND PACKET:C103(String:C10($i; "0000")+$t+String:C10($j; "0000")+$t+"["+Table name:C256($i)+"]"+$t+$aFields{$i}{$j}+$t)
		$aRecSize{$i}:=$aRecSize{$i}+$aLen{$i}{$j}
		Case of 
			: ($aTypes{$i}{$j}="A@")
				$aIndexSize{$i}:=$aIndexSize{$i}+(84*Num:C11($aIdx{$i}{$j}))  //avg $aLength=40
			: ($aTypes{$i}{$j}="R@")
				$aIndexSize{$i}:=$aIndexSize{$i}+(36*Num:C11($aIdx{$i}{$j}))
			: ($aTypes{$i}{$j}="D@")
				$aIndexSize{$i}:=$aIndexSize{$i}+(36*Num:C11($aIdx{$i}{$j}))
			: ($aTypes{$i}{$j}="Bo@")
				$aIndexSize{$i}:=$aIndexSize{$i}+(25*Num:C11($aIdx{$i}{$j}))
			: ($aTypes{$i}{$j}="In@")
				$aIndexSize{$i}:=$aIndexSize{$i}+(25*Num:C11($aIdx{$i}{$j}))
			: ($aTypes{$i}{$j}="L@")
				$aIndexSize{$i}:=$aIndexSize{$i}+(36*Num:C11($aIdx{$i}{$j}))
			: ($aTypes{$i}{$j}="Time")
				$aIndexSize{$i}:=$aIndexSize{$i}+(36*Num:C11($aIdx{$i}{$j}))
			: ($aTypes{$i}{$j}="Text")
			: ($aTypes{$i}{$j}="BLOB")
			: ($aTypes{$i}{$j}="S@")
			: ($aTypes{$i}{$j}="P@")
			Else 
				BEEP:C151
		End case 
		SEND PACKET:C103($aTypes{$i}{$j}+$t+String:C10($aLen{$i}{$j})+$t+String:C10(Num:C11($aIdx{$i}{$j}); "indexed; ; ")+$t+$aRelation{$i}{$j}+$t+$aFieldAttri{$i}{$j}+$cr)
	End for 
	$aRecSize{$i}:=$aRecSize{$i}+64  //conservative record increment adjustment
	$aIndexSize{$i}:=$aIndexSize{$i}*512  //conservative index increment adjustment
End for 
SET CHANNEL:C77(11)
//BEEP
ok:=1  //`CONFIRM("Do statistics?")
If (ok=1)
	MESSAGE:C88(Char:C90(13)+" "+"Writing statistical info to 'WATSON.STAT'...")
	DELETE DOCUMENT:C159("WATSON.STAT")
	SET CHANNEL:C77(10; "WATSON.STAT")
	//est  by Bob Keleher, HSC, Toronto, 70451,510 Subject: Index Disk Usage 1/26/92
	SEND PACKET:C103("Wild Ass Guess on Disk Consumption"+$cr+$cr)
	SEND PACKET:C103($t+"Fixed Structures:"+$t+$t+$t+String:C10(18500)+$cr)
	SEND PACKET:C103($t+"File Tables:"+$t+$t+$t+String:C10(16000*$numFiles)+$cr)
	SEND PACKET:C103($t+"Address Tables(per/4096recs):"+$t+$t+$t+String:C10(16000*$numFiles)+$cr)
	SEND PACKET:C103($cr+"Per file usage:"+$cr)
	For ($i; 1; $numFiles)
		SEND PACKET:C103($t+$aFiles{$i}+" index overhead:"+$t+$t+$t+String:C10($aIndexSize{$i})+$cr)
	End for 
	SEND PACKET:C103($cr+"Per record usage:"+$t+$t+$t+$t+$t+"Est#Recs"+$cr)
	For ($i; 1; $numFiles)
		SEND PACKET:C103($t+$aFiles{$i}+" record:"+$t+$t+$t+String:C10($aRecSize{$i})+$cr)
	End for 
	SEND PACKET:C103($cr)
	For ($i; 1; $numFiles)
		SEND PACKET:C103($t+$aFiles{$i}+" index:"+$t+$t+$t+String:C10($aIndexSize{$i})+$cr)
	End for 
	SET CHANNEL:C77(11)
End if   //ok
BEEP:C151
BEEP:C151
CLOSE WINDOW:C154