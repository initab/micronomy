use Test;
use lib 'lib';
use Micronomy::Calendar;

plan 12;

my $calendar = calendargenerator(Date.new('2024-01-01'));

ok $calendar.starts-with("BEGIN:VCALENDAR\r\n"), "calendar starts with the VCALENDAR header";
ok $calendar.contains("PRODID:Init-Micronomy-2024\r\n"), "calendar contains the requested year";
ok $calendar.contains("VERSION:2.0\r\n"), "calendar declares iCalendar version 2.0";
ok $calendar.ends-with("END:VCALENDAR\r\n"), "calendar ends with the VCALENDAR footer";
ok $calendar.split("\r\n").elems > 1, "calendar uses CRLF line endings";

ok $calendar.contains("SUMMARY:Nyårsdagen - Init ledig dag 8h\r\n"), "fixed New Year's holiday is included";
ok $calendar.contains("SUMMARY:Skärtorsdag - Init ledig dag 4h\r\n"), "movable Maundy Thursday holiday is included";
ok $calendar.contains("DTSTART:20240328T130000\r\nDTEND:20240329T000000\r\n"), "half-day holiday has the expected event times";
ok $calendar.contains("SUMMARY:Trettondagsafton - Init ledig dag 2h\r\n"), "quarter-day holiday is included";
ok $calendar.contains("DTSTART:20240105T150000\r\nDTEND:20240106T000000\r\n"), "quarter-day holiday has the expected event times";
nok $calendar.contains("SUMMARY:Helg"), "ordinary weekends are not exported as holidays";

my $leap-calendar = calendargenerator(Date.new('2024-02-29'));
is $leap-calendar.comb('BEGIN:VEVENT').elems, $calendar.comb('BEGIN:VEVENT').elems,
    "generation uses the full requested year, including leap years";

done-testing;