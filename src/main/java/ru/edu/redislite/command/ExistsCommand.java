package ru.edu.redislite.command;

import ru.edu.redislite.core.KeyValueStore;

public class ExistsCommand implements Command {
    private final String key;
    public ExistsCommand(String key) { this.key = key; }
    public String execute(KeyValueStore store) { return store.exists(key) ? "1" : "0"; }
}
