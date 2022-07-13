//%attributes = {"publishedWeb":true}
//PM: PS_setHeaderPictures() -> 
//@author mlb - 8/15/02  12:25
//see PS_SetReadyColors
// Modified by: Mel Bohince (10/31/17) added 472
// using textEdit type the word with Helvetica Neue Bold 9 point, 
// take screenshot (11pix tall), adjust size to 11 points and rotate left in the png,
// then import into the Pitures Library and ref the ID in a varible below
// Modified by: Mel Bohince (7/2/20) make 497 like a sheeter w/o being a sheeter

// Modified by: Garri Ogata (9/18/20) removed special case for " 421 "
// Modified by: Mel Bohince (8/31/21) remove dependence on Picture library by changing the rez id to a folder path
//    pict1 thru pict8 are picture varibles on the production schedule which
//    need to change based on the schedule context being viewed, hence the case stmt below


C_PICTURE:C286(pict1; pict2; pict3; pict4; pict5; pict6; pict7; pict8)
C_TEXT:C284($picture1; $picture2; $picture3; $picture4; $picture5; $picture6; $picture7; $picture8)

//give the pict resources names
// Modified by: Mel Bohince (8/31/21) 
$psBagOK:="psBagOk.png"  //932
$psBagRtn:="psBagRtn.png"  //938
$psGotBag:="psGotBag.png"  //931
$psBlankers:="psBlankers.png"  //947
$psCounters:="psCounters.png"  //945
$psCyrel:="psCyrel.png"  //936
$psDieBoard:="psDieBoard.png"  //946
$psEmbossDie:="psEmbossDie.png"  //942
$psEmbossFilm:="psEmbossFilm.png"  //943
$psEMPTY:="psEMPTY.png"  //948
$psInk:="psInk.png"  //937
$psLeaf:="psLeaf.png"  //944
$psLocked:="psLocked.png"  //950
$psPlates:="psPlates.png"  //935
$psPrinted:="psPrinted.png"  //939
$psScreen:="psScreen.png"  //951
$psSheeted:="psSheeted.png"  //934
$psStampDie:="psStampDie.png"  //940
$psStampFilm:="psStampFilm.png"  //941
$psStock:="psStock.png"  //933
$psWIP:="psWIP.png"  //949
$psMaterial:="psMaterial.png"  //953
$psFemale:="psFemale.png"  //952
$psInHouse:="psINHOUSE.png"  //2064
$psReq:="psReq.png"  //2073
$psPO:="psPO.png"  //2074
$psTooling:="psTooling.png"  //2075
$psStandards:="psStandards.png"  //2076
$psDieFile:="psDieFile.png"  //17113
$psLatisealed:="psLatisealed.png"  //954
$psWindows:="psWindows.png"  //955
$psAdhesive:="psAdhesive.png"  //956
$psLaminate:="psLaminate.png"  //957
$psDylux:="psDylux.png"  //980
$psPreSheet:="psPreSheeted.png"  //26856
$psNormPDF:="psNormPDF.png"  //26855

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

C_TEXT:C284($pathToResource)  // Modified by: Mel Bohince (8/31/21) 
$pathToResource:=Get 4D folder:C485(Current resources folder:K5:16)+"prodSched"+Folder separator:K24:12

READ PICTURE FILE:C678($pathToResource+$picture1; pict1)
READ PICTURE FILE:C678($pathToResource+$picture2; pict2)
READ PICTURE FILE:C678($pathToResource+$picture3; pict3)
READ PICTURE FILE:C678($pathToResource+$picture4; pict4)
READ PICTURE FILE:C678($pathToResource+$picture5; pict5)
READ PICTURE FILE:C678($pathToResource+$picture6; pict6)
READ PICTURE FILE:C678($pathToResource+$picture7; pict7)
READ PICTURE FILE:C678($pathToResource+$picture8; pict8)