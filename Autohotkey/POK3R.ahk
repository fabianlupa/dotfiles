; This script emulates the behavior of a Poker 3 keyboard with QWERTZ layout
; and Capslock as FN enabled on any QWERTZ keyboard.

; Disable Capslock
SetCapsLockState, AlwaysOff

; Toggle Capslock by using Capslock+T
CapsLock & t::
GetKeyState, CapsLockState, CapsLock, T
if CapsLockState = D
    SetCapsLockState, AlwaysOff
else
    SetCapsLockState, AlwaysOn
KeyWait, ``
return

; Capslock+J -> Left
Capslock & j::Send {Blind}{Left DownTemp}
Capslock & j up::Send {Blind}{Left Up}

; Capslock+K -> Down
Capslock & k::Send {Blind}{Down DownTemp}
Capslock & k up::Send {Blind}{Down Up}

; Capslock+I -> Up
Capslock & i::Send {Blind}{Up DownTemp}
Capslock & i up::Send {Blind}{Up Up}

; Capslock+L -> Right
Capslock & l::Send {Blind}{Right DownTemp}
Capslock & l up::Send {Blind}{Right Up}

; Capslock+H -> Home
Capslock & h::SendInput {Blind}{Home Down}
Capslock & h up::SendInput {Blind}{Home Up}

; Capslock+N -> End
Capslock & n::SendInput {Blind}{End Down}
Capslock & n up::SendInput {Blind}{End Up}

; Capslock+U -> PageUp
Capslock & u::SendInput {Blind}{PgUp Down}
Capslock & u up::SendInput {Blind}{PgUp Up}

; Capslock+O -> PageDown
Capslock & o::SendInput {Blind}{PgDn Down}
Capslock & o up::SendInput {Blind}{PgDn Up}

; Capslock+Number -> F-Key
Capslock & 1::SendInput {Blind}{F1}
Capslock & 2::SendInput {Blind}{F2}
Capslock & 3::SendInput {Blind}{F3}
Capslock & 4::SendInput {Blind}{F4}
Capslock & 5::SendInput {Blind}{F5}
Capslock & 6::SendInput {Blind}{F6}
Capslock & 7::SendInput {Blind}{F7}
Capslock & 8::SendInput {Blind}{F8}
Capslock & 9::SendInput {Blind}{F9}
Capslock & 0::SendInput {Blind}{F10}
Capslock & -::SendInput {Blind}{F11}
Capslock & =::SendInput {Blind}{F12}

; Capslock+Backspace -> Delete
Capslock & BS::SendInput {Del Down}
Capslock & BS up::SendInput {Del Up}

; Capslock+Ö -> Insert
Capslock & ö::SendInput {Ins Down}
Capslock & ö up::SendInput {Ins Up}

; Capslock+Ä -> Delete
Capslock & ä::SendInput {Del Down}
Capslock & ä up::SendInput {Del Up}
