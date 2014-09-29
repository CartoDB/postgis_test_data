#!/bin/sh

#                                            , \
#     (x/6)**2 title 'x/6-squared' with dots

# Z ms     qms       bytes
# 0 15233. 14498.893 145620583

tabname="$1"

data=${tabname}.plotdata
data_clip=${tabname}.plotdata.clip
data_simp=${tabname}.plotdata.simp
data_grid=${tabname}.plotdata.grid
data_cgs=${tabname}.plotdata.clip_grid_simp

plot_out=${tabname}.plot.png

gnuplot -p <<EOF
set title "${tabname}"
set xlabel "zoom level"
set ylabel "rendering time (ms)"
set terminal png size 1024,800 font "Helvetica,20"
set output "${plot_out}"
plot '${data}' using (\$1):(\$2) title 'vanilla' with lines, \
     '${data_clip}' using (\$1):(\$2) title 'clip' with lines, \
     '${data_simp}' using (\$1):(\$2) title 'simp' with lines, \
     '${data_grid}' using (\$1):(\$2) title 'grid' with linespoint, \
     '${data_gcs}' using (\$1):(\$2) title 'clip,grid,simp' with lines
EOF

echo "Saved to $plot_out"
eog $plot_out
