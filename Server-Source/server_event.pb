; --------------------------------------------------------------------------------------------------------------|
;- Server Event-Handling | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                            |
; --------------------------------------------------------------------------------------------------------------|
Select NetworkServerEvent()

; --------------------------------------------------------------------------------------------------------------|
;- connect Server | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                   |
; --------------------------------------------------------------------------------------------------------------|
 Case 1
 sendMSG("this", EventClient(), "", "", "onAlert|Willkommen auf dem Jecedelic Server "+Version)
 
; --------------------------------------------------------------------------------------------------------------|
;- Port Listener | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                    |
; --------------------------------------------------------------------------------------------------------------|
 Case 2
; --------------------------------------------------------------------------------------------------------------|
;- split XMLData | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                    |
; --------------------------------------------------------------------------------------------------------------|
  Rest.s = Space(500)
  ReceiveNetworkData(EventClient(), @Rest, 500)
  Flags.l = CountString(Rest, "|")
  For s=0 To Flags
   Flag                  = FindString(Rest, "|", 0)-1
   XMLDaten(s)\Parameter = Mid(Rest, 1, Flag)
   Rest.s                = Mid(Rest, Flag+2, Len(Rest)+1)
  Next
  
; --------------------------------------------------------------------------------------------------------------|
;- CreateMe | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                         |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Getserverinfo"
   sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|"+Version)
  EndIf
  
; --------------------------------------------------------------------------------------------------------------|
;- CreateMe | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                         |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Createme"
   client_counter = 0
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\product = XMLDaten(3)\Parameter
      If client(x)\name = XMLDaten(2)\Parameter
       client_counter = 1
       Break
      EndIf
     EndIf
    EndIf
   Next
   If client_counter = 0
    For x=0 To maxClient-1
     If client(x)\in_use = "0"
      client(x)\in_use  = "1"
      client(x)\id      = Str(EventClient())
      client(x)\name    = XMLDaten(2)\Parameter
      client(x)\product = XMLDaten(3)\Parameter
      If client(x)\name <> "ServerAdmin"
       sendMSG("this", Val(client(x)\id), "", "", XMLDaten(1)\Parameter+"|true,"+client(x)\id+","+client(x)\name)
       sendMSG("this", Val(client(0)\id), "", "", "alert|"+client(x)\name+" has logged on "+client(x)\product+".")
      EndIf
      Break
     EndIf
    Next
   Else
    sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|false")
   EndIf
  EndIf

; --------------------------------------------------------------------------------------------------------------|
;- change MyName | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                    |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Changemyname"
   client_counter = 0
   For x=0 To maxClient-1
    If client(x)\id = Str(EventClient())
     product.s = client(x)\product
    EndIf
   Next x
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\product = product
      If client(x)\name = XMLDaten(2)\Parameter
       client_counter +1
      EndIf
     EndIf
    EndIf
   Next x
   If client_counter = 0
    For x=0 To maxClient-1
     If client(x)\in_use = "1"
      If client(x)\id = Str(EventClient())
       save_name.s    = client(x)\name
       client(x)\name = XMLDaten(2)\Parameter
       sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|true,"+client(x)\name)
       sendMSG("this", Val(client(0)\id), "", "", "alert|"+save_name+" changing name to "+client(x)\name+".")
      EndIf
     EndIf
    Next x
   Else
    sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|false")
   EndIf
  EndIf
  
; --------------------------------------------------------------------------------------------------------------|
;- GetUserList | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                      |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Getuserlist"
   CList.s = ""
   save_channel.s = XMLDaten(2)\Parameter
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\id = Str(EventClient())
      save_product.s = client(x)\product
      Break
     EndIf
    EndIf
   Next x
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\product = save_product
      If client(x)\channel = save_channel
       CList.s = CList + client(x)\id + ";;" + client(x)\name + ","
      EndIf
     EndIf
    EndIf
   Next x
   sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter + "|" + CList)
  EndIf

; --------------------------------------------------------------------------------------------------------------|
;- GetUserInfo | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                      |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(x)\Parameter = "Getuserinfo"
   CInfo.s = ""
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\id = Str(EventClient())
      save_id.s      = client(x)\id
      save_product.s = client(x)\product 
      Break
     EndIf 
    EndIf
   Next x
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\product = save_product
      If client(x)\id = XMLDaten(2)\Parameter
       CInfo.s = CInfo + client(x)\id
       CInfo.s = CInfo + client(x)\name
       CInfo.s = CInfo + client(x)\product
       CInfo.s = CInfo + client(x)\channel
       CInfo.s = CInfo + client(x)\attribut_1
       CInfo.s = CInfo + client(x)\attribut_2
       CInfo.s = CInfo + client(x)\attribut_3
       CInfo.s = CInfo + client(x)\attribut_4
       CInfo.s = CInfo + client(x)\attribut_5
       sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter + "|" + CInfo)
      EndIf
     EndIf
    EndIf
   Next x
  EndIf

; --------------------------------------------------------------------------------------------------------------|
;- create Channel | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                   |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Createchannel"
   cannel_counter.l = 0
   For c=0 To maxChannel-1
    If channel(c)\in_use = "1"
     If channel(c)\name = XMLDaten(2)\Parameter
      cannel_counter + 1
     EndIf
    EndIf
   Next c
   If cannel_counter = 0
    For c=0 To maxChannel-1
     If channel(c)\in_use = "0"
      channel(c)\in_use = "1"
      channel(c)\name   = XMLDaten(2)\Parameter
      channel(c)\modi   = XMLDaten(3)\Parameter
      channel(c)\pass   = XMLDaten(4)\Parameter
      save_channel.s    = channel(c)\name
      channel_num       = c
      sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|true,"+channel(c)\name+","+channel(c)\modi)
      Break
     EndIf
    Next c
    For x=0 To maxClient-1
     If client(x)\id = Str(EventClient())
       client(x)\channel = save_channel
       save_product.s    = client(x)\product
       sendMSG("this", Val(client(0)\id), "", "", "|"+client(x)\name+" has create and logged the Channel "+save_channel+".")
       Break
     EndIf
    Next x
    channel(channel_num)\product   = save_product
    sendMSG("all", EventClient(), save_product, "", "updateChannel|")
   Else
    sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|false")
   EndIf
  EndIf

; --------------------------------------------------------------------------------------------------------------|
;- change Channel | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                   |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Changechannel"
   change.s = "false"
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\id = Str(EventClient())
      If client(x)\channel <> XMLDaten(2)\Parameter
       save_id.s      = client(x)\id
       save_name.s    = client(x)\name
       save_channel.s = client(x)\channel
       save_product.s = client(x)\product
       For c=0 To maxChannel-1
        If channel(c)\in_use = "1"
         If channel(c)\pass = XMLDaten(3)\Parameter
          change.s = "true"
         EndIf
        EndIf
       Next c
       If change = "true"
        client(x)\channel = XMLDaten(2)\Parameter
        sendMSG("eatchother", EventClient(), save_product, client(x)\channel, "createClient|"+save_name+","+save_id)
        checkchannel(save_product, save_channel)
        sendMSG("all", EventClient(), save_product, "", "updateChannel|")
       EndIf
       Break
      EndIf
     EndIf
    EndIf
   Next x
   If change = "true"
    sendMSG("all", EventClient(), save_product, save_channel, "removeClient|"+save_name+","+save_id)
    sendMSG("this", Val(client(0)\id), "", "", "alert|"+save_name+" change the Channel "+save_channel+".")
    sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|true,"+XMLDaten(2)\Parameter)
    sendMSG("this", Val(client(0)\id), "", "", "alert|"+save_name+" log into the Channel "+XMLDaten(2)\Parameter+".")
    checkchannel(save_product, save_channel)
   Else
    sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|false")
   EndIf
  EndIf

; --------------------------------------------------------------------------------------------------------------|
;- getChannelList | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                   |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Getchannellist"
  CList.s = ""
  client_counter = 0
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\id = Str(EventClient())
      save_product = client(x)\product
      Break
     EndIf
    EndIf
   Next x
   For c=0 To maxChannel-1
    If channel(c)\in_use = "1"
     If channel(c)\product = save_product
      For x=0 To maxClient-1
       If client(x)\in_use = "1"
        If client(x)\product = save_product
         If client(x)\channel = channel(c)\name
          client_counter +1
         EndIf
        EndIf
       EndIf
      Next x
      CList.s = CList + channel(c)\name + ";;" + channel(c)\modi + ";;" + channel(c)\pass + ";;" + Str(client_counter) + ","
      client_counter = 0
     EndIf
    EndIf
   Next c
   sendMSG("this", EventClient(), "", "", XMLDaten(1)\Parameter+"|"+CList)
  EndIf
    
; --------------------------------------------------------------------------------------------------------------|
;- send String | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                      |
; --------------------------------------------------------------------------------------------------------------|
  If XMLDaten(0)\Parameter = "Sendstring"
   For x=0 To maxClient-1
    If client(x)\in_use = "1"
     If client(x)\id = Str(EventClient())
      save_id.s      = client(x)\id
      save_name.s    = client(x)\name
      save_product.s = client(x)\product
      save_channel.s = client(x)\channel
      Break
     EndIf
    EndIf
   Next x
   sendMSG(XMLDaten(2)\Parameter, Val(XMLDaten(3)\Parameter), save_product, save_channel, XMLDaten(1)\Parameter+"|"+XMLDaten(4)\Parameter)
  EndIf
  
 Case 4
; --------------------------------------------------------------------------------------------------------------|
;- remove Client | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                    |
; --------------------------------------------------------------------------------------------------------------|
 For x=0 To maxClient-1 
  If client(x)\id = Str(EventClient())
   save_id.s      = client(x)\id
   save_name.s    = client(x)\name
   save_channel.s = client(x)\channel
   save_product.s = client(x)\product
 
   client(x)\in_use     = "0"
   client(x)\name       = ""
   client(x)\product    = ""
   client(x)\channel    = ""
   client(x)\attribut_1 = ""
   client(x)\attribut_2 = ""
   client(x)\attribut_3 = ""
   client(x)\attribut_4 = ""
   client(x)\attribut_5 = ""
   sendMSG("all", EventClient(), save_product, save_channel, "removeClient|"+save_name+","+save_id)
   sendMSG("this", Val(client(0)\id), "", "", "alert|"+save_name+" disconnect the Server.")
  EndIf
 Next x
 checkchannel(save_product, save_channel)
 ;S/N: wpd800 58636 09432 63997
EndSelect
; IDE Options = PureBasic 5.11 (Windows - x64)
; CursorPosition = 317
; FirstLine = 269