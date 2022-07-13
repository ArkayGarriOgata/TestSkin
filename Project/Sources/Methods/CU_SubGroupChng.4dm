//%attributes = {"publishedWeb":true}
//(p) x_SubGroupChng
//$1 New value
//$2 - string - either a commcode or an '*' = suppress deletion
//• 8/22/97 cs added second parameter - suppress deletion of RM_Group record
//  this is used when called from MoveRM
//• cs 9/11/97 stop RM group records for Est from being deleted
//• 3/18/98 cs found that I had missed com code in Rm_xfers
//• 6/10/98 cs modified so that move can assign to NEW commodity also
//• 6/11/98 cs removed reference to Machine & Material Item table

C_TEXT:C284($2; $CommKey)
C_POINTER:C301($Field1; $Field2; $File; $Field3)
C_LONGINT:C283($i; $FieldCnt; $CommCode)

Case of 
	: (Count parameters:C259=1)
		$CommCode:=iComm
	: ($2="*")
		$CommCode:=iComm
	Else 
		$CommCode:=Num:C11($2)
End case 
$CommKey:=String:C10($CommCode; "00")+"-"+$1

For ($i; 1; 8)
	Case of 
		: ($i=1)
			$File:=->[Raw_Materials:21]
			$Field1:=->[Raw_Materials:21]Commodity_Key:2
			$Field2:=->[Raw_Materials:21]SubGroup:31
			$Field3:=->[Raw_Materials:21]CommodityCode:26
			$FieldCnt:=3
		: ($i=2)
			$File:=->[Raw_Materials_Locations:25]
			$Field1:=->[Raw_Materials_Locations:25]Commodity_Key:12
			$FieldCnt:=1
		: ($i=3)
			$File:=->[Raw_Materials_Groups:22]
			$Field1:=->[Raw_Materials_Groups:22]Commodity_Key:3
			$Field2:=->[Raw_Materials_Groups:22]SubGroup:10
			$Field3:=->[Raw_Materials_Groups:22]Commodity_Code:1
			$FieldCnt:=3
		: ($i=4)
			$File:=->[Purchase_Orders_Items:12]
			$Field1:=->[Purchase_Orders_Items:12]Commodity_Key:26
			$Field2:=->[Purchase_Orders_Items:12]SubGroup:13
			$Field3:=->[Purchase_Orders_Items:12]CommodityCode:16
			$FieldCnt:=3
		: ($i=5)
			$File:=->[Job_Forms_Materials:55]
			$Field1:=->[Job_Forms_Materials:55]Commodity_Key:12
			$FieldCnt:=1
		: ($i=6)
			$File:=->[Process_Specs_Materials:56]
			$Field1:=->[Process_Specs_Materials:56]Commodity_Key:8
			$FieldCnt:=1
		: ($i=7)
			$File:=->[Estimates_Materials:29]
			$Field1:=->[Estimates_Materials:29]Commodity_Key:6
			$FieldCnt:=1
		: ($i=8)
			$File:=->[Raw_Materials_Transactions:23]
			$Field1:=->[Raw_Materials_Transactions:23]Commodity_Key:22
			$field2:=<>Nil_Ptr
			$Field3:=->[Raw_Materials_Transactions:23]CommodityCode:24  //• 3/18/98 cs missed this one
			$FieldCnt:=3
	End case 
	
	USE SET:C118(Table name:C256($File))
	
	Repeat 
		MESSAGE:C88("  Posting in File "+Table name:C256(Table:C252($File))+Char:C90(13))
		
		Case of 
			: ($FieldCnt=1)
				APPLY TO SELECTION:C70($File->; $Field1->:=$CommKey)
			: ($FieldCnt=2)
				APPLY TO SELECTION:C70($File->; CU_Change2($Field1; $Field2; $CommKey; $1))
			: ($FieldCnt=3) & (Count parameters:C259=2)  //this is for Subgoup move
				APPLY TO SELECTION:C70($File->; CU_Change2($Field1; $Field2; $CommKey; $1; $Field3; $CommCode))
			: ($FieldCnt=3)  //this is for RM move
				APPLY TO SELECTION:C70($File->; CU_Change2($Field1; $Field2; $CommKey; $1))
			: ($FieldCnt=0)
				Case of 
					: (Count parameters:C259=1)  //• 8/22/97 cs modification for use by Move RM
						util_DeleteSelection($File)
					: ($2#"*")
						util_DeleteSelection($File)
				End case 
		End case 
	Until (uChkLockedSet($File))
	CLEAR SET:C117(Table name:C256($File))
	uClearSelection($File)
End for 