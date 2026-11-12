package ru.edu.redislite.cli;

import ru.edu.redislite.command.Command;
import ru.edu.redislite.core.KeyValueStore;
import ru.edu.redislite.core.Transaction;
import ru.edu.redislite.factory.CommandFactory;
import ru.edu.redislite.parser.CommandParser;
import ru.edu.redislite.parser.ParsedCommand;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Cli {
    private final KeyValueStore store;
    private final Transaction tx;
    private final CommandParser parser = new CommandParser();
    private final CommandFactory factory = new CommandFactory();
    public Cli(KeyValueStore store) { this.store = store; this.tx = new Transaction(store); }
    public void run() throws Exception {
        System.out.println("Redis Lite CLI. Type EXIT to quit.");
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String line;
        while ((line = in.readLine()) != null) {
            if ("EXIT".equalsIgnoreCase(line.trim())) break;
            System.out.println(handle(line));
        }
    }
    public String handle(String line) {
        try {
            ParsedCommand pc = parser.parse(line);
            String name = pc.getName();
            if ("BEGIN".equals(name)) { tx.begin(); return "OK"; }
            if ("COMMIT".equals(name)) { tx.commit(); return "OK"; }
            if ("ROLLBACK".equals(name)) { tx.rollback(); return "OK"; }
            Command cmd = factory.create(pc);
            if (tx.isActive()) { tx.enqueue(cmd); return "QUEUED"; }
            return cmd.execute(store);
        } catch (RuntimeException e) { return "(error) " + e.getMessage(); }
    }
}
