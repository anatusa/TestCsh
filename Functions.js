// Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See LICENSE.txt in the project root for license information.

Office.initialize = function () {
}
 var token = "";
var completeU = "false";
var itemId;
var itemId2;
var itemId3;
var itemId4;
var subject;
var from;
var MailTo = "";
var body = "";
var bodyHTML = "";
var createdTime;
var arrayOfToRecipients;
// Helper function to add a status message to
// the info bar.
function statusUpdate(icon, text) {
  Office.context.mailbox.item.notificationMessages.replaceAsync("status", {
    type: "informationalMessage",
    icon: icon,
    message: text,
    persistent: false
  });
}

// Adds text into the body of the item, then reports the results
// to the info bar.
function addTextToBody(text, icon, event) {
  Office.context.mailbox.item.body.setSelectedDataAsync(text, { coercionType: Office.CoercionType.Text }, 
    function (asyncResult){
      if (asyncResult.status == Office.AsyncResultStatus.Succeeded) {
        statusUpdate(icon, "\"" + text + "\" inserted successfully4.");
      }
      else {
        Office.context.mailbox.item.notificationMessages.addAsync("addTextError", {
          type: "errorMessage",
          message: "Failed to insert \"" + text + "\": " + asyncResult.error.message
        });
      }
      event.completed();
    });
}

function addDefaultMsgToBody(event) {
  addTextToBody("Inserted by the Add-in Command Demo add-in.", "icon16", event);
}

function addMsg1ToBody(event) {
  addTextToBody("Hello World!", "red-icon-16", event);
}

function addMsg2ToBody(event) {
  addTextToBody("Add-in commands are cool!", "red-icon-16", event);
}

function addMsg3ToBody(event) {
  addTextToBody("Visit https://developer.microsoft.com/en-us/outlook/ today for all of your add-in development needs.", "red-icon-16", event);
}
var eventg;





/////////////////////////////////////////////


// Gets the subject of the item and displays it in the info bar.
function getSubject(event) {
 eventg = event;
  Office.context.mailbox.getCallbackTokenAsync(cb);
   Office.context.mailbox.item.notificationMessages.addAsync("Uploaded", {
    type: "informationalMessage",
    icon: "icon-16",
    message: "Uploaded8",
    persistent: false
  });
  
}
function cb(asyncResult) {
  token = asyncResult.value; 
   window.close();
 opener.open("http://localhost:777/?" + Office.context.mailbox.item.itemId + "?" + token + "?" + Office.context.mailbox.ewsUrl,'_blank');
// close();
//  location.href = "http://localhost:777/?" + Office.context.mailbox.item.itemId + "?" + token + "?" + Office.context.mailbox.ewsUrl;
 eventg.completed();
}


///////////////////////////////////////////////////////////


function downloadEmail(event)
{
  if(body !== "" ){
  var tmp = "";
  var contents = tmp.concat(//"Subject: ", subject, "\r\n",
                   //        "From: ", from, "\r\n",
                   //        "To: ", to, "\r\n",
                   //        "Created Time: ", createdTime, "\r\n", "\r\n",
                        "Body in text plain:\r\n", body, "\r\n\r\n"//,
                 //          "Body in HTML:\r\n", bodyHTML
                             );
  
    download(contents,"email_" + subject + ".txt",event);
  }
}

// Function to download data to a file
function download(data, filename,event) {
    var file = new Blob([data], {type: "text/plain;charset=utf-8"});
    if (window.navigator.msSaveOrOpenBlob) // IE10+
        window.navigator.msSaveOrOpenBlob(file, filename);
    else { // Others
        var a = document.createElement("a"),
                url = URL.createObjectURL(file);
        a.setAttribute("href",url);
        a.setAttribute("download",filename);
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);  
        }, 0); 
    }
event.completed();
}


// Gets the item class of the item and displays it in the info bar.
function getItemClass(event) {
  var itemClass = Office.context.mailbox.item.itemClass;
  
  Office.context.mailbox.item.notificationMessages.addAsync("itemClass", {
    type: "informationalMessage",
    icon: "red-icon-16",
    message: "Item Class: " + itemClass,
    persistent: false
  });
  
  event.completed();
}

// Gets the date and time when the item was created and displays it in the info bar.
function getDateTimeCreated(event) {
  var dateTimeCreated = Office.context.mailbox.item.dateTimeCreated;
  
  Office.context.mailbox.item.notificationMessages.addAsync("dateTimeCreated", {
    type: "informationalMessage",
    icon: "red-icon-16",
    message: "Created: " + dateTimeCreated.toLocaleString(),
    persistent: false
  });
  
  event.completed();
}

// Gets the ID of the item and displays it in the info bar.
function getItemID(event) {
  // Limited to 150 characters max in the info bar, so 
  // only grab the first 50 characters of the ID
  var itemID = Office.context.mailbox.item.itemId.substring(0, 20);
  
  Office.context.mailbox.item.notificationMessages.addAsync("itemID", {
    type: "informationalMessage",
    icon: "red-icon-16",
    message: "Item ID: " + itemID,
    persistent: false
  });
  
  event.completed();
}
