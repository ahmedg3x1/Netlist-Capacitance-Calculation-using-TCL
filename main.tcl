#! C:/Tcl/bin/tclsh
source cap_extraction.tcl
source calc_cap.tcl
source extract_path.tcl


if {[lindex $argv 0] != "-path"} {
    return
}

set ports  [split [lindex $argv 1] :]
  
set port1 [lindex $ports 0]
set port2 [lindex $ports 1]


set paths ""

find_paths paths $port1 $port2

set path1 [lindex $paths 0]
set path2 [lindex $paths 1]

if {[llength $::paths] >= 2} {
    set path [idetify_path $::path1 $::path2]
} else {
    set path $paths
}

set series_cap_list ""
foreach inst $path {
     if {[llength $inst] == 1} {
        lappend series_cap_list $capValuesArr($instance_name($inst))
    } else {
        set p1 $capValuesArr($instance_name([lindex $inst 1]))
        set p2 $capValuesArr($instance_name([lindex $inst 2]))
        
        lappend series_cap_list [Calculate_capacitance [concat $p1 $p2] 1]
    }
}
puts "total capacitance : [Calculate_capacitance $series_cap_list 0]"