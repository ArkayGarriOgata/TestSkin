Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Not:C34(User_AllowedCustomer(Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5); ""; "via C# "+[Finished_Goods_Specifications:98]ControlNumber:2)))
			bDone:=1
			CANCEL:C270
		End if 
		
		wWindowTitle("push"; "FG Specification for "+[Finished_Goods_Specifications:98]ControlNumber:2+":"+[Finished_Goods_Specifications:98]FG_Key:1)
		C_LONGINT:C283(iFG_SpecTabs)
		C_BOOLEAN:C305(fRevisedQuote)  //• mlb - 8/22/02  13:57 track if revise quote has been made
		fRevisedQuote:=False:C215
		READ ONLY:C145([Finished_Goods_Color_SpecMaster:128])
		READ WRITE:C146([Finished_Goods:26])
		READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
		READ WRITE:C146([Prep_Charges:103])
		READ ONLY:C145([Customers:16])
		READ ONLY:C145([Customers_Projects:9])
		READ ONLY:C145([Raw_Materials:21])  // Modified by: Mel Bohince (1/25/20) 
		READ WRITE:C146([Finished_Goods_Spec_QA_Records:189])
		RELATE MANY:C262([Finished_Goods_Specifications:98]QA_Records:52)
		READ WRITE:C146([Finished_Goods_Specs_Inks:188])
		RELATE MANY:C262([Finished_Goods_Specifications:98]Ink:24)
		ORDER BY:C49([Finished_Goods_Specs_Inks:188]; [Finished_Goods_Specs_Inks:188]Side:2; >; [Finished_Goods_Specs_Inks:188]Rotation:1; >)
		
		If (Not:C34(Is new record:C668([Finished_Goods_Specifications:98])))  //see FG_PrepServiceNew 
			iMode:=2
			$numFG:=qryFinishedGood("#KEY"; [Finished_Goods_Specifications:98]FG_Key:1)
			//$numFG:=qryFinishedGood (Substring([FG_Specification]FG_Key;1;5);ProductCode)
			If ($numFG>0)
				
				If (fLockNLoad(->[Finished_Goods:26]))
					
					If ([Finished_Goods:26]ControlNumber:61=[Finished_Goods_Specifications:98]ControlNumber:2)  //make sure its up to date
						
						If ([Finished_Goods:26]OriginalOrRepeat:71="")
							[Finished_Goods:26]OriginalOrRepeat:71:="OriGinaL"
							[Finished_Goods_Specifications:98]CommentsFromQA:53:=" set to OirGinaL "+[Finished_Goods_Specifications:98]CommentsFromQA:53
						End if 
						
						If ([Finished_Goods:26]OrderType:59="")
							uConfirm("Pick an Order Type:"; "Promotional"; "Regular")
							If (ok=1)
								[Finished_Goods:26]OrderType:59:="Promotional"
							Else 
								[Finished_Goods:26]OrderType:59:="Regular"
							End if 
							[Finished_Goods_Specifications:98]CommentsFromQA:53:=" OT set to "+[Finished_Goods:26]OrderType:59+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
						End if 
						
						If (Length:C16([Finished_Goods_Specifications:98]OutLine_Num:65)=0) & (Length:C16([Finished_Goods:26]OutLine_Num:4)>0)
							[Finished_Goods_Specifications:98]OutLine_Num:65:=[Finished_Goods:26]OutLine_Num:4
							[Finished_Goods_Specifications:98]CommentsFromQA:53:=" A# set to "+[Finished_Goods:26]OutLine_Num:4+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
						End if 
						
						QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=[Finished_Goods_Specifications:98]OutLine_Num:65)
						If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=1)
							$set:=util_setDateIfNull(->[Finished_Goods_Specifications:98]Size_n_style:79; [Finished_Goods_SizeAndStyles:132]DateApproved:8)
							If ([Finished_Goods_Specifications:98]Size_n_style:79#!00-00-00!)
								[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:="Yes"
							Else 
								[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:="No"
							End if 
							
						Else   //no sns
							[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:=""
						End if   //found sns
						
						If (Length:C16([Finished_Goods_Specifications:98]UPC_encoded:76)=0) & (Length:C16([Finished_Goods:26]UPC:37)>0)
							[Finished_Goods_Specifications:98]UPC_encoded:76:=[Finished_Goods:26]UPC:37
							[Finished_Goods_Specifications:98]CommentsFromQA:53:=" UPC set to "+[Finished_Goods_Specifications:98]UPC_encoded:76+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
						End if 
						
						If ([Finished_Goods_Specifications:98]UPC_encoded:76#[Finished_Goods:26]UPC:37)
							Core_ObjectSetColor(->[Finished_Goods_Specifications:98]UPC_encoded:76; -(Red:K11:4))
						End if 
						
						If (Length:C16([Finished_Goods_Specifications:98]ColorSpecMaster:70)=0) & (Length:C16([Finished_Goods:26]ColorSpecMaster:77)>0)
							[Finished_Goods_Specifications:98]ColorSpecMaster:70:=[Finished_Goods:26]ColorSpecMaster:77
							[Finished_Goods_Specifications:98]CommentsFromQA:53:=" Color set to "+[Finished_Goods:26]ColorSpecMaster:77+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
						End if 
						
						If (Length:C16([Finished_Goods_Specifications:98]GlueDirection:73)=0) & (Length:C16([Finished_Goods:26]GlueDirection:104)>0)
							[Finished_Goods_Specifications:98]GlueDirection:73:=[Finished_Goods:26]GlueDirection:104
							[Finished_Goods_Specifications:98]CommentsFromQA:53:=" Glue set to "+[Finished_Goods_Specifications:98]GlueDirection:73+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
						End if 
						
						If ([Finished_Goods_Specifications:98]SizeAndStyleApproved:12="Yes")
							
						End if 
						
						If ([Finished_Goods_Specifications:98]Colors:80#!00-00-00!)
							cbColor:=1
						Else 
							cbColor:=0
						End if 
						
						If ([Finished_Goods_Specifications:98]ProcessColors:81)
							cbProcess:=1
						Else 
							cbProcess:=0
						End if 
						
						If ([Finished_Goods_Specifications:98]MatchPrint:82#!00-00-00!)
							cbMatch:=1
						Else 
							cbMatch:=0
						End if 
						
						If ([Finished_Goods_Specifications:98]HiRez:83#!00-00-00!)
							cbHiRez:=1
						Else 
							cbHiRez:=0
						End if 
						
						If ([Finished_Goods_Specifications:98]DatePreflighted:85#!00-00-00!)
							If ([Finished_Goods_Specifications:98]DateSubmitted:5=!00-00-00!)
								cbPFpass:=0
								cbPFfail:=1
							Else 
								cbPFpass:=1
								cbPFfail:=0
							End if 
						Else 
							cbPFpass:=0
							cbPFfail:=0
						End if 
					End if   // current control number
					
					QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=[Finished_Goods_Specifications:98]ColorSpecMaster:70)
					
					C_REAL:C285(r1; r2; r3)
					$num:=FG_PrepServiceTotalCharges([Finished_Goods_Specifications:98]ControlNumber:2; ->r1; ->r2; ->r3)
					CREATE SET:C116([Prep_Charges:103]; "allPrepCharges")
					C_LONGINT:C283(iServiceTabs; lastTab)
					lastTab:=Num:C11([Finished_Goods_Specifications:98]ServiceRequested:54)
					If (lastTab=0)
						lastTab:=7
					End if 
					
					If (lastTab#7)
						
						// ******* Verified  - 4D PS - January  2019 ********
						
						QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=lastTab)
						
						
						// ******* Verified  - 4D PS - January 2019 (end) *********
						
					End if 
					SELECT LIST ITEMS BY POSITION:C381(iServiceTabs; lastTab)
					zwStatusMsg("PREP CHARGES"; String:C10(lastTab)+" ")
					ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]SortOrder:12; >)  //[PrepCharges]PrepItemNumber;>)
					
					QUERY:C277([Customers:16]; [Customers:16]ID:1=Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5))
					uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
					
					QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Finished_Goods_Specifications:98]ProjectNumber:4)
					//FG_QAs_Records 
					FG_PrepServiceProofRead
					FG_PrepServiceSetControls
					
					FG_PrepServiceSetState
					USE SET:C118("allPrepCharges")
					FG_PrepServiceSetSecurity
					
					//Else 
					//uConfirm ("WARNING: "+[Finished_Goods_Specifications]FG_Key+" is set to Control# "+[Finished_Goods]ControlNumber+". Supercede "+[Finished_Goods_Specifications]ControlNumber+"?";"Supercede";"Abort")
					//If (ok=1)
					//$comment:=FG_PrepServiceSupercede ([Finished_Goods_Specifications]ControlNumber)
					//End if  
					//CANCEL
					//End if 
					//End if 
					
				Else 
					uConfirm([Finished_Goods_Specifications:98]FG_Key:1+" was locked."; "OK"; "Dang")
					CANCEL:C270
				End if 
				
			Else 
				uConfirm([Finished_Goods_Specifications:98]FG_Key:1+" was not found in the [Finished_Goods] table."; "OK"; "Dang")
				CANCEL:C270
			End if 
			
		Else 
			uConfirm("Go to the Projects page and click the Art tab, then click new, copy, or make like"+"."; "OK"; "Help")
			CANCEL:C270
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		//in trigger now FG_PrepSetPrepDone   `FG_PrepServiceStateChange `uUpdateTrail
		FG_PrepServiceSetFGrecord([Finished_Goods_Specifications:98]ControlNumber:2)
		// ///////////// STATE CHANGE EMAILS  ////////////////
		If ([Finished_Goods_Specifications:98]Hold:62) & (Not:C34(Old:C35([Finished_Goods_Specifications:98]Hold:62)))  //send email
			FG_PrepServiceEmail("On Hold")
		End if 
		
		If (Not:C34([Finished_Goods_Specifications:98]Hold:62)) & (Old:C35([Finished_Goods_Specifications:98]Hold:62))  //send email
			FG_PrepServiceEmail("Off Hold")
		End if 
		
		If (Not:C34([Finished_Goods_Specifications:98]AdditionalReqs:69)) & (Old:C35([Finished_Goods_Specifications:98]AdditionalReqs:69))  //send email
			READ WRITE:C146([Prep_Charges:103])
			USE SET:C118("allPrepCharges")
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=(Num:C11([Finished_Goods_Specifications:98]ServiceRequested:54)); *)
			QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityQuoted:2=0; *)
			QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityRevised:10=0; *)
			QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityActual:3=0)
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			
			util_DeleteSelection(->[Prep_Charges:103])
			USE SET:C118("allPrepCharges")
			// ******* Verified  - 4D PS - January  2019 ********
			QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=(Num:C11([Finished_Goods_Specifications:98]ServiceRequested:54)))
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]DateDone:14:=4D_Current_date)
			
			FG_PrepServiceEmail("Additional Reqs Done")
		End if 
		
		If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!) & (Old:C35([Finished_Goods_Specifications:98]DatePrepDone:6)=!00-00-00!)  //send email
			FG_PrepServiceEmail("PREP DONE")
		End if 
		
		If ([Finished_Goods_Specifications:98]DateProofRead:7#!00-00-00!) & (Old:C35([Finished_Goods_Specifications:98]DateProofRead:7)=!00-00-00!)  // Added by: Mel Bohince (5/30/19) email for proofreading
			FG_PrepServiceEmail("PROOFREAD")
		End if 
		
		REDUCE SELECTION:C351([Prep_Charges:103]; 0)
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		CLEAR SET:C117("allPrepCharges")
		
	: (Form event code:C388=On Unload:K2:2)
		CLEAR SET:C117("allPrepCharges")
		REDUCE SELECTION:C351([Prep_Charges:103]; 0)
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		wWindowTitle("pop")
End case 