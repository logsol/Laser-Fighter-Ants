; --------------------------------------------------------------------------------------------------------------|
;- Include Server-Matrix | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                            |
; --------------------------------------------------------------------------------------------------------------|
IncludeFile "server_var.pb"
IncludeFile "server_array.pb"
IncludeFile "server_procedure.pb"
IncludeFile "server_include.pb"

;Win=OpenWindow(0,W_x,W_y,W_width,W_height, #W_Attributs, "Jecedelic Server "+Version)

; --------------------------------------------------------------------------------------------------------------|
;- Include Server-Interface | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                         |
; --------------------------------------------------------------------------------------------------------------|
IncludeFile "server_interface.pb"
createNetwork(Network_Port)
Repeat
 IncludeFile "window_event.pb"
 IncludeFile "server_event.pb"
 Delay(1)
ForEver
; ExecutableFormat=Windows
; EnableNT4
; IDE Options = PureBasic 5.11 (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 18
; Executable = G:\Projekte\Jecedelic Server\Server-Anwendung\Jecedelic Server 2.1 .exe