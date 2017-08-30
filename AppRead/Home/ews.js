	var ews = require('ews-javascript-api');
//create ExchangeService object
var exch = new ews.ExchangeService(ews.ExchangeVersion.Exchange2013);
exch.Credentials = new ews.ExchangeCredentials("a.usa-ampai@togetherteam.co.th", "anatomy1A");
//set ews endpoint url to use
exch.Url = new ews.Uri("https://outlook.office365.com/EWS/Exchange.asmx"); //

var item = ews.EmailMessage.bind(exch,new ews.ItemId("AAMkADcwM2EzYmEyLTZhNmQtNDk0ZC04NzQyLWE4YjBiNmY2M2RhMgBGAAAAAADKGV1LwqwrToX/Go0JvvSFBwAJvBImc5C0RLPrNQXCLAYlAAAAAAEMAAAJvBImc5C0RLPrNQXCLAYlAAASgWqiAAA="));

   
	item.Load();
	//exch.LoadPropertiesForItems(item,ews.PropertySet.FirstClassProperties);
	console.log(item.Subject);
	var mc = item.MimiContent;
	var fs = new FileStream("C:\test.eml",FileMode.Create);
	fs.Write(mc.Content,0,mc.Content.Length);
	fs.Close();
