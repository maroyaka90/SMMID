
use strict;

package SMMID::Controller::Search;

use SMMIDDb;

our %urlencode;
use Tie::UrlEncoder;

use parent "Catalyst::Controller";

sub search :Path("/search") :Args(0) { 
    my ($self, $c) = @_;

    my $term = $c->req->param("term");
    print STDERR "Searching term $term\n";

    my @smids = SMMIDDb->search($c->config->{smid_file}, $term);
    
    my @encoded_smids = map { $urlencode{$_} } @smids;

    $c->stash->{template} = "search.tt2";
    $c->stash->{term} = $term;

    my @results;
    for( my $i; $i< @smids; $i++) { 
	push @results, [ $smids[$i], $encoded_smids[$i] ];
    }
	$c->stash->{results} = \@results;
    #$c->stash->{encoded_results} = \@encoded_smids;
    
}

1;
