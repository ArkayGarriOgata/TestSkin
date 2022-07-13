//%attributes = {}
//Method: Arcv_Delete ({oQuery})
//Description: This method will delete the [Archive] and [Arcv_Table] records

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oQuery)
	
	C_BOOLEAN:C305($bDrop)
	
	C_OBJECT:C1216($esArchive)
	C_OBJECT:C1216($esArcvTable)
	
	C_OBJECT:C1216($esArchiveLeft)
	C_OBJECT:C1216($esArcvTableLeft)
	
	C_OBJECT:C1216($oConfirm)
	
	$oQuery:=New object:C1471()
	
	If (Count parameters:C259=1)
		
		$oQuery:=$1
		
	End if 
	
	$bDrop:=True:C214
	
	$esArchive:=New object:C1471()
	$esArcvTable:=New object:C1471()
	
	$esArchiveLeft:=New object:C1471()
	$esArcvTableLeft:=New object:C1471()
	
	$oConfirm:=New object:C1471()
	
	$oConfirm.tMessage:="Are you sure you want to delete all the records from [Archive] and [Arcv_Table]?"
	
	$oConfirm.tDefault:="NO"
	$oConfirm.tCancel:="Delete"
	
End if   //Done initialize

Case of   //Confirm
		
	: (Core_Dialog_ConfirmN($oConfirm)=CoreknDefault)
		
		$bDrop:=False:C215
		
	: (OB Is defined:C1231($oQuery; "Property1"))  //Query
		
		//In Future add
		//and change confirm message
		
	Else   //All
		
		$esArchive:=ds:C1482.Archive.all()
		$esArcvTable:=ds:C1482.Arcv_Table.all()
		
End case   //Done confirm

If ($bDrop)  //Drop
	
	$esArchiveLeft:=$esArchive.drop()
	$esArcvTableLeft:=$esArcvTable.drop()
	
	ALERT:C41(String:C10($esArchiveLeft.length)+" Archive Left")
	ALERT:C41(String:C10($esArcvTableLeft.length)+" Arcv_Table Left")
	
End if   //Done drop
