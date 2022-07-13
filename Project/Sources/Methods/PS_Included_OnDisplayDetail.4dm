//%attributes = {}
// PS_Included_OnDisplayDetail

READ ONLY:C145([Job_Forms_Master_Schedule:67])  // Modified by: MelvinBohince (2/3/22) 

RELATE ONE:C42([ProductionSchedules:110]JOB_MASTER_LOG:71)  // Modified by: MelvinBohince (1/20/22) 

zProdSched_Color_Main:=""
zProdSched_ColorNum_Main:=0

zProdSched_Color_JobInfo:=""
zProdSched_ColorNum_JobInfo:=0

zProdSched_Color_FixedStart:=""
zProdSched_ColorNum_FixedStart:=0
zProdSched_Color_ProcColors:=""
zProdSched_ColorNum_ProcColors:=0

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

zProdSched_Color_Customer:=""
zProdSched_ColorNum_Customer:=0

zProdSched_Color_Priority:=""
zProdSched_ColorNum_Priority:=0

$White:=-(White:K11:1+(256*White:K11:1))

Core_ObjectSetColor(->rb1; $White)
Core_ObjectSetColor(->rb2; $White)
Core_ObjectSetColor(->rb3; $White)
Core_ObjectSetColor(->rb4; $White)
Core_ObjectSetColor(->rb5; $White)
Core_ObjectSetColor(->rb6; $White)
Core_ObjectSetColor(->rb7; $White)
Core_ObjectSetColor(->rb8; $White)

If ([ProductionSchedules:110]Completed:23=0)
	
	PS_SetReadyColors
	
	C_OBJECT:C1216($oNameColor)
	$oNameColor:=New object:C1471()
	$oNameColor:=Cust_Name_ColorO([ProductionSchedules:110]Customer:11)
	
	OBJECT SET RGB COLORS:C628(*; "color@"; $oNameColor.nForeground; $oNameColor.nBackground)
	
	zProdSched_Color_Customer:=String:C10($color)
	zProdSched_ColorNum_Customer:=$color
	
	Case of 
		: ([ProductionSchedules:110]Priority:3=0)
			$ColorPriority:=(-(White:K11:1+(256*Black:K11:16)))
		: ([ProductionSchedules:110]Priority:3<0)
			$ColorPriority:=(-(Yellow:K11:2+(256*Red:K11:4)))
		Else 
			$ColorPriority:=(-(Black:K11:16+(256*White:K11:1)))
	End case 
	
	Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; $ColorPriority)
	
	zProdSched_Color_Priority:=String:C10($ColorPriority)
	zProdSched_ColorNum_Priority:=$ColorPriority
	
	If ([ProductionSchedules:110]StartedAt_ts:79>0)
		$ColorPriority:=(-(Green:K11:9+(256*White:K11:1)))
		
		Core_ObjectSetColor(->[ProductionSchedules:110]Priority:3; $ColorPriority)
		
		zProdSched_Color_Priority:=String:C10($ColorPriority)
		zProdSched_ColorNum_Priority:=$ColorPriority
	End if 
	
Else 
	PS_SetCompleteColors
End if 

