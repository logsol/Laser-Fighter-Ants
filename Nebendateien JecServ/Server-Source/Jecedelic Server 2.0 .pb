url$="about:<html><body scroll='no' margin='0'><h1>Test</h1></body></html>"
; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

GoodOS = OSVersion() 
If GoodOS = #PB_OS_Windows_2000 Or GoodOS = #PB_OS_Windows_XP Or GoodOS = #PB_OS_Windows_Future 
  GoodOS = #True : Else : GoodOS = #False 
EndIf 

Procedure SetWinOpacity (hwnd.l, Opacity.l) ; Opacity: Undurchsichtigkeit 0-255 
  SetWindowLong_(hwnd, #GWL_EXSTYLE, $00080000) 
  If OpenLibrary(1, "user32.dll") 
    CallFunction(1, "SetLayeredWindowAttributes", hwnd, 0, Opacity, 2) 
    CloseLibrary(1) 
  EndIf 
EndProcedure

; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

;- GlobalVars
Serverbezeichnung.s = "Jecedelic Server 2.0"
;Z.s = "G:\Projekte\Jecedelic Server\Server-Anwendung\"
Z.s = "Z:\Jecedelic Server\Server-Anwendung\"

;- Load Externdata
InitSound()
LoadSound(0,Z+"sound\nvg_on.wav")
LoadSound(1,Z+"sound\buddyin.wav")
LoadSound(2,Z+"sound\buddyout.wav")

LoadImage(0,Z+"img\server.bmp")
LoadImage(1,Z+"img\channel.bmp")
LoadImage(2,Z+"img\game.bmp")
LoadImage(3,Z+"img\user.bmp")

;- Build Client_Array for Identification
Structure Client
    in_use.s
    id.s 
    name.s
    channel.s
EndStructure
Dim daten.Client(100)
For x=0 To 99
 daten(x)\in_use ="0"
Next

;- Build Channel_Array for Comunication
Structure Channel
    in_use.s 
    name.s
    modi.s
    pass.s
EndStructure
Dim channel.Channel(100)
For x=0 To 99
 channel(x)\in_use ="0"
Next

;- Build Flags for Server-Interface
Opacity            = 250
Pannel             = 0
Cannel_Liste       = 1
Server_Ausgabefeld = 2


; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

;- Create Server-Interface
hWnd=OpenWindow(0,0,0,700,300, #PB_Window_Screencentered | #PB_Window_SystemMenu, "Jecedelic Server 2.0")
If GoodOS 
  SetWinOpacity(hWnd, Opacity) 
EndIf

PlaySound(0)
CreateGadgetList(WindowID())
PanelGadget     (Pannel,5,5,690,280)
 AddGadgetItem (Pannel,0,"Allgemeines")
  WebGadget(4,1,1,684,50,url$)
 CloseGadgetList()

 AddGadgetItem (Pannel,-1,"Sonstiges")
 TreeGadget(Cannel_Liste, 5,5,170,200)
  AddGadgetItem (Cannel_Liste, 0, Serverbezeichnung, UseImage(0))
  OpenTreeGadgetNode(Cannel_Liste)
   AddGadgetItem(Cannel_Liste, 1, "Main", UseImage(1))
    OpenTreeGadgetNode(Cannel_Liste)
    CloseTreeGadgetNode(Cannel_Liste)
  CloseTreeGadgetNode(Cannel_Liste)
 channel(0)\in_use = "1"
 channel(0)\name   = "Main"
 
 ListIconGadget(Server_Ausgabefeld,180, 5, 500, 200,"Client_Id",60,#PB_ListIcon_FullRowSelect|#PB_ListIcon_HeaderDragDrop)
 AddGadgetColumn(Server_Ausgabefeld,1,"Client_Name",100)
 AddGadgetColumn(Server_Ausgabefeld,2,"Channel",100)
 AddGadgetColumn(Server_Ausgabefeld,3,"Server_Message",235)
 


 ButtonGadget(3, 180, 205, 150, 20, "Protokoll löschen ..." ,#PB_EventType_LeftClick)

;- Create Network
If InitNetwork() = 0: End: EndIf
Socket.l = CreateNetworkServer(6000) 
If Socket = 0: End: EndIf
#FD_ALL = #FD_READ|#FD_WRITE|#FD_OOB|#FD_ACCEPT|#FD_CONNECT|#FD_CLOSE
WSAAsyncSelect_(Socket, WindowID(), #WM_NULL, #FD_ALL) 

; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

Repeat

;- Interface interaktions
  Select WaitWindowEvent()
  
;- Close Window via x
    Case #PB_EventCloseWindow
      For x=0 To 99
        If daten(x)\in_use = "1"
         Send_Data.s = "alert|Jecedelic Server is down ..."
         SendNetworkData(Val(daten(x)\id), @Send_Data, Len(Send_Data)+1)
        EndIf
      Next
      End
      
;- Press Button or Gaget
    Case #PB_Event_Gadget
     Select EventGadgetID()
      Case 3 : ClearGadgetItemList(Server_Ausgabefeld)
     EndSelect
  EndSelect

;- Network interaktions
IncludeFile "serverEvent.pb"
  
ForEver


;- Create_Channellist
Create_Channellist:
   For c=1 To 99
   client_counter.l = 0
    For x=0 To 99
     If daten(x)\in_use = "1"
      If daten(x)\channel = channel(c)\name
       client_counter + 1
      EndIf
     EndIf
    Next
   If client_counter = 0
   channel(c)\in_use = "0"
   channel(c)\name   = ""
   EndIf
   Next
   ClearGadgetItemList(Cannel_Liste)
   
   AddGadgetItem (Cannel_Liste, 0, Serverbezeichnung, UseImage(0))
   OpenTreeGadgetNode(Cannel_Liste)
   For c=0 To 99
    If channel(c)\in_use = "1"
     If channel(c)\name = "Main"
      img.l=1
     Else
      img.l=2
     EndIf
    AddGadgetItem(Cannel_Liste,-1,channel(c)\name,UseImage(img))
    OpenTreeGadgetNode(Cannel_Liste)
     For x=0 To 99
      If daten(x)\in_use = "1"
       If daten(x)\channel = channel(c)\name
        AddGadgetItem (Cannel_Liste, -1, daten(x)\name, UseImage(3))
       EndIf
      EndIf
     Next
     CloseTreeGadgetNode(Cannel_Liste)
    EndIf
   Next
   CloseTreeGadgetNode(Cannel_Liste)
   SetGadgetItemState(Cannel_Liste, 0, #PB_Tree_Expanded)
   SetGadgetItemState(Cannel_Liste, 1, #PB_Tree_Expanded)
   
    For x=0 To 99
     If daten(x)\in_use = "1"
      If daten(x)\channel = "Main"
       update.s = "updateChannel|"
       SendNetworkData(Val(daten(x)\id),@update, Len(update)+1)
      EndIf
     EndIf
    Next
Return
; ExecutableFormat=Windows
; EnableNT4
; EnableXP
; UseIcon=Z:\Jecedelic Server\Server-Anwendung\img\server.ico
; Executable=Z:\Jecedelic Server\Server-Anwendung\Jecedelic Server 2.0 .exe
; EOF