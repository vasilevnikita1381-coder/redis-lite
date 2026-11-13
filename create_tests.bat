@echo off
chcp 65001 >nul
echo Создание тестов JUnit 5...

mkdir src\test\java\ru\edu\redislite\core 2>nul
mkdir src\test\java\ru\edu\redislite\parser 2>nul
mkdir src\test\java\ru\edu\redislite 2>nul

(
echo package ru.edu.redislite.core;
echo.
echo import org.junit.jupiter.api.*;
echo import static org.junit.jupiter.api.Assertions.*;
echo.
echo class KeyValueStoreTest {
echo     private KeyValueStore store;
echo     @BeforeEach void setUp^(^) { store = new KeyValueStore^(^); }
echo.
echo     @Test void setStoresValue^(^) { store.set^("a","1"^); assertEquals^("1", store.get^("a"^)^); }
echo     @Test void setOverwrites^(^) { store.set^("a","1"^); store.set^("a","2"^); assertEquals^("2", store.get^("a"^)^); }
echo     @Test void setNullValueThrows^(^) { assertThrows^(IllegalArgumentException.class, ^(^) -^> store.set^("a", null^)^); }
echo     @Test void getMissingReturnsNull^(^) { assertNull^(store.get^("x"^)^); }
echo     @Test void getEmptyKeyThrows^(^) { assertThrows^(IllegalArgumentException.class, ^(^) -^> store.get^(""^)^); }
echo     @Test void delExistingReturnsOne^(^) { store.set^("k","v"^); assertEquals^(1, store.del^("k"^)^); }
echo     @Test void delMissingReturnsZero^(^) { assertEquals^(0, store.del^("nope"^)^); }
echo     @Test void existsTrue^(^) { store.set^("k","v"^); assertTrue^(store.exists^("k"^)^); }
echo     @Test void existsFalse^(^) { assertFalse^(store.exists^("x"^)^); }
echo     @Test void keysEmpty^(^) { assertTrue^(store.keys^(^).isEmpty^(^)^); }
echo     @Test void keysContains^(^) { store.set^("a","1"^); assertTrue^(store.keys^(^).contains^("a"^)^); }
echo }
) > src\test\java\ru\edu\redislite\core\KeyValueStoreTest.java

(
echo package ru.edu.redislite.parser;
echo.
echo import org.junit.jupiter.api.Test;
echo import static org.junit.jupiter.api.Assertions.*;
echo.
echo class CommandParserTest {
echo     private final CommandParser parser = new CommandParser^(^);
echo     @Test void parsesName^(^) { assertEquals^("SET", parser.parse^("SET a 1"^).getName^(^)^); }
echo     @Test void parsesArgs^(^) { assertEquals^(2, parser.parse^("SET a 1"^).getArgs^(^).size^(^)^); }
echo     @Test void uppercaseName^(^) { assertEquals^("GET", parser.parse^("get a"^).getName^(^)^); }
echo     @Test void emptyThrows^(^) { assertThrows^(IllegalArgumentException.class, ^(^) -^> parser.parse^("   "^)^); }
echo }
) > src\test\java\ru\edu\redislite\parser\CommandParserTest.java

(
echo package ru.edu.redislite;
echo.
echo import org.junit.jupiter.api.*;
echo import ru.edu.redislite.cli.Cli;
echo import ru.edu.redislite.core.KeyValueStore;
echo import static org.junit.jupiter.api.Assertions.*;
echo.
echo class IntegrationScenarioTest {
echo     private Cli cli;
echo     @BeforeEach void setUp^(^) { cli = new Cli^(new KeyValueStore^(^)^); }
echo.
echo     @Test void scenarioSetGet^(^) {
echo         assertEquals^("OK", cli.handle^("SET name Ivan"^)^);
echo         assertEquals^("Ivan", cli.handle^("GET name"^)^);
echo     }
echo     @Test void scenarioTransactionCommit^(^) {
echo         assertEquals^("OK", cli.handle^("BEGIN"^)^);
echo         assertEquals^("QUEUED", cli.handle^("SET a 1"^)^);
echo         assertEquals^("OK", cli.handle^("COMMIT"^)^);
echo         assertEquals^("1", cli.handle^("GET a"^)^);
echo     }
echo     @Test void scenarioRollback^(^) {
echo         cli.handle^("BEGIN"^); cli.handle^("SET a 1"^); cli.handle^("ROLLBACK"^);
echo         assertEquals^("(nil)", cli.handle^("GET a"^)^);
echo     }
echo     @Test void scenarioDelete^(^) {
echo         cli.handle^("SET x 1"^);
echo         assertEquals^("1", cli.handle^("DEL x"^)^);
echo     }
echo }
) > src\test\java\ru\edu\redislite\IntegrationScenarioTest.java

echo Готово! Тесты созданы.
pause >nul