
########## Tcl recorder starts at 05/20/15 10:56:14 ##########

set version "1.8"
set proj_dir "C:/Users/eleve/Desktop/PTSI/DecouvertePTSI"
cd $proj_dir

# Get directory paths
set pver $version
regsub -all {\.} $pver {_} pver
set lscfile "lsc_"
append lscfile $pver ".ini"
set lsvini_dir [lindex [array get env LSC_INI_PATH] 1]
set lsvini_path [file join $lsvini_dir $lscfile]
if {[catch {set fid [open $lsvini_path]} msg]} {
	 puts "File Open Error: $lsvini_path"
	 return false
} else {set data [read $fid]; close $fid }
foreach line [split $data '\n'] { 
	set lline [string tolower $line]
	set lline [string trim $lline]
	if {[string compare $lline "\[paths\]"] == 0} { set path 1; continue}
	if {$path && [regexp {^\[} $lline]} {set path 0; break}
	if {$path && [regexp {^bin} $lline]} {set cpld_bin $line; continue}
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line; continue}
	if {$path && [regexp {^fpgabinpath} $lline]} {set fpga_bin $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]
set fpga_bin [string range $fpga_bin [expr [string first "=" $fpga_bin]+1] end]
regsub -all "\"" $fpga_bin "" fpga_bin
set fpga_bin [file join $fpga_bin]

if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$fpga_bin;$env(PATH)" }

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"testled.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 10:56:14 ###########


########## Tcl recorder starts at 05/20/15 10:57:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"testled.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 10:57:24 ###########


########## Tcl recorder starts at 05/20/15 10:57:32 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/sch2blf\" testled.sch -dev PLSI -sup -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"testled.bls\" -o \"testled.bl0\" -ipo -propadd -family PLSI -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" -i \"testled.bl0\" -o \"testled.bl1\" -red bypin choose -sweep -collapse none -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"testled.bl1\" -o \"decouverteisp.bl2\" -omod testled -propadd -family PLSI -ues decouverteisp.ues -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" decouverteisp.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" -i decouverteisp.bl3 -o decouverteisp.tt2 -propadd -idev PLSI -dev pla_basic -pla -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i decouverteisp.tt2 -if pla -p ispLSI1016EA-100LJ44 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj decouverteisp -log decouverteisp.irs "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
# Application to view the Process: 
# Constraint Editor
if [catch {open ce.rsp w} rspFile] {
	puts stderr "Cannot create response file ce.rsp: $rspFile"
} else {
	puts $rspFile "-devfile \"$install_dir/ispcpld/data/lc1k/lea1016_44j.dev\"
-lci decouverteisp.lct
-touch decouverteisp.irs
-src decouverteisp.tt2
-type PLA
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lciedit\" @ce.rsp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 10:57:32 ###########


########## Tcl recorder starts at 05/20/15 10:58:29 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/syndpm\" -i decouverteisp.laf -if laf -p ispLSI1016EA-100LJ44 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 10:58:29 ###########


########## Tcl recorder starts at 05/20/15 11:01:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"testled.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:01:55 ###########


########## Tcl recorder starts at 05/20/15 11:01:58 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/sch2blf\" testled.sch -dev PLSI -sup -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"testled.bls\" -o \"testled.bl0\" -ipo -propadd -family PLSI -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" -i \"testled.bl0\" -o \"testled.bl1\" -red bypin choose -sweep -collapse none -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"testled.bl1\" -o \"decouverteisp.bl2\" -omod testled -propadd -family PLSI -ues decouverteisp.ues -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" decouverteisp.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" -i decouverteisp.bl3 -o decouverteisp.tt2 -propadd -idev PLSI -dev pla_basic -pla -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i decouverteisp.tt2 -if pla -p ispLSI1016EA-100LJ44 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj decouverteisp -log decouverteisp.irs "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i decouverteisp.laf -if laf -p ispLSI1016EA-100LJ44 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:01:58 ###########


########## Tcl recorder starts at 05/20/15 11:05:33 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/sch2blf\" testled.sch -dev PLSI -sup -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"testled.bls\" -o \"testled.bl0\" -ipo -propadd -family PLSI -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" -i \"testled.bl0\" -o \"testled.bl1\" -red bypin choose -sweep -collapse none -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"testled.bl1\" -o \"decouverteisp.bl2\" -omod testled -propadd -family PLSI -ues decouverteisp.ues -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" decouverteisp.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" -i decouverteisp.bl3 -o decouverteisp.tt2 -propadd -idev PLSI -dev pla_basic -pla -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i decouverteisp.tt2 -if pla -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj decouverteisp -log decouverteisp.irs "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
# Application to view the Process: 
# Constraint Editor
if [catch {open ce.rsp w} rspFile] {
	puts stderr "Cannot create response file ce.rsp: $rspFile"
} else {
	puts $rspFile "-devfile \"$install_dir/ispcpld/data/lc1k/l1016_44h.dev\"
-lci decouverteisp.lct
-touch decouverteisp.irs
-src decouverteisp.tt2
-type PLA
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lciedit\" @ce.rsp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:05:33 ###########


########## Tcl recorder starts at 05/20/15 11:06:05 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/syndpm\" -i decouverteisp.laf -if laf -p ispLSI1016-60LH44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:06:05 ###########


########## Tcl recorder starts at 05/20/15 11:15:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"testled.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:15:08 ###########

