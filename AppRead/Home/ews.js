	var ews = require('ews-javascript-api');
//create ExchangeService object
var exch = new ews.ExchangeService(ews.ExchangeVersion.Exchange2013);
exch.Credentials = new ews.ExchangeCredentials("a.usa-ampai@togetherteam.co.th", "anatomy1A");
//set ews endpoint url to use
exch.Url = new ews.Uri("https://outlook.office365.com/EWS/Exchange.asmx"); //

var item = ews.Item.Bind(exch,"sdfasafsadf");

   
	item.Load(new ews.PropertySet(ews.ItemSchema.MimiContent));
	var mc = item.MimiContent;
	var fs = new FileStream("C:\test.eml",FileMode.Create);
	fs.Write(mc.Content,0,mc.Content.Length);
	fs.Close();
