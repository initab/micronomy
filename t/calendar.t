use Test;
use Micronomy::Calendar;

my $ics = calendargenerator(Date.new(2024, 1, 1));

ok $ics.starts-with("BEGIN:VCALENDAR\r\n"),
    'Ska starta med BEGIN:VCALENDAR vid anrop till calendargenerator';

ok $ics.ends-with("END:VCALENDAR\r\n"),
    'Ska sluta med END:VCALENDAR vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20240101T000000\r\nDTEND:20240102T000000\r\nSUMMARY:Nyårsdagen - Init ledig dag 8h\r\n"),
    'Ska markera Nyårsdagen 2024-01-01 som heldag vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20240105T150000\r\nDTEND:20240106T000000\r\nSUMMARY:Trettondagsafton - Init ledig dag 2h\r\n"),
    'Ska markera Trettondagsafton 2024-01-05 som kvartsdag vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20240328T130000\r\nDTEND:20240329T000000\r\nSUMMARY:Skärtorsdag - Init ledig dag 4h\r\n"),
    'Ska beräkna Skärtorsdag som halvdag tre dagar före påsk vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20240329T000000\r\nDTEND:20240330T000000\r\nSUMMARY:Långfredag - Init ledig dag 8h\r\n"),
    'Ska beräkna Långfredag som heldag två dagar före påsk vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20240331T000000\r\nDTEND:20240401T000000\r\nSUMMARY:Påskdagen - Init ledig dag 8h\r\n"),
    'Ska beräkna Påskdagen till 2024-03-31 vid anrop till calendargenerator för 2024';

ok $ics.contains("DTSTART:20240509T000000\r\nDTEND:20240510T000000\r\nSUMMARY:Kristi himmelsfärdsdag - Init ledig dag 8h\r\n"),
    'Ska beräkna Kristi himmelsfärdsdag 39 dagar efter påsk vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20240621T000000\r\nDTEND:20240622T000000\r\nSUMMARY:Midsommarafton - Init ledig dag 8h\r\n"),
    'Ska beräkna Midsommarafton till dagen före första lördagen på eller efter 20 juni vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20241101T130000\r\nDTEND:20241102T000000\r\nSUMMARY:Allhelgonaafton - Init ledig dag 4h\r\n"),
    'Ska markera Allhelgonaafton som halvdag dagen före första lördagen på eller efter 31 oktober vid anrop till calendargenerator';

ok $ics.contains("DTSTART:20241225T000000\r\nDTEND:20241226T000000\r\nSUMMARY:Juldagen - Init ledig dag 8h\r\n"),
    'Ska markera Juldagen 2024-12-25 som heldag vid anrop till calendargenerator';

nok $ics.contains("DTSTART:20240115"),
    'Ska inte inkludera en vanlig vardag (2024-01-15) vid anrop till calendargenerator';

done-testing;
