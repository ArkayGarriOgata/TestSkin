// _______
// Method: [Finished_Goods_SizeAndStyles].Input   ( ) ->
// ----------------------------------------------------
// Modified by: Mel Bohince (10/15/21) add delimitor before appending to Batch_GetDistributionList

Case of 
	: (Form event code:C388=On Load:K2:1)
		rfc_OnLoadForm
		
	: (Form event code:C388=On Close Box:K2:21)
		ACCEPT:C269
		//RM_BuildStockList ("kill")
		
	: (Form event code:C388=On Validate:K2:3)
		// ///////////// STATE CHANGE EMAILS  ////////////////
		$sendMail:=""
		If ([Finished_Goods_SizeAndStyles:132]Hold:59) & (Not:C34(Old:C35([Finished_Goods_SizeAndStyles:132]Hold:59)))  //send email
			$sendMail:="On Hold"
		End if 
		
		If (Not:C34([Finished_Goods_SizeAndStyles:132]Hold:59)) & (Old:C35([Finished_Goods_SizeAndStyles:132]Hold:59))  //send email
			$sendMail:="Off Hold"
		End if 
		
		If (Length:C16($sendMail)>0)
			distributionList:=Batch_GetDistributionList($sendMail)+"\t"  // Modified by: Mel Bohince (10/15/21) 
			distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]PlannerID:5)+Char:C90(9)
			distributionList:=distributionList+Email_WhoAmI(""; [Customers:16]CustomerService:46)+Char:C90(9)
			$subject:=$sendMail+" S&S Notification"
			$body:="S&S file number "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" has been set "+$sendMail+Char:C90(13)
			$body:=$body
			$from:=Email_WhoAmI
			$subject:=$subject+" of "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" "+[Customers:16]Name:2
			EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
			zwStatusMsg("EMail"; $sendMail+" Notification has been sent to "+distributionList)
		End if 
		
		If ([Finished_Goods_SizeAndStyles:132]DateDone:6#Old:C35([Finished_Goods_SizeAndStyles:132]DateDone:6))
			If ([Finished_Goods_SizeAndStyles:132]DateDone:6#!00-00-00!)  //just marked as done
				rfc_taskCheckBox(->rfc_tasks_uncompleted; "not-done")  //
				If (Position:C15("0"; rfc_tasks_uncompleted)>0)  //some undone so create an additional request
					CREATE RECORD:C68([Finished_Goods_SnS_Additions:150])
					[Finished_Goods_SnS_Additions:150]FileOutlineNum:1:=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1
					[Finished_Goods_SnS_Additions:150]Addition_Num:2:=[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54
					rfc_additionalRequest
					SAVE RECORD:C53([Finished_Goods_SnS_Additions:150])
					
					rfc_taskCheckBox(->rfc_tasks_uncompleted; "reset")  //like rfc_resetWorkflow
					[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54:=[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54+1
					[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27:="== Unfinished Reqest "+String:C10([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54)+" =="+Char:C90(13)+" _______"+[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27
					
				End if 
				
				$subject:="Construction Request Done - "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" - "+String:C10([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54)+" - "+[Customers:16]Name:2
				$body:="The request regarding file outline: '"+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+"-"+String:C10([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54)+"' has been marked Done. "
				$body:=$body+"Line: "+[Finished_Goods_SizeAndStyles:132]Line:11+" Code#: "+[Finished_Goods_SizeAndStyles:132]CustomerCodeNumber:45
				
				$from:=Email_WhoAmI
				
				distributionList:=Email_GetDistribution([Finished_Goods_SizeAndStyles:132]CustID:52)  // Modified by: Mel Bohince (5/8/14) 
				//
				//distributionList:=Email_WhoAmI ("*";[Customers]CustomerService)+Char(9)
				//distributionList:=distributionList+Email_WhoAmI ("*";[Customers]PlannerID)+Char(9)
				//distributionList:=distributionList+Email_WhoAmI ("*";[Customers]SalesCoord)
				zwStatusMsg("EMail"; $subject+" has been sent to "+distributionList)
				EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
				
			Else   //just marked as undone
				//try to undo the havoc done above
				uConfirm("can't revert additional request that was auto created"; "contact mel"; "call x3186")
			End if 
		End if 
		
		If ([Finished_Goods_SizeAndStyles:132]Approved:9#Old:C35([Finished_Goods_SizeAndStyles:132]Approved:9))  //(Modified([Finished_Goods_SizeAndStyles]Approved))
			rfc_Approve
		End if 
End case 

