function fourD_Purchase_Orders_Items(){
    
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
    
    
    	this.field4D_POItemKey = '';	this.field4D_PONo = '';	this.field4D_ItemNo = '';	this.field4D_Qty_Shipping = '';	this.field4D_UM_Ship = '';	this.field4D_VendPartNo = '';	this.field4D_RM_Description = '';	this.field4D_ReqdDate = '';	this.field4D_PromiseDate = '';	this.field4D_UnitPrice = '';	this.field4D_ExtPrice = '';	this.field4D_InspectReqd = '';	this.field4D_SubGroup = '';	this.field4D_Qty_Received = '';	this.field4D_Raw_Matl_Code = '';	this.field4D_CommodityCode = '';	this.field4D_Qty_Billing = '';	this.field4D_ReqnBy = '';	this.field4D_ModDate = '';	this.field4D_ModWho = '';	this.field4D_Count = '';	this.field4D_Deleted = '';	this.field4D_ExpeditingNote = '';	this.field4D_UM_Price = '';	this.field4D_FactNship2price = '';	this.field4D_Commodity_Key = '';	this.field4D_Qty_Open = '';	this.field4D_UM_Arkay_Issue = '';	this.field4D_FactNship2cost = '';	this.field4D_Qty_Ordered = '';	this.field4D_Flex1 = '';	this.field4D_Flex2 = '';	this.field4D_Flex3 = '';	this.field4D_Flex4 = '';	this.field4D_Flex5 = '';	this.field4D_Flex6 = '';	this.field4D_FactDship2cost = '';	this.field4D_FactDship2price = '';	this.field4D_VendorID = '';	this.field4D_PoItemDate = '';	this.field4D_AddedDescrp = '';	this.field4D_RecvdCnt = '';	this.field4D_RecvdDate = '';	this.field4D_Canceled = '';	this.field4D_CompanyID = '';	this.field4D_DepartmentID = '';	this.field4D_ExpenseCode = '';	this.field4D_BudgetBuster = '';	this.field4D_Consignment = '';	this.field4D_AssetNumber = '';	this.field4D_FixedCost = '';	this.field4D__SYNC_ID = '';	this.field4D__SYNC_DATA = '';	this.field4D_pk_id = '';
    




this.tableNumber = function(){
        return 12;
    }
    
this.setLastError = function(ttError){
    this.lastError = ttError;
}
    
this.unloadRecord = function(){
        currentRow = -1;
        
    	this.field4D_POItemKey = '';	this.field4D_PONo = '';	this.field4D_ItemNo = '';	this.field4D_Qty_Shipping = '';	this.field4D_UM_Ship = '';	this.field4D_VendPartNo = '';	this.field4D_RM_Description = '';	this.field4D_ReqdDate = '';	this.field4D_PromiseDate = '';	this.field4D_UnitPrice = '';	this.field4D_ExtPrice = '';	this.field4D_InspectReqd = '';	this.field4D_SubGroup = '';	this.field4D_Qty_Received = '';	this.field4D_Raw_Matl_Code = '';	this.field4D_CommodityCode = '';	this.field4D_Qty_Billing = '';	this.field4D_ReqnBy = '';	this.field4D_ModDate = '';	this.field4D_ModWho = '';	this.field4D_Count = '';	this.field4D_Deleted = '';	this.field4D_ExpeditingNote = '';	this.field4D_UM_Price = '';	this.field4D_FactNship2price = '';	this.field4D_Commodity_Key = '';	this.field4D_Qty_Open = '';	this.field4D_UM_Arkay_Issue = '';	this.field4D_FactNship2cost = '';	this.field4D_Qty_Ordered = '';	this.field4D_Flex1 = '';	this.field4D_Flex2 = '';	this.field4D_Flex3 = '';	this.field4D_Flex4 = '';	this.field4D_Flex5 = '';	this.field4D_Flex6 = '';	this.field4D_FactDship2cost = '';	this.field4D_FactDship2price = '';	this.field4D_VendorID = '';	this.field4D_PoItemDate = '';	this.field4D_AddedDescrp = '';	this.field4D_RecvdCnt = '';	this.field4D_RecvdDate = '';	this.field4D_Canceled = '';	this.field4D_CompanyID = '';	this.field4D_DepartmentID = '';	this.field4D_ExpenseCode = '';	this.field4D_BudgetBuster = '';	this.field4D_Consignment = '';	this.field4D_AssetNumber = '';	this.field4D_FixedCost = '';	this.field4D__SYNC_ID = '';	this.field4D__SYNC_DATA = '';	this.field4D_pk_id = '';
    
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
            
            		this.field4D_POItemKey = recordData.field4D_POItemKey;		this.field4D_PONo = recordData.field4D_PONo;		this.field4D_ItemNo = recordData.field4D_ItemNo;		this.field4D_Qty_Shipping = recordData.field4D_Qty_Shipping;		this.field4D_UM_Ship = recordData.field4D_UM_Ship;		this.field4D_VendPartNo = recordData.field4D_VendPartNo;		this.field4D_RM_Description = recordData.field4D_RM_Description;		this.field4D_ReqdDate = recordData.field4D_ReqdDate;		this.field4D_PromiseDate = recordData.field4D_PromiseDate;		this.field4D_UnitPrice = recordData.field4D_UnitPrice;		this.field4D_ExtPrice = recordData.field4D_ExtPrice;		this.field4D_InspectReqd = recordData.field4D_InspectReqd;		this.field4D_SubGroup = recordData.field4D_SubGroup;		this.field4D_Qty_Received = recordData.field4D_Qty_Received;		this.field4D_Raw_Matl_Code = recordData.field4D_Raw_Matl_Code;		this.field4D_CommodityCode = recordData.field4D_CommodityCode;		this.field4D_Qty_Billing = recordData.field4D_Qty_Billing;		this.field4D_ReqnBy = recordData.field4D_ReqnBy;		this.field4D_ModDate = recordData.field4D_ModDate;		this.field4D_ModWho = recordData.field4D_ModWho;		this.field4D_Count = recordData.field4D_Count;		this.field4D_Deleted = recordData.field4D_Deleted;		this.field4D_ExpeditingNote = recordData.field4D_ExpeditingNote;		this.field4D_UM_Price = recordData.field4D_UM_Price;		this.field4D_FactNship2price = recordData.field4D_FactNship2price;		this.field4D_Commodity_Key = recordData.field4D_Commodity_Key;		this.field4D_Qty_Open = recordData.field4D_Qty_Open;		this.field4D_UM_Arkay_Issue = recordData.field4D_UM_Arkay_Issue;		this.field4D_FactNship2cost = recordData.field4D_FactNship2cost;		this.field4D_Qty_Ordered = recordData.field4D_Qty_Ordered;		this.field4D_Flex1 = recordData.field4D_Flex1;		this.field4D_Flex2 = recordData.field4D_Flex2;		this.field4D_Flex3 = recordData.field4D_Flex3;		this.field4D_Flex4 = recordData.field4D_Flex4;		this.field4D_Flex5 = recordData.field4D_Flex5;		this.field4D_Flex6 = recordData.field4D_Flex6;		this.field4D_FactDship2cost = recordData.field4D_FactDship2cost;		this.field4D_FactDship2price = recordData.field4D_FactDship2price;		this.field4D_VendorID = recordData.field4D_VendorID;		this.field4D_PoItemDate = recordData.field4D_PoItemDate;		this.field4D_AddedDescrp = recordData.field4D_AddedDescrp;		this.field4D_RecvdCnt = recordData.field4D_RecvdCnt;		this.field4D_RecvdDate = recordData.field4D_RecvdDate;		this.field4D_Canceled = recordData.field4D_Canceled;		this.field4D_CompanyID = recordData.field4D_CompanyID;		this.field4D_DepartmentID = recordData.field4D_DepartmentID;		this.field4D_ExpenseCode = recordData.field4D_ExpenseCode;		this.field4D_BudgetBuster = recordData.field4D_BudgetBuster;		this.field4D_Consignment = recordData.field4D_Consignment;		this.field4D_AssetNumber = recordData.field4D_AssetNumber;		this.field4D_FixedCost = recordData.field4D_FixedCost;		this.field4D__SYNC_ID = recordData.field4D__SYNC_ID;		this.field4D__SYNC_DATA = recordData.field4D__SYNC_DATA;		this.field4D_pk_id = recordData.field4D_pk_id;
            
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
        div.id = 'fourD_Purchase_Orders_ItemsProgress';
        
        div.innerHTML = '<img width="64px" height="64px" src="./js_4D/fourpg.gif"  /><h5 style="text-align:center">loading...</h5>';
        
        document.body.appendChild(div);
}
    
this.removeProgress = function(){
        var elem = document.getElementById('fourD_Purchase_Orders_ItemsProgress');
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
    
    	theRequest.addParameter('field4D_POItemKey', this.field4D_POItemKey);	theRequest.addParameter('field4D_PONo', this.field4D_PONo);	theRequest.addParameter('field4D_ItemNo', this.field4D_ItemNo);	theRequest.addParameter('field4D_Qty_Shipping', this.field4D_Qty_Shipping);	theRequest.addParameter('field4D_UM_Ship', this.field4D_UM_Ship);	theRequest.addParameter('field4D_VendPartNo', this.field4D_VendPartNo);	theRequest.addParameter('field4D_RM_Description', this.field4D_RM_Description);	theRequest.addParameter('field4D_ReqdDate', this.field4D_ReqdDate);	theRequest.addParameter('field4D_PromiseDate', this.field4D_PromiseDate);	theRequest.addParameter('field4D_UnitPrice', this.field4D_UnitPrice);	theRequest.addParameter('field4D_ExtPrice', this.field4D_ExtPrice);	theRequest.addParameter('field4D_InspectReqd', this.field4D_InspectReqd);	theRequest.addParameter('field4D_SubGroup', this.field4D_SubGroup);	theRequest.addParameter('field4D_Qty_Received', this.field4D_Qty_Received);	theRequest.addParameter('field4D_Raw_Matl_Code', this.field4D_Raw_Matl_Code);	theRequest.addParameter('field4D_CommodityCode', this.field4D_CommodityCode);	theRequest.addParameter('field4D_Qty_Billing', this.field4D_Qty_Billing);	theRequest.addParameter('field4D_ReqnBy', this.field4D_ReqnBy);	theRequest.addParameter('field4D_ModDate', this.field4D_ModDate);	theRequest.addParameter('field4D_ModWho', this.field4D_ModWho);	theRequest.addParameter('field4D_Count', this.field4D_Count);	theRequest.addParameter('field4D_Deleted', this.field4D_Deleted);	theRequest.addParameter('field4D_ExpeditingNote', this.field4D_ExpeditingNote);	theRequest.addParameter('field4D_UM_Price', this.field4D_UM_Price);	theRequest.addParameter('field4D_FactNship2price', this.field4D_FactNship2price);	theRequest.addParameter('field4D_Commodity_Key', this.field4D_Commodity_Key);	theRequest.addParameter('field4D_Qty_Open', this.field4D_Qty_Open);	theRequest.addParameter('field4D_UM_Arkay_Issue', this.field4D_UM_Arkay_Issue);	theRequest.addParameter('field4D_FactNship2cost', this.field4D_FactNship2cost);	theRequest.addParameter('field4D_Qty_Ordered', this.field4D_Qty_Ordered);	theRequest.addParameter('field4D_Flex1', this.field4D_Flex1);	theRequest.addParameter('field4D_Flex2', this.field4D_Flex2);	theRequest.addParameter('field4D_Flex3', this.field4D_Flex3);	theRequest.addParameter('field4D_Flex4', this.field4D_Flex4);	theRequest.addParameter('field4D_Flex5', this.field4D_Flex5);	theRequest.addParameter('field4D_Flex6', this.field4D_Flex6);	theRequest.addParameter('field4D_FactDship2cost', this.field4D_FactDship2cost);	theRequest.addParameter('field4D_FactDship2price', this.field4D_FactDship2price);	theRequest.addParameter('field4D_VendorID', this.field4D_VendorID);	theRequest.addParameter('field4D_PoItemDate', this.field4D_PoItemDate);	theRequest.addParameter('field4D_AddedDescrp', this.field4D_AddedDescrp);	theRequest.addParameter('field4D_RecvdCnt', this.field4D_RecvdCnt);	theRequest.addParameter('field4D_RecvdDate', this.field4D_RecvdDate);	theRequest.addParameter('field4D_Canceled', this.field4D_Canceled);	theRequest.addParameter('field4D_CompanyID', this.field4D_CompanyID);	theRequest.addParameter('field4D_DepartmentID', this.field4D_DepartmentID);	theRequest.addParameter('field4D_ExpenseCode', this.field4D_ExpenseCode);	theRequest.addParameter('field4D_BudgetBuster', this.field4D_BudgetBuster);	theRequest.addParameter('field4D_Consignment', this.field4D_Consignment);	theRequest.addParameter('field4D_AssetNumber', this.field4D_AssetNumber);	theRequest.addParameter('field4D_FixedCost', this.field4D_FixedCost);	theRequest.addParameter('field4D__SYNC_ID', this.field4D__SYNC_ID);	theRequest.addParameter('field4D__SYNC_DATA', this.field4D__SYNC_DATA);	theRequest.addParameter('field4D_pk_id', this.field4D_pk_id);

    
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
    
    
    






} // End fourD_Purchase_Orders_Items