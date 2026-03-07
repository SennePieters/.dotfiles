*Capslock::
    ; Press the Left Windows key down invisibly
    Send {LWin down}
    
    ; Wait for you to release the key
    KeyWait, Capslock
    
    ; Check if you hit any other keys while holding it. 
    if (A_PriorKey = "Capslock") {
        ; If you ONLY pressed Capslock and let go, send a dummy key to prevent Start Menu, then CapsLock.
        Send {Blind}{vkE8}
        Send {LWin up}
        Send {CapsLock}
    } else {
        ; Release the Windows key
        Send {LWin up}
    }
return