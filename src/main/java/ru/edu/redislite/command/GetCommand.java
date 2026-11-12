package ru.edu.redislite.command;

import ru.edu.redislite.core.KeyValueStore;

public class GetCommand implements Command {
    private final String key;
    public GetCommand(String key) { this.key = key; }
    public String execute(KeyValueStore store) {
        String v = store.get(key);
        return v == null ? "(nil)" : v;
    }
}
