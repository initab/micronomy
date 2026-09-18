unit module Micronomy::Validation;

sub fix-token(Str $token --> Str) is export {
    return $token if $token eq 'demo';
    return "" unless $token;
    given $token.split(":")[1].chars % 4 {
        when 3 { return "$token=" }
        when 2 { return "$token==" }
        default { return $token }
    }
}

sub is-demo-login(Str $username, Str $password --> Bool) is export {
    return $username eq "demo" && $password eq "demo";
}

sub validate-date(Str $value --> Bool) is export {
    return False unless $value ~~ /^ \d ** 4 '-' \d ** 2 '-' \d ** 2 $/;
    try {
        Date.new($value);
        return True;
    }
    return False;
}

sub validate-hours(Str $value --> Bool) is export {
    my $hours = $value // "";
    return False unless $hours.chars;
    $hours = $hours.subst(",", ".");
    return False unless $hours ~~ /^ \d+ [ '.' \d+ ]? $/;
    my $numeric = +$hours;
    return $numeric >= 0 && $numeric <= 24;
}

sub validate-day-hours(@values --> Bool) is export {
    my $total = 0;
    for @values -> $value {
        my $hours = $value || "0";
        return False unless validate-hours($hours);
        $total += +$hours.subst(",", ".");
    }
    return $total <= 24;
}

sub encode-query-value(Str $value --> Str) is export {
    my @parts;
    for $value.encode('utf8').list -> $byte {
        my $char = $byte.chr;
        if $char ~~ / <[A..Z a..z 0..9 \- . _ ~]> / {
            @parts.push($char);
        } else {
            @parts.push('%' ~ sprintf('%02X', $byte));
        }
    }
    return @parts.join;
}
