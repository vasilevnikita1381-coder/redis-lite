package ru.edu.redislite.command;

import ru.edu.redislite.core.KeyValueStore;

public class SetCommand implements Command {
    private final String key, value;
    public SetCommand(String key, String value) { this.key = key; this.value = value; }
    public String execute(KeyValueStore store) { store.set(key, value); return "OK"; }
}
