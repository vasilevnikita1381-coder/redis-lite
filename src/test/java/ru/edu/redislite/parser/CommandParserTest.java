package ru.edu.redislite.parser;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CommandParserTest {
    private final CommandParser parser = new CommandParser();
    @Test void parsesName() { assertEquals("SET", parser.parse("SET a 1").getName()); }
    @Test void parsesArgs() { assertEquals(2, parser.parse("SET a 1").getArgs().size()); }
    @Test void uppercaseName() { assertEquals("GET", parser.parse("get a").getName()); }
    @Test void emptyThrows() { assertThrows(IllegalArgumentException.class, () -> parser.parse("   ")); }
}
