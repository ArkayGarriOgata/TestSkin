//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/21/13, 13:06:17
// ----------------------------------------------------
// Method: MainEventCase
// Description:
// Considolation of Main Event button code.
// ----------------------------------------------------

C_TEXT:C284($tWhichOne; $1; $tMenuItems; $tEnabled; $tDisabled)
C_LONGINT:C283($xlClickX; $xlClickY; $xlMouseBtn; $xlUserChoice; $xlErrCode)

$tWhichOne:=$1
GET MOUSE:C468($xlClickX; $xlClickY; $xlMouseBtn)

If (Form event code:C388=On Clicked:K2:4)
	Case of 
		: ($tWhichOne="AskMe")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="Supply and Demand Details"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>0)
						sAskMe_UI
				End case 
			Else 
				sAskMe_UI
			End if 
			
		: ($tWhichOne="Projects")
			If (Form event code:C388=On Clicked:K2:4)
				If (Macintosh control down:C544 | ($xlMouseBtn=2))
					$tMenuItems:="Project Center"
					$xlUserChoice:=Pop up menu:C542($tMenuItems)
					Case of 
						: ($xlUserChoice>0)
							Pjt_ProjectUserInterface
					End case 
				Else 
					Pjt_ProjectUserInterface
				End if 
				
			End if 
			
		: ($tWhichOne="JobMaster")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="Job Master Log"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>0)
						app_Log_Usage("log"; "Job Master Log"; "")
						JML_ShowListing
				End case 
			Else 
				app_Log_Usage("log"; "Job Master Log"; "")
				JML_ShowListing
			End if 
			
		: ($tWhichOne="Schedule")
			//If you add code here, add it to PS_qryPrintingOnly, uInitInterPrsVar, MainEventCase, and Object Method: [zz_control].MainEvent.Schedule1.
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="(Production Schedule;Presses;Die Cutters;Sheeting;(-;(412;421;414;415;416;418;(-;452;454;455;466;467;468;469;474;475;(-;428"  // Added by: Mark Zinke (7/31/13) Added 466
				
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=2)
						PS_ShowAll
					: ($xlUserChoice=3)
						PS_ShowDC
					: ($xlUserChoice=4)
						PS_Show497
					: ($xlUserChoice=6)
						PS_Show412
					: ($xlUserChoice=7)
						PS_Show421
					: ($xlUserChoice=8)
						PS_Show414
					: ($xlUserChoice=9)
						PS_Show415
					: ($xlUserChoice=10)
						PS_Show416
					: ($xlUserChoice=11)  // Added by: Mark Zinke (10/23/13) 
						PS_Show418
					: ($xlUserChoice=13)
						PS_Show452
					: ($xlUserChoice=14)
						PS_Show454
					: ($xlUserChoice=15)
						PS_Show455
					: ($xlUserChoice=16)  // Added by: Mark Zinke (7/31/13) 
						PS_Show470
					: ($xlUserChoice=17)
						PS_Show467
					: ($xlUserChoice=18)
						PS_Show468
					: ($xlUserChoice=19)
						PS_Show469
					: ($xlUserChoice=20)
						PS_Show474
					: ($xlUserChoice=21)
						PS_Show475
					: ($xlUserChoice=22)
						PS_Show497
				End case 
			Else 
				PS_ShowAll
			End if 
			
		: ($tWhichOne="Customers")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:=<>BASE_POPUP_MENU
				$xlUserChoice:=Pop up menu:C542("(Customers;"+$tMenuItems)
				Case of 
					: ($xlUserChoice>1)
						ViewSetter($xlUserChoice-1; ->[Customers:16])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("gCustEvent"; "$Customers Palette")
				If (False:C215)
					gCustEvent
				End if 
			End if 
			
		: ($tWhichOne="Estimates")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="(Estimates;New via Project Center;Modify...;Review..."
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=2)
						Pjt_ProjectUserInterface
					: ($xlUserChoice>2)
						ViewSetter($xlUserChoice-1; ->[Estimates:17])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("ESTIMATE_OpenPalette"; "$Estimating Palette")
				If (False:C215)
					ESTIMATE_OpenPalette
				End if 
			End if 
			
		: ($tWhichOne="Orders")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="(Customer Orders;Enter via Project Center;Modify...;Review...;(-;Print..."
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=2)
						Pjt_ProjectUserInterface
					: ($xlUserChoice=6)
						ViewSetter(7; ->[Customers_Orders:40]; "Cust_Order")
					: ($xlUserChoice>2)
						ViewSetter($xlUserChoice-1; ->[Customers_Orders:40])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("gCustOrdEvent"; "$Customers' Order Palette")
				If (False:C215)
					gCustOrdEvent
				End if 
			End if 
			
		: ($tWhichOne="Jobs")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				Case of 
					: (User in group:C338(Current user:C182; "Planners"))
						$tMenuItems:="(Jobs;Plan via Project Center;Modify...;Review...;(-;Job Bags Review;(Modify Actuals"
					: (User in group:C338(Current user:C182; "RoleCostAccountant"))
						$tMenuItems:="(Jobs;Plan via Project Center;Modify...;Review...;(-;Job Bags Review;Modify Actuals"
					Else 
						$tMenuItems:="(Jobs;(Plan via Project Center;(Modify...;Review...;(-;Job Bags Review;(Modify Actuals"
				End case 
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=6)
						<>JFActivity:=3
						Job_JobBagReview
					: ($xlUserChoice=7)
						If (Size of array:C274(<>asJobAPages)=0)
							ARRAY TEXT:C222(<>asJobAPages; 6)
							<>asJobAPages{1}:="Actual"
							<>asJobAPages{2}:="Machine"
							<>asJobAPages{3}:="Material"
							<>asJobAPages{4}:="Summary"
							<>asJobAPages{5}:="Good/Waste Units"
							<>asJobAPages{6}:="Transfers"
						End if 
						<>JFActivity:=2
						ViewSetter(2; ->[Job_Forms:42])
					: ($xlUserChoice=2)
						Pjt_ProjectUserInterface
					: ($xlUserChoice>2)
						ViewSetter($xlUserChoice-1; ->[Jobs:15])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("JOB_OpenPalette"; "$Jobs Palette")
			End if 
			
		: ($tWhichOne="Addresses")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tEnabled:=<>BASE_POPUP_MENU
				$tDisabled:="(New;(Modify...;(Review..."
				If (User in group:C338(Current user:C182; "Addresses"))
					$tMenuItems:="(Addresses;"+$tEnabled
				Else 
					$tMenuItems:="(Addresses;"+$tDisabled
				End if 
				If (User in group:C338(Current user:C182; "Contacts"))
					$tMenuItems:=$tMenuItems+";(Contacts;"+$tEnabled
				Else 
					$tMenuItems:=$tMenuItems+";(Contacts;"+$tDisabled
				End if 
				If (User in group:C338(Current user:C182; "Vendors"))
					$tMenuItems:=$tMenuItems+";(Vendors;"+$tEnabled
				Else 
					$tMenuItems:=$tMenuItems+";(Vendors;"+$tDisabled
				End if 
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>1) & ($xlUserChoice<5)
						ViewSetter($xlUserChoice-1; ->[Addresses:30])
						
					: ($xlUserChoice>5) & ($xlUserChoice<9)
						ViewSetter($xlUserChoice-5; ->[Contacts:51])
						
					: ($xlUserChoice>9) & ($xlUserChoice<13)
						ViewSetter($xlUserChoice-9; ->[Vendors:7])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("gCaddEvent"; "$Address Palette")
			End if 
			
		: ($tWhichOne="Standards")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="Raw Material and Cost Center Standards"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>0)
						app_Log_Usage("log"; "Standards Palette"; "")
						$errCode:=uSpawnPalette("gCCEvent"; "$Standards Palette")
				End case 
			Else 
				app_Log_Usage("log"; "Standards Palette"; "")
				$xlErrCode:=uSpawnPalette("gCCEvent"; "$Standards Palette")
			End if 
			
		: ($tWhichOne="Quality")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				If (User in group:C338(Current user:C182; "RoleQA"))
					$tMenuItems:=<>BASE_POPUP_MENU
				Else 
					$tMenuItems:="(New;(Modify;Review"
				End if 
				$xlUserChoice:=Pop up menu:C542("(Corrective Actions;"+$tMenuItems)
				Case of 
					: ($xlUserChoice>1)
						ViewSetter($xlUserChoice-1; ->[QA_Corrective_Actions:105])
				End case 
			Else 
				prQA2Front
			End if 
			
		: ($tWhichOne="FinishedGoods")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				If (User in group:C338(Current user:C182; "FGinventory"))
					If (User in group:C338(Current user:C182; "Planners"))
						$tMenuItems:="(Finished Goods;New via Project Center;Modify...;Review...;(-;AskMe;(-;Prep Services Tracking;Size-n-Style Tracking"
					Else 
						$tMenuItems:="(Finished Goods;(New via Project Center;(Modify...;Review...;(-;AskMe;(-;Prep Services Tracking;Size-n-Style Tracking"
					End if 
				Else 
					$tMenuItems:="(Finished Goods;New via Project Center;(Modify...;Review...;(-;(Prep Services Tracking;(Size-n-Style Tracking"
				End if 
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=6)
						sAskMe_UI
					: ($xlUserChoice=8)
						<>Activitiy:=0
						ViewSetter(2; ->[Finished_Goods_Specifications:98])
					: ($xlUserChoice=9)
						<>Activitiy:=2
						ViewSetter(2; ->[Finished_Goods_SizeAndStyles:132])
					: ($xlUserChoice=2)
						Pjt_ProjectUserInterface
					: ($xlUserChoice>2)
						ViewSetter($xlUserChoice-1; ->[Finished_Goods:26])
				End case 
				
			Else 
				$xlErrCode:=uSpawnPalette("FG_OpenPalette"; "$Finished Goods Palette")
			End if 
			
		: ($tWhichOne="SalesMen")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:=<>BASE_POPUP_MENU
				$xlUserChoice:=Pop up menu:C542("(Salesmen;"+$tMenuItems)
				Case of 
					: ($xlUserChoice>1)
						ViewSetter($xlUserChoice-1; ->[Salesmen:32])
				End case 
			Else 
				app_Log_Usage("log"; "Sales Reps' Palette"; "")
				$xlErrCode:=uSpawnPalette("gSaleEvent"; "$Sales Reps' Palette")
			End if 
			
		: ($tWhichOne="Requisitions")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:=<>BASE_POPUP_MENU
				$xlUserChoice:=Pop up menu:C542("(Requisitions;"+$tMenuItems)
				Case of 
					: ($xlUserChoice>1)
						ViewSetter($xlUserChoice-1; ->[Purchase_Orders_Requisitions:80])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("gReqEvent"; "$Requistion Palette")
			End if 
			
		: ($tWhichOne="Purchasing")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				If (User in group:C338(Current user:C182; "Purchasing Modify"))
					$tMenuItems:=<>BASE_POPUP_MENU
				Else 
					$tMenuItems:="(New;(Modify...;Review"
				End if 
				$xlUserChoice:=Pop up menu:C542("(Purchase Orders;"+$tMenuItems)
				Case of 
					: ($xlUserChoice>1)
						If (User in group:C338(Current user:C182; "AccountsPayable"))
							$xlErrCode:=uSpawnProcess("PoAcctReview"; 0; "Review Purchase Orders"; True:C214; True:C214)
						Else 
							ViewSetter($xlUserChoice-1; ->[Purchase_Orders:11])
						End if 
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("PO_OpenPalette"; "$Purchasing Palette")
			End if 
			
		: ($tWhichOne="RawMaterials")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				If (User in group:C338(Current user:C182; "RMcreate"))
					$tMenuItems:="New"
				Else 
					$tMenuItems:="(New"
				End if 
				If (User in group:C338(Current user:C182; "RMupdate"))
					$tMenuItems:=$tMenuItems+";Modify..."
				Else 
					$tMenuItems:=$tMenuItems+";(Modify..."
				End if 
				If (User in group:C338(Current user:C182; "RMinquire"))
					$tMenuItems:=$tMenuItems+";Review..."
				Else 
					$tMenuItems:=$tMenuItems+";(Review..."
				End if 
				$xlUserChoice:=Pop up menu:C542("(Raw Materials;"+$tMenuItems)
				Case of 
					: ($xlUserChoice>1)
						ViewSetter($xlUserChoice-1; ->[Raw_Materials:21])
				End case 
			Else 
				$xlErrCode:=uSpawnPalette("RM_OpenPalette"; "$Raw Material Palette")
			End if 
			
		: ($tWhichOne="DBA")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="(Database Administration;Batch Runner...;Connect to WMS"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=2)
						$xlErrCode:=uSpawnProcess("bBatch_Runner"; <>lBigMemPart; "bBatch_Runner")
						If (False:C215)
							bBatch_Runner
						End if 
					: ($xlUserChoice=3)
						wms_start_from_menu
						
					Else 
						$xlErrCode:=uSpawnProcess("DBA_OpenPalette"; <>lMidMemPart; "Administration"; False:C215; False:C215)
				End case 
			Else 
				$xlErrCode:=uSpawnProcess("DBA_OpenPalette"; <>lMidMemPart; "Administration"; False:C215; False:C215)
			End if 
			
		: ($tWhichOne="EDI")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="Electronic Data Interchange"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>0)
						prEDI2Front
				End case 
			Else 
				prEDI2Front
			End if 
			
		: ($tWhichOne="eBag")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="Electronic Job Bag;Bag Tracker"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice=1)
						eBag_UI
					: ($xlUserChoice=2)
						app_Log_Usage("log"; "Bag Tracker"; "")
						JTB_bagTrack_UI
				End case 
			Else 
				eBag_UI
			End if 
			
		: ($tWhichOne="Help")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="Help"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>0)
						app_Log_Usage("log"; "Help"; "")
						utl_Help("init")
				End case 
				
			Else 
				app_Log_Usage("log"; "Help"; "")
				utl_Help("init")
			End if 
			
		: ($tWhichOne="FAQ")
			If (Macintosh control down:C544 | ($xlMouseBtn=2))
				$tMenuItems:="FAQ's on Arkay Intranet"
				$xlUserChoice:=Pop up menu:C542($tMenuItems)
				Case of 
					: ($xlUserChoice>0)
						app_Log_Usage("log"; "FAQs"; "")
						OPEN URL:C673("http://intranet.arkay.com/ams/gems/faqindex.html")
				End case 
			Else 
				app_Log_Usage("log"; "FAQs"; "")
				OPEN URL:C673("http://intranet.arkay.com/ams/gems/faqindex.html")
			End if 
			
		: ($tWhichOne="Config")
			$errCode:=uSpawnProcess("Config"; 32000; "Config")
			
	End case 
End if 