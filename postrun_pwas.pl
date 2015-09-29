#!perl

use Multtest qw(bonferroni BH qvalue);

%gene=();
open(IN,"genemap.txt");
<IN>;
while(<IN>){
chomp;
$s=$_;
@r=split(/\t/,$s);
$gid=$r[0];
$gene{$gid}=$s;
}
close(IN);



$f=shift;
%list=();
open(IN,$f);
<IN>;
while(<IN>){
chomp;
$s=$_;
@r=split(/\t/,$s);
$gid=$r[0];$pv=$r[5];
$list{$gid}=$pv;
}
close(IN);
$list_ref=\%list;
$bf = bonferroni($list_ref);
$bh = BH($list_ref);
#$qv = qvalue($list_ref);

open(IN,$f);
<IN>;
print "gid\tcount\ttotal\tpop_count\tpop_total\tpvalue\tpmids\tfold\tbonferroni\tbenjamini\tgid2\tsymbol\ttitle\tsymbol2\ttitle2\n";
while(<IN>){
chomp;
$s=$_;
@r=split(/\t/,$s);
$gid=$r[0];
$fd=$r[1]/$r[2]/($r[3]/$r[4]);
$pv1=${$bf}{$gid};
$pv2=${$bh}{$gid};
#$pv3=${$qv}{$gid};
$genemap=$gene{$gid};
print $s."\t".$fd."\t".$pv1."\t".$pv2."\t".$genemap."\n";
}
close(IN);




 


