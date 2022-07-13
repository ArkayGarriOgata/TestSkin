//%attributes = {"publishedWeb":true}
//PM: PS_SetReadyColors() -> 
//@author mlb - 3/27/02  15:25
//see PS_setHeaderPictures
// SetObjectProperties, Mark Zinke (5/16/13)

$jf:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
$jobRef:=Num:C11(JML_cacheInfo("jobRef"; $jf))

SetObjectProperties("alertRect"; -><>NULL; False:C215)
SetObjectProperties("alertRect2"; -><>NULL; False:C215)

$grey:=-(Black:K11:16+(256*12))
$blue:=-(Blue:K11:7+(256*209))
$porto:=-(Black:K11:16+(256*224))
$blackOnWhite:=-(Black:K11:16+(256*White:K11:1))
$YellowOnRed:=-(Yellow:K11:2+(256*Red:K11:4))
$blackOnGreen:=-(Black:K11:16+(256*Green:K11:9))
Core_ObjectSetColor("*"; "c@"; $blackOnWhite)

Case of 
	: (Position:C15("NY"; [ProductionSchedules:110]JobInfo:58)>0)
		Core_ObjectSetColor(->[ProductionSchedules:110]JobInfo:58; $blue)
	: (Position:C15("VA"; [ProductionSchedules:110]JobInfo:58)>0)
		Core_ObjectSetColor(->[ProductionSchedules:110]JobInfo:58; $grey)
	: (Position:C15("PR"; [ProductionSchedules:110]JobInfo:58)>0)
		Core_ObjectSetColor(->[ProductionSchedules:110]JobInfo:58; $porto)
	Else 
		Core_ObjectSetColor(->[ProductionSchedules:110]JobInfo:58; $blackOnWhite)
End case 

If ([ProductionSchedules:110]FirstRelease:59=!00-00-00!)
	Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $blackOnWhite)
	
Else 
	If ([ProductionSchedules:110]FirstRelease:59<=[ProductionSchedules:110]StartDate:4) & ([ProductionSchedules:110]FirstRelease:59#!00-00-00!)
		Core_ObjectSetColor(->[ProductionSchedules:110]ProcessColors:21; $YellowOnRed)
		SetObjectProperties("alertRect"; -><>NULL; True:C214)
	Else 
		Core_ObjectSetColor(->[ProductionSchedules:110]ProcessColors:21; $blackOnWhite)
	End if 
End if 

If ([ProductionSchedules:110]HRD:60=!00-00-00!)
	Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $blackOnWhite)
	SetObjectProperties("alertRect2"; -><>NULL; True:C214)
	
Else 
	If ([ProductionSchedules:110]HRD:60<=[ProductionSchedules:110]StartDate:4) & ([ProductionSchedules:110]HRD:60#!00-00-00!)
		Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $YellowOnRed)
		SetObjectProperties("alertRect"; -><>NULL; True:C214)
	Else 
		Core_ObjectSetColor(->[ProductionSchedules:110]FixedStart:12; $blackOnWhite)
	End if 
End if 

$green:=-(Green:K11:9+(256*Green:K11:9))
$red:=-(Red:K11:4+(256*Red:K11:4))
$yellow:=-(Yellow:K11:2+(256*Yellow:K11:2))
$black:=-(Black:K11:16+(256*Black:K11:16))

Case of 
	: (Position:C15("HOLD"; [ProductionSchedules:110]JobInfo:58)>0)
		Core_ObjectSetColor(->rb1; $yellow)
		Core_ObjectSetColor(->rb2; $yellow)
		Core_ObjectSetColor(->rb3; $yellow)
		Core_ObjectSetColor(->rb4; $yellow)
		Core_ObjectSetColor(->rb5; $yellow)
		Core_ObjectSetColor(->rb6; $yellow)
		Core_ObjectSetColor(->rb7; $yellow)
		$rvb:=(254*256*256)+(244*256)+156
		OBJECT SET RGB COLORS:C628(*; "BackRect"; 127; $rvb)
		
	: (Position:C15("not found"; [ProductionSchedules:110]JobInfo:58)=0)  // | (True)
		//If ($eBag="0")
		//SET COLOR([ProductionSchedules]Comment;$blackOnWhite)
		//Else 
		//SET COLOR([ProductionSchedules]Comment;$blackOnGreen)
		//End if 
		
		Case of 
			: (Position:C15([ProductionSchedules:110]CostCenter:1; " 417 ")>0)
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("SCREEN"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("INK"; $jf; $jobRef)#"00/00/00")
				rb5:=-1
				rb6:=-1
				rb7:=-1
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>PRESSES)>0)
				rb1:=Num:C11(JML_cacheInfo("BAGGOT"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("STKGOT"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("PLATES"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("CYREL"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("INK"; $jf; $jobRef)#"00/00/00")
				
			: (Position:C15([ProductionSchedules:110]CostCenter:1; <>SHEETERS)>0)
				If ([ProductionSchedules:110]CostCenter:1="428")
					rb1:=Num:C11(JML_cacheInfo("BAGGOT"; $jf; $jobRef)#"00/00/00")
					rb2:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
					rb3:=Num:C11(JML_cacheInfo("STKGOT"; $jf; $jobRef)#"00/00/00")
					rb4:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
					rb5:=-1
					rb6:=-1
					rb7:=-1
				Else 
					rb1:=Num:C11(JML_cacheInfo("BAGGOT"; $jf; $jobRef)#"00/00/00")
					rb2:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
					rb3:=Num:C11(JML_cacheInfo("STKGOT"; $jf; $jobRef)#"00/00/00")
					rb4:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
					rb5:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
					rb6:=-1
					rb7:=-1
				End if 
				
			: ([ProductionSchedules:110]CostCenter:1="452") | ([ProductionSchedules:110]CostCenter:1="455") | ([ProductionSchedules:110]CostCenter:1="454")
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("DIE_EMBOSS"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("FILM_EMB"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("DIE_STAMP"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("FILM_STAMP"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LEAF"; $jf; $jobRef)#"00/00/00")
				
			: ([ProductionSchedules:110]CostCenter:1="468") | ([ProductionSchedules:110]CostCenter:1="469") | ([ProductionSchedules:110]CostCenter:1="467") | ([ProductionSchedules:110]CostCenter:1="476")
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("STKSHT"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("COUNTERS"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("DIE_BOARD"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("BLANKER"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				
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
				
			: ([ProductionSchedules:110]CostCenter:1="462")
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("COUNTERS"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("DIE_BOARD"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("BLANKER"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("STRIPPER"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				
			: ([ProductionSchedules:110]CostCenter:1="461")
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("DIE_EMBOSS"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("FILM_EMB"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("COUNTERS"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("DIE_BOARD"; $jf; $jobRef)#"00/00/00")
				rb7:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				
			: ([ProductionSchedules:110]CostCenter:1="471") | ([ProductionSchedules:110]CostCenter:1="472") | ([ProductionSchedules:110]CostCenter:1="474")
				rb1:=Num:C11(JML_cacheInfo("BAGRTN"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("WIP"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("LOCKED"; $jf; $jobRef)#"00/00/00")
				rb5:=-1
				rb6:=-1
				rb7:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="475")
				rb1:=Num:C11(JML_cacheInfo("BAGOK"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("PRINTED"; $jf; $jobRef)#"00/00/00")
				rb3:=Num:C11(JML_cacheInfo("LATISEALED"; $jf; $jobRef)#"00/00/00")
				rb4:=Num:C11(JML_cacheInfo("WINDOWS"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("ADHESIVE"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("LAMINATE"; $jf; $jobRef)#"00/00/00")
				rb7:=-1
				
			: ([ProductionSchedules:110]CostCenter:1="9@")
				rb1:=Num:C11(JML_cacheInfo("INHOUSE"; $jf; $jobRef)#"00/00/00")
				rb2:=Num:C11(JML_cacheInfo("REQ"; $jf; $jobRef)#"")
				rb3:=Num:C11(JML_cacheInfo("PO"; $jf; $jobRef)#"")
				rb4:=Num:C11(JML_cacheInfo("TOOLING"; $jf; $jobRef)#"00/00/00")
				rb5:=Num:C11(JML_cacheInfo("STD"; $jf; $jobRef)#"00/00/00")
				rb6:=Num:C11(JML_cacheInfo("WIPOUT"; $jf; $jobRef)#"0")
				rb7:=Num:C11(JML_cacheInfo("WIPBACK"; $jf; $jobRef)#"0")
				
			Else 
				rb1:=-1
				rb2:=-1
				rb3:=-1
				rb4:=-1
				rb5:=-1
				rb6:=-1
				rb7:=-1
		End case 
		
		For ($i; 1; 7)
			$flag:=Get pointer:C304("rb"+String:C10($i))
			Case of 
				: ($flag->>0)
					Core_ObjectSetColor($flag; $green)
				: ($flag->=0)
					Core_ObjectSetColor($flag; $red)
				Else 
					Core_ObjectSetColor($flag; $black)
			End case 
		End for 
		
	Else 
		Core_ObjectSetColor(->rb1; $yellow)
		Core_ObjectSetColor(->rb2; $yellow)
		Core_ObjectSetColor(->rb3; $yellow)
		Core_ObjectSetColor(->rb4; $yellow)
		Core_ObjectSetColor(->rb5; $yellow)
		Core_ObjectSetColor(->rb6; $yellow)
		Core_ObjectSetColor(->rb7; $yellow)
End case 