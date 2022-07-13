function fourD_Purchase_Orders(){
    
    var YES = 1;
    var NO = 0;
    var NSNotFound = -1;
    
    
	if (window.XMLHttpRequest) {
		this.xmlHttpReq = new XMLHttpRequest();
	}
	// IE
	else if (window.ActiveXObject) {
		this.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
	}
	this.ipAddress='localhost';
	this.portNumber='80';
	this.message='';
	this.binaryData = null;
	this.numParams = 0;
	this.fourDResponse = '';
	this.fourDError = '';
	this.onSuccess = null;
	this.onError = null;

    this.lastError = '';
    this.useSections = NO;
    this.sectionField = '';
    this.tableRows = new Array();
    this.sectionRowNames = new Array();
    this.sectionRows = new Array();
    this.currentRow = NO;
    
    
    	this.field4D_PONo = '';
	this.field4D_VendorID = '';
	this.field4D_DefaultJobId = '';
	this.field4D_PODate = '';
	this.field4D_ReqNo = '';
	this.field4D_ReqBy = '';
	this.field4D_Dept = '';
	this.field4D_FOB = '';
	this.field4D_Terms = '';
	this.field4D_ShipVia = '';
	this.field4D_Buyer = '';
	this.field4D_OrigOrderAmt = '';
	this.field4D_ChgdOrderAmt = '';
	this.field4D_AckRecdDate = '';
	this.field4D_Status = '';
	this.field4D_StatusBy = '';
	this.field4D_StatusDate = '';
	this.field4D_LastChgOrdNo = '';
	this.field4D_LastChgOrdDate = '';
	this.field4D_ShipInstruct = '';
	this.field4D_Comments = '';
	this.field4D_ConfirmingTo = '';
	this.field4D_ConfirmingBy = '';
	this.field4D_ConfirmingDate = '';
	this.field4D_ConfirmingNotes = '';
	this.field4D_ApprovedBy = '';
	this.field4D_Required = '';
	this.field4D_AttentionOf = '';
	this.field4D_ConfirmingOrder = '';
	this.field4D_Count = '';
	this.field4D_ModDate = '';
	this.field4D_ModWho = '';
	this.field4D_PO_Clauses = '';
	this.field4D_ShipTo1 = '';
	this.field4D_ShipTo2 = '';
	this.field4D_ShipTo3 = '';
	this.field4D_ShipTo4 = '';
	this.field4D_ShipTo5 = '';
	this.field4D_Released = '';
	this.field4D_ExpeditingNote = '';
	this.field4D_Std_Discount = '';
	this.field4D_VendorName = '';
	this.field4D_CompanyID = '';
	this.field4D_PurchaseApprv = '';
	this.field4D_NewVendor = '';
	this.field4D_ReqVendorID = '';
	this.field4D_Ordered = '';
	this.field4D_INX_autoPO = '';
	this.field4D_Printed = '';
	this.field4D_FaxStatus = '';
	this.field4D_StatusTrack = '';
	this.field4D_PercentComplete = '';
	this.field4D_ShippingOption = '';
	this.field4D__SYNC_ID = '';
	this.field4D_SupplyChainPO = '';
	this.field4D_DateApproved = '';
	this.field4D__SYNC_DATA = '';
	this.field4D_ChainOfCustody = '';
	this.field4D_pk_id = '';
    




this.tableNumber = function(){
        return 11;
    }
    
this.setLastError = function(ttError){
    this.lastError = ttError;
}
    
this.unloadRecord = function(){
        currentRow = -1;
        
    	this.field4D_PONo = '';
	this.field4D_VendorID = '';
	this.field4D_DefaultJobId = '';
	this.field4D_PODate = '';
	this.field4D_ReqNo = '';
	this.field4D_ReqBy = '';
	this.field4D_Dept = '';
	this.field4D_FOB = '';
	this.field4D_Terms = '';
	this.field4D_ShipVia = '';
	this.field4D_Buyer = '';
	this.field4D_OrigOrderAmt = '';
	this.field4D_ChgdOrderAmt = '';
	this.field4D_AckRecdDate = '';
	this.field4D_Status = '';
	this.field4D_StatusBy = '';
	this.field4D_StatusDate = '';
	this.field4D_LastChgOrdNo = '';
	this.field4D_LastChgOrdDate = '';
	this.field4D_ShipInstruct = '';
	this.field4D_Comments = '';
	this.field4D_ConfirmingTo = '';
	this.field4D_ConfirmingBy = '';
	this.field4D_ConfirmingDate = '';
	this.field4D_ConfirmingNotes = '';
	this.field4D_ApprovedBy = '';
	this.field4D_Required = '';
	this.field4D_AttentionOf = '';
	this.field4D_ConfirmingOrder = '';
	this.field4D_Count = '';
	this.field4D_ModDate = '';
	this.field4D_ModWho = '';
	this.field4D_PO_Clauses = '';
	this.field4D_ShipTo1 = '';
	this.field4D_ShipTo2 = '';
	this.field4D_ShipTo3 = '';
	this.field4D_ShipTo4 = '';
	this.field4D_ShipTo5 = '';
	this.field4D_Released = '';
	this.field4D_ExpeditingNote = '';
	this.field4D_Std_Discount = '';
	this.field4D_VendorName = '';
	this.field4D_CompanyID = '';
	this.field4D_PurchaseApprv = '';
	this.field4D_NewVendor = '';
	this.field4D_ReqVendorID = '';
	this.field4D_Ordered = '';
	this.field4D_INX_autoPO = '';
	this.field4D_Printed = '';
	this.field4D_FaxStatus = '';
	this.field4D_StatusTrack = '';
	this.field4D_PercentComplete = '';
	this.field4D_ShippingOption = '';
	this.field4D__SYNC_ID = '';
	this.field4D_SupplyChainPO = '';
	this.field4D_DateApproved = '';
	this.field4D__SYNC_DATA = '';
	this.field4D_ChainOfCustody = '';
	this.field4D_pk_id = '';
    
    }
    
this.init = function(){
    
        this.lastError = '';
        this.useSections = NO;
        this.sectionField = '';
        this.tableRows.length = 0;
        this.sectionRowNames.length = 0;
        this.sectionRows.length = 0;
        this.currentRow = -1;

        this.unloadRecord();
        
        
        
        //return this;
        
    }



    
this.getRecordsInSelection = function(){  // Returns INT
        return this.tableRows.length;
    }
    
this.gotoRecord = function(xlRow){  // Returns BOOL
        var fReturn = NO;
        if (xlRow < this.tableRows.length) {
            this.currentRow = xlRow;
            fReturn = YES;
            var recordData = this.tableRows[this.currentRow];  // NO NEED FOR JSON, Already parsed into objects
            
            		this.field4D_PONo = recordData.field4D_PONo;
		this.field4D_VendorID = recordData.field4D_VendorID;
		this.field4D_DefaultJobId = recordData.field4D_DefaultJobId;
		this.field4D_PODate = recordData.field4D_PODate;
		this.field4D_ReqNo = recordData.field4D_ReqNo;
		this.field4D_ReqBy = recordData.field4D_ReqBy;
		this.field4D_Dept = recordData.field4D_Dept;
		this.field4D_FOB = recordData.field4D_FOB;
		this.field4D_Terms = recordData.field4D_Terms;
		this.field4D_ShipVia = recordData.field4D_ShipVia;
		this.field4D_Buyer = recordData.field4D_Buyer;
		this.field4D_OrigOrderAmt = recordData.field4D_OrigOrderAmt;
		this.field4D_ChgdOrderAmt = recordData.field4D_ChgdOrderAmt;
		this.field4D_AckRecdDate = recordData.field4D_AckRecdDate;
		this.field4D_Status = recordData.field4D_Status;
		this.field4D_StatusBy = recordData.field4D_StatusBy;
		this.field4D_StatusDate = recordData.field4D_StatusDate;
		this.field4D_LastChgOrdNo = recordData.field4D_LastChgOrdNo;
		this.field4D_LastChgOrdDate = recordData.field4D_LastChgOrdDate;
		this.field4D_ShipInstruct = recordData.field4D_ShipInstruct;
		this.field4D_Comments = recordData.field4D_Comments;
		this.field4D_ConfirmingTo = recordData.field4D_ConfirmingTo;
		this.field4D_ConfirmingBy = recordData.field4D_ConfirmingBy;
		this.field4D_ConfirmingDate = recordData.field4D_ConfirmingDate;
		this.field4D_ConfirmingNotes = recordData.field4D_ConfirmingNotes;
		this.field4D_ApprovedBy = recordData.field4D_ApprovedBy;
		this.field4D_Required = recordData.field4D_Required;
		this.field4D_AttentionOf = recordData.field4D_AttentionOf;
		this.field4D_ConfirmingOrder = recordData.field4D_ConfirmingOrder;
		this.field4D_Count = recordData.field4D_Count;
		this.field4D_ModDate = recordData.field4D_ModDate;
		this.field4D_ModWho = recordData.field4D_ModWho;
		this.field4D_PO_Clauses = recordData.field4D_PO_Clauses;
		this.field4D_ShipTo1 = recordData.field4D_ShipTo1;
		this.field4D_ShipTo2 = recordData.field4D_ShipTo2;
		this.field4D_ShipTo3 = recordData.field4D_ShipTo3;
		this.field4D_ShipTo4 = recordData.field4D_ShipTo4;
		this.field4D_ShipTo5 = recordData.field4D_ShipTo5;
		this.field4D_Released = recordData.field4D_Released;
		this.field4D_ExpeditingNote = recordData.field4D_ExpeditingNote;
		this.field4D_Std_Discount = recordData.field4D_Std_Discount;
		this.field4D_VendorName = recordData.field4D_VendorName;
		this.field4D_CompanyID = recordData.field4D_CompanyID;
		this.field4D_PurchaseApprv = recordData.field4D_PurchaseApprv;
		this.field4D_NewVendor = recordData.field4D_NewVendor;
		this.field4D_ReqVendorID = recordData.field4D_ReqVendorID;
		this.field4D_Ordered = recordData.field4D_Ordered;
		this.field4D_INX_autoPO = recordData.field4D_INX_autoPO;
		this.field4D_Printed = recordData.field4D_Printed;
		this.field4D_FaxStatus = recordData.field4D_FaxStatus;
		this.field4D_StatusTrack = recordData.field4D_StatusTrack;
		this.field4D_PercentComplete = recordData.field4D_PercentComplete;
		this.field4D_ShippingOption = recordData.field4D_ShippingOption;
		this.field4D__SYNC_ID = recordData.field4D__SYNC_ID;
		this.field4D_SupplyChainPO = recordData.field4D_SupplyChainPO;
		this.field4D_DateApproved = recordData.field4D_DateApproved;
		this.field4D__SYNC_DATA = recordData.field4D__SYNC_DATA;
		this.field4D_ChainOfCustody = recordData.field4D_ChainOfCustody;
		this.field4D_pk_id = recordData.field4D_pk_id;
            
        }
        return fReturn;
    }
    
this.numberOfSections = function(){  // returns INT
        if (this.useSections === NO) {
            return 1;
        }else
            return this.sectionRowNames.length;
        
    }
    
this.numberOfRowsInSection = function(section){  // returns INT
        var xlReturn = NO;
        if (this.useSections === NO) {
            xlReturn = this.getRecordsInSelection();
        }else{
            if (section < this.sectionRows.length) {
                var sttRows = this.sectionRows[section];
                xlReturn = sttRows.length;
            }
        }
        return xlReturn;
    }
    
this.titleForSection = function(section){  // returns String
        var ttReturn = '';
        if (this.useSections === YES) {
            if (section < this.sectionRowNames.length)
                ttReturn = this.sectionRowNames[section];
        }
        
        return ttReturn;
        
    }
    
this.gotoRecordInSection = function(section, row){  // returns BOOL
        var fReturn = NO;
        
        if (this.useSections === NO) { // we are NOT using sections, so row is the actual row number in our selection
            fReturn = this.gotoRecord(row);
        }else{
            if (section<this.sectionRows.length) {
                var sttRows = this.sectionRows[section];
                if (row < sttRows.length) {
                    var xlGlobalRow = sttRows[row];
                    fReturn = this.gotoRecord(xlGlobalRow);
                }
            }
        }
        return fReturn;
    }
    
this.useSectionsOff = function(){
        this.useSections = NO;
        
    }
    
    
this.buildSections = function(){
        
    this.sectionRowNames.length = 0;
    
    
        var xlItems = this.getRecordsInSelection();
        
        for (var i=0; i<xlItems; i++) {
            var recordData = this.tableRows[i];  // No need for JSON, already parsed into Objects
            
            var ttFieldValue = recordData[this.sectionField];
            
            var xlIndex = this.sectionRowNames.indexOf(ttFieldValue);

            if (xlIndex === NSNotFound) {
                this.sectionRowNames.push(ttFieldValue);
            }
            
        }
        // we can sort an array of NSString using this syntax...

    this.sectionRowNames.sort();
    
        // Now, lets build our section rows
    this.sectionRows.length = 0;
        var xlSize = this.sectionRowNames.length;
    
        for (var i=0; i<xlSize; i++) {
            var sttRows = new Array();
            this.sectionRows.push(sttRows);
        }
        
        
        
        for (var i=0; i<xlItems; i++) {
            var recordData = this.tableRows[i];  // No need to JSON, already parsed into Objects
            
            var ttFieldValue = recordData[this.sectionField];
            
            var xlIndex = this.sectionRowNames.indexOf(ttFieldValue);

            if (xlIndex != NSNotFound) {
                this.sectionRows[xlIndex].push(i);
            }
            
        }
        
    }
    
    
    
this.useSectionsOnField = function(ttFieldName){
        this.useSections = YES;

    this.sectionField = ttFieldName;
        
     this.buildSections();
        
        
    }
    
this.setFieldValue = function(ttValue, ttField){
        if (this.currentRow >=0) {
            
            this.tableRows[currentRow][ttField] = ttValue;
            
            
        }
    }
    
this.showProgress = function(){
        var div = document.createElement('div');
        div.style.width = '64px';
        div.style.height = '64px';
        div.style.top = '50%';
        div.style.left = '50%';
        div.style.position = 'absolute';
        div.id = 'fourD_Purchase_OrdersProgress';
        
        div.innerHTML = '<img width="64px" height="64px" src="./js_4D/fourpg.gif"  /><h5 style="text-align:center">loading...</h5>';
        
        document.body.appendChild(div);
}
    
this.removeProgress = function(){
        var elem = document.getElementById('fourD_Purchase_OrdersProgress');
        elem.parentNode.removeChild(elem);
}
    
    
this.saveRecordWithKey = function(ttKey, ttPrefsIP, ttPrefsPort, successFunction, failFunction){ // Returns BOOL
    var fReturn = NO;
    var ttData = '';
    
    var theRequest=new FourDWebRequest();
	theRequest.initWithAddress(ttPrefsIP, ttPrefsPort,'4DWEB_SaveRecordWithKey');
	theRequest.addParameter('TableNumber', this.tableNumber());
	theRequest.addParameter('keyField', ttKey);
	theRequest.addParameter('event', 'Save');
    
    	theRequest.addParameter('field4D_PONo', this.field4D_PONo);
	theRequest.addParameter('field4D_VendorID', this.field4D_VendorID);
	theRequest.addParameter('field4D_DefaultJobId', this.field4D_DefaultJobId);
	theRequest.addParameter('field4D_PODate', this.field4D_PODate);
	theRequest.addParameter('field4D_ReqNo', this.field4D_ReqNo);
	theRequest.addParameter('field4D_ReqBy', this.field4D_ReqBy);
	theRequest.addParameter('field4D_Dept', this.field4D_Dept);
	theRequest.addParameter('field4D_FOB', this.field4D_FOB);
	theRequest.addParameter('field4D_Terms', this.field4D_Terms);
	theRequest.addParameter('field4D_ShipVia', this.field4D_ShipVia);
	theRequest.addParameter('field4D_Buyer', this.field4D_Buyer);
	theRequest.addParameter('field4D_OrigOrderAmt', this.field4D_OrigOrderAmt);
	theRequest.addParameter('field4D_ChgdOrderAmt', this.field4D_ChgdOrderAmt);
	theRequest.addParameter('field4D_AckRecdDate', this.field4D_AckRecdDate);
	theRequest.addParameter('field4D_Status', this.field4D_Status);
	theRequest.addParameter('field4D_StatusBy', this.field4D_StatusBy);
	theRequest.addParameter('field4D_StatusDate', this.field4D_StatusDate);
	theRequest.addParameter('field4D_LastChgOrdNo', this.field4D_LastChgOrdNo);
	theRequest.addParameter('field4D_LastChgOrdDate', this.field4D_LastChgOrdDate);
	theRequest.addParameter('field4D_ShipInstruct', this.field4D_ShipInstruct);
	theRequest.addParameter('field4D_Comments', this.field4D_Comments);
	theRequest.addParameter('field4D_ConfirmingTo', this.field4D_ConfirmingTo);
	theRequest.addParameter('field4D_ConfirmingBy', this.field4D_ConfirmingBy);
	theRequest.addParameter('field4D_ConfirmingDate', this.field4D_ConfirmingDate);
	theRequest.addParameter('field4D_ConfirmingNotes', this.field4D_ConfirmingNotes);
	theRequest.addParameter('field4D_ApprovedBy', this.field4D_ApprovedBy);
	theRequest.addParameter('field4D_Required', this.field4D_Required);
	theRequest.addParameter('field4D_AttentionOf', this.field4D_AttentionOf);
	theRequest.addParameter('field4D_ConfirmingOrder', this.field4D_ConfirmingOrder);
	theRequest.addParameter('field4D_Count', this.field4D_Count);
	theRequest.addParameter('field4D_ModDate', this.field4D_ModDate);
	theRequest.addParameter('field4D_ModWho', this.field4D_ModWho);
	theRequest.addParameter('field4D_PO_Clauses', this.field4D_PO_Clauses);
	theRequest.addParameter('field4D_ShipTo1', this.field4D_ShipTo1);
	theRequest.addParameter('field4D_ShipTo2', this.field4D_ShipTo2);
	theRequest.addParameter('field4D_ShipTo3', this.field4D_ShipTo3);
	theRequest.addParameter('field4D_ShipTo4', this.field4D_ShipTo4);
	theRequest.addParameter('field4D_ShipTo5', this.field4D_ShipTo5);
	theRequest.addParameter('field4D_Released', this.field4D_Released);
	theRequest.addParameter('field4D_ExpeditingNote', this.field4D_ExpeditingNote);
	theRequest.addParameter('field4D_Std_Discount', this.field4D_Std_Discount);
	theRequest.addParameter('field4D_VendorName', this.field4D_VendorName);
	theRequest.addParameter('field4D_CompanyID', this.field4D_CompanyID);
	theRequest.addParameter('field4D_PurchaseApprv', this.field4D_PurchaseApprv);
	theRequest.addParameter('field4D_NewVendor', this.field4D_NewVendor);
	theRequest.addParameter('field4D_ReqVendorID', this.field4D_ReqVendorID);
	theRequest.addParameter('field4D_Ordered', this.field4D_Ordered);
	theRequest.addParameter('field4D_INX_autoPO', this.field4D_INX_autoPO);
	theRequest.addParameter('field4D_Printed', this.field4D_Printed);
	theRequest.addParameter('field4D_FaxStatus', this.field4D_FaxStatus);
	theRequest.addParameter('field4D_StatusTrack', this.field4D_StatusTrack);
	theRequest.addParameter('field4D_PercentComplete', this.field4D_PercentComplete);
	theRequest.addParameter('field4D_ShippingOption', this.field4D_ShippingOption);
	theRequest.addParameter('field4D__SYNC_ID', this.field4D__SYNC_ID);
	theRequest.addParameter('field4D_SupplyChainPO', this.field4D_SupplyChainPO);
	theRequest.addParameter('field4D_DateApproved', this.field4D_DateApproved);
	theRequest.addParameter('field4D__SYNC_DATA', this.field4D__SYNC_DATA);
	theRequest.addParameter('field4D_ChainOfCustody', this.field4D_ChainOfCustody);
	theRequest.addParameter('field4D_pk_id', this.field4D_pk_id);

    
    var parentObject = this;
    
    // Send the request Asynchronous
	theRequest.sendRequest(true,
                           function()
                           {
                           
                           var ttResponse = this.fourDResponse;
                           if(ttResponse.length > 0){
                           
                                   if (ttResponse === 'SUCCESS')
                                   {
                                        fReturn = YES;
                                        successFunction.call(); // Call the Success Function
                                   }else{
                                        parentObject.setLastError(ttResponse);
                                        failFunction.call(this, parentObject.lastError); // Call the fail Function
                                   }
                           
                           }else{
                                parentObject.setLastError('Invalid data returned by 4D');
                                failFunction.call(this, parentObject.lastError); // Call the fail Function
                           }
                           
                           },
                           function(ttError)
                           {
                                parentObject.setLastError('Connection failed to 4D, network error');
                                failFunction.call(this, parentObject.lastError); // Call the fail Function
                           });
	
    
    
    
    
        return fReturn;
        
        
    }
	
	
	
	
this.saveFieldWithKey = function(ttKey, ttKeyValue, ttFieldName, ttPrefsIP, ttPrefsPort, successFunction, failFunction){ // Returns BOOL
    var fReturn = NO;
    var ttData = '';
    
    var theRequest=new FourDWebRequest();
	theRequest.initWithAddress(ttPrefsIP, ttPrefsPort,'4DWEB_SaveFieldWithKey');
	theRequest.addParameter('TableNumber', this.tableNumber());
	theRequest.addParameter('keyField', ttKey);
	theRequest.addParameter('event', 'Save');
    
	theRequest.addParameter(ttKey, ttKeyValue);
    theRequest.addParameter(ttFieldName, this[ttFieldName]);

    
    var parentObject = this;
    
    // Send the request Asynchronous
	theRequest.sendRequest(true,
                           function()
                           {
                           
                           var ttResponse = this.fourDResponse;
                           if(ttResponse.length > 0){
                           
                                   if (ttResponse === 'SUCCESS')
                                   {
                                        fReturn = YES;
                                        successFunction.call(); // Call the Success Function
                                   }else{
                                        parentObject.setLastError(ttResponse);
                                        failFunction.call(this, parentObject.lastError); // Call the fail Function
                                   }
                           
                           }else{
                                parentObject.setLastError('Invalid data returned by 4D');
                                failFunction.call(this, parentObject.lastError); // Call the fail Function
                           }
                           
                           },
                           function(ttError)
                           {
                                parentObject.setLastError('Connection failed to 4D, network error');
                                failFunction.call(this, parentObject.lastError); // Call the fail Function
                           });
	
    
    
    
    
        return fReturn;
        
        
    }
    
	
	
	
	
	
    
this.deleteRecordWithKey = function(ttKey, ttPrefsIP, ttPrefsPort, successFunction, failFunction){ // Returns BOOL
        var fReturn = NO;
        var ttData = '';
    
    var theRequest=new FourDWebRequest();
	theRequest.initWithAddress(ttPrefsIP, ttPrefsPort,'4DWEB_SaveRecordWithKey');
	theRequest.addParameter('TableNumber', this.tableNumber());

	theRequest.addParameter('keyField', ttKey);
	theRequest.addParameter('event', 'Delete');
    
	var ttFieldValue = this[ttKey];
    theRequest.addParameter(ttKey, ttFieldValue);


    var parentObject = this;
    
    // Send the request Asynchronous
	theRequest.sendRequest(true,
                           function()
						   
                           {
                           
                           var ttResponse = this.fourDResponse;
                           if(ttResponse.length > 0){
                           
                                   if (ttResponse === 'SUCCESS')
                                   {
                                        fReturn = YES;
                                        successFunction.call(); // Call the Success Function
                                   }else{
                                        parentObject.setLastError(ttResponse);
                                        failFunction.call(this, parentObject.lastError); // Call the fail Function
                                   }
                           
                           }else{
                                parentObject.setLastError('Invalid data returned by 4D');
                                failFunction.call(this, parentObject.lastError); // Call the fail Function
                           }
                           
                           },
                           function(ttError)
                           {
                                parentObject.setLastError('Connection failed to 4D, network error');
                                failFunction.call(this, parentObject.lastError); // Call the fail Function
                           });
	

    
    
        return fReturn;
        
        
    }
    
    
    
this.queryTableByFormula = function(ttFormula, ttPrefsIP, ttPrefsPort, successFunction, failFunction, fieldArray){ // Returns INT
        var xlReturn = 0;
        var ttData = '';
        
        // Reset our section arrays to zero
    this.sectionRowNames.length = 0;
    this.sectionRows.length = 0;
    
    
    var theRequest=new FourDWebRequest();
	var ttEvent = '4DWEB_QueryTableByFormula';
	if(fieldArray){
		ttEvent = ttEvent+'LimitFields'
	}
	theRequest.initWithAddress(ttPrefsIP, ttPrefsPort,ttEvent);
	theRequest.addParameter('TableNumber', this.tableNumber());
	theRequest.addParameter('Formula', ttFormula);
	if(fieldArray){
		var ttFields = '';
		for(var i=0; i < fieldArray.length; i++){
			ttFields = ttFields+fieldArray[i]+';';
		}
		theRequest.addParameter('Fields', ttFields);
	}
	
	
    
    var parentObject = this;
    
	// Send the request Asynchronous
	theRequest.sendRequest(true,
                           function()
                           {
                           
                               var ttResponse = this.fourDResponse;
                               if(ttResponse.length > 0){
                           
                           
                                   parentObject.tableRows.length = 0;
                                   var ttJsonObject = JSON.parse(ttResponse, null);
                                   
								   var xlLength = ttJsonObject.ReturnList.length;
                                   
                                   for	(var i=0; i < xlLength; i++){
                                        parentObject.tableRows.push(ttJsonObject.ReturnList[i].Record);
                                   
                                   }
                               
                                   if (parentObject.useSections === YES) { // if we are using sections, rebuild the sections after our query
                                    parentObject.buildSections();
                                   }
                                  
                                   successFunction.call(); // Call the Success Function
                           
                               }else{
                                   xlReturn = -2;
                                   failFunction.call(this, 'Connected, but 4D Returned Empty string. This is invalid'); // Call the fail Function
                               }
                           
                           },
                           function( ttError)
                           {
                               xlReturn = -1;
                               failFunction.call(this, 'Could not connect to 4D'); // Call the fail Function
                           });
	
	
    
        return xlReturn;
    
        
    }
    
    
this.queryTable = function(ttSQL, ttPrefsIP, ttPrefsPort, successFunction, failFunction, fieldArray){
        var xlReturn = 0;
        var ttData = '';
    this.showProgress();
        
    // Reset our section arrays to zero
    this.sectionRowNames.length = 0;
    this.sectionRows.length = 0;

    
    var theRequest=new FourDWebRequest();
		var ttEvent = '4DWEB_QueryTable';
	if(fieldArray){
		ttEvent = ttEvent+'LimitFields'
	}
	theRequest.initWithAddress(ttPrefsIP, ttPrefsPort,ttEvent);

	theRequest.addParameter('TableNumber', this.tableNumber());
	theRequest.addParameter('SQL', ttSQL);
	if(fieldArray){
		var ttFields = '';
		for(var i=0; i < fieldArray.length; i++){
			ttFields = ttFields+fieldArray[i]+';';
		}
		theRequest.addParameter('Fields', ttFields);
	}
	
	
    
    var parentObject = this;
    
	// Send the request Asynchronous
	theRequest.sendRequest(true,
                           function()
                           {
                           
                               var ttResponse = this.fourDResponse;
                               if(ttResponse.length > 0){
                               
                               
                                   parentObject.tableRows.length = 0;
                                   var ttJsonObject = JSON.parse(ttResponse, null);
                                   
								   var xlLength = ttJsonObject.ReturnList.length;
                                   
                                   for	(var i=0; i < xlLength; i++){
                                   parentObject.tableRows.push(ttJsonObject.ReturnList[i].Record);
                                   
                                   }
                                   
                                   if (parentObject.useSections === YES) { // if we are using sections, rebuild the sections after our query
                                   parentObject.buildSections();
                                   }
                                   
                                   successFunction.call(); // Call the Success Function
                               
                               }else{
                                    xlReturn = -2;
                                    failFunction.call(this, 'Connected, but 4D Returned Empty string. This is invalid'); // Call the fail Function
                               }
                           
                                parentObject.removeProgress();
                           },
                           function(ttError)
                           {
                               xlReturn = -1;
                               failFunction.call(this, 'Could not connect to 4D'); // Call the fail Function
                                parentObject.removeProgress();
                           });
	
	
    
    return xlReturn;

}
    
    
this.cleanup = function(){
        
    this.init();
    
        
}
    
    
    






} // End fourD_Purchase_Orders