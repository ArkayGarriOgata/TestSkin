//%attributes = {}
//PM: PS_SetReadyColors() -> 
//@author mlb - 3/27/02  15:25
//see PS_setHeaderPictures
// SetObjectProperties, Mark Zinke (5/16/13)
// Modified by: Mel Bohince (12/6/13) added 470 removed 476
// Modified by: Mel Bohince (7/2/20) make the 497 behave like 429 w/o being a SHEETER
// Modified by: Garri Ogata (3/17/21) remove lines 162 – 170 left over from when it was going to be a digi press
// Modified by: MelvinBohince (2/15/22) set windower, 472, color to orange
// Modified by: Garri Ogata (3/18/22) changed color to blue (353) and used OBJECT SET RGB COLORS

$jf:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
$jobRef:=Num:C11(JML_cacheInfo("jobRef"; $jf))

SetObjectProperties("alertRect"; -><>NULL; False:C215)
SetObjectProperties("alertRect2"; -><>NULL; False:C215)

$grey:=-(Black:K11:16+(256*Light grey:K11:13))
//$blue:=-(Blue+(256*209))//Not used
$porto:=-(Light blue:K11:8+(256*224))  //Use OBJECT SET RGB COLORS - 40191 : 16769023
//$outside:=-(Purple+(256*224))  //Use OBJECT SET RGB COLORS - 8388736  :  16769023
$blackOnWhite:=-(Black:K11:16+(256*White:K11:1))
$YellowOnRed:=-(Yellow:K11:2+(256*Red:K11:4))
$windower:=-(Orange:K11:3+(256*209))  //Use OBJECT SET RGB COLORS - 16753920  : 12569087

Core_ObjectSetColor("*"; "c@"; $blackOnWhite)
zProdSched_Color_Main:="BlackOnWhite"
zProdSched_ColorNum_Main:=$blackOnWhite
zProdSched_Color_JobInfo:=""
zProdSched_ColorNum_JobInfo:=0

Case of 
		//: (Position("NY";[ProductionSchedules]JobInfo)>0)
		//Core_ObjectSetColor(->[ProductionSchedules]JobInfo;$blue)
		//zProdSched_Color_JobInfo:="Blue"
		//zProdSched_ColorNum_JobInfo:=$blue
		
	: (Position:C15("VA"; [ProductionSchedules:110]JobInfo:58)>0)
		Core_ObjectSetColor(->[ProductionSchedules:110]JobInfo:58; $grey)
		zProdSched_Color_JobInfo:="Grey"
		zProdSched_ColorNum_JobInfo:=$grey
		//: (Position("PR";[ProductionSchedules]JobInfo)>0)
		//Core_ObjectSetColor(->[ProductionSchedules]JobInfo;$porto)
		//zProdSched_Color_JobInfo:="Porto"
		//zProdSched_ColorNum_JobInfo:=$porto
		
	: (Position:C15("483"; [ProductionSchedules:110]JobInfo:58)>0) | (Position:C15("Ang"; [ProductionSchedules:110]JobInfo:58)>0)
		
		OBJECT SET RGB COLORS:C628([ProductionSchedules:110]JobInfo:58; 40191; 16769023)
		
		zProdSched_Color_JobInfo:="Porto"
		zProdSched_ColorNum_JobInfo:=$porto
		
	: (Position:C15("472"; [ProductionSchedules:110]JobInfo:58)>0)  // Modified by: MelvinBohince (2/15/22) set windower, 472, color to orange
		
		OBJECT SET RGB COLORS:C628([ProductionSchedules:110]JobInfo:58; 16753920; 12569087)
		
		zProdSched_Color_JobInfo:="Porto"
		zProdSched_ColorNum_JobInfo:=$windower
		
	: (Position:C15("OS"; [ProductionSchedules:110]JobInfo:58)>0)
		
		OBJECT SET RGB COLORS:C628([ProductionSchedules:110]JobInfo:58; 16711680; 16769023)  // Modified by: MelvinBohince (2/25/22) 
		
		zProdSched_Color_JobInfo:="Porto"
		zProdSched_ColorNum_JobInfo:=$outside
		
	Else 
		Core_ObjectSetColor(->[ProductionSchedules:110]JobInfo:58; $blackOnWhite)
		zProdSched_Color_JobInfo:="BlackOnWhite"
		zProdSched_ColorNum_JobInfo:=$blackOnWhite
End case 

zProdSched_Color_FixedStart:=""
zProdSched_ColorNum_FixedStart:=0
zProdSched_Color_ProcColors:=""
zProdSched_ColorNum_ProcColors:=0

If ([ProductionSchedules:110]FirstRelease:59=!00-00-00!)
	Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $blackOnWhite)
	zProdSched_Color_FixedStart:="BlackOnWhite"
	zProdSched_ColorNum_FixedStart:=$blackOnWhite
	
Else 
	If ([ProductionSchedules:110]FirstRelease:59<=[ProductionSchedules:110]StartDate:4) & ([ProductionSchedules:110]FirstRelease:59#!00-00-00!)
		Core_ObjectSetColor(->[ProductionSchedules:110]ProcessColors:21; $YellowOnRed)
		zProdSched_Color_ProcColors:="YellowOnRed"
		zProdSched_ColorNum_ProcColors:=$YellowOnRed
		SetObjectProperties("alertRect"; -><>NULL; True:C214)
	Else 
		Core_ObjectSetColor(->[ProductionSchedules:110]ProcessColors:21; $blackOnWhite)
		zProdSched_Color_ProcColors:="BlackOnWhite"
		zProdSched_ColorNum_ProcColors:=$blackOnWhite
	End if 
End if 

If ([ProductionSchedules:110]HRD:60=!00-00-00!)
	Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $blackOnWhite)
	zProdSched_Color_FixedStart:="BlackOnWhite"
	zProdSched_ColorNum_FixedStart:=$blackOnWhite
	SetObjectProperties("alertRect2"; -><>NULL; True:C214)
	
Else 
	If ([ProductionSchedules:110]HRD:60<=[ProductionSchedules:110]StartDate:4) & ([ProductionSchedules:110]HRD:60#!00-00-00!)
		Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $YellowOnRed)
		zProdSched_Color_FixedStart:="YellowOnRed"
		zProdSched_ColorNum_FixedStart:=$YellowOnRed
		SetObjectProperties("alertRect"; -><>NULL; True:C214)
	Else 
		Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $blackOnWhite)
		zProdSched_Color_FixedStart:="BlackOnWhite"
		zProdSched_ColorNum_FixedStart:=$blackOnWhite
	End if 
End if 

$green:=-(Green:K11:9+(256*Green:K11:9))
$red:=-(Red:K11:4+(256*Red:K11:4))
$yellow:=-(Yellow:K11:2+(256*Yellow:K11:2))
$black:=-(Black:K11:16+(256*Black:K11:16))

zProdSched_Color_Col_1:=""
zProdSched_ColorNum_Col_1:=0
zProdSched_Color_Col_2:=""
zProdSched_ColorNum_Col_2:=0
zProdSched_Color_Col_3:=""
zProdSched_ColorNum_Col_3:=0
zProdSched_Color_Col_4:=""
zProdSched_ColorNum_Col_4:=0
zProdSched_Color_Col_5:=""
zProdSched_ColorNum_Col_5:=0
zProdSched_Color_Col_6:=""
zProdSched_ColorNum_Col_6:=0
zProdSched_Color_Col_7:=""
zProdSched_ColorNum_Col_7:=0
zProdSched_Color_Col_8:=""
zProdSched_ColorNum_Col_8:=0
zProdSched_Color_BackRect:=""
zProdSched_ColorNum_BackRect:=0

Case of 
	: (Position:C15("HOLD"; [ProductionSchedules:110]JobInfo:58)>0) | (Position:C15("KILL"; [ProductionSchedules:110]JobInfo:58)>0) | (Position:C15("CLOS"; [ProductionSchedules:110]JobInfo:58)>0)
		Core_ObjectSetColor(->rb1; $yellow)
		Core_ObjectSetColor(->rb2; $yellow)
		Core_ObjectSetColor(->rb3; $yellow)
		Core_ObjectSetColor(->rb4; $yellow)
		Core_ObjectSetColor(->rb5; $yellow)
		Core_ObjectSetColor(->rb6; $yellow)
		Core_ObjectSetColor(->rb7; $yellow)
		Core_ObjectSetColor(->rb8; $yellow)
		$rvb:=(254*256*256)+(244*256)+156
		OBJECT SET RGB COLORS:C628(*; "BackRect"; 127; $rvb)
		
		zProdSched_Color_Col_1:="Yellow"
		zProdSched_ColorNum_Col_1:=$yellow
		zProdSched_Color_Col_2:="Yellow"
		zProdSched_ColorNum_Col_2:=$yellow
		zProdSched_Color_Col_3:="Yellow"
		zProdSched_ColorNum_Col_3:=$yellow
		zProdSched_Color_Col_4:="Yellow"
		zProdSched_ColorNum_Col_4:=$yellow
		zProdSched_Color_Col_5:="Yellow"
		zProdSched_ColorNum_Col_5:=$yellow
		zProdSched_Color_Col_6:="Yellow"
		zProdSched_ColorNum_Col_6:=$yellow
		zProdSched_Color_Col_7:="Yellow"
		zProdSched_ColorNum_Col_7:=$yellow
		zProdSched_Color_Col_8:="Yellow"
		zProdSched_ColorNum_Col_8:=$yellow
		zProdSched_Color_BackRect:=String:C10($rvb)
		zProdSched_ColorNum_BackRect:=$rvb
		
	: (Position:C15("not found"; [ProductionSchedules:110]JobInfo:58)=0)  // | (True)
		//If ($eBag="0")
		//SET COLOR([ProductionSchedules]Comment;$blackOnWhite)
		//Else 
		//SET COLOR([ProductionSchedules]Comment;$blackOnGreen)
		//End if 
		
		Case of 
				
				// Removed by: Garri Ogata (3/17/21) 
				//: ([ProductionSchedules]CostCenter="421")
				//rb1:=Num(JML_cacheInfo ("BAGGOT";$jf;$jobRef)#"00/00/00")
				//rb2:=Num(JML_cacheInfo ("BAGOK";$jf;$jobRef)#"00/00/00")
				//rb3:=Num(JML_cacheInfo ("STKGOT";$jf;$jobRef)#"00/00/00")
				//rb4:=Num(JML_cacheInfo ("STKSHT";$jf;$jobRef)#"00/00/00")
				//rb5:=Num(JML_cacheInfo ("PDF";$jf;$jobRef)#"00/00/00")  //PDF
				//rb6:=Num(JML_cacheInfo ("CYREL";$jf;$jobRef)#"00/00/00")
				//rb7:=-1
				//rb8:=Num(JML_cacheInfo ("PRESHEETED";$jf;$jobRef)#"00/00/00")
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>PRESSES)>0)
				rb1:=Num:C11(JML_cacheInfo("BAGGOT"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("STKGOT"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("PLATES"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("CYREL"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("INK"; $jf; $jobRef)#"00/00/00")
				rb8:=Num:C11(JML_cacheInfo("PRESHEETED"; $jf; $jobRef)#"00/00/00")
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>SHEETERS)>0) | ([ProductionSchedules:110]CostCenter:1="497")
				If ([ProductionSchedules:110]CostCenter:1="428")
					rb1:=Num:C11(JML_cacheInfo("BAGGOT"; $jf; $jobRef)#"00/00/00")
					rb2:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
					rb3:=Num:C11(JML_cacheInfo("STKGOT"; $jf; $jobRef)#"00/00/00")
					rb4:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
					rb5:=-1
					rb6:=-1
					rb7:=-1
					rb8:=-1
					
				Else 
					rb1:=Num:C11(JML_cacheInfo("BAGGOT"; $jf; $jobRef)#"00/00/00")
					rb2:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
					rb3:=Num:C11(JML_cacheInfo("STKGOT"; $jf; $jobRef)#"00/00/00")
					rb4:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
					rb5:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
					rb6:=-1
					rb7:=-1
					rb8:=-1
				End if 
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>STAMPERS)>0)
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("DIE_EMBOSS"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("FILM_EMB"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("DIE_STAMP"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("FILM_STAMP"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LEAF"; $jf; $jobRef)#"00/00/00")
				rb8:=Num:C11(JML_cacheInfo("DYLUX"; $jf; $jobRef)#"00/00/00")
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>BLANKERS)>0)  // blankers ` Modified by: Mel Bohince (12/6/13) added 470 removed 476
				//: ([ProductionSchedules]CostCenter="466") | ([ProductionSchedules]CostCenter="468") | ([ProductionSchedules]CostCenter="469") | ([ProductionSchedules]CostCenter="467") | ([ProductionSchedules]CostCenter="476")  // Modified by: Mark Zinke (8/5/13) Added 466
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("COUNTERS"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("DIE_BOARD"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("BLANKER"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				rb8:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="453")
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("DIE_STAMP"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("DIE_EMBOSS"; $jf; $jobRef)#"00/00/00")
				//rb5:=Num(JML_cacheInfo ("DIE_STAMP";$jf;$jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("FILM_STAMP"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("LEAF"; $jf; $jobRef)#"00/00/00")
				//rb6:=-1  `Num(JML_cacheInfo ("DIE_FILE";$jf;$jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				rb8:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="462")
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("COUNTERS"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("DIE_BOARD"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("BLANKER"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("STRIPPER"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				rb8:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="461")
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("DIE_EMBOSS"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("FILM_EMB"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("COUNTERS"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("DIE_BOARD"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				rb8:=-1
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>COATERS)>0)
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				rb5:=-1
				rb6:=-1
				rb7:=-1
				rb8:=-1
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>LAMINATERS)>0)
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("LATISEALED"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("WINDOWS"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("ADHESIVE"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("LAMINATE"; $jf; $jobRef)#"00/00/00")
				rb7:=-1
				rb8:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="472")  // Modified by: Mel Bohince (10/31/17) 
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("D/C"; $jf; $jobRef)#"00/00/00")
				rb4:=-1  //Num(JML_cacheInfo ("MATL ORDERED";$jf;$jobRef)#"00/00/00")
				rb5:=-1  //Num(JML_cacheInfo ("MATL REC'D";$jf;$jobRef)#"00/00/00")
				rb6:=-1
				rb7:=-1
				rb8:=-1
				rb8:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="9@")
				rb1:=Num:C11(JML_cacheInfo("INHOUSE"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("REQ"; $jf; $jobRef)#"")
				rb3:=Num:C11(JML_cacheInfo("PO"; $jf; $jobRef)#"")
				rb4:=Num:C11(JML_cacheInfo("TOOLING"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("STD"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("WIPOUT"; $jf; $jobRef)#"0")
				rb7:=Num:C11(JML_cacheInfo("WIPBACK"; $jf; $jobRef)#"0")
				rb8:=-1
				
			Else 
				rb1:=-1
				rb2:=-1
				rb3:=-1
				rb4:=-1
				rb5:=-1
				rb6:=-1
				rb7:=-1
				rb8:=-1
		End case 
		
		
		For ($i; 1; 8)
			$flag:=Get pointer:C304("rb"+String:C10($i))
			
			$ptColorCol:=Get pointer:C304("zProdSched_Color_Col_"+String:C10($i))
			$ptColorNumCol:=Get pointer:C304("zProdSched_ColorNum_Col_"+String:C10($i))
			
			Case of 
				: ($flag->>0)
					Core_ObjectSetColor($flag; $green)
					$ptColorCol->:="Green"
					$ptColorNumCol->:=$green
				: ($flag->=0)
					Core_ObjectSetColor($flag; $red)
					$ptColorCol->:="Red"
					$ptColorNumCol->:=$red
				Else 
					Core_ObjectSetColor($flag; $black)
					$ptColorCol->:="Black"
					$ptColorNumCol->:=$black
			End case 
			
		End for 
		
		If ((Position:C15([ProductionSchedules:110]CostCenter:1; <>EMBOSSERS)>0) | (Position:C15([ProductionSchedules:110]CostCenter:1; <>STAMPERS)>0))
			If (Position:C15("Emboss"; [ProductionSchedules:110]JobInfo:58)>0)
				OBJECT SET RGB COLORS:C628([ProductionSchedules:110]JobSequence:8; 1814251; 16777215)
			Else 
				Core_ObjectSetColor(->[ProductionSchedules:110]JobSequence:8; $blackOnWhite)
			End if 
		End if 
		
	Else 
		Core_ObjectSetColor(->rb1; $yellow)
		Core_ObjectSetColor(->rb2; $yellow)
		Core_ObjectSetColor(->rb3; $yellow)
		Core_ObjectSetColor(->rb4; $yellow)
		Core_ObjectSetColor(->rb5; $yellow)
		Core_ObjectSetColor(->rb6; $yellow)
		Core_ObjectSetColor(->rb7; $yellow)
		Core_ObjectSetColor(->rb8; $yellow)
		
		zProdSched_Color_Col_1:="Yellow"
		zProdSched_ColorNum_Col_1:=$yellow
		zProdSched_Color_Col_2:="Yellow"
		zProdSched_ColorNum_Col_2:=$yellow
		zProdSched_Color_Col_3:="Yellow"
		zProdSched_ColorNum_Col_3:=$yellow
		zProdSched_Color_Col_4:="Yellow"
		zProdSched_ColorNum_Col_4:=$yellow
		zProdSched_Color_Col_5:="Yellow"
		zProdSched_ColorNum_Col_5:=$yellow
		zProdSched_Color_Col_6:="Yellow"
		zProdSched_ColorNum_Col_6:=$yellow
		zProdSched_Color_Col_7:="Yellow"
		zProdSched_ColorNum_Col_7:=$yellow
		zProdSched_Color_Col_8:="Yellow"
		zProdSched_ColorNum_Col_8:=$yellow
End case 