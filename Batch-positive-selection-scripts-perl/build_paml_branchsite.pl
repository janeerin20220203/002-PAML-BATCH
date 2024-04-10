#!/usr/bin/perl
use strict;
use warnings;
use File::Path;

my $gene_file_dir = 'gene';
my $tree_file_dir = 'tree';

opendir INTREE, "$tree_file_dir" or die "cannot open tree: $!";
opendir INGENE, "$gene_file_dir" or die "cannot open gene: $!";
my @alltrees = readdir INTREE;
my @allgenes = readdir INGENE;
closedir INGENE;
closedir INTREE;

for my $gene (@allgenes) {
    next if $gene =~ /^\./;
    for my $tree (@alltrees) {
        next if $tree =~ /^\./;
        mkpath("$gene/$tree/ma");
        `cp ./$tree_file_dir/$tree ./$gene/$tree/ma`;
        `cp ./$gene_file_dir/$gene ./$gene/$tree/ma`;
        open my $fhctl, ">", "./$gene/$tree/ma/codeml.ctl" or die;
        print $fhctl
            "seqfile = $gene\ntreefile = $tree\noutfile = $tree\_out\nnoisy = 0\nverbose = 2\nrunmode = 0\nseqtype = 1\nCodonFreq = 2\nclock = 0\naaDist = 0\naaRatefile = dat\/jones.dat\nmodel = 2\nNSsites = 2\nicode = 0\nMgene = 0\nfix_kappa = 0\nkappa = 2\nfix_omega = 0\nomega = 0.5\nfix_alpha = 1\nalpha = 0.\nMalpha = 0\nncatG = 8\ngetSE = 0\nRateAncestor = 1\nSmall_Diff = .5e-6\ncleandata = 0";
        close $fhctl;
        mkpath("$gene/$tree/ma0");
        `cp ./$tree_file_dir/$tree ./$gene/$tree/ma0`;
        `cp ./$gene_file_dir/$gene ./$gene/$tree/ma0`;
        open $fhctl, ">", "./$gene/$tree/ma0/codeml.ctl" or die;
        print $fhctl
            "seqfile = $gene\ntreefile = $tree\noutfile = $tree\_out\nnoisy = 0\nverbose = 2\nrunmode = 0\nseqtype = 1\nCodonFreq = 2\nclock = 0\naaDist = 0\naaRatefile = dat\/jones.dat\nmodel = 2\nNSsites = 2\nicode = 0\nMgene = 0\nfix_kappa = 0\nkappa = 2\nfix_omega = 1\nomega = 1\nfix_alpha = 1\nalpha = 0.\nMalpha = 0\nncatG = 8\ngetSE = 0\nRateAncestor = 1\nSmall_Diff = .5e-6\ncleandata = 0";
        close $fhctl;
    }
}

