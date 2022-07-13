//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/23/13, 09:34:52
// ----------------------------------------------------
// Method: Est_PandBCheckProbs
// The button, bShowProbs is set to invisible by default. 
// It is only shown if there is a problem and/or the manager needs to see it.
// ----------------------------------------------------

Case of 
	: ((User in group:C338(Current user:C182; "SalesManager")) & (BLOB size:C605([Job_Forms:42]PandGProblems:83)#0))
		//SetObjectProperties ("";->bShowProbs;True)
		
	: ([Job_Forms:42]PandGProbsCkByMgr:84)  //The estimate has been looked over by the manager and the estimator can view the problems for reference.
		//SetObjectProperties ("";->bShowProbs;True;"Review Problems";True)
		
End case 