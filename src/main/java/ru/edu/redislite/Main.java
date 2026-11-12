package ru.edu.redislite;

import ru.edu.redislite.cli.Cli;
import ru.edu.redislite.core.KeyValueStore;

public class Main {
    public static void main(String[] args) throws Exception {
        KeyValueStore store = new KeyValueStore();
        new Cli(store).run();
    }
}
