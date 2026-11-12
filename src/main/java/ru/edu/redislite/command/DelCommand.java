package ru.edu.redislite.command;

import ru.edu.redislite.core.KeyValueStore;

public class DelCommand implements Command {
    private final String key;
    public DelCommand(String key) { this.key = key; }
    public String execute(KeyValueStore store) { return String.valueOf(store.del(key)); }
}
