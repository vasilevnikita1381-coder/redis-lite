@echo off
chcp 65001 >nul

echo Создание структуры проекта...
mkdir src\main\java\ru\edu\redislite\core 2>nul
mkdir src\main\java\ru\edu\redislite\command 2>nul
mkdir src\main\java\ru\edu\redislite\factory 2>nul
mkdir src\main\java\ru\edu\redislite\parser 2>nul
mkdir src\main\java\ru\edu\redislite\cli 2>nul
mkdir src\main\java\ru\edu\redislite\server 2>nul
mkdir src\test\java\ru\edu\redislite\core 2>nul
mkdir src\test\java\ru\edu\redislite\parser 2>nul
mkdir src\test\java\ru\edu\redislite 2>nul

echo Создание файлов main...
(
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"^>
echo   ^<modelVersion^>4.0.0^</modelVersion^>
echo   ^<groupId^>ru.edu^</groupId^>
echo   ^<artifactId^>redis-lite^</artifactId^>
echo   ^<version^>1.0.0^</version^>
echo   ^<properties^>
echo     ^<maven.compiler.release^>17^</maven.compiler.release^>
echo     ^<project.build.sourceEncoding^>UTF-8^</project.build.sourceEncoding^>
echo     ^<junit.version^>5.10.2^</junit.version^>
echo   ^</properties^>
echo   ^<dependencies^>
echo     ^<dependency^>
echo       ^<groupId^>org.junit.jupiter^</groupId^>
echo       ^<artifactId^>junit-jupiter^</artifactId^>
echo       ^<version^>${junit.version}^</version^>
echo       ^<scope^>test^</scope^>
echo     ^</dependency^>
echo   ^</dependencies^>
echo   ^<build^>
echo     ^<finalName^>redis-lite^</finalName^>
echo     ^<plugins^>
echo       ^<plugin^>
echo         ^<groupId^>org.apache.maven.plugins^</groupId^>
echo         ^<artifactId^>maven-compiler-plugin^</artifactId^>
echo         ^<version^>3.13.0^</version^>
echo       ^</plugin^>
echo       ^<plugin^>
echo         ^<groupId^>org.apache.maven.plugins^</groupId^>
echo         ^<artifactId^>maven-surefire-plugin^</artifactId^>
echo         ^<version^>3.2.5^</version^>
echo       ^</plugin^>
echo       ^<plugin^>
echo         ^<groupId^>org.apache.maven.plugins^</groupId^>
echo         ^<artifactId^>maven-shade-plugin^</artifactId^>
echo         ^<version^>3.5.3^</version^>
echo         ^<executions^>
echo           ^<execution^>
echo             ^<phase^>package^</phase^>
echo             ^<goals^>^<goal^>shade^</goal^>^</goals^>
echo             ^<configuration^>
echo               ^<transformers^>
echo                 ^<transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer"^>
echo                   ^<mainClass^>ru.edu.redislite.Main^</mainClass^>
echo                 ^</transformer^>
echo               ^</transformers^>
echo             ^</configuration^>
echo           ^</execution^>
echo         ^</executions^>
echo       ^</plugin^>
echo     ^</plugins^>
echo   ^</build^>
echo ^</project^>
) > pom.xml

(
echo package ru.edu.redislite.core;
echo.
echo import java.util.Set;
echo import java.util.concurrent.ConcurrentHashMap;
echo.
echo public class KeyValueStore {
echo     private final ConcurrentHashMap^<String, String^> data = new ConcurrentHashMap^<^>^(^);
echo.
echo     public void set^(String key, String value^) {
echo         if ^(key == null ^|^| key.isEmpty^(^)^) throw new IllegalArgumentException^("key must not be null or empty"^);
echo         if ^(value == null^) throw new IllegalArgumentException^("value must not be null"^);
echo         data.put^(key, value^);
echo     }
echo.
echo     public String get^(String key^) {
echo         if ^(key == null ^|^| key.isEmpty^(^)^) throw new IllegalArgumentException^("key must not be null or empty"^);
echo         return data.get^(key^);
echo     }
echo.
echo     public int del^(String key^) {
echo         if ^(key == null ^|^| key.isEmpty^(^)^) throw new IllegalArgumentException^("key must not be null or empty"^);
echo         return data.remove^(key^) != null ? 1 : 0;
echo     }
echo.
echo     public boolean exists^(String key^) {
echo         if ^(key == null ^|^| key.isEmpty^(^)^) throw new IllegalArgumentException^("key must not be null or empty"^);
echo         return data.containsKey^(key^);
echo     }
echo.
echo     public Set^<String^> keys^(^) {
echo         return Set.copyOf^(data.keySet^(^)^);
echo     }
echo }
) > src\main\java\ru\edu\redislite\core\KeyValueStore.java

(
echo package ru.edu.redislite.command;
echo.
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public interface Command {
echo     String execute^(KeyValueStore store^);
echo }
) > src\main\java\ru\edu\redislite\command\Command.java

(
echo package ru.edu.redislite.command;
echo.
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public class SetCommand implements Command {
echo     private final String key, value;
echo     public SetCommand^(String key, String value^) { this.key = key; this.value = value; }
echo     public String execute^(KeyValueStore store^) { store.set^(key, value^); return "OK"; }
echo }
) > src\main\java\ru\edu\redislite\command\SetCommand.java

(
echo package ru.edu.redislite.command;
echo.
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public class GetCommand implements Command {
echo     private final String key;
echo     public GetCommand^(String key^) { this.key = key; }
echo     public String execute^(KeyValueStore store^) {
echo         String v = store.get^(key^);
echo         return v == null ? "(nil)" : v;
echo     }
echo }
) > src\main\java\ru\edu\redislite\command\GetCommand.java

(
echo package ru.edu.redislite.command;
echo.
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public class DelCommand implements Command {
echo     private final String key;
echo     public DelCommand^(String key^) { this.key = key; }
echo     public String execute^(KeyValueStore store^) { return String.valueOf^(store.del^(key^)^); }
echo }
) > src\main\java\ru\edu\redislite\command\DelCommand.java

(
echo package ru.edu.redislite.command;
echo.
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public class ExistsCommand implements Command {
echo     private final String key;
echo     public ExistsCommand^(String key^) { this.key = key; }
echo     public String execute^(KeyValueStore store^) { return store.exists^(key^) ? "1" : "0"; }
echo }
) > src\main\java\ru\edu\redislite\command\ExistsCommand.java

(
echo package ru.edu.redislite.command;
echo.
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public class KeysCommand implements Command {
echo     public String execute^(KeyValueStore store^) { return String.join^(",", store.keys^(^)^); }
echo }
) > src\main\java\ru\edu\redislite\command\KeysCommand.java

(
echo package ru.edu.redislite.parser;
echo.
echo import java.util.ArrayList;
echo import java.util.List;
echo.
echo public class ParsedCommand {
echo     private final String name;
echo     private final List^<String^> args;
echo     public ParsedCommand^(String name, List^<String^> args^) { this.name = name; this.args = args; }
echo     public String getName^(^) { return name; }
echo     public List^<String^> getArgs^(^) { return args; }
echo }
) > src\main\java\ru\edu\redislite\parser\ParsedCommand.java

(
echo package ru.edu.redislite.parser;
echo.
echo import java.util.ArrayList;
echo import java.util.List;
echo.
echo public class CommandParser {
echo     public ParsedCommand parse^(String line^) {
echo         if ^(line == null ^|^| line.trim^(^).isEmpty^(^)^) throw new IllegalArgumentException^("empty command"^);
echo         String[] parts = line.trim^(^).split^("\\s+"^);
echo         List^<String^> args = new ArrayList^<^>^(^);
echo         for ^(int i = 1; i ^< parts.length; i++^) args.add^(parts[i]^);
echo         return new ParsedCommand^(parts[0].toUpperCase^(^), args^);
echo     }
echo }
) > src\main\java\ru\edu\redislite\parser\CommandParser.java

(
echo package ru.edu.redislite.factory;
echo.
echo import ru.edu.redislite.command.*;
echo import ru.edu.redislite.parser.ParsedCommand;
echo import java.util.List;
echo.
echo public class CommandFactory {
echo     public Command create^(ParsedCommand pc^) {
echo         List^<String^> a = pc.getArgs^(^);
echo         switch ^(pc.getName^(^)^) {
echo             case "SET": requireArgs^(a, 2, "SET"^); return new SetCommand^(a.get^(0^), a.get^(1^)^);
echo             case "GET": requireArgs^(a, 1, "GET"^); return new GetCommand^(a.get^(0^)^);
echo             case "DEL": requireArgs^(a, 1, "DEL"^); return new DelCommand^(a.get^(0^)^);
echo             case "EXISTS": requireArgs^(a, 1, "EXISTS"^); return new ExistsCommand^(a.get^(0^)^);
echo             case "KEYS": return new KeysCommand^(^);
echo             default: throw new IllegalArgumentException^("unknown command: " + pc.getName^(^)^);
echo         }
echo     }
echo     private void requireArgs^(List^<String^> a, int n, String name^) {
echo         if ^(a.size^(^) != n^) throw new IllegalArgumentException^(name + " expects " + n + " args"^);
echo     }
echo }
) > src\main\java\ru\edu\redislite\factory\CommandFactory.java

(
echo package ru.edu.redislite.core;
echo.
echo import ru.edu.redislite.command.Command;
echo import java.util.ArrayList;
echo import java.util.List;
echo.
echo public class Transaction {
echo     private final KeyValueStore store;
echo     private final List^<Command^> buffer = new ArrayList^<^>^(^);
echo     private boolean active = false;
echo     public Transaction^(KeyValueStore store^) { this.store = store; }
echo     public boolean isActive^(^) { return active; }
echo     public void begin^(^) {
echo         if ^(active^) throw new IllegalStateException^("transaction already active"^);
echo         buffer.clear^(^); active = true;
echo     }
echo     public void enqueue^(Command command^) {
echo         if ^(!active^) throw new IllegalStateException^("no active transaction"^);
echo         buffer.add^(command^);
echo     }
echo     public List^<String^> commit^(^) {
echo         if ^(!active^) throw new IllegalStateException^("no active transaction"^);
echo         List^<String^> res = new ArrayList^<^>^(^);
echo         for ^(Command c : buffer^) res.add^(c.execute^(store^)^);
echo         buffer.clear^(^); active = false; return res;
echo     }
echo     public void rollback^(^) {
echo         if ^(!active^) throw new IllegalStateException^("no active transaction"^);
echo         buffer.clear^(^); active = false;
echo     }
echo }
) > src\main\java\ru\edu\redislite\core\Transaction.java

(
echo package ru.edu.redislite.cli;
echo.
echo import ru.edu.redislite.command.Command;
echo import ru.edu.redislite.core.KeyValueStore;
echo import ru.edu.redislite.core.Transaction;
echo import ru.edu.redislite.factory.CommandFactory;
echo import ru.edu.redislite.parser.CommandParser;
echo import ru.edu.redislite.parser.ParsedCommand;
echo import java.io.BufferedReader;
echo import java.io.InputStreamReader;
echo.
echo public class Cli {
echo     private final KeyValueStore store;
echo     private final Transaction tx;
echo     private final CommandParser parser = new CommandParser^(^);
echo     private final CommandFactory factory = new CommandFactory^(^);
echo     public Cli^(KeyValueStore store^) { this.store = store; this.tx = new Transaction^(store^); }
echo     public void run^(^) throws Exception {
echo         System.out.println^("Redis Lite CLI. Type EXIT to quit."^);
echo         BufferedReader in = new BufferedReader^(new InputStreamReader^(System.in^)^);
echo         String line;
echo         while ^(^(line = in.readLine^(^)^) != null^) {
echo             if ^("EXIT".equalsIgnoreCase^(line.trim^(^)^)^) break;
echo             System.out.println^(handle^(line^)^);
echo         }
echo     }
echo     public String handle^(String line^) {
echo         try {
echo             ParsedCommand pc = parser.parse^(line^);
echo             String name = pc.getName^(^);
echo             if ^("BEGIN".equals^(name^)^) { tx.begin^(^); return "OK"; }
echo             if ^("COMMIT".equals^(name^)^) { tx.commit^(^); return "OK"; }
echo             if ^("ROLLBACK".equals^(name^)^) { tx.rollback^(^); return "OK"; }
echo             Command cmd = factory.create^(pc^);
echo             if ^(tx.isActive^(^)^) { tx.enqueue^(cmd^); return "QUEUED"; }
echo             return cmd.execute^(store^);
echo         } catch ^(RuntimeException e^) { return "(error) " + e.getMessage^(^); }
echo     }
echo }
) > src\main\java\ru\edu\redislite\cli\Cli.java

(
echo package ru.edu.redislite;
echo.
echo import ru.edu.redislite.cli.Cli;
echo import ru.edu.redislite.core.KeyValueStore;
echo.
echo public class Main {
echo     public static void main^(String[] args^) throws Exception {
echo         KeyValueStore store = new KeyValueStore^(^);
echo         new Cli^(store^).run^(^);
echo     }
echo }
) > src\main\java\ru\edu\redislite\Main.java

echo.
echo Готово! Все файлы созданы. Нажмите любую клавишу для выхода.
pause >nul