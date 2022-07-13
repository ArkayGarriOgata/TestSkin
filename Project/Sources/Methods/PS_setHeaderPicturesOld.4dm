//%attributes = {}
//PM: PS_setHeaderPictures() -> 
//@author mlb - 8/15/02  12:25
//see PS_SetReadyColors
// Modified by: Mel Bohince (10/31/17) added 472
// using textEdit type the word with Helvetica Neue Bold 9 point, 
// take screenshot (11pix tall), adjust size to 11 points and rotate left in the png,
// then import into the Pitures Library and ref the ID in a varible below
// Modified by: Mel Bohince (7/2/20) make 497 like a sheeter w/o being a sheeter

// Modified by: Garri Ogata (9/18/20) removed special case for " 421 "

//give the pict resources names
$psBagOK:=932
$psBagRtn:=938
$psGotBag:=931
$psBlankers:=947
$psCounters:=945
$psCyrel:=936
$psDieBoard:=946
$psEmbossDie:=942
$psEmbossFilm:=943
$psEMPTY:=948
$psInk:=937
$psLeaf:=944
$psLocked:=950
$psPlates:=935
$psPrinted:=939
$psScreen:=951
$psSheeted:=934
$psStampDie:=940
$psStampFilm:=941
$psStock:=933
$psWIP:=949
$psMaterial:=953
$psFemale:=952
$psInHouse:=2064
$psReq:=2073
$psPO:=2074
$psTooling:=2075
$psStandards:=2076
$psDieFile:=17113
$psLatisealed:=954
$psWindows:=955
$psAdhesive:=956
$psLaminate:=957
$psDylux:=980
$psPreSheet:=26856
$psNormPDF:=26855

//set up the pictures to display
Case of 
	: (sCriterion1="All")
		$picture1:=$psGotBag
		$picture2:=$psBagOK
		$picture3:=$psStock
		$picture4:=$psSheeted
		$picture5:=$psPlates
		$picture6:=$psCyrel
		$picture7:=$psInk
		$picture8:=$psPreSheet
		
	: (sCriterion1="D/C")
		$picture1:=$psBagOK
		$picture2:=$psSheeted
		$picture3:=$psPrinted
		$picture4:=$psCounters
		$picture5:=$psDieBoard
		$picture6:=$psBlankers
		$picture7:=$psLocked
		$picture8:=$psEMPTY
		
	: (Position:C15(sCriterion1; " screen press ")>0)
		$picture1:=$psBagRtn  //bag
		$picture2:=$psWIP
		$picture3:=$psScreen
		$picture4:=$psInk
		$picture5:=$psEMPTY
		$picture6:=$psEMPTY
		$picture7:=$psEMPTY
		$picture8:=$psEMPTY
		
	: (Position:C15(sCriterion1; <>PRESSES)>0)
		$picture1:=$psGotBag
		$picture2:=$psBagOK
		$picture3:=$psStock
		$picture4:=$psSheeted
		$picture5:=$psPlates
		$picture6:=$psCyrel
		$picture7:=$psInk
		$picture8:=$psPreSheet
		
	: (Position:C15(sCriterion1; <>SHEETERS)>0) | (sCriterion1="497")
		//If (sCriterion1="428")
		$picture1:=$psGotBag
		$picture2:=$psBagOK
		$picture3:=$psStock
		$picture4:=$psSheeted
		$picture5:=$psEMPTY
		$picture6:=$psEMPTY
		$picture7:=$psEMPTY
		$picture8:=$psEMPTY
		
		//Else 
		//$picture1:=$psGotBag
		//$picture2:=$psBagOK
		//$picture3:=$psStock
		//$picture4:=$psSheeted
		//$picture5:=$psBagRtn
		//$picture6:=$psEMPTY
		//$picture7:=$psEMPTY
		//$picture8:=$psEMPTY
		//End if 
		
	: (Position:C15(sCriterion1; <>STAMPERS)>0)
		$picture1:=$psBagOK
		$picture2:=$psPrinted
		$picture3:=$psEmbossDie
		$picture4:=$psEmbossFilm
		$picture5:=$psStampDie
		$picture6:=$psStampFilm
		$picture7:=$psLeaf
		$picture8:=$psDylux
		
	: (Position:C15(sCriterion1; <>BLANKERS)>0)  // Modified by: Mark Zinke (8/6/13) Added 466` Modified by: Mel Bohince (12/5/13) add 470 to replace 466 and 477
		$picture1:=$psBagOK
		$picture2:=$psSheeted
		$picture3:=$psPrinted
		$picture4:=$psCounters
		$picture5:=$psDieBoard
		$picture6:=$psBlankers
		$picture7:=$psLocked
		$picture8:=$psDylux
		
	: (sCriterion1="453")
		$picture1:=$psBagRtn
		$picture2:=$psWIP
		$picture3:=$psStampDie  //$psEmbossDie
		$picture4:=$psEmbossDie  //$psEmbossFilm
		$picture5:=$psLeaf  //$psStampDie
		$picture6:=$psStampFilm  //$psDieFile  `$psStampFilm
		$picture7:=$psLocked  //$psLeaf
		$picture8:=$psEMPTY
		
	: (sCriterion1="462")
		$picture1:=$psBagRtn
		$picture2:=$psWIP
		$picture3:=$psCounters
		$picture4:=$psDieBoard
		$picture5:=$psBlankers
		$picture6:=$psFemale
		$picture7:=$psLocked
		$picture8:=$psEMPTY
		
	: (sCriterion1="461")
		$picture1:=$psBagRtn
		$picture2:=$psWIP
		$picture3:=$psEmbossDie
		$picture4:=$psEmbossFilm
		$picture5:=$psCounters
		$picture6:=$psDieBoard
		$picture7:=$psLocked
		$picture8:=$psEMPTY
		
	: (Position:C15(sCriterion1; <>COATERS)>0)
		$picture1:=$psBagRtn
		$picture2:=$psWIP
		$picture3:=$psPrinted
		$picture4:=$psLocked
		$picture5:=$psEMPTY
		$picture6:=$psEMPTY
		$picture7:=$psEMPTY
		$picture8:=$psEMPTY
		
	: (Position:C15(sCriterion1; <>LAMINATERS)>0)
		$picture1:=$psBagOK
		$picture2:=$psPrinted
		$picture3:=$psLatisealed
		$picture4:=$psWindows
		$picture5:=$psAdhesive
		$picture6:=$psLaminate
		$picture7:=$psEMPTY
		$picture8:=$psEMPTY
		
	: (sCriterion1="472")  // Modified by: Mel Bohince (10/31/17) added
		$picture1:=$psBagOK
		$picture2:=$psPrinted
		$picture3:=$psBlankers
		$picture4:=$psReq
		$picture5:=$psMaterial
		$picture6:=$psEMPTY
		$picture7:=$psEMPTY
		$picture8:=$psEMPTY
		
	: (sCriterion1="9@")
		$picture1:=$psInHouse
		$picture2:=$psReq
		$picture3:=$psPO
		$picture4:=$psTooling
		$picture5:=$psStandards
		$picture6:=$psStock
		$picture7:=$psWIP
		$picture8:=$psEMPTY
		
	Else 
		$picture1:=$psEMPTY
		$picture2:=$psEMPTY
		$picture3:=$psEMPTY
		$picture4:=$psEMPTY
		$picture5:=$psEMPTY
		$picture6:=$psEMPTY
		$picture7:=$psEMPTY
		$picture8:=$psEMPTY
End case 


GET PICTURE FROM LIBRARY:C565($picture1; pict1)
GET PICTURE FROM LIBRARY:C565($picture2; pict2)
GET PICTURE FROM LIBRARY:C565($picture3; pict3)
GET PICTURE FROM LIBRARY:C565($picture4; pict4)
GET PICTURE FROM LIBRARY:C565($picture5; pict5)
GET PICTURE FROM LIBRARY:C565($picture6; pict6)
GET PICTURE FROM LIBRARY:C565($picture7; pict7)
GET PICTURE FROM LIBRARY:C565($picture8; pict8)