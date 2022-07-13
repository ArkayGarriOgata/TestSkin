// _______
// Form Method: [ProductionSchedules].PrePressViewer   ( ) ->
// By: MelvinBohince @ 03/01/22, 15:21:45
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($criterion_s; $objectName_t)

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		$objectName_t:=OBJECT Get name:C1087(Object with focus:K67:3)  //Object current, not so much
		
		Case of 
			: (Position:C15("Filter_cb"; $objectName_t)>0)  //filter requested via checkbox
				$criterion_s:=PS_PrePressFilter
				zwStatusMsg("PrePressViewer"; "Filter: "+$criterion_s)
				
			: (Position:C15("LB_"; $objectName_t)>0)  //listbox clicked, set the jobsequence up
				
				$selectedListBoxObjectName:="clicked"+Uppercase:C13(Substring:C12($objectName_t; 4; 1))+Substring:C12($objectName_t; 5)+"_o"  //covert Camelcase to TitleCase
				
				If (Form:C1466[$selectedListBoxObjectName]#Null:C1517)  //an entity selected, there won't be after exiting the buttons action
					
					Form:C1466.activeJobSequence_t:=Form:C1466[$selectedListBoxObjectName].JobSequence  //grab the attribute so buttons have something to work with
					
					If (Length:C16(Form:C1466.activeJobSequence_t)>11)  //turn on controls
						zwStatusMsg("PrePressViewer"; "Job Sequence "+Form:C1466.activeJobSequence_t+" selected last")
						OBJECT SET ENABLED:C1123(*; "jsSelected_@"; True:C214)
					Else 
						Form:C1466.activeJobSequence_t:=""
						OBJECT SET ENABLED:C1123(*; "jsSelected_@"; False:C215)
					End if 
					
				Else 
					Form:C1466.activeJobSequence_t:=""
					OBJECT SET ENABLED:C1123(*; "jsSelected_@"; False:C215)
				End if   //an entity selected
				
			Else   //idk
				//pass
				
		End case   // clicked
		
	: (Form event code:C388=On Load:K2:1)
		$criterion_s:=PS_PrePressFilter
		zwStatusMsg("PrePressViewer"; "Filter: "+$criterion_s)
		
		OBJECT SET ENABLED:C1123(*; "jsSelected_@"; False:C215)
		
End case 
