//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gListMTArray
// 12/19/94
// ----------------------------------------------------

If (Size of array:C274(adMADate)>0)
	j:=adMADate
	If (j>0)
		dMADate:=adMADate{j}
		sMAJob:=asMAJob{j}
		iMASeq:=aiMASeq{j}
		sMACC:=asMACC{j}
		If (Position:C15(sMACC; <>GLUERS)#0)
			SetObjectProperties(""; ->iMAItemNo; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("item@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		Else 
			SetObjectProperties(""; ->iMAItemNo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("item@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		End if 
		
		iMAItemNo:=aiMAItemNo{j}
		iShift:=aiShift{j}
		rMAMRHours:=arMAMRHours{j}
		If (rMAMRHours#0)
			SetObjectProperties(""; ->tMRcode; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("mr@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		Else 
			SetObjectProperties(""; ->tMRcode; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("mr@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		End if 
		
		tMRcode:=aMRcode{j}
		rMARHours:=arMARHours{j}
		rMADTHours:=arMADTHours{j}
		If (rMADTHours#0)
			SetObjectProperties(""; ->sMADTCat; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("dt@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		Else 
			SetObjectProperties(""; ->sMADTCat; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			SetObjectProperties("dt@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		End if 
		
		sMADTCat:=asMADTCat{j}
		lMAGood:=alMAGood{j}
		lMAWaste:=alMAWaste{j}
		sP_C:=asP_C{j}
		fNewMT:=False:C215
		
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12(sMAJob; 1; 5))))
		SET QUERY LIMIT:C395(0)
		sCustName:=[Jobs:15]CustomerName:5
	Else 
		gClearMT(dMADate)
	End if 
End if 