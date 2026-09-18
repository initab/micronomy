use Test;
use Micronomy::Calendar;

my $ics = calendargenerator(Date.new(2024, 1, 1));

ok $ics.starts-with("BEGIN:VCALENDAR\r\n"), 'ICS-strängen börjar med BEGIN:VCALENDAR';
ok $ics.ends-with("END:VCALENDAR\r\n"), 'ICS-strängen slutar med END:VCALENDAR';

ok $ics.contains("DTSTART:20240101T000000\r\nDTEND:20240102T000000\r\nSUMMARY:Nyårsdagen - Init ledig dag 8h\r\n"),
    'Nyårsdagen (fast datum, heldag)';

ok $ics.contains("DTSTART:20240105T150000\r\nDTEND:20240106T000000\r\nSUMMARY:Trettondagsafton - Init ledig dag 2h\r\n"),
    'Trettondagsafton (fast datum, kvartsdag)';

ok $ics.contains("DTSTART:20240328T130000\r\nDTEND:20240329T000000\r\nSUMMARY:Skärtorsdag - Init ledig dag 4h\r\n"),
    'Skärtorsdag, påsk -3 dagar (halvdag)';

ok $ics.contains("DTSTART:20240329T000000\r\nDTEND:20240330T000000\r\nSUMMARY:Långfredag - Init ledig dag 8h\r\n"),
    'Långfredag, påsk -2 dagar (heldag)';

ok $ics.contains("DTSTART:20240331T000000\r\nDTEND:20240401T000000\r\nSUMMARY:Påskdagen - Init ledig dag 8h\r\n"),
    'Påskdagen 2024-03-31 (heldag)';

ok $ics.contains("DTSTART:20240509T000000\r\nDTEND:20240510T000000\r\nSUMMARY:Kristi himmelsfärdsdag - Init ledig dag 8h\r\n"),
    'Kristi himmelsfärdsdag, påsk +39 dagar';

ok $ics.contains("DTSTART:20240621T000000\r\nDTEND:20240622T000000\r\nSUMMARY:Midsommarafton - Init ledig dag 8h\r\n"),
    'Midsommarafton (första lördagen på/efter 20 juni, minus en dag)';

ok $ics.contains("DTSTART:20241101T130000\r\nDTEND:20241102T000000\r\nSUMMARY:Allhelgonaafton - Init ledig dag 4h\r\n"),
    'Allhelgonaafton (första lördagen på/efter 31 okt, minus en dag; halvdag)';

ok $ics.contains("DTSTART:20241225T000000\r\nDTEND:20241226T000000\r\nSUMMARY:Juldagen - Init ledig dag 8h\r\n"),
    'Juldagen (fast datum, heldag)';

nok $ics.contains("DTSTART:20240115"), 'En vanlig vardag (t.ex. 2024-01-15) finns inte med i kalendern';

done-testing;
