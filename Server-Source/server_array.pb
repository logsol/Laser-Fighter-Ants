; --------------------------------------------------------------------------------------------------------------|
;- Client Array | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                     |
; --------------------------------------------------------------------------------------------------------------|
Structure Client
 in_use.s
 id.s 
 name.s
 product.s 
 channel.s
 attribut_1.s
 attribut_2.s
 attribut_3.s
 attribut_4.s
 attribut_5.s
EndStructure
Global Dim client.Client(maxClient)

;- Array DB generieren
For x=0 To maxClient - 1
 client(x)\in_use = "0"
Next x

; --------------------------------------------------------------------------------------------------------------|
;- Channel Array | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                    |
; --------------------------------------------------------------------------------------------------------------|
Structure Channel
 in_use.s
 product.s
 name.s
 modi.s
 pass.s
EndStructure
Global Dim channel.Channel(maxChannel)

;- Array DB generieren
For c=0 To maxChannel - 1
 channel(c)\in_use = "0"
Next c

; --------------------------------------------------------------------------------------------------------------|
;- Server Array | Author: T.Schmalenberg | (c)rigthed by Jecedelic Software                                     |
; --------------------------------------------------------------------------------------------------------------|
Structure Server
 Parameter.s
EndStructure
Global Dim XMLDaten.Server(maxXMLDaten)

;- Array DB generieren
For s=0 To maxXMLDaten- 1
 XMLDaten(s)\Parameter = ""
Next s
; IDE Options = PureBasic 5.11 (Windows - x64)
; CursorPosition = 45