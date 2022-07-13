//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/13/14, 09:23:47
// ----------------------------------------------------
// Method: PSG_UI_SetOptions
// ----------------------------------------------------
BEEP:C151
BEEP:C151
BEEP:C151
//***TODO keep PSG_UI_SetOptions??
Case of 
	: (Form event code:C388=On Load:K2:1)
		//PSG_UI_SaveSettings ("Set")
		
		OBJECT SET ENABLED:C1123(bExtend; False:C215)
		
	: (Form event code:C388=On Clicked:K2:4)
		If (User in group:C338(Current user:C182; "Role_Glue_Scheduling"))
			Case of 
				: (cb1=1)
					OBJECT SET ENABLED:C1123(bExtend; False:C215)
				: (cb2=1) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=1) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=1) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=1) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=1) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=1) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=1) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=1) & (cb10=0) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=1) & (cb11=0) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=1) & (cb12=0)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				: (cb2=0) & (cb3=0) & (cb4=0) & (cb5=0) & (cb6=0) & (cb7=0) & (cb8=0) & (cb9=0) & (cb10=0) & (cb11=0) & (cb12=1)
					OBJECT SET ENABLED:C1123(bExtend; True:C214)
				Else 
					OBJECT SET ENABLED:C1123(bExtend; False:C215)
			End case 
			SetObjectProperties(""; ->aReleased; True:C214; ""; True:C214)  // Added by: Mark Zinke (8/28/13)
			SetObjectProperties(""; ->aQtyPlnd; True:C214; ""; True:C214)  // Added by: Mark Zinke (8/28/13)
			SetObjectProperties(""; ->aQtyReleased; True:C214; ""; True:C214)  // Added by: Mark Zinke (8/28/13) 
			SetObjectProperties(""; ->aGluer; True:C214; ""; True:C214)
			SetObjectProperties(""; ->aPrior; True:C214; ""; True:C214)
			
			//QUERY([UserPrefs];[UserPrefs]UserName=Current user;*)  // Added by: Mark Zinke (9/20/13) Show/Hide Separate
			//QUERY([UserPrefs]; & ;[UserPrefs]PrefType="SeparateColumn")
			//If ([UserPrefs]LongIntField=0)
			SetObjectProperties(""; ->aSeparate; True:C214)
			//Else 
			//SetObjectProperties ("";->aSeparate;False)
			//End if 
			
			SetObjectProperties(""; ->aHRD; True:C214; ""; True:C214)
			SetObjectProperties(""; ->aStyle; True:C214; ""; True:C214)
			SetObjectProperties(""; ->aComment; True:C214; ""; True:C214)
			SetObjectProperties(""; ->aRecNum; False:C215)  // Added by: Mark Zinke (9/20/13) Hide the Record Num
			SetObjectProperties(""; ->aCustID; False:C215)  // Added by: Mark Zinke (9/20/13) Hide the Cust ID
			
		Else 
			SetObjectProperties(""; ->aReleased; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aQtyPlnd; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aQtyReleased; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aGluer; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aPrior; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aSeparate; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aHRD; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aStyle; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aComment; True:C214; ""; False:C215)
			SetObjectProperties(""; ->aRecNum; False:C215)  // Added by: Mark Zinke (9/20/13) Hide the Record Num
			SetObjectProperties(""; ->aCustID; False:C215)  // Added by: Mark Zinke (9/20/13) Hide the Cust ID
			OBJECT SET ENABLED:C1123(bExtend; False:C215)
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		//PSG_UI_SaveSettings ("Save")
		
End case 