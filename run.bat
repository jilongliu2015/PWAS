perl prerun_pwas.pl endometriosis.ga.xml endometriosis.sentence.xml > sentence_out.txt

perl pwas3.pl sentence_out.txt BGfile > pwas_out3.txt
perl postrun_pwas.pl pwas_out3.txt > pwas_out_multiple_test_correction3.txt

rem Or use the sentence_out_curated.txt

perl pwas3.pl sentence_out_curated.txt BGfile > pwas_out_curated3.txt
perl postrun_pwas.pl pwas_out_curated3.txt > pwas_out_curated_multiple_test_correction3.txt

pause