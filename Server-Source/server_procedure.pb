; --------------------------------------------------------------------------------------------------------------|
;- Path_ermitlung | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                   |
; --------------------------------------------------------------------------------------------------------------|
Procedure.s Path() 
  Path$ = Space(1000) 
  GetModuleFileName_(0,@Path$,1000) 
  ProcedureReturn GetPathPart(Path$) 
EndProcedure 

; --------------------------------------------------------------------------------------------------------------|
;- Win_alpha-Blending | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                               |
; --------------------------------------------------------------------------------------------------------------|
If OSVersion() = #PB_OS_Windows_2000 Or OSVersion() = #PB_OS_Windows_XP Or OSVersion() = #PB_OS_Windows_Future 
 OS = #True : Else : OS = #False 
EndIf
Procedure alphaBlending (Win.l, Opacity.l, Flash_interface.s) 
 SetWindowLong_(Win, #GWL_EXSTYLE, $00080000) 
 If OpenLibrary(1, "user32.dll") 
  CallFunction(1, "SetLayeredWindowAttributes", Win, 0, Opacity, 2) 
  CloseLibrary(1)
 EndIf 
EndProcedure

; --------------------------------------------------------------------------------------------------------------|
;- Win_Style | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                        |
; --------------------------------------------------------------------------------------------------------------|
Procedure WindowStyle(Win.l, W_i_x.l, W_i_y.l, W_i_width.l, W_i_height.l, W_i_corner.l) 
 GRgn.l 
 RgnA.l 
 RgnB.l 
 RgnB = CreateEllipticRgn_(0, 0, 0, 0) 
 RgnA = CreateRoundRectRgn_(W_i_x, W_i_y, W_i_width, W_i_height, W_i_corner, W_i_corner) 
 GRgn = RgnA 
 CombineRgn_(GRgn, GRgn, RgnB, #RGN_OR) 
 SetWindowRgn_(Win, GRgn, True) 
 hBrush1 = CreateSolidBrush_(RGB(168,245,83)) 
 SetClassLong_(Win, #GCL_HBRBACKGROUND, hBrush1) 
 InvalidateRect_(Win, #NULL, #TRUE)
EndProcedure 

; --------------------------------------------------------------------------------------------------------------|
;- Win_Move | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                         |
; --------------------------------------------------------------------------------------------------------------|
Procedure WinMove() 
   ReleaseCapture_()
   SendMessage_(WindowID(), #WM_SYSCOMMAND, #SC_MOVE + #HTCAPTION, 0) 
EndProcedure 

; --------------------------------------------------------------------------------------------------------------|
;- Create-Network | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                   |
; --------------------------------------------------------------------------------------------------------------|
Procedure createNetwork (Network_Port.l)
 If InitNetwork() = 0: End: EndIf
 Socket.l = CreateNetworkServer(Network_Port) 
 If Socket = 0: End : EndIf
 #FD_ALL = #FD_READ|#FD_WRITE|#FD_OOB|#FD_ACCEPT|#FD_CONNECT|#FD_CLOSE
 WSAAsyncSelect_(Socket, WindowID(), #WM_NULL, #FD_ALL)
EndProcedure

; --------------------------------------------------------------------------------------------------------------|
;- Netzwerk-Adapter | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                 |
; --------------------------------------------------------------------------------------------------------------|
Procedure sendMSG (Empfaenger.s, ClientID.l, Product.s, Channel.s, Msg.s)
;MessageRequester("sendMSG",Empfaenger+","+ Str(ClientID)+","+ Product+","+ Channel+","+ Msg)
 If Empfaenger = "all"
  For x=0 To 99
   If client(x)\in_use = "1"
    If client(x)\product = Product
     If client(x)\channel = Channel
      SendNetworkData(Val(client(x)\id), @Msg, Len(Msg)+1)
     EndIf
    EndIf
   EndIf
  Next x
 EndIf
 If Empfaenger = "eatchother"
  For x=0 To 99
   If client(x)\in_use = "1"
    If client(x)\product = Product
     If client(x)\channel = Channel
      If client(x)\id <> Str(ClientID)
       SendNetworkData(Val(client(x)\id), @Msg, Len(Msg)+1)
      EndIf
     EndIf
    EndIf
   EndIf
  Next x
 EndIf
 If Empfaenger = "this"
  SendNetworkData(ClientID, @Msg, Len(Msg)+1)
 EndIf
 If Empfaenger = "global"
  For x=0 To 99
   If client(x)\in_use = "1"
    SendNetworkData(Val(client(x)\id), @Msg, Len(Msg)+1)
   EndIf
  Next x
 EndIf
EndProcedure

; --------------------------------------------------------------------------------------------------------------|
;- check Channel | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                    |
; --------------------------------------------------------------------------------------------------------------|
Procedure checkchannel (save_product.s, save_channel.s)
 client_counter = 0
 For x=0 To 99
  If client(x)\in_use = "1"
   If client(x)\product = save_product
    If client(x)\channel = save_channel
     client_counter+1
    EndIf
   EndIf
  EndIf
 Next x
 If client_counter = 0
  For c=0 To 99
   If channel(c)\product = save_product
    If save_channel <> ""
     If channel(c)\name = save_channel
      channel(c)\in_use = "0"
      channel(c)\name   = ""
      channel(c)\product= ""
      sendMSG("this", Val(client(0)\id), "", "", "alert|Channel "+save_channel+" is closed by Server.")
     EndIf
    EndIf
   EndIf
  Next c
 EndIf
 sendMSG("all", NetworkClientID(), save_product, "", "updateChannel|")
EndProcedure
; ExecutableFormat=Windows
; EOF