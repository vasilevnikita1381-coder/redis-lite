package ru.edu.redislite.factory;

import ru.edu.redislite.command.*;
import ru.edu.redislite.parser.ParsedCommand;
import java.util.List;

public class CommandFactory {
    public Command create(ParsedCommand pc) {
        List<String> a = pc.getArgs();
        switch (pc.getName()) {
            case "SET": requireArgs(a, 2, "SET"); return new SetCommand(a.get(0), a.get(1));
            case "GET": requireArgs(a, 1, "GET"); return new GetCommand(a.get(0));
            case "DEL": requireArgs(a, 1, "DEL"); return new DelCommand(a.get(0));
            case "EXISTS": requireArgs(a, 1, "EXISTS"); return new ExistsCommand(a.get(0));
            case "KEYS": return new KeysCommand();
            default: throw new IllegalArgumentException("unknown command: " + pc.getName());
        }
    }
    private void requireArgs(List<String> a, int n, String name) {
        if (a.size() != n) throw new IllegalArgumentException(name + " expects " + n + " args");
    }
}
