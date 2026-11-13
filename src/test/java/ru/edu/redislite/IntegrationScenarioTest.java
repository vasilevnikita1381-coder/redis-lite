package ru.edu.redislite;

import org.junit.jupiter.api.*;
import ru.edu.redislite.cli.Cli;
import ru.edu.redislite.core.KeyValueStore;
import static org.junit.jupiter.api.Assertions.*;

class IntegrationScenarioTest {
    private Cli cli;
    @BeforeEach void setUp() { cli = new Cli(new KeyValueStore()); }

    @Test void scenarioSetGet() {
        assertEquals("OK", cli.handle("SET name Ivan"));
        assertEquals("Ivan", cli.handle("GET name"));
    }
    @Test void scenarioTransactionCommit() {
        assertEquals("OK", cli.handle("BEGIN"));
        assertEquals("QUEUED", cli.handle("SET a 1"));
        assertEquals("OK", cli.handle("COMMIT"));
        assertEquals("1", cli.handle("GET a"));
    }
    @Test void scenarioRollback() {
        cli.handle("BEGIN"); cli.handle("SET a 1"); cli.handle("ROLLBACK");
        assertEquals("(nil)", cli.handle("GET a"));
    }
    @Test void scenarioDelete() {
        cli.handle("SET x 1");
        assertEquals("1", cli.handle("DEL x"));
    }
}
