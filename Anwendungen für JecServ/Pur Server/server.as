// *****************  ALLGEMEIN FUNKTIONEN  **************
// wenn parameter einen wert enthält, wird true zurückgegeben.
checkParameter = function(input){  
	if(input != "" || input != undefined){
		return false;
	} else {
		return true;
	}
}
encodeString = function(daten){
	daten = daten.toString;
	trace("func: "+daten);
	daten = daten.split("ü").join("&ue&&");
	daten = daten.split("Ü").join("&UE&&");
	daten = daten.split("ä").join("&ae&&");
	daten = daten.split("Ä").join("&AE&&");
	daten = daten.split("ö").join("&oe&&");
	daten = daten.split("Ö").join("&OE&&");
	daten = daten.split("ß").join("&SS&&");
	return daten;
}

decodeString = function(daten){
	daten = daten.split("&ue&&").join("ü");
	daten = daten.split("&UE&&").join("Ü");
	daten = daten.split("&ae&&").join("ä");
	daten = daten.split("&AE&&").join("Ä");
	daten = daten.split("&oe&&").join("ö");
	daten = daten.split("&OE&&").join("Ö");
	daten = daten.split("&SS&&").join("ß");
	return daten;
}

// *****************  SERVER FUNKTIONEN  **************
sendString = function(callback, wem, daten){
	JecSocket.send("String|"+callback+"|"+wem+"|"+daten+"|");
	//wem = all, eachother, username
}

// ---------- User Name ---------
createMyAccount = function(client_name){
	callback = "setUserVar";
	JecSocket.send("Createclient|"+callback+"|"+client_name+"|");
}

changeMyProperty = function(callback, myProperty, parameter){
	JecSocket.send("Changeproperty|"+callback+"|"+myProperty+"|"+parameter+"|");
}


// ---------- Channels ---------
createChannel = function(callback, channel_name, modi){
	//channel_name = encodeString(channel_name);
	//modi = encodeString(modi);
	if(checkParameter(modi)){
		JecSocket.send("Createchannel|"+callback+"|"+new_name+"|"+modi+"|");
	} else {
		JecSocket.send("Createchannel|"+callback+"|"+channel_name+"|");
	}
}
listChannel = function(callback){
	JecSocket.send("Listchannel|"+callback+"|");
}
listClientOnChannel = function(callback){
	JecSocket.send("Listclientonchannel|"+callback+"|");
}


// ---------- Global Variablen ---------
setUserVar = function(id, username){
	_root.userid = id;
	_root.username = username;
	trace("SETTING USER VARS");
	startApplication();
}