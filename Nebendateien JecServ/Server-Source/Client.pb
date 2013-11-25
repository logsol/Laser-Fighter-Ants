OpenWindow(0,0,0,400,400, #PB_Window_Screencentered | #PB_Window_SystemMenu, "Client")

CreateGadgetList(WindowID())
ListViewGadget(1, 5, 5, 290, 390)
ButtonGadget(2, 295, 5, 100, 20, "Create Room" ,#PB_EventType_LeftClick)
ButtonGadget(3, 295, 25, 100, 20, "Change Channel" ,#PB_EventType_LeftClick)
ButtonGadget(4, 295, 45, 100, 20, "Channellist" ,#PB_EventType_LeftClick)

If InitNetwork()=0: End: EndIf
ConnID.l = OpenNetworkConnection("localhost",6000)
If ConnID = 0: End: EndIf

#FD_ALL = #FD_READ|#FD_WRITE|#FD_OOB|#FD_ACCEPT|#FD_CONNECT|#FD_CLOSE
WSAAsyncSelect_(ConnID, WindowID(), #WM_NULL, #FD_ALL) 

Repeat

  Select WaitWindowEvent()
    Case #PB_EventCloseWindow : End
    Case #PB_Event_Gadget
     Select EventGadgetID()
      Case 2 : SendNetworkString(ConnID,"Createchannel|callback|Battel GrandMom|Jungel||")
      Case 3 : SendNetworkString(ConnID,"Changechannel|callback|Battel GrandMom||")
      Case 4 : SendNetworkString(ConnID,"Channellist|callback|")
     EndSelect
  EndSelect

  
  If NetworkClientEvent(ConnID) = 2
    Receive_Data.s = Space(500)
    ReceiveNetworkData(ConnID, @Receive_Data, 500)
    Comand_Flag = FindString(Receive_Data, "|", 0)-1
    Comand.s = Mid(Receive_Data, 1, Comand_Flag)
    
    If Comand = "alert"
     SendNetworkString(ConnID, "Createclient|CALLBACK|" + Hostname() + "|")
    EndIf
    AddGadgetItem(1,0,Receive_Data)
  EndIf
  
ForEver
; ExecutableFormat=Windows
; EnableNT4
; UseIcon=client.ico
; Executable=G:\Projekte\Jecedelic Server\client.exe
; EOF