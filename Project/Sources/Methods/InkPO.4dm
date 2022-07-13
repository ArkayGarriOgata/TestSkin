//%attributes = {"publishedWeb":true}
//(p) InkPO 6/1/98 cs created
//$1 - string - Jobform ID
//$2 - string - anything flag suppress print settings
//$0 - boolean - returns wether a report was actually printed
//This routine creates a PO for direct billing of ink
//to a specifed jobform.
//It will print a report, which is to be given to the INK company 
//rep on site.  
//The report is to be filled out by the Ink company empoyee indicating
//what amount of ink of each type was actually used by Arkay
//The completed form is then to be given to the receiving person
//who will then receive the qtys & types of ink as if the material were walking in
//• 6/8/98 cs validate Ink Material codes BEFORE creating PO header
//• 6/9/98 cs change from yesterday - re -vendor √
//   caused this to incorrectly report invalid Ink codes
//• 6/11/98 cs fixed the alert under condition where all ink Mat were bad said zer
//• 8/4/98 cs report sometimes fails to print
//•102798  MLB  UPR 1983 tidy up selections
//•010699  MLB  remove unnecessary sets, find PO# snatching problem
// Modified by: Mel Bohince (9/13/13)  auto issue

C_TEXT:C284($1; $JobForm)
C_TEXT:C284($2)
C_BOOLEAN:C305($Continue; $Printed; $0)
C_LONGINT:C283($Count; $i)

If (Not:C34(<>Auto_Ink_Issue))  // Modified by: Mel Bohince (9/13/13)  auto issue
	//READ WRITE([Purchase_Orders])
	//READ WRITE([Purchase_Orders_Items])
	//READ WRITE([Job_Forms])
	//READ WRITE([Purchase_Orders_Job_forms])
	//READ WRITE([Raw_Materials])  //• 8/6/98 cs made read only
	//NewWindow (250;50;0;-720)
	//MESSAGE("Collecting data for Ink Order Form..."+Char(13))
	//$JobForm:=$1
	//
	//If ([Job_Forms]JobFormID#$Jobform)
	//QUERY([Job_Forms];[Job_Forms]JobFormID=$JobForm)
	//End if 
	//
	//If ([Job_Forms]Status#"Closed") & ([Job_Forms]Status#"Completed")
	//CUT NAMED SELECTION([Job_Forms_Materials];"ThisJobForm")  //•010699  MLB 
	//QUERY([Job_Forms_Materials];[Job_Forms_Materials]JobForm=$jobForm;*)  //lcoate all ink budgeted for this jobform
	//QUERY([Job_Forms_Materials]; & ;[Job_Forms_Materials]Commodity_Key="02@")  //•102798  MLB  UPR 1983 add conjunction &
	//$Continue:=True
	//
	//If (Records in selection([Job_Forms_Materials])>0)  //there are budgeted ink
	//uRelateSelect (->[Raw_Materials]Raw_Matl_Code;->[Job_Forms_Materials]Raw_Matl_Code)  //• 6/8/98 cs locate & validate RM codes
	//
	//If (Records in selection([Raw_Materials])>0)
	//  //test that all inks on the job are in the rm itemmaster
	//ARRAY TEXT($aBudgetRm;0)
	//ARRAY TEXT($aRawRm;0)
	//SELECTION TO ARRAY([Job_Forms_Materials]Raw_Matl_Code;$aBudgetRm)
	//SELECTION TO ARRAY([Raw_Materials]Raw_Matl_Code;$aRawRm)
	//$Size:=Size of array($aBudgetRm)
	//$Count:=0
	//xText:=""
	//
	//For ($i;1;$Size)
	//$Loc:=Find in array($aRawRm;$aBudgetRm{$i})
	//If ($Loc<0)  //nothing found - bad RM code
	//$Continue:=False
	//$Count:=$Count+1  //total number of bad RMs
	//xText:=xText+"'"+Replace string($aBudgetRm{$i};" ";"^")+"'"+Char(13)
	//End if 
	//End for 
	//
	//Else   //all inks missing in item master
	//$Continue:=False
	//$Count:=Records in selection([Job_Forms_Materials])  //• 6/11/98 cs
	//xText:="None of the budget ink were found in the R/M item master."  //•010699  MLB 
	//End if   //inks in item master
	//
	//If ($Continue)  //valid material codes
	//If ([Job_Forms]InkPONumber="")  //no po for this jobform
	//$PO:=InkPoCreate   //create a Po Header
	//[Job_Forms]InkPONumber:=$PO
	//SAVE RECORD([Job_Forms])  //need to do this here since PO has been created
	//$New:=True
	//REDUCE SELECTION([Purchase_Orders_Items];0)  //•102798  MLB  UPR 1983 tidy up
	//Else   //po exists remove recreate items
	//$PO:=[Job_Forms]InkPONumber
	//$New:=False
	//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]PONo=$PO;*)  //delete any prior unused inks
	//QUERY([Purchase_Orders_Items]; & ;[Purchase_Orders_Items]Qty_Received<=0)
	//
	//If (Records in selection([Purchase_Orders_Items])>0)  //• 8/6/98 cs try to get this form to printevery time
	//uRelateSelect (->[Purchase_Orders_Job_forms]POItemKey;->[Purchase_Orders_Items]POItemKey)  //remove PO_item job links
	//util_DeleteSelection (->[Purchase_Orders_Items])  //uDelSelection (->[PO_Items])
	//util_DeleteSelection (->[Purchase_Orders_Job_forms])  //uDelSelection (->[POitJobFormLink])  `•102798  MLB  UPR 1983 move inside this if
	//End if 
	//
	//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]PONo=$PO)  //get any remaining PO Items
	//End if   //new po
	//
	//$Dollars:=0
	//ARRAY TEXT(aSubgroup;0)  //used to satisfy urmtopoitem
	//$Dollars:=InkPOItemCreate ($PO;$i;"*")
	//RELATE MANY([Purchase_Orders]PONo)  //get all items
	//
	//  //[Purchase_Orders]OrigOrderAmt:=$Dollars
	//  //[Purchase_Orders]ChgdOrderAmt:=$Dollars
	//PO_setExtendedTotals ("all")
	//SAVE RECORD([Purchase_Orders])
	//MESSAGE("Printing Ink requisition form...")
	//
	//PDF_setUp ("inkform"+$PO+".pdf")
	//If (Count parameters=2)
	//rInkOrderForm ($PO;$New;"*")  //print form for Ken, no print settings
	//Else 
	//rInkOrderForm ($PO;$New)  //print form for Ken, print settings    
	//End if 
	//$Printed:=True
	//REDUCE SELECTION([Purchase_Orders];0)
	//REDUCE SELECTION([Purchase_Orders_Items];0)
	//REDUCE SELECTION([Purchase_Orders_Job_forms];0)
	//Else   //there are invalid ink raw material codes    
	//uConfirm ("There are "+String($Count)+" Invalid Ink material codes for Jobform "+[Job_Forms]JobFormID+Char(13)+"Do You Want to print a list of these Inks?";"Print")
	//If (OK=1)
	//xTitle:="Invalid Ink Material codes for Jobform "+[Job_Forms]JobFormID
	//xText:=xText+Char(13)+Char(13)+"the '^' is replacing spaces so that if there is a leading or traling space"+" which is causing a problem you can see it."
	//rPrintText 
	//End if 
	//
	//$Printed:=False
	//OK:=0  //• 6/8/98 cs forgot on previous send
	//End if   //continue
	//
	//Else   //no inks
	//OK:=1
	//$Printed:=False  //return this as false so that print settings are displayed for job bag
	//End if 
	//USE NAMED SELECTION("ThisJobForm")  //replace set of materials to job form`•010699  MLB
	//End if 
	//CLOSE WINDOW
	//$0:=$Printed
End if 