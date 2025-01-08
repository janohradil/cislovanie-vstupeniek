#!/usr/bin/perl

use warnings;
use strict;

my $localtime = localtime;

my $template = '<replace with path to my template>';
my $fname = $template;
open FILE, $fname or die 'Cant open file';
my $cislo_vstupenky_najnizsie = 1;   # tymto cislom vstupenky sa zacina cislovanie
my %vstupenka_c = (
    c1 => $cislo_vstupenky_najnizsie + 0,
    c2 => $cislo_vstupenky_najnizsie + 1,
    c3 => $cislo_vstupenky_najnizsie + 2,
    c4 => $cislo_vstupenky_najnizsie + 3,
);

sub ocisluj_vstupenku {
    my $kluc = shift @_;
    $_ = shift @_;
    s#(?<=>)($kluc)(?=</text>)#$vstupenka_c{$kluc}#gi;
    print "zvnutra funkcie ocisluj_vstupenku $1 --> $vstupenka_c{$kluc}\n";
}


my $obsah = join '', <FILE>;

for (my $i=0; $i<3; $i++) {
    my $poradove_cislo = $cislo_vstupenky_najnizsie + $i*4;
    $poradove_cislo = sprintf '%03d', $poradove_cislo;
    my $file = $fname;
    $file =~ s#(.*?)(\.svg)#$1_$poradove_cislo$2#gi;
    print "$i\n";
    $file =~ s#\s+#_#g;
    my $export_png = $file;
    $export_png =~ s#\.svg$#.png#g;
    my $export_pdf = $file;
    $export_pdf =~ s#\.svg$#.pdf#g;
    print "$export_png\n";
    print "$export_pdf\n";
    open FOUT, ">", $file
	or die "Nemozno otvorit subor '$file'.";
    my $kolky_cyklus = $i+1;
    print "$kolky_cyklus. cyklus\n";
    for my $key (sort keys %vstupenka_c) {
	print "$key --> $vstupenka_c{$key}\n";
    }
    my $obsah = $obsah;
    my $vstup_cislo_1 = sprintf '%03d', $vstupenka_c{c1};
    my $vstup_cislo_2 = sprintf '%03d', $vstupenka_c{c2};
    my $vstup_cislo_3 = sprintf '%03d', $vstupenka_c{c3};
    my $vstup_cislo_4 = sprintf '%03d', $vstupenka_c{c4};
    $obsah =~ s#(?<=>)(c1)(?=</text>)#$vstup_cislo_1#gi;
    $obsah =~ s#(?<=>)(c2)(?=</text>)#$vstup_cislo_2#gi;
    $obsah =~ s#(?<=>)(c3)(?=</text>)#$vstup_cislo_3#gi;
    $obsah =~ s#(?<=>)(c4)(?=</text>)#$vstup_cislo_4#gi;
    print FOUT $obsah;
    system 'inkscape', '--export-filename=' . $export_pdf, $file;
    system 'inkscape', '--export-filename=' . $export_png, '--export-dpi=300', $file;
    for my $key (sort keys %vstupenka_c) {
	$vstupenka_c{$key} = $vstupenka_c{$key} + 4;
    }
}

print "$fname\n" ;
