#Requires AutoHotkey v2.0
#Module GetFilePathFromFileObject
Export Default GetFilePathFromFileObject(FileObject) {
    static GetFinalPathNameByHandleW := DllCall("Kernel32\GetProcAddress", "Ptr", DllCall("Kernel32\GetModuleHandle",
        "Str", "Kernel32", "Ptr"), "AStr", "GetFinalPathNameByHandleW", "Ptr")

    ; Initialize a buffer to receive the file path
    static bufSize := 65536    ;64kb to accomodate long path names in UTF-16
    buf := Buffer(bufSize)

    ; Call GetFinalPathNameByHandleW
    len := DllCall(GetFinalPathNameByHandleW
        , "Ptr", FileObject.handle       ; File handle
        , "Ptr", buf         ; Buffer to receive the path
        , "UInt", bufSize    ; Size of the buffer (in wchar_t units)
        , "UInt", 0          ; Flags (0 for default behavior)
        , "UInt")            ; Return length of the file path

    if(len == 0 || len > bufSize)
        throw Error("Failed to retrieve file path or insufficient buffer size.", A_LastError)

    ; Return the result as a string
    return StrGet(buf, "UTF-16")
}