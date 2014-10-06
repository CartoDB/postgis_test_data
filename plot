#!/bin/sh

#                                            , \
#     (x/6)**2 title 'x/6-squared' with dots

tabname="$1"
if test -e "${tabname}.log"; then
  `dirname $0`/analize ${tabname}.log > ${tabname}.anal
  `dirname $0`/plotdata ${tabname}.anal
else
  echo "${tabname}.log: file does not exist" >&2
  exit 1
fi

# Z ms     qms       bytes
# 0 15233. 14498.893 145620583
col="2" # by default we show ms
# but can be overridden!
if test -n "$2"; then col="$2"; fi

outsuffix=""
case $col in
  2|ms) ylabel="generation time (ms)"; col=\$2;;
  3|qms) ylabel="query time (ms)"; outsuffix="-qms"; col=\$3;;
  4|b*|kb) ylabel="payload (kb)"; outsuffix="-kb"; col=\$4;;
  qms,kb)
    ylabel="query time (ms) - lines";
    y2label="payload (kb) - boxes";
    outsuffix="-qms_kb";
    col="\$3,\$4"
  ;;
  ms,kb)
    ylabel="generation time (ms) - lines";
    y2label="payload (kb) - boxes";
    outsuffix="-ms_kb";
    col="\$2,\$4"
  ;;
  rms)
    ylabel="rendering time (ms)";
    col="\$2-\$3"
    outsuffix="-rms";
    ;;
  rms,kb)
    ylabel="rendering time (ms) - lines";
    y2label="payload (kb) - boxes";
    outsuffix="-rms_kb";
    col="(\$2-\$3),\$4"
  ;;
  qms,ms)
    ylabel="time (ms) - total:lines, sql:boxes";
    outsuffix="-qms_rms";
    col="\$2,\$3"
  ;;
  wkb|wkb,twkb)
    ylabel="payload (kb) - wkb:lines, twkb:boxes";
    outsuffix="-wkb_twkb";
    col="\$4,\$5"
  ;;
  *) echo "Invalid column spec (use 2,3,4,ms,qms,kb)";;
esac

ncols=`echo "$col" | tr ',' '\n' | wc -l`

from=0
if test -n "$3"; then
  from="$3"
  outsuffix="$outsuffix+${from}"
fi

to=13
if test -n "$4"; then
  to="$4"
  outsuffix="$outsuffix+${to}"
  if test "$ncols" -gt 1; then
    to=$((to+1))
  fi
fi

plot_out=${tabname}.plot${outsuffix}.png

nflavors=`ls ${tabname}.plotdata* | wc -l`
boxwidth=`echo "scale=3;1/(${nflavors})" | bc`
#echo "boxwidth: $boxwidth" >&2

#gnuplot -p <<EOF
{
cat <<EOF
set title "${tabname}"
set xlabel "zoom level"
set terminal png size 1024,768 font "Helvetica,14"
set output "${plot_out}"
set boxwidth ${boxwidth} relative
set xrange [${from}:${to}]
set grid noytics xtics
EOF
#if test -n "$y2label"; then
if test "$ncols" -gt 1; then
  echo "set xtics axis 1 offset first "`echo "scale=3;$boxwidth*$nflavors/2"|bc`
else
  echo "set xtics axis 1"
fi
echo "set ylabel '${ylabel}'"
test -n "$y2label" && {
  echo "set y2label '${y2label}'"
  echo "set y2tics" # adds units on the second Y axis
  echo "set ytics in nomirror"
}
echo -n "plot "
sep=""
yax=`echo "${col}" | tr ',' '\n' | wc -l`
for c in `echo "${col}" | tr ',' '\n' | tac | tr '\n' ' '`; do
  t=0
  for dat in ${tabname}.plotdata*; do
    title=`echo ${dat} | sed 's/.*\.//'`
    if test "$title" = 'plotdata'; then title=vanilla; fi
    color=''
    case $title in
      vanilla)           color='lt rgb "#000000"';;
      clip)              color='lt rgb "#FF0000"';;
      simp)              color='lt rgb "#00FF00"';;
      grid)              color='lt rgb "#0033AA"';;
      clip_grid)         color='lt rgb "#FF00FF"';;
      clip_simp)         color='lt rgb "#EECC00"';;
      grid_simp)         color='lt rgb "#00AAFF"';;
      clip_grid_simp)    color='lt rgb "#AAAAAA"';;
    esac
    echo -n "${sep}'${dat}'" 
    if test "$ncols" -gt 1; then
      xoff=`echo "scale=2;${t}*${boxwidth}+${boxwidth}/2" | bc`
    else
      xoff=0
    fi
    #echo $xoff >&2
    echo -n " using (\$1+$xoff):(${c}) "
    test -n "$y2label" && {
      echo -n " axes x1y${yax}"
    }
    echo -n " ${color}"
    if test $yax -gt 1; then
      echo -n " with boxes fill solid 0.3 border -1"
      echo -n " notitle"
    else
      if test "$ncols" -gt 1; then
        echo -n " with points"
      else
        echo -n " with linespoints"
      fi
      #echo -n " with impulsespoints"
      #echo -n " with impulses"
      #echo -n " with boxes fill solid 0.5 border -1"
      #echo -n " with boxes boxwidth 0.01 fill pattern border -1"
      echo -n " title '${title}'"
      # Plot again this time with impulses
      if test "$ncols" -gt 1; then
        echo -n ","
        echo -n "'${dat}'" 
        echo -n " using (\$1+$xoff):(${c}) "
        echo -n " axes x1y${yax}"
        echo -n " ${color}"
        echo -n " with impulses"
        echo -n " notitle"
      fi
    fi
    sep=", "
    t=$((t+1))
  done
  yax=$((yax-1))
done
} | tee ${tabname}.plot.cmd | gnuplot -p

echo "Saved to $plot_out"
eog $plot_out &
