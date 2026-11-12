package ru.edu.redislite.parser;

import java.util.ArrayList;
import java.util.List;

public class ParsedCommand {
    private final String name;
    private final List<String> args;
    public ParsedCommand(String name, List<String> args) { this.name = name; this.args = args; }
    public String getName() { return name; }
    public List<String> getArgs() { return args; }
}
