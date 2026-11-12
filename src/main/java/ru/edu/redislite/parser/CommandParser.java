package ru.edu.redislite.parser;

import java.util.ArrayList;
import java.util.List;

public class CommandParser {
    public ParsedCommand parse(String line) {
        if (line == null || line.trim().isEmpty()) throw new IllegalArgumentException("empty command");
        String[] parts = line.trim().split("\\s+");
        List<String> args = new ArrayList<>();
        for (int i = 1; i < parts.length; i++) args.add(parts[i]);
        return new ParsedCommand(parts[0].toUpperCase(), args);
    }
}
