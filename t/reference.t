use strict;
use Test::More tests => 1;
use AnyEvent;
use t::Redis;

test_redis {
    my $r = shift;
    my $port = shift;
    $r = AnyEvent::Redis->new(
        host => "127.0.0.1",
        port => $port,
    );

    # connect;
    $r->set("foo", "bar")->recv;

    my $cv = AnyEvent->condvar;
    $r->get("foo", sub {
        $cv->send;
        pass "GET foo";
    });
    undef $r;
    $cv->recv;
};

done_testing;
