; --------------------------------------------------------------------------------------------------------------|
;- Window Event-Handling | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                            |
; --------------------------------------------------------------------------------------------------------------|
Select WaitWindowEvent()
 Case #PB_EventCloseWindow 
  sendMSG("global", NetworkClientID(), "", "", "alert|Jecedelic Server "+Version+" is down!")
  End : DeleteObject_(hBrush1)
 Case #PB_Event_Gadget
  Select EventGadgetID()
   Case 0 : createNetwork(Network_Port)
   Case 1 : WinMove()
   Case 2 : WinMove()
   Case 3 : WinMove()
   Case 5
    HideWindow(0,1)
    AddSysTrayIcon(7, WindowID(), LoadImage(7, "icon16_xp.ico"))
    SysTrayIconToolTip(7, "Jecedelic Server "+Version)
   Case 6 
    sendMSG("global", NetworkClientID(), "", "", "onAlert|Jecedelic Server "+Version+" is down!")
    End : DeleteObject_(hBrush1)
  EndSelect
 Case #PB_Event_SysTray
  Select EventType()
   Case #PB_EventType_LeftClick
    HideWindow(0,0)
    RemoveSysTrayIcon(7)
   Case #PB_EventType_RightClick
    DisplayPopupMenu(0, WindowID())
  EndSelect
 Case #PB_EventMenu
  Select EventMenuID()
   Case 1
    HideWindow(0,0)
    RemoveSysTrayIcon(7)
   Case 2
    sendMSG("global", NetworkClientID(), "", "", "onAlert|Jecedelic Server "+Version+" is down!")
    End : DeleteObject_(hBrush1)
  EndSelect
EndSelect
; ExecutableFormat=Windows
; EOF