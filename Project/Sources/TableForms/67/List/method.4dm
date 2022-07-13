// Form Method: [Job_Forms_Master_Schedule].List
// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 5/3/01  15:45
// ----------------------------------------------------
// SetObjectProperties, Mark Zinke (5/17/13)
// ----------------------------------------------------
// Modified by: MelvinBohince (6/6/22) chg the way tHold is set

app_basic_list_form_method

Case of 
	: (Form event code:C388=On Load:K2:1)
		b1:=0
		b2:=0
		b3:=0
		b4:=1
		cb1:=0
		cb2:=1
		cb3:=0
		i1:=1
		i2:=1
		lastTab:=1
		SELECT LIST ITEMS BY POSITION:C381(iJMLTabs; lastTab)
		FORM GOTO PAGE:C247(1)
		
	: (Form event code:C388=On Display Detail:K2:22)
		
		whereIsBag:=JTB_findLastCheckin([Job_Forms_Master_Schedule:67]JobForm:4)
		
		// Modified by: MelvinBohince (6/6/22) chg the way tHold is set
		C_OBJECT:C1216($jf_e)
		$jf_e:=ds:C1482.Job_Forms.query("JobFormID = :1"; [Job_Forms_Master_Schedule:67]JobForm:4).first()
		If ($jf_e#Null:C1517)
			tHold:=$jf_e.Status
			tHold:=Choose:C955(Position:C15(tHold; "wip kill hold")>0; tHold; "")  //only interested in these 3 statii, they will be colorized
		Else 
			tHold:=""
		End if 
		
		JML_setColors
		
End case 
