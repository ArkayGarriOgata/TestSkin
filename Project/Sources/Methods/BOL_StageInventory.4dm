//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 14:10:36
// ----------------------------------------------------
// Method: BOL_StageInventory()  --> 
// Description
// set BOL_pending in bins and releases
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/16) send email when there is a 'fail' -- EMAIL_Sender ("Check Shipping.log";"";"failure recorded by BOL_StageInventory line 141";"";"";"";"mel.bohince@arkay.com")

ARRAY LONGINT:C221($release_already_marked; 0)  //only try to update the release once
C_LONGINT:C283($i; $numElements; $hit; $err; $0)

READ WRITE:C146([Finished_Goods_Locations:35])
READ WRITE:C146([Customers_ReleaseSchedules:46])

BOL_ListBox1("restore-from-blob")

$err:=0
$numElements:=Size of array:C274(aLocation2)

//uThermoInit ($numElements;"Staging Inventory")
For ($i; 1; $numElements)
	If ($err=0)
		If (Not:C34([Customers_Bills_of_Lading:49]WasBilled:29))  //don't try to stage if already executed, they not going to be found
			If (aJobit2{$i}#"T.B.D.")  //just sending to WMS
				If (Length:C16(aPallet2{$i})=0)
					$numFGL:=FGL_qryBin(aJobit2{$i}; aLocation2{$i})
				Else 
					$numFGL:=FGL_qryBin(aJobit2{$i}; aLocation2{$i}; aPallet2{$i})
				End if 
				If ($numFGL=1)
					If ([Finished_Goods_Locations:35]BOL_Pending:31#[Customers_Bills_of_Lading:49]ShippersNo:1)  //not already staged
						If (fLockNLoad(->[Finished_Goods_Locations:35]))
							[Finished_Goods_Locations:35]BOL_Pending:31:=[Customers_Bills_of_Lading:49]ShippersNo:1
							SAVE RECORD:C53([Finished_Goods_Locations:35])
							
						Else 
							$err:=TriggerMessage_Set(-30000-Table:C252(->[Finished_Goods_Locations:35]); "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+" couldn't stage bin location")
							utl_Logfile("shipping.log"; "Staging jobit: "+aJobit2{$i}+" in location: "+aLocation2{$i}+" failed, record locked BOL#"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1))
							EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_StageInventory line 40"; ""; ""; ""; "mel.bohince@arkay.com")
						End if 
					End if   //not already staged
					
				Else 
					If ($numFGL>1)
						$err:=TriggerMessage_Set(-30000-Table:C252(->[Finished_Goods_Locations:35]); "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+String:C10($numFGL)+" records found")
						utl_Logfile("shipping.log"; "Staging jobit: "+aJobit2{$i}+" in location: "+aLocation2{$i}+" failed, "+String:C10($numFGL)+" records found BOL#"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1))
						EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_StageInventory line 48"; ""; ""; ""; "mel.bohince@arkay.com")
					Else 
						$err:=TriggerMessage_Set(-30000-Table:C252(->[Finished_Goods_Locations:35]); "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+String:C10($numFGL)+" records found")
						utl_Logfile("shipping.log"; "Staging jobit: "+aJobit2{$i}+" in location: "+aLocation2{$i}+" failed, record not found BOL#"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1))
						EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_StageInventory line 51"; ""; ""; ""; "mel.bohince@arkay.com")
					End if 
				End if   //found 
			End if 
			
			If ($err=0)
				$hit:=Find in array:C230($release_already_marked; aReleases{$i})
				If ($hit=-1)
					APPEND TO ARRAY:C911($release_already_marked; aReleases{$i})
					
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=aReleases{$i})
					If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
						If ([Customers_ReleaseSchedules:46]B_O_L_number:17=0)
							If ([Customers_ReleaseSchedules:46]B_O_L_pending:45#[Customers_Bills_of_Lading:49]ShippersNo:1)
								If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
									[Customers_ReleaseSchedules:46]B_O_L_pending:45:=[Customers_Bills_of_Lading:49]ShippersNo:1  //•020596  MLB 
									SAVE RECORD:C53([Customers_ReleaseSchedules:46])
									
								Else 
									$err:=TriggerMessage_Set(-31000-Table:C252(->[Customers_ReleaseSchedules:46]); "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+" rel "+String:C10(aReleases{$i})+" locked")
									utl_Logfile("shipping.log"; "Staging release:"+String:C10(aReleases{$i})+" failed, record locked BOL#"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1))
									EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_StageInventory line 73"; ""; ""; ""; "mel.bohince@arkay.com")
								End if   // `release locked 
							End if   //not already staged 
						End if   //not already shipped
						
					Else 
						$err:=TriggerMessage_Set(-31000-Table:C252(->[Customers_ReleaseSchedules:46]); "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+" rel "+String:C10(aReleases{$i})+" not found")
						utl_Logfile("shipping.log"; "Staging release:"+String:C10(aReleases{$i})+" failed, record not found")
						EMAIL_Sender("Check Shipping.log"; ""; "failure recorded by BOL_StageInventory line 80"; ""; ""; ""; "mel.bohince@arkay.com")
					End if 
				End if 
			End if 
			
		End if 
	End if   //no err
End for 
$0:=$err

REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)