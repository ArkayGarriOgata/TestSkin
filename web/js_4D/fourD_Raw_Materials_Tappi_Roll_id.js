function fourD_Raw_Materials_Tappi_Roll_id(){
    
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
    
    
    	this.field4D_pk_id = '';	this.field4D_Roll_id = '';	this.field4D_POItemKey = '';	this.field4D_Linear_Feet = '';
    




this.tableNumber = function(){
        return 178;
    }
    
this.setLastError = function(ttError){
    this.lastError = ttError;
}
    
this.unloadRecord = function(){
        currentRow = -1;
        
    	this.field4D_pk_id = '';	this.field4D_Roll_id = '';	this.field4D_POItemKey = '';	this.field4D_Linear_Feet = '';
    
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
            
            		this.field4D_pk_id = recordData.field4D_pk_id;		this.field4D_Roll_id = recordData.field4D_Roll_id;		this.field4D_POItemKey = recordData.field4D_POItemKey;		this.field4D_Linear_Feet = recordData.field4D_Linear_Feet;
            
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
        div.id = 'fourD_Raw_Materials_Tappi_Roll_idProgress';
        
        div.innerHTML = '<img width="64px" height="64px" src="./js_4D/fourpg.gif"  /><h5 style="text-align:center">loading...</h5>';
        
        document.body.appendChild(div);
}
    
this.removeProgress = function(){
        var elem = document.getElementById('fourD_Raw_Materials_Tappi_Roll_idProgress');
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
    
    	theRequest.addParameter('field4D_pk_id', this.field4D_pk_id);	theRequest.addParameter('field4D_Roll_id', this.field4D_Roll_id);	theRequest.addParameter('field4D_POItemKey', this.field4D_POItemKey);	theRequest.addParameter('field4D_Linear_Feet', this.field4D_Linear_Feet);

    
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
    
    
    






} // End fourD_Raw_Materials_Tappi_Roll_id