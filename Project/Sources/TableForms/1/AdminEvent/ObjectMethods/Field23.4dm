//(s) Method: [zz_control].AdminEvent.InkVendorId()
//• 6/1/98 cs created
// Modified by: Mel Bohince (9/13/13) set up for auto ink issue

Case of 
	: ([zz_control:1]InkVendorID:39="ISSUE")
		[zz_control:1]InkVendor:40:="Auto Issue on Close"
		[zz_control:1]Auto_Ink_Percent:41:=".029"
		<>Auto_Ink_Issue:=([zz_control:1]InkVendorID:39="ISSUE")  // Modified by: Mel Bohince (8/23/13) 
		<>Auto_Ink_Percent:=Num:C11([zz_control:1]Auto_Ink_Percent:41)
		If (<>Auto_Ink_Percent<=0)
			<>Auto_Ink_Percent:=0.029
		End if 
		
		
End case 
