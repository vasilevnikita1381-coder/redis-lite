package ru.edu.redislite.command;

import ru.edu.redislite.core.KeyValueStore;

public interface Command {
    String execute(KeyValueStore store);
}
