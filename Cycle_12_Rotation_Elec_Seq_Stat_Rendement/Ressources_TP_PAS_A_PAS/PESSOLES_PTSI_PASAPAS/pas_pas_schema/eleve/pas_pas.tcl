
########## Tcl recorder starts at 05/03/11 10:40:14 ##########

set version "5.1"
set proj_dir "C:/fichier_pas"
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
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]

switch $tcl_platform(platform) {
   windows {
      set fpga_bin [file join $fpga_dir "bin" "nt"]
	     if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
	        set env(PATH) "$fpga_bin;$env(PATH)" } }
   unix {
      set fpga_bin [file join $fpga_dir "bin" "sol"]
      if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
         set env(PATH) "$fpga_bin;$env(PATH)"}}}

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 10:40:14 ###########


########## Tcl recorder starts at 05/03/11 10:44:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 10:44:24 ###########


########## Tcl recorder starts at 05/03/11 10:44:32 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 10:44:32 ###########


########## Tcl recorder starts at 05/03/11 10:58:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 10:58:39 ###########


########## Tcl recorder starts at 05/03/11 10:59:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj pas_pas -if pas_pas.jed -j2s -log pas_pas.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 10:59:01 ###########


########## Tcl recorder starts at 05/03/11 11:00:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:00:15 ###########


########## Tcl recorder starts at 05/03/11 11:00:20 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:00:20 ###########


########## Tcl recorder starts at 05/03/11 11:01:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:01:49 ###########


########## Tcl recorder starts at 05/03/11 11:01:51 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:01:51 ###########


########## Tcl recorder starts at 05/03/11 11:10:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:10:33 ###########


########## Tcl recorder starts at 05/03/11 11:10:38 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:10:38 ###########


########## Tcl recorder starts at 05/03/11 11:13:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:13:42 ###########


########## Tcl recorder starts at 05/03/11 11:13:52 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:13:52 ###########


########## Tcl recorder starts at 05/03/11 11:15:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:15:01 ###########


########## Tcl recorder starts at 05/03/11 11:15:06 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:15:06 ###########


########## Tcl recorder starts at 05/03/11 11:15:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:15:56 ###########


########## Tcl recorder starts at 05/03/11 11:15:58 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 11:15:58 ###########


########## Tcl recorder starts at 05/03/11 13:55:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:55:49 ###########


########## Tcl recorder starts at 05/03/11 13:55:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:55:55 ###########


########## Tcl recorder starts at 05/03/11 13:55:59 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:55:59 ###########


########## Tcl recorder starts at 05/03/11 13:57:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:57:57 ###########


########## Tcl recorder starts at 05/03/11 13:58:02 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:58:02 ###########


########## Tcl recorder starts at 05/03/11 13:59:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:59:50 ###########


########## Tcl recorder starts at 05/03/11 13:59:53 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 13:59:53 ###########


########## Tcl recorder starts at 05/03/11 14:01:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:01:53 ###########


########## Tcl recorder starts at 05/03/11 14:01:56 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:01:56 ###########


########## Tcl recorder starts at 05/03/11 14:04:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:04:19 ###########


########## Tcl recorder starts at 05/03/11 14:04:23 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:04:23 ###########


########## Tcl recorder starts at 05/03/11 14:05:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:05:54 ###########


########## Tcl recorder starts at 05/03/11 14:05:58 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:05:58 ###########


########## Tcl recorder starts at 05/03/11 14:06:13 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:06:13 ###########


########## Tcl recorder starts at 05/03/11 14:06:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:06:50 ###########


########## Tcl recorder starts at 05/03/11 14:06:54 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:06:54 ###########


########## Tcl recorder starts at 05/03/11 14:18:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:18:19 ###########


########## Tcl recorder starts at 05/03/11 14:18:21 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:18:21 ###########


########## Tcl recorder starts at 05/03/11 14:18:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:18:59 ###########


########## Tcl recorder starts at 05/03/11 14:19:05 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:19:05 ###########


########## Tcl recorder starts at 05/03/11 14:20:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:20:09 ###########


########## Tcl recorder starts at 05/03/11 14:20:46 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:20:46 ###########


########## Tcl recorder starts at 05/03/11 14:21:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:21:20 ###########


########## Tcl recorder starts at 05/03/11 14:21:23 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:21:23 ###########


########## Tcl recorder starts at 05/03/11 14:21:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:21:56 ###########


########## Tcl recorder starts at 05/03/11 14:21:59 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:21:59 ###########


########## Tcl recorder starts at 05/03/11 14:22:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:22:18 ###########


########## Tcl recorder starts at 05/03/11 14:22:21 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:22:21 ###########


########## Tcl recorder starts at 05/03/11 14:22:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:22:39 ###########


########## Tcl recorder starts at 05/03/11 14:22:45 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:22:45 ###########


########## Tcl recorder starts at 05/03/11 14:23:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:23:34 ###########


########## Tcl recorder starts at 05/03/11 14:23:38 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:23:38 ###########


########## Tcl recorder starts at 05/03/11 14:24:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:24:31 ###########


########## Tcl recorder starts at 05/03/11 14:24:35 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:24:35 ###########


########## Tcl recorder starts at 05/03/11 14:26:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:26:17 ###########


########## Tcl recorder starts at 05/03/11 14:26:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:26:32 ###########


########## Tcl recorder starts at 05/03/11 14:26:35 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:26:35 ###########


########## Tcl recorder starts at 05/03/11 14:32:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:32:27 ###########


########## Tcl recorder starts at 05/03/11 14:33:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:33:39 ###########


########## Tcl recorder starts at 05/03/11 14:33:49 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:33:49 ###########


########## Tcl recorder starts at 05/03/11 14:34:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:34:39 ###########


########## Tcl recorder starts at 05/03/11 14:34:50 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:34:50 ###########


########## Tcl recorder starts at 05/03/11 14:42:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:42:01 ###########


########## Tcl recorder starts at 05/03/11 14:42:04 ##########

# Commands to make the Process: 
# Fitter Report
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 14:42:04 ###########


########## Tcl recorder starts at 05/03/11 15:21:59 ##########

set version "5.1"
set proj_dir "F:/fichier_pas"
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
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]

switch $tcl_platform(platform) {
   windows {
      set fpga_bin [file join $fpga_dir "bin" "nt"]
	     if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
	        set env(PATH) "$fpga_bin;$env(PATH)" } }
   unix {
      set fpga_bin [file join $fpga_dir "bin" "sol"]
      if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
         set env(PATH) "$fpga_bin;$env(PATH)"}}}

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 15:21:59 ###########


########## Tcl recorder starts at 05/03/11 15:22:04 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=plsi -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p isplsi1016-60lh44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noprp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p isplsi1016-60lh44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/03/11 15:22:04 ###########


########## Tcl recorder starts at 05/09/11 21:41:59 ##########

set version "6.1"
set proj_dir "D:/Mes Documents/Laurent/Prof/_TSI/TP/TP_série_7_logique/pas_pas_schema"
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
# JEDEC File
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noPrp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p ispLSI1016-60LH44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/09/11 21:41:59 ###########


########## Tcl recorder starts at 05/09/11 21:44:27 ##########

set version "6.1"
set proj_dir "D:/Mes Documents/Laurent/Prof/_TSI/TP/TP_série_7_logique/pas_pas_schema"
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
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/09/11 21:44:27 ###########


########## Tcl recorder starts at 05/09/11 21:45:30 ##########

set version "6.1"
set proj_dir "D:/Mes Documents/Laurent/Prof/_TSI/TP/TP_série_7_logique/pas_pas_schema"
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
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=PLSI -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noPrp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p ispLSI1016-60LH44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/09/11 21:45:30 ###########


########## Tcl recorder starts at 05/20/15 11:43:17 ##########

set version "1.8"
set proj_dir "C:/Users/eleve/Desktop/PTSI/pas_pas_schema/eleve"
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
if [runCmd "\"$cpld_bin/sch2jhd\" \"principal.sch\" "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:43:17 ###########


########## Tcl recorder starts at 05/20/15 11:43:20 ##########

# Commands to make the Process: 
# Generate Schematic Symbol
if [runCmd "\"$cpld_bin/naf2sym\" \"principal\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:43:20 ###########


########## Tcl recorder starts at 05/20/15 11:43:25 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/edifnets\" -ext=.edn -bracket -family=PLSI -map -root -external_primitives -top principal.sch"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open pas_pas.efl w} rspFile] {
	puts stderr "Cannot create response file pas_pas.efl: $rspFile"
} else {
	puts $rspFile "principal.edn
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/edfmerge\" -i pas_pas.efl -prj principal -inc \"$install_dir/ispcpld/plsi/map/plsi_bse.ecf\" -flib \"$install_dir/ispcpld/plsi/map/plsi_map.ecf\" -fixname -family plsi -o pas_pas.emf"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete pas_pas.efl
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.ir0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.emf -if edif -prop pas_pas.prp -p ispLSI1016-60LH44/883 -pre "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$install_dir/ispcomp/bin/impsrclever\" -prj pas_pas -log pas_pas.irs -noPrp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/syndpm\" -i pas_pas.laf -if laf -p ispLSI1016-60LH44/883 -pd \"$proj_dir\"  -of vhdl -of verilog"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 05/20/15 11:43:25 ###########

