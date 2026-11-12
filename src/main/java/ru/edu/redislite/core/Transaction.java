package ru.edu.redislite.core;

import ru.edu.redislite.command.Command;
import java.util.ArrayList;
import java.util.List;

public class Transaction {
    private final KeyValueStore store;
    private final List<Command> buffer = new ArrayList<>();
    private boolean active = false;
    public Transaction(KeyValueStore store) { this.store = store; }
    public boolean isActive() { return active; }
    public void begin() {
        if (active) throw new IllegalStateException("transaction already active");
        buffer.clear(); active = true;
    }
    public void enqueue(Command command) {
        if (!active) throw new IllegalStateException("no active transaction");
        buffer.add(command);
    }
    public List<String> commit() {
        if (!active) throw new IllegalStateException("no active transaction");
        List<String> res = new ArrayList<>();
        for (Command c : buffer) res.add(c.execute(store));
        buffer.clear(); active = false; return res;
    }
    public void rollback() {
        if (!active) throw new IllegalStateException("no active transaction");
        buffer.clear(); active = false;
    }
}
