//%attributes = {}
// ----------------------------------------------------
// Method: _version220218
// By: Garri Ogata
// Description:  This method will assign foreground and background colors to active
//.  Customers
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nCustID; $nNumberOfCustIDs)
	
	ARRAY TEXT:C222($atID; 0)
	
	ARRAY LONGINT:C221($anForeground; 0)
	ARRAY LONGINT:C221($anBackground; 0)
	
	APPEND TO ARRAY:C911($atID; "00015")  //Aramis, Inc. (1)
	APPEND TO ARRAY:C911($atID; "00001")  //Arkay
	APPEND TO ARRAY:C911($atID; "01780")  //Bobbi Brown
	APPEND TO ARRAY:C911($atID; "00050")  //Clinique Laboratories, Inc.
	APPEND TO ARRAY:C911($atID; "01080")  //Combined Customer   (5)
	APPEND TO ARRAY:C911($atID; "00065")  //Coty, Inc.
	APPEND TO ARRAY:C911($atID; "00074")  //Elizabeth Arden Inc. CT
	APPEND TO ARRAY:C911($atID; "00765")  //L'Oreal
	APPEND TO ARRAY:C911($atID; "00121")  //Len Ron Mfg.
	APPEND TO ARRAY:C911($atID; "02117")  //Luxe Brands, Inc.  (10)
	APPEND TO ARRAY:C911($atID; "01039")  //Mac Cosmetics Ltd
	APPEND TO ARRAY:C911($atID; "91859")  //Nest Fragrances
	APPEND TO ARRAY:C911($atID; "00152")  //Prescriptives
	APPEND TO ARRAY:C911($atID; "00199")  //Procter & Gamble Co.
	APPEND TO ARRAY:C911($atID; "01597")  //Shiseido Inc.    (15)
	
	APPEND TO ARRAY:C911($anForeground; 4342338)  //(1)
	APPEND TO ARRAY:C911($anForeground; 16766720)
	APPEND TO ARRAY:C911($anForeground; 15461355)
	APPEND TO ARRAY:C911($anForeground; 4342338)
	APPEND TO ARRAY:C911($anForeground; 15597568)  //(5)
	APPEND TO ARRAY:C911($anForeground; 0)
	APPEND TO ARRAY:C911($anForeground; 7799551)
	APPEND TO ARRAY:C911($anForeground; 1118481)
	APPEND TO ARRAY:C911($anForeground; 16766720)
	APPEND TO ARRAY:C911($anForeground; 15461355)  //(10)
	APPEND TO ARRAY:C911($anForeground; 4342338)
	APPEND TO ARRAY:C911($anForeground; 8913152)
	APPEND TO ARRAY:C911($anForeground; 4342338)
	APPEND TO ARRAY:C911($anForeground; 228351)
	APPEND TO ARRAY:C911($anForeground; 4342338)  //(15)
	
	APPEND TO ARRAY:C911($anBackground; 3467670)  //(1)
	APPEND TO ARRAY:C911($anBackground; 11184810)
	APPEND TO ARRAY:C911($anBackground; 9720320)
	APPEND TO ARRAY:C911($anBackground; 14876639)
	APPEND TO ARRAY:C911($anBackground; 16711427)  //(5)
	APPEND TO ARRAY:C911($anBackground; 16750850)
	APPEND TO ARRAY:C911($anBackground; 16711584)
	APPEND TO ARRAY:C911($anBackground; 16711427)
	APPEND TO ARRAY:C911($anBackground; 524441)
	APPEND TO ARRAY:C911($anBackground; 9713663)  //(10)
	APPEND TO ARRAY:C911($anBackground; 1762939)
	APPEND TO ARRAY:C911($anBackground; 16769248)
	APPEND TO ARRAY:C911($anBackground; 5174562)
	APPEND TO ARRAY:C911($anBackground; 16752895)
	APPEND TO ARRAY:C911($anBackground; 6803945)  //(15)
	
	$nNumberOfCustIDs:=Size of array:C274($atID)
	
End if   //Done initialize

//Clear colors from inactive customers
QUERY:C277([Customers:16]; [Customers:16]Active:15=False:C215; *)
QUERY:C277([Customers:16];  & ; [Customers:16]DisplayColor:55#0)

APPLY TO SELECTION:C70([Customers:16]; [Customers:16]DisplayColor:55:=0)

For ($nCustID; 1; $nNumberOfCustIDs)  //Id
	
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$atID{$nCustID})
	
	[Customers:16]ColorForeground:69:=$anForeground{$nCustID}
	[Customers:16]ColorBackground:70:=$anBackground{$nCustID}
	
	SAVE RECORD:C53([Customers:16])
	
End for   //Done id

ALERT:C41("Done changing customers colors")

