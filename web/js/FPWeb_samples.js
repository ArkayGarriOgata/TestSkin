// JavaScript Document

var theFormsEntryClass;

var obFormEntryObject;
// Create Base64 Object



$(document).ready(function() {
	theFormsEntryClass=new fourD_InspectionForms();
	obFormEntryObject = {};
	


	$("#rm_username").val('');
	$("#rm_password").val('');


	
	$("#captureButton").on("change", function(e){
		e.preventDefault();
	   var file = this.files[0],
		   fileName = file.name,
		   fileSize = file.size;
		resize(file, 640, 480, 1.0, 'image/jpeg');
	});

/*
	var input = document.querySelector('input[type=file]'); // see Example 4

	input.onchange = function () {
	  var file = input.files[0];
	
	  upload(file);
	  //drawOnCanvas(file);   // see Example 6
	  //displayAsImage(file); // see Example 7
	};
*/

	/*
	$("#cart").on("mouseenter", function() {
    	$(".shopping-cart").fadeToggle( "fast");
  	});

	$("#cart").on("mouseleave", function() {
    	$(".shopping-cart").fadeToggle( "fast");
  	});

	$("#cart").on("click", function() {
    	//$(".shopping-cart").fadeToggle( "fast");
  			window.location.href = "/YVT/Checkout/checkout.shtml";
	});

	$("#checkout_button").on("click", function() {
		window.location.href = "/YVT/Checkout/checkout.shtml";
  	});
	*/

});



function dataURItoBlob(dataURI) {
  // convert base64 to raw binary data held in a string
  // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
  var byteString = atob(dataURI.split(',')[1]);

  // separate out the mime component
  var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

  // write the bytes of the string to an ArrayBuffer
  var ab = new ArrayBuffer(byteString.length);
  var ia = new Uint8Array(ab);
  for (var i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i);
  }

  // write the ArrayBuffer to a blob, and you're done
  var blob = new Blob([ab], {type: mimeString});
 
  return blob;

  // Old code
  // var bb = new BlobBuilder();
  // bb.append(ab);
  // return bb.getBlob(mimeString);
}


function resize(file, max_width, max_height, compression_ratio, imageEncoding){
    var fileLoader = new FileReader(),
    canvas = document.createElement('canvas'),
    context = null,
    imageObj = new Image(),
    blob = null;            

    //create a hidden canvas object we can use to create the new resized image data
    canvas.id     = "hiddenCanvas";
    canvas.width  = max_width;
    canvas.height = max_height;
    canvas.style.visibility   = "hidden";   
    document.body.appendChild(canvas);  

    //get the context to use 
    context = canvas.getContext('2d');  
	
	var reader = new FileReader();

    // check for an image then
    //trigger the file loader to get the data from the image         
    if (file.type.match('image.*')) {
        fileLoader.readAsDataURL(file);
    } else {
        alert('File is not an image');
    }

    // setup the file loader onload function
    // once the file loader has the data it passes it to the 
    // image object which, once the image has loaded, 
    // triggers the images onload function
    fileLoader.onload = function() {
        var data = this.result; 
        imageObj.src = data;
    };

    fileLoader.onabort = function() {
        alert("The upload was aborted.");
    };

    fileLoader.onerror = function() {
        alert("An error occured while reading the file.");
    };  


    // set up the images onload function which clears the hidden canvas context, 
    // draws the new image then gets the blob data from it
    imageObj.onload = function() {  

        // Check for empty images
        if(this.width == 0 || this.height == 0){
            alert('Image is empty');
        } else {                
			var xrAspectRatio = 0;
			var xrHAspect = max_width/this.width;
			var xrVAspect = max_height/this.height;
			if(xrHAspect < xrVAspect){
				xrAspectRatio = xrHAspect;
			}else{
				xrAspectRatio = xrVAspect;
			}
		
			if(xrAspectRatio > 1){ // We DON"T want to increase the size, ONLY decrease it, so if the ratio is > 1, set to 1
				xrAspectRatio = 1;
			}
		
		

            context.clearRect(0,0,max_width,max_height);
            context.drawImage(imageObj, 0, 0, this.width, this.height, 0, 0, (this.width * xrAspectRatio), (this.height * xrAspectRatio));


            //dataURItoBlob function available here:
            // http://stackoverflow.com/questions/12168909/blob-from-dataurl
            // add ')' at the end of this function SO dont allow to update it without a 6 character edit
			var ttBase64Data = canvas.toDataURL(imageEncoding);
			
			upload(ttBase64Data);
			
            //blob = dataURItoBlob(ttBase64Data);

            //pass this blob to your upload function
            //reader.readAsText(blob);

			
        }       
    };

    imageObj.onabort = function() {
        alert("Image load was aborted.");
    };

    imageObj.onerror = function() {
        alert("An error occured while loading image.");
    };
	
	
	
	reader.onload = function() {
		upload(reader.result);

	}


}









function upload(ttFileData) {
	var base64ImageRepresentation =  ttFileData; //Base64.encode(ttFileData);

	var ttFormSN = theFormsEntryClass.field4D_SeqNum;
	
	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","iOS_SaveISImage");
	theRequest.addParameter('ImageSeqNum', "0");// Designates new image
	theRequest.addParameter('ISFormSeqNum', ttFormSN);  
		
	//var ttFileData = file.data;
	theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
									   if (ttResponse == "SUCCESS"){


									   }else{
											//window.alert("Invalid username or password.");
											popupAlert("Invalid Username or Password!");
									   }
									
																				
								   } else {
									   popupAlert("An error occurred, the record cannot be saved at this time.");
								   }
								},null);


}









function showInspections(ttOrderSeqNum, ttDisplayOrderNum, ttAccountName){
	$("#currentOrder").html(ttDisplayOrderNum);
	$("#currentOrderSN").html(ttOrderSeqNum);
	$("#currentAccount").html(ttAccountName);
	
	loadInspectionSheets(ttOrderSeqNum);
	
	var url = '#ISList';
	navGotoURL(url);
	
	
	
}


function showInspectionEntry(ttSeqNum, ttName){
	$("#currentISName").html(ttName);
	$("#currentISOrder").html($("#currentOrder").html());
	$("#currentISAccount").html($("#currentAccount").html());
	
	loadInspectionSheetEntry(ttSeqNum);
	queryForImages(ttSeqNum)
	
	var url = '#ISEntry';
	navGotoURL(url);
	
	
}


function loadPurchaseOrders(ttStatus){
	
	var theOrderClass=new fourD_Purchase_Orders();
	theOrderClass.init();


    var ttSQL = "Purchase_Orders.Status = '"+ttStatus+"'";
	
	theOrderClass.queryTable(ttSQL, '', '', 
	function()
			{
				var ttText = '';

				for (var i = 0; i < theOrderClass.getRecordsInSelection(); i++)
				{
					theOrderClass.gotoRecord(i);
					var ttDisplayON = theOrderClass.field4D_PONo.replace("'", "`");
					ttText = ttText+"<li><a href='#' onclick='showInspections(\""+theOrderClass.field4D_PONo+"\", \""+ttDisplayON+"\", \""+theOrderClass.field4D_VendorName+"\")'>"+theOrderClass.field4D_PONo+" - "+theOrderClass.field4D_VendorName+"</a></li>";

				}
				
				$("#order_list").html(ttText);
				$('#order_list').listview('refresh');// reload the company list
				$('#order_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_PONo", "field4D_VendorName", "field4D_PODate"]);

	
}



function loadInspectionSheets(ttOrderSN){
	
	var theFormsClass=new fourD_InspectionForms();
	theFormsClass.init();


    var ttSQL = "InspectionForms.OrderSeqNum = "+ttOrderSN;
	
	theFormsClass.queryTable(ttSQL, '', '', 
	function()
			{
				var ttText = '';

				for (var i = 0; i < theFormsClass.getRecordsInSelection(); i++)
				{
					theFormsClass.gotoRecord(i);
					
					ttText = ttText+"<li><a href='#' onclick='showInspectionEntry(\""+theFormsClass.field4D_SeqNum+"\", \""+theFormsClass.field4D_Name+"\")'>"+theFormsClass.field4D_Name+"</a></li>";

				}
				
				$("#sheet_list").html(ttText);
				$('#sheet_list').listview('refresh');// reload the company list
				$('#sheet_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_SeqNum", "field4D_Name"]);

	
}


function setDone(ttSelectMenu, xlIndex){
	var ttValue = $(ttSelectMenu).val();
	var fDone = false;
	if(ttValue == "on"){
		fDone = true;
	}
	obFormEntryObject.Fields[xlIndex].Done = fDone;
	saveTheFormsRecord();
}

function setQuestionText(ttTextField, xlIndex){
	var ttValue = $(ttTextField).val();
	obFormEntryObject.Fields[xlIndex].Notes = ttValue;
	saveTheFormsRecord();
}

function saveTheFormsRecord(){
	
	var ttSeqNum = theFormsEntryClass.field4D_SeqNum;
	theFormsEntryClass.field4D_FormFields = JSON.stringify(obFormEntryObject); // stringify the fields object and save it back to the database
	theFormsEntryClass.saveFieldWithKey("field4D_SeqNum", ttSeqNum, "field4D_FormFields", '', '', 
	function()
			{
				//Success, do nothing
			}, 
			function()
			{
				// Fail Function
				popupAlert("An error occurred, the record cannot be saved at this time.");
			});


}



function queryForImages(ttSeqNum){
	
	var theImagesClass=new fourD_InspectionFormImages();
	theImagesClass.init();


    var ttSQL = "InspectionFormImages.InspectionFormsSeqNum = "+ttSeqNum;
	
	theImagesClass.queryTable(ttSQL, '', '', 
	function()
			{
				var ttText = '';

				for (var i = 0; i < theImagesClass.getRecordsInSelection(); i++)
				{
					theImagesClass.gotoRecord(i);
					ttText = ttText + '<li><a href="#">';
					ttText = ttText + '<img src="data:image/jpeg;base64,'+theImagesClass.field4D_Thumbnail+'" id="'+theImagesClass.field4D_SeqNum+'" class="ui-li-thumb">';
					ttText = ttText + '<h2>'+theImagesClass.field4D_SeqNum+'</h2>';
					ttText = ttText + '<p>'+theImagesClass.field4D_InspectionFormsSeqNum+'</p>';
					ttText = ttText + '</a></li>';

				}
				
				$("#imageList").html(ttText);
				$('#imageList').listview('refresh');// reload the company list
				$('#imageList').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_SeqNum", "field4D_InspectionFormsSeqNum", "field4D_Thumbnail"]);



	
}



function loadInspectionSheetEntry(ttSeqNum){

	theFormsEntryClass.init();


    var ttSQL = "InspectionForms.SeqNum = "+ttSeqNum;
	
	theFormsEntryClass.queryTable(ttSQL, '', '', 
	function()
			{
				var ttText = '';
				if(theFormsEntryClass.getRecordsInSelection() > 0){
					theFormsEntryClass.gotoRecord(0); // activate the first and only record in the selection
					if(theFormsEntryClass.field4D_FormFields.length > 0){
						obFormEntryObject = JSON.parse(theFormsEntryClass.field4D_FormFields, null);
						var sttFieldArray = obFormEntryObject.Fields;
						for (var i = 0; i < sttFieldArray.length; i++)
						{
							var ttFieldData = sttFieldArray[i];
							var ttDone = "";
							if(ttFieldData.Done){
								ttDone = "selected";
							}
							
							
							
							ttText = ttText + '<li class="ui-field-contain">';
							ttText = ttText + '<div class="ui-corner-all custom-corners">';
							ttText = ttText + '<div class="ui-bar ui-bar-a">';
							
							ttText = ttText + '<h2>'+ttFieldData.FieldName+'</h2>';
								ttText = ttText + '<div style="position:absolute; right:10px; top:5px;">';
									ttText = ttText + '<select name="done-'+i+'" id="done-'+i+'" data-role="slider" onchange="setDone(this, '+i+')">';
										ttText = ttText + '<option value="off"></option>';
										ttText = ttText + '<option value="on"'+ttDone+'>Done</option>';
									ttText = ttText + '</select>';
								ttText = ttText + '</div>';
							ttText = ttText + '</div>';
							
							ttText = ttText + '<div class="ui-body ui-body-a">';
								//ttText = ttText + '<label for="textarea-'+i+'" class="ui-hidden-accessible">Textarea:</label>';
								ttText = ttText + '<textarea name="textarea-'+i+'" id="textarea-'+i+'" onchange="setQuestionText(this, '+i+')">'+ttFieldData.Notes+'</textarea>';
							ttText = ttText + '</div>';
								
							
							
							
							
							ttText = ttText + '</div>';
							ttText = ttText + '</li>';
							
							
							
							
							
							
							
							
						} // End for
						
					}
					
				}
				
				
				
				$("#field_list").html(ttText);
				$('#field_list').listview('refresh');// reload the company list
				$('#field_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, null);

	
	
}





