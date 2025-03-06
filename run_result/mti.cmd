qrun \
 -f best_rjptl_bfms.filelist \
 +UVM_TESTNAME=super_like_rj_test_case \
 -sv \
 -R -sv_seed 666 \
 -l mti.log \
 +test_runtime +clk_period=100 \

