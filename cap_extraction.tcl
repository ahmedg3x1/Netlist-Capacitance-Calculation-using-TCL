#! C:/Tcl/bin/tclsh

set fread [open ./NangateOpenCellLibrary_typical.lib r]
while {![eof $fread]} {
    set line [gets $fread]
    set cellFound [regexp {cell\s*\((\w+)\)\s*\{} $line fullmatch cellName]
    
    if {$cellFound} {
        set capValuesArr($cellName) "None"        
    }

    set capFound [regexp {max_capacitance\s*:\s*([0-9]+\.?[0-9]*)} $line fullmatch capValue]

    if {$capFound} {
        if {$capValuesArr($cellName) == "None"} {
            set capValuesArr($cellName) $capValue
        } else {
            set capValuesArr($cellName) $capValue
        }
        
    }
    
}
close $fread