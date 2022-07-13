//%attributes = {"publishedWeb":true}
//Procedure: Job_Form(msg;form or size;cost;cost)  120397  MLB
//create a jobform structure
//•011298  MLB  UPR 1914, make room for in-period revenue
//•052098  MLB  missing array in sort
//•052098  MLB  deal with conversion costs

C_TEXT:C284($1)
C_TEXT:C284($2)
C_REAL:C285($3; $0; $4)
C_LONGINT:C283($hit)
C_TEXT:C284($cr)

$cr:=Char:C90(13)

Case of 
	: ($1="cost")
		$hit:=Find in array:C230(aJob; $2)
		If ($hit=-1)  //not found, so create and initialize salesvalue     
			$hit:=Job_Form("new"; $2; $3)
		End if 
		aTotalCost{$hit}:=aTotalCost{$hit}+$3
		$0:=$hit
		
	: ($1="cc")
		$hit:=Find in array:C230(aJob; $2)
		If ($hit=-1)  //not found, so create and initialize salesvalue     
			$hit:=Job_Form("new"; $2; $3)
		End if 
		$cc:=String:C10($3)
		If (Position:C15($cc; aTickFrom{$hit})=0)
			aTickFrom{$hit}:=aTickFrom{$hit}+$cc+" "
		End if 
		
	: ($1="roanC")
		$hit:=Find in array:C230(aJob; $2)
		If ($hit=-1)  //not found, so create and initialize salesvalue     
			$hit:=Job_Form("new"; $2; $3)
		End if 
		aRoanLabor{$hit}:=aRoanLabor{$hit}+$3
		aRoanBurden{$hit}:=aRoanBurden{$hit}+$4
		aTotalCost{$hit}:=aTotalCost{$hit}+$3+$4
		$0:=$hit
		
	: ($1="haupC")
		$hit:=Find in array:C230(aJob; $2)
		If ($hit=-1)  //not found, so create and initialize salesvalue     
			$hit:=Job_Form("new"; $2; $3)
		End if 
		aHaupLabor{$hit}:=aHaupLabor{$hit}+$3
		aHaupBurden{$hit}:=aHaupBurden{$hit}+$4
		aTotalCost{$hit}:=aTotalCost{$hit}+$3+$4
		$0:=$hit
		
	: ($1="Bill")
		$hit:=Find in array:C230(aJob; $2)
		If ($hit=-1)  //not found, so create and initialize cost   
			$hit:=Job_Form("new2"; $2; $3)
		End if 
		aRevPeriod{$hit}:=aRevPeriod{$hit}+$3
		
	: ($1="init")
		ARRAY TEXT:C222(aJob; Num:C11($2))  //key
		ARRAY REAL:C219(aTotalCost; Num:C11($2))  //total cost for this job
		ARRAY REAL:C219(aSalesValue; Num:C11($2))  //total Revenue projected for this job
		//•011298  MLB  UPR 1914
		ARRAY REAL:C219(aRevPeriod; Num:C11($2))  //revenue realized for job in specific period
		ARRAY REAL:C219(aMaterial; Num:C11($2))  //•052098  MLB  so we can use conversion cost only
		
		ARRAY REAL:C219(aRoanLabor; Num:C11($2))  //•052098  MLB  so we can use conversion cost only
		ARRAY REAL:C219(aRoanBurden; Num:C11($2))  //•052098  MLB  so we can use conversion cost only
		ARRAY REAL:C219(aHaupLabor; Num:C11($2))  //•052098  MLB  so we can use conversion cost only
		ARRAY REAL:C219(aHaupBurden; Num:C11($2))  //•052098  MLB  so we can use conversion cost only
		ARRAY TEXT:C222(aTickFrom; Num:C11($2))
		
	: ($1="new")
		$hit:=Job_FormInit($2)
		$0:=$hit
		
	: ($1="new2")
		$hit:=Job_FormInit($2; "save set")
		$0:=$hit
		
	: ($1="sort")  //get rid of empty slots
		SORT ARRAY:C229(aJob; aTotalCost; aSalesValue; aRevPeriod; aMaterial; aRoanLabor; aRoanBurden; aHaupLabor; aHaupBurden; aTickFrom; >)
		
	: ($1="pack")  //get rid of empty slots
		SORT ARRAY:C229(aJob; aTotalCost; aSalesValue; aRevPeriod; aMaterial; aRoanLabor; aRoanBurden; aHaupLabor; aHaupBurden; aTickFrom; <)  // `•052098  MLB  missing array in sort
		$hit:=Find in array:C230(aJob; "")
		//TRACE
		Job_Form("init"; String:C10($hit-1))
		
	Else 
		BEEP:C151
		ALERT:C41($1+" message not supported by Job_Form")
		
End case 