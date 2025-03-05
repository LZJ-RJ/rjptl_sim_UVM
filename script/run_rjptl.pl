#!/usr/bin/perl

use Getopt::Long qw(:config no_ignore_case);
$result = GetOptions(
    "h"          => \$opt_h,
    "M=s"        => \@opt_M,
    "R=s"        => \@opt_R,
    "t=s"        => \$opt_t,
    "s=s"        => \$opt_s
);

if ($opt_h) {
    print "run_rjptl.pl [options] \n";
    print "     -M <opt>         simulator Macro options \n";
    print "     -R <opt>         simulator Runtime arguments\n";
    print "     -t <test>        testcase file name\n";
    print "     -s <seed>        random seed number\n";
    print "     run_rjptl.pl\n";
    print "     run_rjptl.pl -R +best_rjptl_level=2 -M +define+RJPTL_DUMP_VCD -t rjptlt_basic.sv\n";
    exit (1);
}

# /*
#     Default
#     # Using UVM, no pure SV
#     # Using MTI, no other simulators, e.g., Synopsys VCS, Cadence NC
#     # +UVM_TESTNAME=rjptlt_uvm_basic
#     # Testbench is rjptl_top.sv
# */
print "###There are 5 steps.###\n";
print "Step 1: Environment variables - Start ...\n";
$PATH_UVM  = $ENV{"UVM_HOME"};
$PATH_RJPTL = $ENV{"BEST_RJPTL"};
if (! -e "$PATH_UVM" || ! -e "$PATH_RJPTL") {
    die "Error: env variable UVM_HOME($PATH_UVM) or BEST_RJPTL($PATH_RJPTL) is not setup properly\n";
}
print "Step 1: Environment variables - End ...\n";

print "Step 2: Prepare BEST RJPTL files - Start ...\n";
# +incdir+:
# 1. Allows the compiler to search for .vh or .svh files inside the "src" directory;
# 2. It will not automatically compile .sv files inside "src".
# 3. So the previous step only allows it, and then when using "include *.sv", SystemVerilog files like pkg.sv and top.sv will be compiled.
$files .= " +incdir+$PATH_RJPTL/test_bench\n";
$files .= " +incdir+$PATH_RJPTL/src\n";

# Use default uvm-1.1 via Questasim simulator
# $files .= " +incdir+$PATH_UVM/src\n";
# $files .= " $PATH_UVM/src/uvm_pkg.sv\n";
# $files .= " $PATH_UVM/src/dpi/uvm_dpi.cc\n";
# $files .= " $PATH_UVM/src/uvm_macros.svh\n";

$files .= " $PATH_RJPTL/src/pkg.sv\n";
$files .= " $PATH_RJPTL/test_bench/top.sv\n";
print "Step 2: Prepare BEST RJPTL files - End ...\n";

print "Step 3: Search the path to find the test - Start ...\n";
@test_dir_array = ("./", "test_case/");
$files .= " +incdir+$PATH_RJPTL/test_case\n";
open(FILE, ">best_rjptl_bfms.filelist");
print FILE "$files\n";
close(FILE);
if ($opt_t) {
    $test = $opt_t;
    if ($test ne "" && $test =~ m/\.sv/) {
        $test =~ s/\.sv//;
    }
} else {
    $test = "super_like_rj_test_case";
}

print "Find test: $test\n";
print "Step 3: Search the path to find the test - End ...\n";

print "Step 4: Prepare run command options - Start ...\n";
foreach(@opt_R)  { $runtime .= " $_ ";}
@runtime = split(" ", $runtime);
foreach(@opt_M)  { $macro .= " $_ ";}
@macro = split(" ", $macro);
if ($opt_s) {
    $seed = $opt_s;
} else {
    $seed = "1234";
}

# foreach(@opt_M)  { $cmd .= " -M $_ ";}
print "Step 4: Prepare run command options - End ...\n";

# /*
# EXAMPLE CMD:
#     qrun \
#     -f tb.f \
#     -l mti.log \
#     -bitscalars \
#     -primitiveaccess \
#     -sv \
#     -R -sv_seed 1234 \
#     +UVM_TESTNAME=ahdmit_tmds_aud_4cc \
#     -permit_unmatched_virtual_intf \
# */
print "Step 5: ### Run Best testcase in UVM env: $testcase ... ###\n\n\n";
@cmds = (
    "qrun",
    " -f best_rjptl_bfms.filelist",
    " +UVM_TESTNAME=$test",
    " -sv",
    " -R -sv_seed $seed",
    " -l mti.log",
    " -uvmcontrol=all +UVM_COMPONENT_TRACE +UVM_VERBOSITY=UVM_DEBUG", 
    # " -uvmhome /home/jaslin86/uvm-1.2",
    # " +UVM_VERBOSITY=UVM_DEBUG",
    " @runtime",
    " @macro",
);
# add \ and \n
foreach $t (@cmds) {
    $cmd .= "$t \\\n";
}
open(CMD, "> mti.cmd");
print CMD "$cmd\n";
close(CMD);
system $cmd;