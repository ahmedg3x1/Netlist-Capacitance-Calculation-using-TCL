#! C:/Tcl/bin/tclsh

proc Calculate_capacitance {cap_list flag} {
    #flag = 1 -> parallel
    set result 0
    
    if {$flag} {
        foreach cap $cap_list {
            set result [expr $result + $cap]
        }
        return $result
    }
    
    foreach cap $cap_list {
            set result [expr $result + 1.0/$cap]
    }
    return [expr 1.0/$result]
}
