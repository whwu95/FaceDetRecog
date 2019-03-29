#!/usr/bin/gnuplot

set term png
set size .75,1
set output "lfw_unrestricted_labeled.png"
set xtics .1
set ytics .1
set grid
set size ratio -1
set ylabel "true positive rate"
set xlabel "false positive rate"
set title "Unrestricted, Labeled Outside Data" font "giant"
set key right bottom
plot "roc.txt" using 2:1 with lines title "pose+shape+exp"
set output "lfw_unrestricted_labeled_zm.png"
set xrange [0:0.3]
set yrange [0.7:1]
replot
set output "lfw_unrestricted_labeled_zm2.png"
set xrange [0:0.05]
set yrange [0.95:1]
set xtics .01
set ytics .01
replot
# "kumar_similes_pami2011.txt" using 2:1 with lines title "Simile classifiers", \
# "berg_belhumeur_attrs_bmvc12.txt" using 2:1 with lines title "Tom-vs-Pete + Attribute", \
# "berg_belhumeur_poofs_cvpr13_hog.txt" using 2:1 with lines title "POOF-HOG", \

