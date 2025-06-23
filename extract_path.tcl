#! C:/Tcl/bin/tclsh

set module_ports [list A B C K]

set fread [open ./netlist.v r]

while {![eof $fread]} {
    set line [gets $fread]
    set found [regexp {(\w+)\s+(i_\d+_?\d*)\s+\((.*)\)} $line fillmatch name id ports]
    if {$found} {
        set instance_name($id) $name
        set matched [regexp -all -inline {\.\w+\((\w+\[?\d*\]?)\)} $ports]

        foreach {fullmatch port} $matched {
            lappend instances_ports($id) $port
        }
    }
}

close $fread

proc find_paths {paths_arr desired_ip desired_port {from_inst ""}} {
    upvar #0 $paths_arr arr
    foreach inst_id [array names ::instances_ports] {
        if {[lsearch $from_inst $inst_id] >= 0} {continue}

        foreach port $::instances_ports($inst_id) {
            if {$port == $desired_port} {

                lappend from_inst $inst_id
                
                foreach port $::instances_ports($inst_id) {
                    regexp {(\w+)\[?\d*\]?} $port fullmatch p
                    if {[lsearch $::module_ports $p] < 0 && $desired_port != $port } {
                        find_paths $paths_arr $desired_ip $port $from_inst
                    }

                    if {$desired_ip == $port} {
                        lappend arr $from_inst
                    }
                }
                return
            }
        }
    }
}


proc parallel_path {path p1 p2} {
    return [lrange $path [lsearch $path $p1]+1 [lsearch $path $p2]-1] 
}

proc idetify_path {path1 path2} {
    lappend path1 E
    lappend path2 E
    set R ""
    set foundNum 0
    set found_ele ""
    foreach ele1 $path1 {
        set found [lsearch $path2 $ele1]
            if {$found >= 0} {
                incr foundNum
                lappend found_ele $ele1     
            }
            if {$found >=0 && $foundNum >= 2} {

                set p1 [lindex $found_ele 0]
                set p2 [lindex $found_ele 1]
                set z1 ""
                set z2 ""
                set z1 [parallel_path $path1 $p1 $p2]
                set z2 [parallel_path $path2 $p1 $p2]

                set zt ""
                if {$z1 != "" && $z2 != ""} {
                    set zt "P {$z1} {$z2}"
                }

                if {!($foundNum%2)} {
                    lappend R $p1
                }

                if {$zt != ""} {lappend R $zt}
                lappend R $p2
                set found_ele [lreplace $found_ele 0 0]  
            } 
    }
    
    return [lrange $R 0 end-1]
}    


