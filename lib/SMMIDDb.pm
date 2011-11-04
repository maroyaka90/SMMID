use strict;

package SMMIDDb;

use Tie::UrlEncoder;

our %urlencode;
our $PARSED;
our %SMMID;

sub new { 
    my $class = shift;
    my $file = shift;
    my $smmid = shift;
    my $self = bless {}, $class;

    $self->set_smmid($smmid);
    #print STDERR "SMMID FILE = $file\n";
    $self->{smmid_file} = $file;

    $self->fetch();

    return $self;
}

=head2 accessors get_smmid, set_smmid

 Usage:
 Desc:
 Property
 Side Effects:
 Example:

=cut

sub get_smmid {
  my $self = shift;
  return $self->{smmid}; 
}

sub set_smmid {
  my $self = shift;
  my $smmid = shift;
  $self->{smmid} = $smmid
}

sub fetch { 
    my $self = shift;    

    if (!$PARSED) { 
	open (my $F, "<".$self->{smmid_file}) || die "Can't open the SMMID definition file $self->{smmid_file}.";
	my $current = "";	
	my $section = "";
	while (<$F>) { 
	    chomp;
	    next() if !$_;
	    if (/^SMMID\:\s*(.*\#.*)$/) { 
		$current = $1;
		chomp($current);
		$SMMID{$current}->{SMMID}=$current;
		
	    }
	    else { 
		my ($key, $value) = split /\s*\:\s*/;
		if ($key=~/^http/) { 
		    print STDERR "Adding reference to $section: $value.\n";
		    push @{$SMMID{$current}->{link_url}->{$section}}, $value;
		}
		elsif ($key=~/^\(/) { 
		    print STDERR "Adding link to $section: $key\n";
		    push @{$SMMID{$current}->{link_text}->{$section}}, $key;
		}
		else { 
		    $SMMID{$current}->{$key}=$value;
		    $section = $key;
		}
	    
	    }
	    $PARSED = "TRUE!";
	}
    }
    
}
	    
=head2 accessors get_name, set_name

 Usage:
 Desc:
 Property
 Side Effects:
 Example:

=cut

sub get_name {
  my $self = shift;
if (!exists $SMMID{$self->get_smmid()}) { 
    die "Need to set smmid first with set_smmid()";
}
  my $name =  $SMMID{$self->get_smmid()}->{"CHEMICAL NAME"}; 
  print STDERR "Chemical name is $name\n";
  return $name;
}

sub set_name {
  my $self = shift;
  $SMMID{$self->get_smmid()}->{NAME}=shift;
}

=head2 accessors get_synonyms, set_synonyms

 Usage:
 Desc:
 Property
 Side Effects:
 Example:

=cut

sub get_synonyms {
  my $self = shift;
  return $SMMID{$self->get_smmid()}->{SYNONYMS}; 
}

sub set_synonyms {
  my $self = shift;
  $SMMID{$self->get_smmid()}->{SYNONYMS}=shift;
}

=head2 accessors get_molecular_formula, set_molecular_formula

 Usage:
 Desc:
 Property
 Side Effects:
 Example:

=cut

sub get_molecular_formula {
  my $self = shift;
  return $SMMID{$self->get_smmid()}->{"MOLECULAR FORMULA"};
}

sub set_molecular_formula {
  my $self = shift;
  $SMMID{$self->get_smmid()}->{"MOLCULAR FORMULA"}=shift;
}


=head2 accessors get_molecular_weight, set_molecular_weight

 Usage:
 Desc:
 Property
 Side Effects:
 Example:

=cut

sub get_molecular_weight {
  my $self = shift;
  return $SMMID{$self->get_smmid()}->{"MOLECULAR WEIGHT"};
}

sub set_molecular_weight {
  my $self = shift;
  $SMMID{$self->get_smmid()}->{"MOLECULAR WEIGHT"}=shift;
}

=head2 get_structure_file

 Usage:
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_structure_file {
    my $self = shift;
    my $file = $self->get_smmid();
    $file =~ s/\#/\%23/g;
    return $file;

}

=head2 get_smmid_for_link

 Usage: 
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_smmid_for_link {
    my $self = shift;
    return $urlencode{$self->get_smmid()};

}

=head2 get_links

 Usage:
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_links {
    my $self =shift;
    my $section = shift;
    print STDERR "getting links for section $section\n";
    my @links = ();
    if (!defined($SMMID{$self->get_smmid()}->{link_text}->{$section})) { return; }
    print STDERR scalar(@{$SMMID{$self->get_smmid()}->{link_text}->{$section}})." entries\n";
    for (my $i=0; $i<@{$SMMID{$self->get_smmid()}->{link_text}->{$section}}; $i++) { 
	push @links, [ ${$SMMID{$self->get_smmid()}->{link_text}->{$section}}[$i], ${$SMMID{$self->get_smmid()}->{link_url}->{$section}}[$i] ];
    }
    return @links;
    
}


=head2 get_cas

 Usage:
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_cas {
    my $self = shift;
    return $SMMID{$self->get_smmid()}->{CAS};
}

=head2 get_concise_summary

 Usage:
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_concise_summary {
    my $self = shift;
    return $SMMID{$self->get_smmid()}->{"CONCISE SUMMARY"};
}

=head2 get_biosynthesis

 Usage:
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_biosynthesis {
    my $self = shift;
    return $SMMID{$self->get_smmid()}->{BIOSYNTHESIS};
}

=head2 get_receptors

 Usage:
 Desc:
 Ret:
 Args:
 Side Effects:
 Example:

=cut

sub get_receptors {
    my $self = shift;
    return $SMMID{$self->get_smmid()}->{RECEPTORS};
}






=head2 all_smmids

 Usage:         my @smmids = SMMIDDb->new($smmid_file);
 Desc:          returns all the SMIDs in the database
 Ret:           a list of SMMIDDb objects
 Args:          the smmid file to parse
 Side Effects:
 Example:

=cut

sub all_smmids {
    my $class = shift;
    my $path = shift;

    my $self = $class->new($path);

    $self->fetch();

    my @all_smmids = ();
    
    foreach my $s (sort keys(%SMMID)) {
	my $smmid = SMMIDDb->new($path, $s);
	
	push @all_smmids, $smmid;
    }

    my @sorted_smmids = sort smmid_sort @all_smmids;
    
    return @all_smmids;
    
}

sub smmid_sort { 
    my $asmmid = $a->get_smmid();
    my $bsmmid = $b->get_smmid();
    
    print STDERR "SMID A: $asmmid\n";
    print STDERR "SMID B: $bsmmid\n";
    my ($sa, $na) = split "#", $asmmid;
    my ($sb, $nb) = split "#", $bsmmid;
    
    #if (!($sa cmp $sb) ) {
	print STDERR "SORTING N.. ".($na <=> $nb)."\n";
	return $nb <=> $na;
    #}
    print STDERR "SORTING AB ".($sa cmp $sb)."\n";
    return $sb cmp $sa;
}


=head2 search

 Usage:
 Desc:         searches a match of the term with the smmid, concise 
               summary or cas number
 Ret:          a list of smmids [strings]
 Args:         a smmid definition file, and the search string
 Side Effects:
 Example:

=cut

sub search {
    my $self = shift;
    my $file = shift;
    my $string = shift;
    $string =~ s/\{|\}|\;//g;
    
    my @smids = SMMIDDb->all_smmids($file);
    
    my @results = ();

    foreach my $smid (@smids) { 
	print STDERR "Checking match between $smid and $string\n";
	if ($smid->get_name() =~ m/$string/i || 
	    $smid->get_concise_summary() =~ m/$string/i ||
	    $smid->get_cas() =~ m/$string/i ||
	    $smid->get_smmid() =~ m/$string/i 
	    ) { 
	    push @results, $smid->get_smmid();
	
	}
    }
    return @results;
}




    
1;
