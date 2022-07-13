//%attributes = {}
//Method:  Batch_0000_Explain
//Description:  This method will explain how the batch module works

//1. How to add user to batch emails
//.  A. Make sure to get the virtual factory email that user is to be added too
//.  B. Find the report in design and located it in bBatch_Runner add bullet to distributionList:=...
//.  C. Add it to Distribution List in the [y_batches] record
//.      when you add it will clear list, make sure to exit and come back in to assure it was added
//.  D. Test it via 2

//2. Test it
//.  A. Execute Batch_0000_Run("Name")
//.     Batch_0000_Run ("Daily Item Status")
//.  B. When it hits the bullet where distributionList is entered verify email is there

//3. How to add batch emails
//.  A. Create the record in [y_batches]
//.  B. Make sure the number before the name is above 1
//.  C. Step 4. Method bBatch_Runner

//4. Add Batch Method bBatch_Runner
//.   A. Find the For Loop //run every thing that is marked
//.   B. Find case statement : (asBull{$i}="X") & (aCustName{$i}="Jobs Missing Board")
//.   C. Use same values only change value of aCustName{$i}="Name")
//.   D. Create {Batch_MethodName}
//.   E. Create record to [y_batches] in method _VersionYYMMDD.
//.      There are examples in _VersionYYMMDD 
//.   F. From Batch client (Admin)
//.        1. Make sure to execute the _VersionYYMMDD
//.        2. Then from DBA click on Batch Runner button.
//.        3. Scroll list till you see the information.

//How we check Batch is running properly

//1.  Make sure the Batch is ready to run
//.      Batch_CheckBatchRunner (Stored proc running on the server)
//.           This method verifies if the batch client is logged into aMs
//            and is set to run at 11:00 PM every day
//.           It also checks that it is logged in as Administrator
//.           It is set to run at 10:00 PM everyday

//2.  Make sure the Batch ran correctly
//.      Batch_CheckSuccess
//.           This method is run as a side process to check
//.           that the batch reports run completely.
//.           It will be lauched with the batch reports are started.
//.           It uses the batch reports process ID and checks
//.           that it is no longer running after 60 Minutes

