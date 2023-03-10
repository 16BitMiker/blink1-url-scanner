#!/usr/bin/env perl

my $go = Blink::URL::Scan->load();
$go->run();

package Blink::URL::Scan
{
    use feature         qw|say|;
    use Term::ANSIColor qw|:constants|;

    sub load
    {
        my $class = shift;
        
        unless ($ARGV[0] && $ARGV[0] =~ m`^http`)
        {
            say q|> |, UNDERLINE RED q|need to provide a url...|, RESET;
            exit 69;
        }
        
        chomp (my $url = $ARGV[0]);
        
        my $cmd   = q|/home/mike/git/blink1-tool/blink1-tool|;
        my $curl  = q|curl -sSL -I --connect-timeout 5|;
    
        my $codes = {};
        $$codes{0}   = q|--red|;         # can not connect
        $$codes{200} = q|--green|;       # success
        $$codes{300} = q|--yellow|;      # redirected
        $$codes{400} = q|--rgb=#6B5B95|; # access denied
        
        my $blink = q|--blue --blink 1|;
        my $off   = q|--off|;
       
        return bless 
        { 
            blink  => $blink, 
            cmd    => $cmd, 
            curl   => $curl, 
            url    => $url, 
            codes  => $codes,
            off    => $off
        }, $class;
    }
    
    sub run
    {
        my $self = shift;
        my $code = '';
        
        qx|$$self{cmd} $$self{off}|;
        
        while (1)
        {
            $code = $self->_ping_site();
            $self->_blink($code);
            $self->_sleepy_time(1800,100);
        }
    }
    
    sub _sleepy_time($$)
    {
        my $self   = shift;
        my $static = shift;
        my $random = shift;
        
        my $sleepy = $static + int(rand($random));
        
        say q|> |, YELLOW qq|sleeping for ${sleepy} seconds...|, RESET;
        sleep $sleepy;
    }
    
    sub _ping_site
    {
        my $self  = shift;
        my $cmd   = $$self{cmd};
        
        my $return = qx|$$self{curl} $$self{url}|;
        
        # example return: HTTP/2 200
        my $code = $return =~ s`^HTTP/[1-2\.]+\s(\d+)(?s).*`$1`re;
        
        return $code =~ m`` ? 0 : $code;
    }
    
    sub _blink($)
    {
        my $self = shift;
        my $code = shift;
        
        say q|> scanning: |, BLUE $$self{url}, RESET;
        
        map { qx|$$self{cmd} $$self{blink}|; sleep 1 } 0..10;
        
        $code = 0 unless $$self{codes}{$code};
        
        say q|> returned with code: |, UNDERLINE GREEN $code, RESET;
        
        qx|$$self{cmd} $$self{codes}{$code}|;
    }
}


