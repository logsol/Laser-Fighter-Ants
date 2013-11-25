var jecSocket:XMLSocket = new XMLSocket();
_global.jecConnect = function(callback, serverIP, serverPort) {
	jecSocket.connect(serverIP, serverPort);
	jecSocket.onConnect = function(serverStatus) {
		if (serverStatus) {
			callback(true);
		} else {
			callback(false);
		}
	}
}
_global.jecDisconnect = function(){
	jecSocket.close();
}
// ------------------------------------------------------------------
traceSend = function(){
	
}
traceIncoming = function(){
	
}
jecSend = function(XMLData){
	if (serverTrace){
		traceSend(XMLData)
	}
	jecSocket.send(XMLData);
}
// ------------------------------  CLIENTS  --------------------------
_global.createMe = function(callback, clientName, produktName){
	jecSend("Createme|"+callback+"|"+clientName+"|"+produktName+"|");
}
_global.changeMyName = function(callback, clientName){
	jecSend("Changemyname|"+callback+"|"+clientName+"|");
}
_global.changeMyAttribute = function(callback, attributeNumber, attributeString){
	jecSend("Changemyattribute|"+callback+"|"+attributeNumber+"|"+attributeString+"|");
}
_global.getUserInfo = function(callback, clientID){
	jecSend("Getuserinfo|"+callback+"|"+clientID+"|");
}
_global.getUserList = function(callback, channelName){
	jecSend("Getuserlist|"+callback+"|"+channelName+"|");
}
// -----------------------------  CHANNELS  --------------------------
_global.createChannel = function(callback, channelName, modus, passwort){
	jecSend("Createchannel|"+callback+"|"+channelName+"|"+modus+"|"+passwort+"|");
}
_global.changeChannel = function(callback, channelName, passwort){
	if(passwort == undefined){
		passwort = "";
	}
	jecSend("Changechannel|"+callback+"|"+channelName+"|"+passwort+"|");
}
_global.getChannelList = function(callback){
	jecSend("Getchannellist|"+callback+"|");
}
// -------------------------------  SEND  ----------------------------
_global.sendAll = function(callback, msg){
	jecSend("Sendstring|"+callback+"|all|0|"+msg+"|");
}
_global.sendClient = function(callback, clientID, msg){
	jecSend("Sendstring|"+callback+"|client|"+clientID+"|"+msg+"|");
}
_global.sendEachother = function(callback, clientIDArray, msg){
	jecSend("Sendstring|"+callback+"|eachother|"+clientIDArray+",|"+msg+"|");
}
// ------------------------------  SERVER  ---------------------------
_global.getServerInfo = function(callback){
	jecSend("Getserverinfo|"+callback+"|");
}
// ------------------------------- EVENTS  ---------------------------
jecSocket.onData = function(XMLData:String):Void{
	if (serverTrace){
		traceIncoming(XMLData);
	}
	XMLData = XMLData.split("|");
	XMLData[0](XMLData[1]);
}