// ----------------------------------------------------
// Method: [Finished_Goods_PackingSpecs].Input
// ----------------------------------------------------
// Modified by: Mel Bohince (3/19/20) update fg and rels in case packing changes
// Modified by: MelvinBohince (3/31/22) skip the email when there is a case cnt change

Case of 
	: (Form event code:C388=On Load:K2:1)
		PackingSpecComments("Init")  // Added by: Mark Zinke (10/24/13) 
		//FGArrays ("init";0)
		C_OBJECT:C1216(fgEntSel)
		//[Finished_Goods]PackingSpecification
		
		// Modified by: Mel Bohince (3/19/20) switch to entity listbox for related fg's
		//get any related fg recs to put in listbox and later update if needed
		fgEntSel:=ds:C1482.Finished_Goods_PackingSpecs.query("FileOutlineNum =:1"; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1).FINISHED_GOODS
		
		If ([Finished_Goods_PackingSpecs:91]CaseCount:2>0)  //add restrictions
			If (User in group:C338(Current user:C182; "PackingSpecMgr"))
				SetObjectProperties("restrictCS@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "restrictCS@"; True:C214)
			Else 
				SetObjectProperties("restrictCS@"; -><>NULL; True:C214; ""; False:C215; White:K11:1; Black:K11:16)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "restrictCS@"; False:C215)
			End if 
		End if 
		
		If ([Finished_Goods_PackingSpecs:91]CasesPerSkid:29>0)  //add restrictions
			If (User in group:C338(Current user:C182; "PackingSpecMgr"))
				SetObjectProperties("restrictSK@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "restrictSK@"; True:C214)
			Else 
				SetObjectProperties("restrictSK@"; -><>NULL; True:C214; ""; False:C215; White:K11:1; Black:K11:16)  // Modified by: Mark Zinke (5/13/13)
				OBJECT SET ENABLED:C1123(*; "restrictSK@"; False:C215)
			End if 
		End if 
		cb1:=0
		cb2:=0
		cb3:=0
		rb1:=0
		rb2:=0
		
		Case of   //mullen strength
			: ([Finished_Goods_PackingSpecs:91]MullenStrength:13="200")
				cb1:=1
			: ([Finished_Goods_PackingSpecs:91]MullenStrength:13="250")
				cb2:=1
			: ([Finished_Goods_PackingSpecs:91]MullenStrength:13="275")
				cb3:=1
		End case 
		
		Case of   //fixed/variable
			: ([Finished_Goods_PackingSpecs:91]FixedOrCanChange:11="Fixed")
				rb1:=1
			: ([Finished_Goods_PackingSpecs:91]FixedOrCanChange:11="Variable")
				rb2:=1
		End case 
		
		If (Is new record:C668([Finished_Goods_PackingSpecs:91]))
			[Finished_Goods_PackingSpecs:91]TopPadMaterial:16:="SBS"
			SetObjectProperties("restricted@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			OBJECT SET ENABLED:C1123(*; "restricted@"; True:C214)
			GOTO OBJECT:C206([Finished_Goods_PackingSpecs:91]FileOutlineNum:1)
		Else 
			//$numFGs:=qryFinishedGood ("#PACK";[Finished_Goods_PackingSpecs]FileOutlineNum)
			//  //FGArrays ("load")
			//$numFGs:=qryFinishedGood ("#SiZE";"0")
		End if 
		
		iQty:=0
		sJobit:=""
		If (Length:C16(<>JOBIT)=0)
			OBJECT SET ENABLED:C1123(cb1; False:C215)
		Else 
			sJobit:=<>JOBIT
			If ([Finished_Goods_PackingSpecs:91]CaseCount:2#0)
				READ ONLY:C145([Job_Forms_Items:44])
				$numJMI:=qryJMI(sJobit)
				If ($numJMI>0)
					iQty:=Round:C94([Job_Forms_Items:44]Qty_Yield:9/[Finished_Goods_PackingSpecs:91]CaseCount:2; 0)
				End if 
			End if 
			OBJECT SET ENABLED:C1123(cb1; True:C214)
		End if 
		RMcode:=[Finished_Goods_PackingSpecs:91]RM_Code:36
		dDateBegin:=4D_Current_date+1
		
	: (Form event code:C388=On Validate:K2:3)
		[Finished_Goods_PackingSpecs:91]ModDate:37:=4D_Current_date
		[Finished_Goods_PackingSpecs:91]ModWho:38:=<>zResp
		
		If (False:C215)  // Modified by: MelvinBohince (3/31/22) skip
			
			If (Old:C35([Finished_Goods_PackingSpecs:91]CaseCount:2)#[Finished_Goods_PackingSpecs:91]CaseCount:2)  //warn someone
				$subject:="PackSpec Chg "+[Finished_Goods_PackingSpecs:91]FileOutlineNum:1
				$distribList:="mel.bohince@arkay.com,"  //anna.soto@arkay.com, 
				$body:="Was: "+String:C10(Old:C35([Finished_Goods_PackingSpecs:91]CaseCount:2))+" Now: "+String:C10([Finished_Goods_PackingSpecs:91]CaseCount:2)+Char:C90(13)
				$body:=$body+"Case Comment: "+[Finished_Goods_PackingSpecs:91]CaseComment:21+Char:C90(13)
				$body:=$body+"Variations: "+[Finished_Goods_PackingSpecs:91]Variations:10+Char:C90(13)
				$body:=$body+"Following product codes may be effected: "+Char:C90(13)
				//For ($i;1;Size of array(aFGkey))
				//$body:=$body+aFGkey{$i}+" - "+aLine{$i}+Char(13)
				//End for 
				For each ($fgObj; fgEntSel)
					$body:=$body+$fgObj.FG_KEY+" - "+$fgObj.Line_Brand+Char:C90(13)
				End for each 
				EMAIL_Sender($subject; ""; $body; $distribList)
			End if 
		End if   //false
		
		//FGArrays ("case";iCnt)
		C_LONGINT:C283($caseCount)
		$caseCount:=[Finished_Goods_PackingSpecs:91]CaseCount:2
		C_OBJECT:C1216($fgObj; $fgsToChgEntSel; $success; $rels_es; $relObj)
		$fgsToChgEntSel:=fgEntSel.query("PackingQty # :1"; $caseCount)
		zwStatusMsg("Updating FG"; "Setting "+String:C10($fgsToChgEntSel.length)+" case counts to "+String:C10($caseCount))
		For each ($fgObj; $fgsToChgEntSel)
			$fgObj.PackingQty:=$caseCount
			$success:=$fgObj.save(dk auto merge:K85:24)
			//notify the open firm releases
			$rels_es:=ds:C1482.Customers_ReleaseSchedules.query("ProductCode = :1 and OpenQty > 0 and CustomerRefer # :2"; $fgObj.ProductCode; "<@")
			For each ($relObj; $rels_es)
				$relObj.TrackingComment:="!!!CaseQty changed to "+String:C10($caseCount)+" on "+String:C10(4D_Current_date)+"!!!\r\r"+$relObj.TrackingComment
				$success:=$relObj.save(dk auto merge:K85:24)  //trigger will calc lot multiple
			End for each 
		End for each 
		zwStatusMsg("Updating FG"; "Finished Setting "+String:C10($fgsToChgEntSel.length)+" case counts to "+String:C10($caseCount))
		
	: (Form event code:C388=On Close Box:K2:21)
		//FGArrays ("case";iCnt)
		ACCEPT:C269
End case 