package ru.edu.redislite.command;

import ru.edu.redislite.core.KeyValueStore;

public class KeysCommand implements Command {
    public String execute(KeyValueStore store) { return String.join(",", store.keys()); }
}
