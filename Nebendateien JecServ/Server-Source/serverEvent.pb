Select NetworkServerEvent()
 Case 1
;- Connection
  Send_Data.s = "alert|Willkommen auf dem Jecedelic Server 2.0"
  SendNetworkData(NetworkClientID(), @Send_Data, Len(Send_Data)+1)

 Case 2
;- ReceiveData_Split
  Receive_Data.s = Space(500)
  ReceiveNetworkData(NetworkClientID(), @Receive_Data, 500)
  
  Comand_Flag_1 = FindString(Receive_Data, "|", 0)-1
  Comand.s      = Mid(Receive_Data, 1, Comand_Flag_1)
  Rest.s        = Mid(Receive_Data, Comand_Flag_1+2, Len(Receive_Data)+1)
  
  Comand_Flag_2 = FindString(Rest, "|", 0)-1
  Callback.s    = Mid(Rest, 1, Comand_Flag_2)
  Rest.s        = Mid(Rest, Comand_Flag_2+2, Len(Rest)+1)
  
  Comand_Flag_3 = FindString(Rest, "|", 0)-1
  Parameter_1.s = Mid(Rest, 1, Comand_Flag_3)
  Rest.s        = Mid(Rest, Comand_Flag_3+2, Len(Rest)+1)
  
  Comand_Flag_4 = FindString(Rest, "|", 0)-1
  Parameter_2.s = Mid(Rest, 1, Comand_Flag_4)
  Rest.s        = Mid(Rest, Comand_Flag_4+2, Len(Rest)+1)
  
  Comand_Flag_5 = FindString(Rest, "|", 0)-1
  Parameter_3.s = Mid(Rest, 1, Comand_Flag_5)
  Rest.s        = Mid(Rest, Comand_Flag_5+2, Len(Rest)+1)
  
  ;MessageRequester("",Comand)
;- Create_Client
  If Comand = "Createclient"
   PlaySound(1)
   For x=0 To 99
    If daten(x)\in_use="0"
     daten(x)\in_use= "1"
     daten(x)\id    = Str(NetworkClientID())
     daten(x)\name  = Parameter_1
     daten(x)\channel= "Main"
     AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Connect the Jecedelic Server")
     Login_text.s = Callback+"|true,"+daten(x)\id+","+daten(x)\name+","+daten(x)\channel
     SendNetworkData(NetworkClientID(),@Login_text, Len(Login_text)+1)
     Break
    EndIf
   Next
   Gosub Create_Channellist
  EndIf

;- Create_Cannel
  If Comand = "Createchannel"
   cannel_counter.l = 0
   For c=0 To 99
    If channel(c)\in_use = "1"
     If channel(c)\name = Parameter_1
      cannel_counter + 1
     EndIf
    EndIf
   Next
   If cannel_counter = 0
    For c=0 To 99
     If channel(c)\in_use = "0"
      channel(c)\in_use = "1"
      channel(c)\name   = Parameter_1
      channel(c)\modi   = Parameter_2
      channel(c)\pass   = Parameter_3
      new_Channel.s = Callback+"|true,"+channel(c)\name+","+channel(c)\modi+","+channel(c)\pass
      SendNetworkData(NetworkClientID(),@new_Channel, Len(new_Channel)+1)
      Break
     EndIf
    Next
    For x=0 To 99
     If daten(x)\id = Str(NetworkClientID())
      AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Create a new Channel ("+Parameter_1+")")
      AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Log-out")
      daten(x)\channel = Parameter_1
      AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Log-in")
      Break
     EndIf
    Next
    Gosub Create_Channellist
   Else
;- Create_Channel_false-exzist
     new_Channel.s = Callback+"|false"
     SendNetworkData(NetworkClientID(),@new_Channel, Len(new_Channel)+1)
   EndIf
  EndIf

;- Change_Channel
  If Comand = "Changechannel"
             Client_Log.s = Callback+"|drin.."
           SendNetworkData(NetworkClientID(), @Client_Log, Len(Client_Log)+1)
   log.s="false"
   For c=0 To 99
    If channel(c)\in_use = "1"
     If channel(c)\name = Parameter_1
      For x=0 To 99
       If daten(x)\in_use = "1"
        If daten(x)\id = Str(NetworkClientID())
         If daten(x)\channel = Parameter_1
         log.s="false"
;- Change_Channel_false-is_in
          Client_Log.s = Callback+"|"+log
          SendNetworkData(NetworkClientID(), @Client_Log, Len(Client_Log)+1)
         Else
          If channel(c)\pass = Parameter_2
           old_channel.s = daten(x)\channel
           daten(x)\channel = Parameter_1
           AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+old_channel+Chr(10)+"Log-out")
           AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Log-in")       
           save_id.s   = daten(x)\id
           save_name.s = daten(x)\name
           log.s="true"
           Client_Log.s = Callback+"|"+log+","+Parameter_1
           SendNetworkData(NetworkClientID(), @Client_Log, Len(Client_Log)+1)
          EndIf
         EndIf
        EndIf
       EndIf
      Next  
     EndIf
    EndIf
   Next
   If log="true"
    For x=0 To 99
     If daten(x)\in_use = "1"
      If daten(x)\channel = Parameter_1
       If daten(x)\id = save_id       
       Else
        Client_Log.s = "new_client_log|"+save_id+"|"+save_name
        SendNetworkData(daten(x)\id, @Client_Log, Len(Client_Log)+1)
       EndIf
      Else
       If daten(x)\channel = old_channel
        Remove_Client.s = "remove_client|"+save_id+"|"+save_name
        SendNetworkData(daten(x)\id, @Remove_Client, Len(Remove_Client)+1)
       EndIf
      EndIf
     EndIf
    Next
    Gosub Create_Channellist
   EndIf
  EndIf
  
;- Change_Name
  If Comand = "Changename"
   For x=0 To 99
    If daten(x)\in_use = "1"
     If daten(x)\id = Str(NetworkClientID())
      AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Change Username to ("+Parameter_1+")")      
      daten(x)\name = Parameter_1
      Change_Name.s = Callback+"|"+daten(x)\name
      SendNetworkData(Val(daten(x)\id), @Change_Name, Len(Change_Name)+1)
      Gosub Create_Channellist
      Break
     EndIf
    EndIf
   Next
  EndIf
  
  
;- Channellist
  CListe.s = ""
  If Comand = "Channellist"
   For c=1 To 100
    If channel(c)\in_use = "1"
     client_counter = 0
     For cl=0 To 99
      If daten(cl)\in_use = "1"
       If daten(cl)\channel = channel(c)\name
        client_counter + 1
       EndIf
      EndIf
     Next
     CListe.s = CListe + channel(c)\name + ";;" + channel(c)\modi + ";;" + channel(c)\pass + ";;" + Str(client_counter) + ","
    EndIf
   Next c
   Channel_String.s = Callback+"|"+CListe
   SendNetworkData(NetworkClientID(), @Channel_String, Len(Channel_String)+1)
  EndIf
  
  
;- Send String
  If Comand = "String"
   For x=0 To 99
    If daten(x)\in_use = "1"
     If daten(x)\id = Str(NetworkClientID())
      If Parameter_1 = "all"
       String.s = Parameter_2
       SendNetworkData(NetworkClientID(), @String, Len(String)+1)
      EndIf
     Else
      If Parameter_1 = "eachother"
       String.s = Parameter_2
       SendNetworkData(NetworkClientID(), @String, Len(String)+1)
      EndIf
      If Parameter_1 = "person"
       If daten(x)\name = Parameter_3
        String.s = Parameter_2
        SendNetworkData(NetworkClientID(), @String, Len(String)+1)
       EndIf
      EndIf
     EndIf
    EndIf
   Next
  EndIf
  
;- Remove_Client
 Case 4
  ClearGadgetItemList(Cannel_Liste)
  For x=0 To 99
   If daten(x)\id = Str(NetworkClientID())
    Client_go_home_id.s      = daten(x)\id
    Client_go_home_name.s    = daten(x)\name
    Client_go_home_channel.s = daten(x)\channel
    AddGadgetItem(Server_Ausgabefeld,0, daten(x)\id+Chr(10)+daten(x)\name+Chr(10)+daten(x)\channel+Chr(10)+"Disconnect the Jecedelic Server")
    daten(x)\in_use = "0"
    daten(x)\id     = ""
    daten(x)\name   = ""
    daten(x)\channel= ""
   EndIf
  Next
  For x=0 To 99
   If daten(x)\in_use = "1"
    If daten(x)\channel = Client_go_home_channel
     Client_go_home_string.s = "remove_client|"+ Client_go_home_id + "|" + Client_go_home_name
     SendNetworkData(NetworkClientID(), @Client_go_home_string, Len(Client_go_home_string)+1)
    EndIf
   EndIf
  Next
  Gosub Create_Channellist
  PlaySound(2)
  
EndSelect
; ExecutableFormat=Windows
; DisableDebugger
; EOF