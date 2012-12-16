import at.ac.tuwien.infosys.www.phpparser.*;
import java.io.*;
import java.util.*;

class Example {

    public static void main(String[] args) {

        if (args.length == 0) {
            System.out.println("Please specify one or more PHP files to be parsed.");
            System.exit(1);
        }

        for (int i = 0; i < args.length; i++) {

            String fileName = args[i];
            
            ParseTree parseTree = null;
            try {
                PhpParser parser = new PhpParser(new PhpLexer(new FileReader(fileName)));
                ParseNode rootNode = (ParseNode) parser.parse().value;
                parseTree = new ParseTree(rootNode);
            } catch (FileNotFoundException e) {
                System.err.println("File not found: " + fileName);
                System.exit(1);
            } catch (Exception e) {
                System.err.println("Error parsing " + fileName);
                System.err.println(e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }

            System.out.println("*** Printing tokens for file " + fileName + "...");
            for (Iterator iter = parseTree.leafIterator(); iter.hasNext(); ) {
                ParseNode leaf = (ParseNode) iter.next();
                System.out.println(leaf.getLexeme());
            }
        }
    }

}
