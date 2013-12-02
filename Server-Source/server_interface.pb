; --------------------------------------------------------------------------------------------------------------|
;- Win_alpha-Blending | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                               |
; --------------------------------------------------------------------------------------------------------------|
; HideWindow(0,1)
; If OS
;   alphaBlending(Win, W_opacity, Flash_interface) 
; EndIf
; If Win And Flash_interface = "an"
;  WindowStyle(Win, W_i_x, W_i_y, W_i_width, W_i_height, W_i_corner)
; EndIf
; 
; CreateGadgetList(WindowID())
; If Flash_interface = "an"
;  createNetwork(Network_Port)
;  WebGadget(0,0,30,W_width,W_height+30,url$)
;  ImageGadget(1,0,0,W_width,11,UseImage(1),#PB_EventType_LeftClick)
;  ImageGadget(2,0,27,W_width,3,UseImage(2),#PB_EventType_LeftClick)
;  ImageGadget(3,0,11,W_width-30,16,UseImage(3),#PB_EventType_LeftClick)
;  ImageGadget(4,559,11,9,16,UseImage(4))
;  ImageGadget(5,528,11,17,16,UseImage(5),#PB_EventType_LeftClick)
;  ImageGadget(6,545,11,19,16,UseImage(6),#PB_EventType_LeftClick)
;  For v=0 To 6
;   HideGadget(v,1)
;  Next v
; EndIf
; 
; CreatePopupMenu(0)
;  MenuItem(1, "anzeigen")
;  MenuBar()
;  MenuItem(2, "beenden")
; 
; HideWindow(0,0)
; Delay(Timer)
;  For v=0 To 6
;   HideGadget(v,0)
;  Next v
; IDE Options = PureBasic 5.11 (Windows - x64)
; CursorPosition = 35