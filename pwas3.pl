#!perl

($f_fg,$f_bg)=@ARGV;

%list_bg=();
%list_fg=();
%list1=();
%list2=();

$N=0; #pubmed all
$n=0; #pubmed topic

open(BG,"<$f_bg");
while(<BG>){
chomp;
($gid,$ct)=split(/\t/);
$list_bg{$gid}=$ct;
}
close(BG);
$N=$list_bg{'BG'};


open(IN,"<$f_fg");
<IN>;
while(<IN>){
chomp;
@r=split(/\t/);
$pmid=$r[1];
$gid=$r[6];
$list1{$pmid."\t".$gid}+=1;
$list2{$pmid}+=1;
}
close(IN);
$n=scalar(keys %list2);
$list2=();

foreach $t (keys %list1){
($pmid,$gid)=split(/\t/,$t);
$list_fg{$gid}[0]+=1;
$list_fg{$gid}[1].=$pmid.";";
}
$list1=();

print "gid\tcount\tn\tN_this\tN\tpvalue\tpmid_list\n";


foreach $gid (keys %list_fg){
$pmids=$list_fg{$gid}[1];
$pmids=~s/\;\Z//;
$N_this=$list_bg{$gid};
if($N_this eq ''){$N_this=1;}
$n_this=$list_fg{$gid}[0];

$N_good=$N_this;
$N_bad=$N-$N_this;

$pval=0;
#warn "$gid\t$n_this\t$n\t$N_this\t$N\t$pval\t$pmids\n";
for($i=$n_this;$i<=$N_this;$i++){
$t=eval '&hypergeom($N_good,$N_bad,$n,$i)';
if($@) {
$t=0;}

$pval+=$t;
}
$pval=0 if $pval<0;
$pval=1 if $pval>1;
print "$gid\t$n_this\t$n\t$N_this\t$N\t$pval\t$pmids\n";

}


#####################################################3
sub logfact {
   return gammln(shift(@_) + 1.0);
}

sub hypergeom {
   # There are m "bad" and n "good" balls in an urn.
   # Pick N of them. The probability of i or more successful selections:
   # (m!n!N!(m+n-N)!)/(i!(n-i)!(m+i-N)!(N-i)!(m+n)!)

   my ($n, $m, $N, $i) = @_;

   my $loghyp1 = logfact($m)+logfact($n)+logfact($N)+logfact($m+$n-$N);

   my $loghyp2 = logfact($i)+logfact($n-$i)+logfact($m+$i-$N)+logfact($N-$i)+logfact($m+$n);

   return exp($loghyp1 - $loghyp2);
}

sub gammln {
  my $xx = shift;
  my @cof = (76.18009172947146, -86.50532032941677,
             24.01409824083091, -1.231739572450155,
             0.12086509738661e-2, -0.5395239384953e-5);
  my $y = my $x = $xx;
  my $tmp = $x + 5.5;
  $tmp -= ($x + .5) * log($tmp);
  my $ser = 1.000000000190015;
  for my $j (0..5) {
     $ser += $cof[$j]/++$y;
  }
  -$tmp + log(2.5066282746310005*$ser/$x);
}