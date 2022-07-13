//(lop) EffeiencySum
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		rReal1:=[Job_Forms_Machine_Tickets:61]Good_Units:8  //aItem{Selected record number([MachineTicket])}  `production
		//rReal2  Act MR
		rReal3:=[Job_Forms_Machine_Tickets:61]MR_AdjStd:14  //Std Mr
		//rReal4  Mr Eff
		//rReal5 Act Run
		rReal6:=[Job_Forms_Machine_Tickets:61]Run_AdjStd:15  //Run Std
		//rReal7 Run Eff
		//rReal8  Tot Actual
		//rReal9 Total Std
		//rReal10 Tot Eff
		//rReal11 Down Time
		//rReal12   Down %
		rReal13:=ayDown_Bud{Selected record number:C246([Job_Forms_Machine_Tickets:61])}  //% down time
		//rReal14  Act Impressions/hr
		//    rReal15  Std Impres hr
		sCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
		xText:=aDesc{Selected record number:C246([Job_Forms_Machine_Tickets:61])}  //Cost center description
		
End case 

