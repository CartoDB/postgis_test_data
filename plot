#!/bin/sh

#                                            , \
#     (x/6)**2 title 'x/6-squared' with dots

tabname="$1"
`dirname $0`/analize ${tabname}.log > ${tabname}.anal
`dirname $0`/plotdata ${tabname}.anal

# Z ms     qms       bytes
# 0 15233. 14498.893 145620583
col="2" # by default we show ms
# but can be overridden!
if test -n "$2"; then col="$2"; fi

outsuffix=""
case $col in
  2|ms) ylabel="rendering time (ms)"; col=2;;
  3|qms) ylabel="query time (ms)"; outsuffix="-qms"; col=3;;
  4|b*|kb) ylabel="payload (kb)"; outsuffix="-kb"; col=4;;
  *) echo "Invalid column spec (use 2,3,4,ms,qms,kb)";;
esac

from=0
if test -n "$3"; then
  from="$3"
  outsuffix="$outsuffix+${from}"
fi

plot_out=${tabname}.plot${outsuffix}.png

#gnuplot -p <<EOF
{
cat <<EOF
set title "${tabname}"
set xlabel "zoom level"
set terminal png size 1024,800 font "Helvetica,20"
set output "${plot_out}"
EOF
echo "set ylabel '${ylabel}'"
echo -n "plot "
sep=""
t=0
for dat in ${tabname}.plotdata*; do
  title=`echo ${dat} | sed 's/.*\.//'`
  if test "$title" = 'plotdata'; then title=vanilla; fi
  echo -n "${sep}'${dat}' every ::${from} using (\$1):(\$${col}) title '${title}' with linespoints "
  #echo -n ",'${dat}' using (\$1):(\$3) title '${title} pl' with points axes x1y2 "
  sep=", "
  t=$((t+1))
done
} | tee ${tabname}.plot.cmd | gnuplot -p

echo "Saved to $plot_out"
eog $plot_out &
