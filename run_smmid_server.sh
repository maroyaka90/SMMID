#!/bin/bash

#export PERL5LIB=/usr/local/share/smid-db/local-lib/lib/perl5
export PERL5LIB=/home/smmid/perl5/lib/perl5
screen ./script/smmid_server.pl -r --fork
