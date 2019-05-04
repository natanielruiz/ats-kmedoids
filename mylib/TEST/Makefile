######
#
# A simple Makefile
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
MYATSCC=$(PATSHOME)/bin/MYATSCC

######

all::

######

all:: \
mylib_test
mylib_test: \
mylib_test.dats ; \
$(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $<

######

all:: \
isPrime
isPrime: \
isPrime.dats ; \
$(PATSCC) -O2 \
-DATS_MEMALLOC_LIBC -o $@ $< -lm

######

all:: \
QueenPuzzle
QueenPuzzle: \
QueenPuzzle.dats ; \
$(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $<

######

regress:: mylib_test; ./$<

######

regress:: isPrime; ./$<
regress:: QueenPuzzle; ./$<

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.c
clean:: ; rm -f *_?ats.o

cleanall:: clean
cleanall:: ; rm -f mylib_test
cleanall:: ; rm -f isPrime
cleanall:: ; rm -f QueenPuzzle

######

testall:: all
testall:: regress
testall:: cleanall

###### end of [Makefile] ######
