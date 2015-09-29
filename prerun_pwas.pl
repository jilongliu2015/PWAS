#!perl

#ga output
#<Gene pmid='26216523' sid='ABSTRACT_10' start='36' end='39' tax_id='9606' entrezID='7157' score='0.5704'>p53</Gene>

#sentence output
#<TEXT pmid='26228249' sid='ABSTRACT_6'>Estradiol production in OEC tissues was also investigated.</TEXT>

#genemap
#3	A2MP	alpha-2-macroglobulin pseudogene	-	-


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

($ga_f,$s_f)=@ARGV;

%sentence=();
open(IN,$s_f);
while(<IN>){
chomp;
$pmid='';$sid='';$s='';
if(~/pmid=\'(\d+)\'/){$pmid=$1;}
if(~/sid=\'([\d\w_]+)\'/){$sid=$1;}
$s=$_;
$s=~s/\<\/TEXT\>//;
$s=~s/\<TEXT[^\>]+\>//;
#print $pmid."_".$sid."\t".$pmid."\t".$sid."\t".$s."\n";
$sentence{$pmid."_".$sid}=$pmid."_".$sid."\t".$pmid."\t".$sid."\t".$s;

}
print "pmid_sid\tpmid\tsid\tstart\tend\ttax\tgid\tscore\tmention\tgid\tsymbol\ttitle\tsymbol_other\ttitle_other\tpmid_sid\tpmid\tsid\tsentence\n";




open(IN,$ga_f);
while(<IN>){
chomp;
$pmid='';$sid='';$s1='';$s2='';$tax='';$id='';$sc='';$m='';
$t=$_;
if($t=~/^\<Gene /){
if($t=~/pmid=\'(\d+)\'/){$pmid=$1;}
if($t=~/sid=\'([\d\w_]+)\'/){$sid=$1;}
if($t=~/start=\'(\d+)\'/){$s1=$1;}
if($t=~/end=\'(\d+)\'/){$s2=$1;}
if($t=~/tax_id=\'(\d+)\'/){$tax=$1;}
if($t=~/entrezID=\'(\d+)[\,\']/){$id=$1;}
if($t=~/score=\'([\d\.]+)\'/){$sc=$1;}
$m=$_;
$m=~s/\<\/Gene\>//;
$m=~s/\<Gene[^\>]+\>//;
$stxt=$sentence{$pmid."_".$sid};
$gatxt=$gene{$id};
print $pmid."_".$sid."\t".$pmid."\t".$sid."\t".$s1."\t".$s2."\t".$tax."\t".$id."\t".$sc."\t".$m."\t".$gatxt."\t".$stxt."\n";

             }
}

