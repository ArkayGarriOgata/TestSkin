//%attributes = {}
//Method:  Arky_Prcs_Initialize(tStatus{;pOption1})
//Description:  This method will inititlaize the values for the
//  Arky_Prcs form it is often called from a button where the only 
//  event is on_Load.  It doesn't look for a form event so that
//  the form can be reinitialized without having to execute a
//  form event.

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tPhase)
	
	C_TEXT:C284($tItem)
	C_TEXT:C284($tTableName; $tQuery)
	
	C_LONGINT:C283($nItemReference; $nItem; $nSubListReference)
	
	C_BOOLEAN:C305($bExpanded)
	
	$tPhase:=$1
	
	$tTableName:=Table name:C256(->[Arky_Process:68])
	$tQuery:=CorektBlank
	
End if   //Done initialization

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		//Picture button object names
		Form:C1466.ktProcess:="Process"
		Form:C1466.ktHome:="Home"
		Form:C1466.ktSales:="Sales"
		Form:C1466.ktCustomerService:="Customer Service"
		Form:C1466.ktProduction:="Production"
		Form:C1466.ktWarehouse:="Warehouse"
		
		//Must match the page numbers of the Story Boards
		Form:C1466.cPage:=New collection:C1472(\
			"Page Zero"; \
			Form:C1466.ktProcess; \
			Form:C1466.ktHome; \
			Form:C1466.ktSales; \
			Form:C1466.ktCustomerService; \
			Form:C1466.ktProduction; \
			Form:C1466.ktWarehouse)
		
		Arky_Prcs_Home
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		GET LIST ITEM:C378(CorenHList2; *; $nItemReference; $tItem; $nSubListReference; $bExpanded)
		
		$nItem:=Find in array:C230(Arky_atPrcs_Title; $tItem)
		
		If ($nItem>0)  //Title
			
			OBJECT SET TITLE:C194(*; "Title"; Arky_atPrcs_Title{$nItem})
			
			$tQuery:="Arky_Process_Key = "+Arky_atPrcs_ArkyProcessKey{$nItem}
			
			$esArkyProcess:=ds:C1482[$tTableName].query($tQuery)
			
			Case of   //Unique
					
				: ($esArkyProcess.length#1)
					
				: (Not:C34(OB Is defined:C1231($esArkyProcess; "WriteProDocument")))
					
				Else   //Valid
					
					WP INSERT DOCUMENT:C1411(Arky_uPrcs_WriteProDocument; $esArkyProcess.WriteProDocument; wk replace:K81:177)
					
			End case   //Done unique
			
		End if   //Done title
		
	: ($tPhase=CorektPhaseClear)
		
		
End case   //Done phase
