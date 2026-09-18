use Test;
use Micronomy::Cache;

# get-cache/set-cache resolve their file path relative to the running
# script's directory (via $*PROGRAM-NAME), which sandboxes this test's
# writes under t/resources/ instead of the real resources/ directory,
# as long as this file is run with a relative path (e.g. `raku -I lib t/cache.t`).
my @test-employees = <999901 999902 demo>;

END {
    for @test-employees -> $employeeNumber {
        unlink "t/resources/$employeeNumber.json" if "t/resources/$employeeNumber.json".IO.e;
    }
    rmdir "t/resources" if "t/resources".IO.d && !"t/resources".IO.dir;
}

mkdir "t/resources" unless "t/resources".IO.d;

# --- Enabled cache: only approved (state 2) weeks survive ---
set-cache({
    employeeName => "Test Testsson",
    employeeNumber => "999901",
    enabled => True,
    jobs => { "42" => { tasks => { "1" => "Utveckling" } } },
    weeks => {
        2024 => {
            "01" => {
                "15" => { state => 2, hours => 8 },
                "16" => { state => 1, hours => 4 },
            }
        }
    },
});
my %enabled-cache = get-cache("999901");

is %enabled-cache<employeeNumber>, "999901",
    'Ska bevara employeeNumber vid läsning av en aktiverad cache';

ok %enabled-cache<jobs><42>.defined,
    'Ska bevara jobs vid läsning av en aktiverad cache';

is %enabled-cache<weeks><2024><01><15><hours>, 8,
    'Ska bevara en godkänd vecka (state 2) vid läsning av en aktiverad cache';

nok %enabled-cache<weeks><2024><01><16>.defined,
    'Ska filtrera bort en ej godkänd vecka (state 1) vid läsning av en aktiverad cache';

# --- Disabled cache: jobs/weeks are stripped entirely ---
set-cache({
    employeeName => "Inaktiv Inaktivsson",
    employeeNumber => "999902",
    enabled => False,
    jobs => { "42" => { tasks => { "1" => "Utveckling" } } },
    weeks => {
        2024 => { "01" => { "15" => { state => 2, hours => 8 } } }
    },
});
my %disabled-cache = get-cache("999902");

is %disabled-cache<employeeNumber>, "999902",
    'Ska bevara employeeNumber vid läsning av en inaktiverad cache';

nok %disabled-cache<jobs>.defined,
    'Ska inte spara jobs vid läsning av en inaktiverad cache';

nok %disabled-cache<weeks>.defined,
    'Ska inte spara weeks vid läsning av en inaktiverad cache';

# --- "demo" bypasses both the enabled-check and the state filter ---
set-cache({
    employeeName => "Demo",
    employeeNumber => "demo",
    enabled => False,
    jobs => { "1" => { tasks => { "1" => "Demoarbete" } } },
    weeks => {
        2024 => { "02" => { "01" => { state => 0, hours => 3 } } }
    },
});
my %demo-cache = get-cache("demo");

ok %demo-cache<jobs><1>.defined,
    'Ska spara jobs för "demo" trots att enabled är falskt';

is %demo-cache<weeks><2024><02><01><hours>, 3,
    'Ska spara en icke godkänd vecka för "demo" trots att state inte är 2';

# --- Reading a cache that was never written ---
my $missing = get-cache("999903-saknas");

nok $missing.defined,
    'Ska returnera odefinierat värde vid läsning av en anställd utan cachefil';

done-testing;
