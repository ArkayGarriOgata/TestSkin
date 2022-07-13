// _______
// Method: [Vendors].VendorMgmt.Reports1   ( ) ->
// By: Mel Bohince @ 04/23/20, 09:30:03
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Size of array:C274(<>aVenRptPop)=0)
			ARRAY TEXT:C222(<>aVenRptPop; 3)
			<>aVenRptPop{1}:="Vendor Listing"
			<>aVenRptPop{2}:="Performance"
			<>aVenRptPop{3}:="Outstanding POs"
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: (<>aVenRptPop=3)
				ViewSetter(78; ->[Vendors:7]; <>aVenRptPop{<>aVenRptPop})
			Else 
				ViewSetter(7; ->[Vendors:7]; <>aVenRptPop{<>aVenRptPop})
		End case 
		
End case 
