GC=gnuclad
INKSCAPE=inkscape

all: mot.svg

mot.svg: mot.conf mot.csv
	$(GC) mot.csv mot.svg mot.conf
	$(INKSCAPE) mot.svg -D --export-png=mot.png

.PNONY: all
