# PhpParser

PhpParser generates a pure Java parser for PHP programs. Invoking this parser
yields an explicit parse tree suitable for further analysis.

This package is based upon:

- [JFlex 1.4.1](http://www.jflex.de/)
- [Cup 0.10k](http://www2.cs.tum.edu/projects/cup/)
- Grammar and lexer specifications of PHP 4.3.10.

The modifications to JFlex and Cup have been documented in the files inside
the directory doc/modifications.


## Building

You can build PhpParser by installing Ant (ant.apache.org) and typing

    ant build

inside the directory of this README.

## Usage

All you need to do in order to use the generated PhpParser is to copy the directories: 

    build/class/at 

and

    build/class/java_cup

into your project and make their parent directory part of your class path.

Then add the following import statement to the Java file which shall invoke PhpParser:

    import at.ac.tuwien.infosys.www.phpparser.*;

Then create the parse tree for a file given by "fileName" in the following way:

    PhpLexer lexer = new PhpLexer(new FileReader(fileName));
    lexer.setFileName(fileName);
    PhpParser parser = new PhpParser(lexer);
    ParseNode rootNode = (ParseNode) parser.parse().value;

The last two statements must be enclosed by a matching try-catch clause. The 
directory doc/example contains a simple usage example that parses one or more
PHP files and prints the lexemes of the parse tree nodes. It can be compiled by 
changing into that directory and typing

    javac -classpath ../../build/class Example.java

Execute it by typing

    java -classpath ../../build/class:. Example test1.php test2.php


For more information, see the Javadoc inside doc/html. It is generated along
with building the project.


## Directory layout
- toplevel 
  - build.xml
  - README
  - build
    - class
      - generated java class files
    - java
      - generated java source files (PHP Lexer and Parser)
  - doc
    - various documentation files
  - src
    - java_cup
      - modified version of the Cup parser generator
    - jflex
      - modified version of the JFlex scanner generator
    - project
      - parse tree data structures
    - spec
      - specification (input) files for Cup and JFlex

## Licenses

* jFlex: GPL
* Cup: custom license, derived from "Standard ML of New Jersey", GPL-compatible
* CLI: Apache license
* rest: GPL

## Credits

Many thanks to Engin Kirda and Christopher Krügel for their invaluable advice
and support.

Thank you for using PhpParser.

Nenad Jovanovic <enji@infosys.tuwien.ac.at>
