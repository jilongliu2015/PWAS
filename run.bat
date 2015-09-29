perl prerun_pwas.pl endo.ga.xml endo.sentence.xml > sentence.txt

perl pwas3.pl sentence.txt BGfile > pwas_out3.txt
perl postrun_pwas.pl pwas_out3.txt > pwas_out_multiple_test_correction3.txt

