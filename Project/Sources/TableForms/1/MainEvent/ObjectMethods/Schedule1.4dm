// _______
// Method: [zz_control].MainEvent.Schedule1   ( ) ->
// By: Mark Zinke @ 10/23/13, 11:55:52
// Description
// 
// ----------------------------------------------------
// If you add code here, add it to PS_qryPrintingOnly, uInitInterPrsVar, MainEventCase, and Object Method: [zz_control].MainEvent.Schedule1.
// ----------------------------------------------------
// Modified by: Mel Bohince (10/12/20) reorder list, remove 414 & 415
// Modified by: MelvinBohince (3/7/22) PS_PrePressViewer_ui in addition of show all
// Modified by: MelvinBohince (3/26/22) PS_InkRoomViewer_ui and PS_PrePressViewer_ui get their own items

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			//$menu_items:="(Production Schedule;Presses;Die Cutters;Sheeting;(-;(412;421;(414;(415;417;418;419;420;(-;452;454;455;467;468;469;474;475;(-;Gluers"
			$menu_items:="(Production Schedule;Presses;Prepress Viewer;Ink Room Viewer;Die Cutters;Sheeting;(-;(417;418;419;420;421;(-;452;454;455;467;469;470;471;475;(-;Gluers"
			//---------------------------------2----------3---------4---------6---7---8---9--10------12--13--14--15--16--17--18--19-----21
			$xlUserChoice:=Pop up menu:C542($menu_items)
			Case of 
				: ($xlUserChoice=2)
					PS_ShowAll
					
				: ($xlUserChoice=3)
					PS_PrePressViewer_ui
					
				: ($xlUserChoice=4)
					PS_InkRoomViewer_ui
					
				: ($xlUserChoice=5)
					PS_ShowDC
				: ($xlUserChoice=6)
					PS_Show429  //PS_Show428 
				: ($xlUserChoice=8)
					PS_Show417
				: ($xlUserChoice=9)  // Added by: Mark Zinke (10/23/13) 
					PS_Show418
				: ($xlUserChoice=10)
					PS_Show419
				: ($xlUserChoice=11)  // Modified by: Mel Bohince (6/20/18) 
					PS_Show420
				: ($xlUserChoice=12)
					PS_Show421
				: ($xlUserChoice=14)
					PS_Show452
				: ($xlUserChoice=15)
					PS_Show454
				: ($xlUserChoice=16)
					PS_Show455
				: ($xlUserChoice=17)
					PS_Show467
				: ($xlUserChoice=18)
					PS_Show469
				: ($xlUserChoice=19)
					PS_Show470
				: ($xlUserChoice=20)
					PS_Show471
				: ($xlUserChoice=21)
					PS_Show475
				: ($xlUserChoice=23)
					PSG_GlueScheduleUI("AllGluers")
			End case 
			
		Else 
			PS_ShowAll
		End if 
		
End case 