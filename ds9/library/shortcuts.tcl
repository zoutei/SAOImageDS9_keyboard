#  Copyright (C) 1999-2026
#  Smithsonian Astrophysical Observatory, Cambridge, MA, USA
#  For conditions of distribution and use, see copyright notice in "copyright"

package provide DS9 1.0

proc ShortcutsDef {} {
    global shortcuts
    global shortcut_timer
    global shortcut_pending_action
    global shortcut_pending_frame

    set shortcuts(buffer) ""
    set shortcut_timer ""
    set shortcut_pending_action ""
    set shortcut_pending_frame ""
    set shortcuts(timeout) 500

    LoadShortcutConfig
}

proc LoadShortcutConfig {} {
    global shortcuts

    # Clear existing map
    array unset shortcuts map,*
    set shortcuts(buffer) ""
    set shortcuts(timeout) 500

    # Set default mappings
    set shortcuts(map,l) "lock_scale_limits"
    set shortcuts(map,i) "lock_frame image"
    set shortcuts(map,w) "lock_frame wcs"
    set shortcuts(map,c9) "scale 90"
    set shortcuts(map,c1) "range -10 10"
    set shortcuts(map,c5) "range -5 5"
    set shortcuts(map,c2) "range -20 20"
    set shortcuts(map,d) "delete_frame"
    set shortcuts(map,b) "display blink"
    set shortcuts(map,s) "display single"
    set shortcuts(map,t) "display tile"
    set shortcuts(map,p) "mode pan"
    set shortcuts(map,r) "mode region"
    set shortcuts(map,n) "mode none"

    # Search for config file
    set cfg_file ""
    global env
    if {[info exists env(DS9_SHORTCUTS_CFG)]} {
	set cfg_file $env(DS9_SHORTCUTS_CFG)
    } else {
	set home [GetEnvHome]
	set paths [list \
		       [file join $home ".ds9" "shortcuts.cfg"] \
		       [file join $home ".ds9.shortcuts"] \
		       "shortcuts.cfg" \
		      ]
	foreach p $paths {
	    if {[file exists $p] && [file isfile $p]} {
		set cfg_file $p
		break
	    }
	}
    }

    if {$cfg_file != ""} {
	if {[catch {open $cfg_file r} ch]} {
	    Error "Could not open shortcuts config file: $cfg_file"
	    return
	}

	while {[gets $ch line] >= 0} {
	    set line [string trim $line]
	    # skip comments and empty lines
	    if {$line == "" || [string index $line 0] == "#" || [string index $line 0] == ";"} {
		continue
	    }

	    # Find separator (= or :)
	    set sep_idx [string first "=" $line]
	    if {$sep_idx == -1} {
		set sep_idx [string first ":" $line]
	    }

	    if {$sep_idx != -1} {
		set key_part [string range $line 0 [expr $sep_idx - 1]]
		set action_part [string range $line [expr $sep_idx + 1] end]

		set key [string tolower [string trim $key_part]]
		set action [string trim $action_part]

		if {$key != "" && $action != ""} {
		    if {$key == "timeout"} {
			set shortcuts(timeout) $action
		    } else {
			set shortcuts(map,$key) $action
		    }
		}
	    }
	}
	close $ch
    }
}

proc ResetShortcutBuffer {} {
    global shortcuts
    set shortcuts(buffer) ""
}

proc CancelPendingAction {} {
    global shortcut_timer
    global shortcut_pending_action
    global shortcut_pending_frame
    catch {after cancel $shortcut_timer}
    set shortcut_pending_action ""
    set shortcut_pending_frame ""
}

proc ExecutePendingAction {} {
    global shortcuts
    global shortcut_pending_action
    global shortcut_pending_frame
    if {$shortcut_pending_action != ""} {
	ExecuteShortcutAction $shortcut_pending_frame $shortcut_pending_action
	CancelPendingAction
	set shortcuts(buffer) ""
    }
}

proc ProcessShortcutKey {which K A xx yy} {
    global shortcuts
    global shortcut_timer
    global shortcut_pending_action
    global shortcut_pending_frame

    # 1. Determine key identifier
    set key ""
    if {$A != "" && [string is print $A]} {
	set key $A
    } else {
	set key $K
    }
    set key [string tolower $key]

    # Normalize shifted digits (e.g. ! -> 1, ( -> 9) to support holding Shift
    switch -exact -- $key {
	"!" { set key "1" }
	"@" { set key "2" }
	"#" { set key "3" }
	"$" { set key "4" }
	"%" { set key "5" }
	"^" { set key "6" }
	"&" { set key "7" }
	"*" { set key "8" }
	"(" { set key "9" }
	")" { set key "0" }
    }

    # If there was a pending action and a new key is pressed, cancel it
    CancelPendingAction

    # Append to buffer
    append shortcuts(buffer) $key

    # 2. Check if the buffer is a prefix of any shortcut (excluding itself if it's an exact match)
    set is_prefix_of_other 0
    foreach seq [array names shortcuts map,*] {
	set seq_key [string range $seq 4 end]
	if {$seq_key != $shortcuts(buffer) && [string first $shortcuts(buffer) $seq_key] == 0} {
	    set is_prefix_of_other 1
	    break
	}
    }

    # 3. Check if the buffer is an exact match
    if {[info exists shortcuts(map,$shortcuts(buffer))]} {
	set action $shortcuts(map,$shortcuts(buffer))
	if {$is_prefix_of_other} {
	    # It's an exact match but also a prefix of a longer shortcut.
	    # Wait for the timeout duration. If no other key is pressed, execute this action.
	    set shortcut_pending_action $action
	    set shortcut_pending_frame $which
	    set shortcut_timer [after $shortcuts(timeout) [list ExecutePendingAction]]
	    return 1
	} else {
	    # Exact match, not a prefix of anything else. Execute immediately.
	    ExecuteShortcutAction $which $action
	    set shortcuts(buffer) ""
	    return 1
	}
    }

    if {$is_prefix_of_other} {
	# Not a match, but prefix of a longer shortcut. Reset buffer if no key is pressed.
	set shortcut_timer [after [expr $shortcuts(timeout) * 2] ResetShortcutBuffer]
	return 1
    }

    # 4. If not a prefix and not a match, fallback to checking last key alone
    set shortcuts(buffer) $key
    set is_prefix_of_other 0
    foreach seq [array names shortcuts map,*] {
	set seq_key [string range $seq 4 end]
	if {$seq_key != $shortcuts(buffer) && [string first $shortcuts(buffer) $seq_key] == 0} {
	    set is_prefix_of_other 1
	    break
	}
    }

    if {[info exists shortcuts(map,$shortcuts(buffer))]} {
	set action $shortcuts(map,$shortcuts(buffer))
	if {$is_prefix_of_other} {
	    set shortcut_pending_action $action
	    set shortcut_pending_frame $which
	    set shortcut_timer [after $shortcuts(timeout) [list ExecutePendingAction]]
	    return 1
	} else {
	    ExecuteShortcutAction $which $action
	    set shortcuts(buffer) ""
	    return 1
	}
    }

    if {$is_prefix_of_other} {
	set shortcut_timer [after [expr $shortcuts(timeout) * 2] ResetShortcutBuffer]
	return 1
    } else {
	set shortcuts(buffer) ""
	return 0
    }
}

proc ExecuteShortcutAction {which action} {
    global current
    global scale
    global panzoom
    global rgb
    global zscale

    set cmd [lindex $action 0]
    set args [lrange $action 1 end]

    switch -- $cmd {
	lock_scale_limits {
	    set scale(lock,limits) [expr !$scale(lock,limits)]
	    LockScaleLimitsCurrent
	}
	lock_frame {
	    set type [lindex $args 0]
	    if {$panzoom(lock) == $type} {
		set panzoom(lock) none
	    } else {
		set panzoom(lock) $type
	    }
	    LockFrameCurrent
	}
	scale {
	    set mode [lindex $args 0]
	    set scale(mode) $mode
	    ChangeScaleMode
	}
	range {
	    set rmin [lindex $args 0]
	    set rmax [lindex $args 1]
	    if {$current(frame) != {} && $rmin != {} && $rmax != {}} {
		set scale(min) $rmin
		set scale(max) $rmax
		set scale(mode) user
		EvalLockCurrent lock,scale [list $current(frame) clip user $scale(min) $scale(max)]
		EvalLockCurrent lock,scale [list $current(frame) clip mode $scale(mode)]
		UpdateScale
	    }
	}
	delete_frame {
	    DeleteCurrentFrame
	}
	display {
	    set mode [lindex $args 0]
	    set current(display) $mode
	    DisplayMode
	}
	mode {
	    set m [lindex $args 0]
	    ChangeModeItem $m
	}
	tcl {
	    eval [join $args " "]
	}
	default {
	    # Fallback to direct Tcl execution for custom actions
	    if {[catch {eval $action} err]} {
		Error "Shortcut action error: $err"
	    }
	}
    }
}
