//%attributes = {}
//Method:  Batch_CheckBatchRunner({bRunProcess})
//Description:  This method verifies if the batch client is logged into aMs
//  and is set to run at 11:00 PM every day
//  This gets called from the On Server Startup database method and starts a new process: "Batch_CheckBatchRunner"
//  The first thing it does is pause itself until 10:00 PM current date
//  At 10:00 PM it checks the following:
//     1. The batch client is logged in (false - send email to launch the client)
//     2. The process bBatch_Runner is running on the client and logged in as administrator (false - send email to start batch runner)
//     3. The date and time to run the batch is set to current date and time 10:45 PM. (false - send email to reset date and time to current at 11:00 PM)

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($1; $bStartProcess)
	
	C_LONGINT:C283($nNumberOfParameters; $nCheckProcessID)
	C_LONGINT:C283($rDelay5Minutes)
	C_REAL:C285($rDelayInTicks)
	
	C_BOOLEAN:C305($bStartProcess; $bBatchRunner)
	
	C_TEXT:C284($tCurrentMethodName; $tDistributionList)
	C_TEXT:C284($tProcessName; $tServer)
	
	C_TIME:C306($hDelayUntilTime; $hkCheckAt; $hkNextRunAt)
	
	C_OBJECT:C1216($oRunner)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$bStartProcess:=($nNumberOfParameters=0)
	$bRunProcess:=False:C215
	
	If ($nNumberOfParameters>=1)
		$bRunProcess:=$1
	End if 
	
	$hkNextRunAt:=?23:00:00?  //Always start batch at 11:00:00 PM
	$hkCheckAt:=?22:00:00?  //Always start checking at 10:00:00 PM
	
	$rDelay5Minutes:=5*(60*60)
	
	$oRunner:=New object:C1471()
	
	Batch_CheckBatchRunnerSet(->$oRunner)
	
	$tCurrentMethodName:=Current method name:C684
	
	$tDistributionList:="garri.ogata@arkay.com"
	
End if   //Done initialize

Case of   //Start or run process
		
	: ($bStartProcess)  //Start process
		
		$nCheckProcessID:=New process:C317($tCurrentMethodName; <>lMinMemPart; $tCurrentMethodName; True:C214; *)
		
	: ($bRunProcess)  //Run process
		
		$nCheckProcessID:=Current process:C322
		
		While (Not:C34(<>fQuit4d))  //Quit
			
			Case of   //Check batch runner
					
				: (Current time:C178(*)<$hkCheckAt)  //Wait till ok to check
					
					$rDelayInTicks:=Core_Time_DelayUntilR($hkCheckAt)
					
					DELAY PROCESS:C323($nCheckProcessID; $rDelayInTicks)
					
					Batch_CheckBatchRunnerSet(->$oRunner)
					
				: ($oRunner.nBatchProcess=0)  //Batch Runner process is not running
					
					EMAIL_Sender(\
						"[UsSp] - Batch Runner is not running"; \
						"Make sure to start Batch Runner"; \
						"Log into aMs Batch Client and click on DBA - Batch Runner"; \
						$tDistributionList)
					
					DELAY PROCESS:C323($nCheckProcessID; $rDelay5Minutes)
					
					Batch_CheckBatchRunnerSet(->$oRunner)
					
				: (Not:C34($oRunner.bAdministrator))
					
					EMAIL_Sender(\
						"[UsSp] - Batch Runner is not logged in as Administrator"; \
						"Make sure to Restart Batch Runner"; \
						"Need to relaunch aMs batch client. Login as Administrator"; \
						$tDistributionList)
					
				Else   //Check next time it will run
					
					$dDelayUntilDate:=!00-00-00!
					$hDelayUntilTime:=?00:00:00?
					
					GET PROCESS VARIABLE:C371($oRunner.nBatchProcess; delayUntilDate; $dDelayUntilDate)
					GET PROCESS VARIABLE:C371($oRunner.nBatchProcess; delayUntilTime; $hDelayUntilTime)
					
					Case of   //Next schedule run is set
							
						: ((Current time:C178(*)>$hkNextRunAt))  //Delay till midnight
							
							$rDelayInTicks:=Core_Time_DelayUntilR(?24:00:00?)
							
							DELAY PROCESS:C323($nCheckProcessID; $rDelayInTicks)
							
							Batch_CheckBatchRunnerSet(->$oRunner)
							
						: (($dDelayUntilDate#Current date:C33(*)) | ($hDelayUntilTime#$hkNextRunAt))  //Send email to reset date and time
							
							EMAIL_Sender(\
								"[UsSp] - Batch date time reset"; \
								"Date and time needs to be reset"; \
								"Make sure this runs daily at 11:00 PM."; \
								$tDistributionList)
							
							DELAY PROCESS:C323($nCheckProcessID; $rDelay5Minutes)
							
							Batch_CheckBatchRunnerSet(->$oRunner)
							
						Else   //Check every 5 minutes
							
							DELAY PROCESS:C323($nCheckProcessID; $rDelay5Minutes)
							
							Batch_CheckBatchRunnerSet(->$oRunner)
							
					End case   //Done next scheduled run is set
					
			End case   //Done check batch runner
			
		End while   //Done quit
		
End case   //Done start or run process
