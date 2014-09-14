#!/usr/bin/perl -W

##################################################################################
#                       Copyright © 2014, GHOSTnew                               #
##################################################################################
# The MIT License (MIT)                                                          #
#                                                                                #
# Permission is hereby granted, free of charge, to any person obtaining a copy   #
# of this software and associated documentation files (the "Software"), to deal  #
# in the Software without restriction, including without limitation the rights   #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      #
# copies of the Software, and to permit persons to whom the Software is          #
# furnished to do so, subject to the following conditions:                       #
#                                                                                #
# The above copyright notice and this permission notice shall be included in     #
# all copies or substantial portions of the Software.                            #
#                                                                                #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN      #
# THE SOFTWARE.                                                                  #
##################################################################################

use IO::Socket::Socks;
use IO::Socket::SSL;
use IO::Socket;
use threads;
use strict;

my $server = IO::Socket::INET->new(Proto => 'tcp',
                                    LocalPort => "20000",
                                    Listen => SOMAXCONN,
                                    Reuse => 1
                                    );
printf("Vous pouvez maintenant vous connecter sur 127.0.0.1 port: 20000\n");
printf("exemple , avec irssi: \$ irssi -c 127.0.0.1 -p 20000\n");

while ($server = $server->accept()) {
    $server->autoflush(1);
    print $server "Connexion en cours\n";
    print $server "Dogecoin: DMP3meY5fy2ydX45qyXoexw1oLKkSpJYbG\n";
    my $tsock = new IO::Socket::Socks->new(ProxyAddr=>"127.0.0.1",
                                        ProxyPort=>"9050",
                                        ConnectAddr=>"oghzthm3fgvkh5wo.onion",
                                        ConnectPort=>"6697",
                                    );
    IO::Socket::SSL->start_SSL($tsock) or die "Erreur: $SSL_ERROR";
    sub recvserv{
        while(<$server>) {
            if($tsock){
                print $tsock $_;
            }else{
                $server->close();
            }
        }
        $server->close();
    }

    sub recvtsock{
        while(<$tsock>){
            if($server){
                print $server $_;
            }else{
                $tsock->close();
            }
        }
        $tsock->close();
    }

    my $thrServIRC = threads->new(\&recvtsock);
    my $thrClient = threads->new(\&recvserv);
    $thrServIRC->join();
    $thrClient->join();
}
