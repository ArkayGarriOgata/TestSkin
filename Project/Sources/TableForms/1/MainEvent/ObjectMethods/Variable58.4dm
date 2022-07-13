Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="(Database Administration;Batch Runner...;Connect to WMS;Connect to Flex;PNGA Administration..."
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=2)
					$id:=uSpawnProcess("bBatch_Runner"; <>lBigMemPart; "bBatch_Runner")
					If (False:C215)
						bBatch_Runner
					End if 
				: ($user_choice=3)
					wms_start_from_menu
				: ($user_choice=4)
					PS_Exchange_Data_with_Flex
				: ($user_choice=5)
					//zzPNGA_OpenAdmin 
				Else 
					uSpawnProcess("DBA_OpenPalette"; <>lMidMemPart; "Administration"; False:C215; False:C215)
					If (False:C215)
						DBA_OpenPalette
					End if 
			End case 
			
		Else 
			uSpawnProcess("DBA_OpenPalette"; <>lMidMemPart; "Administration"; False:C215; False:C215)
			If (False:C215)
				DBA_OpenPalette
			End if 
		End if 
		
End case   //(S) ibAdmin

//EOS