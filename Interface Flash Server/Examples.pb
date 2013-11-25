; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=759&highlight=
; Author: Danilo
; Date: 01. May 2003
LoadImage(0,"designbg.bmp")

GoodOS = OSVersion() 
If GoodOS = #PB_OS_Windows_2000 Or GoodOS = #PB_OS_Windows_XP Or GoodOS = #PB_OS_Windows_Future 
  GoodOS = #True : Else : GoodOS = #False 
EndIf 

; SetLayeredWindowAttributes is only available for Win2000, WinXP - so we have this little version check included
Procedure SetWinOpacity (hwnd.l, Opacity.l) ; Opacity: Undurchsichtigkeit 0-255 
  SetWindowLong_(hwnd, #GWL_EXSTYLE, $00080000) 
  If OpenLibrary(1, "user32.dll") 
    CallFunction(1, "SetLayeredWindowAttributes", hwnd, 0, Opacity, 2) 
    CloseLibrary(1) 
  EndIf 
  ;MakeToolWindow(hwnd, 1)   ; activate this line, if you want to have a ToolWindow  (need user-lib ToolBar Prof. from Danilo)
EndProcedure
Procedure NewWindowStyle(hWnd.l) 
GRgn.l 
RgnA.l 
RgnB.l

;  Erzeugen der Regionen 
    RgnB = CreateRoundRectRgn_(3, 30, 571, 379, 12, 12) 
    RgnA = CreateRoundRectRgn_(0,0,0,0,0,0)
      

    ;Regionen kombinieren 
    GRgn = RgnA 
    CombineRgn_(GRgn, GRgn, RgnB, #RGN_OR) 
    ;auf das Fenster anwenden 
    SetWindowRgn_(hWnd, GRgn, Tru) 

    HideWindow(0,0) ; Das Fenster anzeigen 
EndProcedure 

hWnd.l = OpenWindow(0, 100, 100, 700, 500,#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_Invisible, "PureBasic Window") 
If GoodOS 
  SetWinOpacity(hWnd, 100) 
EndIf

CreateGadgetList(WindowID())
 ImageGadget(0,0,0,568,349,UseImage(0))
If hwnd 
NewWindowStyle(hWnd)
  Repeat 
    EventID.l = WaitWindowEvent() 
    
    Select EventID
     Case #PB_Event_CloseWindow 
     End 
     Case #WM_LBUTTONDOWN
     SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
    EndSelect
    
  Until EventID = #PB_EventCloseWindow 
EndIf 
End 
; ExecutableFormat=Windows
; CursorPosition=1
; FirstLine=1
; EOF

; ExecutableFormat=Windows
; EOF