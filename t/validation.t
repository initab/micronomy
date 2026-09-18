use Test;
use lib 'lib';
use Micronomy::Validation;

plan 22;

is fix-token("demo"), "demo", "demo token is left unchanged";
is fix-token(""), "", "empty token stays empty";
is fix-token("abc:defg"), "abc:defg", "already padded token is unchanged";
is fix-token("abc:def"), "abc:def=", "padding is added for 3-char suffix";
is fix-token("abc:de"), "abc:de==", "padding is added for 2-char suffix";
is fix-token("abc:de123"), "abc:de123", "normal token is preserved";
ok is-demo-login("demo", "demo"), "demo login is detected";
nok is-demo-login("demo", "wrong"), "non-demo password is rejected";
 nok is-demo-login("Demo", "demo"), "demo login is case-sensitive";
ok validate-date("2026-09-18"), "valid ISO date is accepted";
nok validate-date("2024-02-30"), "invalid calendar date is rejected";
ok validate-date("2024-02-29"), "valid leap-day date is accepted";
nok validate-date("2026/09/18"), "invalid date format is rejected";
ok validate-hours("7.5"), "decimal hours are accepted";
nok validate-hours("-1"), "negative hours are rejected";
ok validate-hours("0"), "zero hours are accepted";
ok validate-hours("24"), "the upper hours boundary is accepted";
nok validate-hours("24.1"), "hours beyond the upper boundary are rejected";
ok validate-hours("7,5"), "comma decimal hours are accepted";
nok validate-hours("99"), "hours beyond the supported range are rejected";
is encode-query-value("hello world&x=1"), "hello%20world%26x%3D1", "user input is percent-encoded for URLs";
is encode-query-value("AZaz09-._~"), "AZaz09-._~", "URL-safe characters are preserved";

done-testing;
