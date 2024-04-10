#!/usr/bin/perl

use warnings;
#use strict;
use lib "/Users/Sundysun/perl5/lib/perl5/darwin-thread-multi-2level/";
use Math::CDF qw(pchisq);
#适用于计算branchsite，多个基因下一个计算的p值计算，输出w值
my $result_file = shift;

opendir FF, "$result_file" or die;
open my $OUT, '>', "branchsite_del.txt" or die;
print $OUT "Gene_Name\tNode\tModel\tlnL\t2lnL\tP_Value\tLevel_Parameters\tPositive_Site\n";

my @files = grep(/\.fas$/i, readdir FF);
for my $i (@files){
	opendir SF,"./$result_file/$i" or die;
	my @second = grep(/\.txt$/i, readdir SF);
	for my $j (@second){
		open GG,"$result_file/$i/$j/ma/${j}_out" or die;
		my $ma0lnl;
		my $malnl;
		my $maw0;
		my $maw1;
		my $maw2;
		my $ma0w0;
		my $ma0w1;
		my $ma0w2;
		while (<GG>) {
			if (/^lnL/) {
		 		chomp;
		 		my @temp = split(/\s+/, $_);
		 		$malnl = $temp[2];
		 	}
		 	if (/^foreground/){
		 		chomp;
		 		my @bb = split(/\s+/, $_);
		 		$maw2 = $bb[5];
		 		$maw0 = $bb[2];
		 		$maw1 = $bb[3];	
		 	}
		
		}
		open HH,"$result_file/$i/$j/ma0/${j}_out" or die;
		while (<HH>){
		 	if (/^lnL/) {
		 		chomp;
		 		my @tempp = split(/\s+/, $_);
		 		$ma0lnl = $tempp[2];
		 	}
		 	if (/^background/){
		 		chomp;
		 		my @bb = split(/\s+/, $_);
		 		$ma0w2 = $bb[5];
		 		$ma0w0 = $bb[2];
		 		$ma0w1 = $bb[3];	
		 	}


		}
		open GG,"$result_file/$i/$j/ma/${j}_out" or die;
		my @lines = <GG>;
		my $start = 0;
	my $end = 0;
	foreach(@lines){
		if (/^Bayes Empirical Bayes/)
        {
        	last;
        }else {
        	$start++;
        }
    }
    foreach(@lines){
        if (/^The grid/)
        {
        	last;
        }else {
        	$end++;
        }
	}

	my @beb;
	my @count = ($start+2..$end-1);
	foreach(@count){
		chomp $lines[$_];
		push (@beb, $lines[$_]);
	}
    my $out = join("",@beb);

		my $x=2*($malnl-$ma0lnl);
		$x=abs($x);
		my $pvalue = 1-pchisq($x,1); 
		
		print $OUT "$i\t$j\tma\t$malnl\t \t \tw0=$maw0,w1=$maw1,w2=$maw2\n";
		print $OUT " \t \tma0\t$ma0lnl\t$x\t$pvalue\tw0=$ma0w0,w1=$ma0w1,w2=$ma0w2\t$out\n";
		
	}
}





