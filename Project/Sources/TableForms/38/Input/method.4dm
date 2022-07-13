// ----------------------------------------------------
// Form Method: [Estimates_Differentials].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)  //Test restrictions normally set in beforeEstimate
		Case of 
			: (<>fisSalesRep)
				testRestrictions:=True:C214
			: (<>fisCoord)
				testRestrictions:=True:C214
			Else 
				testRestrictions:=False:C215
		End case 
		
		If (testRestrictions)
			estimateDifferentialPage:=2
		Else 
			estimateDifferentialPage:=1
		End if 
		
		SetObjectProperties("restricted_access"; -><>NULL; True:C214; ""; testRestrictions)  // Modified by: Mark Zinke (5/10/13)
		
		If (Is new record:C668([Estimates_Differentials:38]))
			CANCEL:C270
		End if 
		
		wWindowTitle("push"; "Differential "+[Estimates_Differentials:38]Id:1+" Tagged: "+[Estimates_Differentials:38]PSpec_Qty_TAG:25)
		
		If (User in group:C338(Current user:C182; "PriceManager"))
			OBJECT SET ENABLED:C1123(*; "price@"; True:C214)
			SetObjectProperties("price@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
		Else 
			OBJECT SET ENABLED:C1123(*; "price@"; False:C215)
			SetObjectProperties("price@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
		End if 
		
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		
		RELATE MANY:C262([Estimates_Differentials:38]Id:1)  //retrieve forms for this differential
		ORDER BY:C49([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3; >)
		
		OBJECT SET ENABLED:C1123(bUseIt; False:C215)
		
		restoreReadWrite:=Not:C34(Read only state:C362([Estimates_Carton_Specs:19]))
		If (testRestrictions)
			OBJECT SET ENABLED:C1123(bAddForm; False:C215)
			OBJECT SET ENABLED:C1123(bDelForm; False:C215)
			OBJECT SET ENABLED:C1123(bViewForm; False:C215)
			OBJECT SET ENABLED:C1123(bEditCartn; False:C215)
			READ ONLY:C145([Estimates_Carton_Specs:19])
			READ ONLY:C145([Estimates_DifferentialsForms:47])
			SetObjectProperties("priceK@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
		Else 
			OBJECT SET ENABLED:C1123(bAddForm; True:C214)
			OBJECT SET ENABLED:C1123(bDelForm; True:C214)
			OBJECT SET ENABLED:C1123(bViewForm; True:C214)
			OBJECT SET ENABLED:C1123(bEditCartn; True:C214)
			READ WRITE:C146([Estimates_Carton_Specs:19])
			READ WRITE:C146([Estimates_DifferentialsForms:47])
		End if 
		FORM GOTO PAGE:C247(estimateDifferentialPage)
		
		If (imode>2)
			OBJECT SET ENABLED:C1123(bAddForm; False:C215)
			OBJECT SET ENABLED:C1123(bDelForm; False:C215)
			SetObjectProperties(""; ->bViewForm; True:C214; "View")  // Modified by: Mark Zinke (5/10/13)
			SetObjectProperties(""; ->bEditCartn; True:C214; "View")  // Modified by: Mark Zinke (5/10/13)
			READ ONLY:C145([Estimates_Carton_Specs:19])
			READ ONLY:C145([Estimates_DifferentialsForms:47])
			restoreReadWrite:=False:C215
		Else 
			SetObjectProperties(""; ->bViewForm; True:C214; "Edit")  // Modified by: Mark Zinke (5/10/13)
			SetObjectProperties(""; ->bEditCartn; True:C214; "Edit")  // Modified by: Mark Zinke (5/10/13)
		End if 
		
		CUT NAMED SELECTION:C334([Estimates_Carton_Specs:19]; "cartonsInWorksheet")  //use when returning from a form
		gEstimateLDWkSh("Diff")
		COPY NAMED SELECTION:C331([Estimates_Carton_Specs:19]; "cartonsInDifferential")  //use when returning from a form
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
		If (restoreReadWrite)
			READ WRITE:C146([Estimates_Carton_Specs:19])
		End if 
		gEstimateLDWkSh
		CLEAR NAMED SELECTION:C333("cartonsInDifferential")
End case 