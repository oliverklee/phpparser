# PhpParser

PhpParser generates a pure Java parser for PHP programs. Invoking this parser
yields an explicit parse tree suitable for further analysis.

This package is based upon:

- [JFlex 1.4.1](http://www.jflex.de/)
- [Cup 0.10k](http://www2.cs.tum.edu/projects/cup/)
- Grammar and lexer specifications of PHP 4.3.10.

The modifications to JFlex and Cup have been documented in the files inside
the directory doc/modifications.


## Building and cleaning the project with Ant from within Eclipse

1. Project > Properties > Builders
2. Deactivate the Java Builder.
3. New ...
4. Select "Ant builder"
3. Name it "Ant build" or "PhpParser build" (or any other suitable name).
5. In the Main tab, select the build.xml in the project directory as Buildfile and the project directory as Base directory.
6. In the Targets tab for "Manual build", select "build".
7. In the Targets tab for "During a clean", select "clean all".
8. OK the changes for both dialogs.

You then can build the project using Project > Build Project and Clean the project using Project > Clean ...

Or you can build the project using the command line from within the project main directory:

    ant build


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


## PhpParser and Pixy

PhpParser was developed as a sub-project of the PHP security vulnerability scanner Pixy, which resides [on Github](https://github.com/oliverklee/pixy "Pixy on Github").


## Licenses

* PhpParser: GPL V3
* jFlex: GPL V2
* Cup: custom license, derived from "Standard ML of New Jersey", GPL-compatible
* rest: GPL V2

## Credits

The original author of PhpParser was Nenad Jovanovic, enji@infosys.tuwien.ac.at. The current maintainer is Oliver Klee, pixy@oliverklee.de.

Many thanks to Engin Kirda and Christopher Krügel for their invaluable advice
and support.

Thank you for using PhpParser.
