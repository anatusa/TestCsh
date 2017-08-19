// Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See LICENSE.txt in the project root for license information.

Office.initialize = function () {
}

var itemId;
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

// Gets the subject of the item and displays it in the info bar.
function getSubject(event) {
  finished="false";
 itemId = Office.context.mailbox.item.itemId.substring(0, 50);
   itemId2 = Office.context.mailbox.item.itemId.substring(50, 100);
   itemId3 = Office.context.mailbox.item.itemId.substring(100, 150);
  subject = Office.context.mailbox.item.subject;
//  from = Office.context.mailbox.item.from.emailAddress;
//  createdTime = Office.context.mailbox.item.dateTimeCreated;
      
 arrayOfToRecipients = Office.context.mailbox.item.cc;
  for(i=0;i<arrayOfToRecipients.length;i++)
  {
    MailTo = MailTo + arrayOfToRecipients[i].displayName + "(" +  arrayOfToRecipients[i].emailAddress + ")";
  }
  Office.context.mailbox.item.notificationMessages.addAsync("subject", {
    type: "informationalMessage",
    icon: "icon16",
    message: "Subject10: " + subject,
    persistent: false
  });
   Office.context.mailbox.item.notificationMessages.addAsync("itemId", {
    type: "informationalMessage",
    icon: "icon16",
    message: "itemId: " + itemId,
    persistent: false
  });
    Office.context.mailbox.item.notificationMessages.addAsync("itemId2", {
    type: "informationalMessage",
    icon: "icon16",
    message: "itemId2: " + itemId2,
    persistent: false
  });
    Office.context.mailbox.item.notificationMessages.addAsync("itemId3", {
    type: "informationalMessage",
    icon: "icon16",
    message: "itemId3: " + itemId3,
    persistent: false
  });
  
 Office.context.mailbox.item.notificationMessages.addAsync("to", {
    type: "informationalMessage",
    icon: "icon16",
    message: "to: " + MailTo,
    persistent: false
  });
    Office.context.mailbox.item.body.getAsync('text', function(asyncResult){
    body = asyncResult.value;
    downloadEmail(event);
  });

  
}

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
