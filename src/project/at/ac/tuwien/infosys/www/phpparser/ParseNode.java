/*
 * ParseNode.java
 * 
 * Copyright (C) 2005 Nenad Jovanovic
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License. See the file
 * COPYRIGHT for more information.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */


package at.ac.tuwien.infosys.www.phpparser;

import java.util.*;
import java.io.Serializable;

/**
 * An interior or leaf (token) node in the parse tree. Not all methods are meaningful
 * for both interior and token nodes, so they may throw an 
 * <code>UnsupportedOperationException</code> in such cases.
 * 
 * @author  Nenad Jovanovic
 * @version July 14, 2005
 */
public final class ParseNode
implements Serializable {

    /** symbol (token or rule) number */ 
    private final int symbol;
    
    /** name (useful for output) */
    private final String name;

    /** name of the parsed file */
    private final String fileName;
    
    /** child nodes */
    private List children;
    
    /** parent node; available for all nodes except the root of the parse tree */
    private ParseNode parent;

    /** lexeme and line number; available for tokens only (i.e. parse tree leaves) */
    private final String lexeme;
    private final int lineno;

    /** node ID and static helper field for ID generation */
    private final int id;
    private static int minFreeId = 0;
    
    /** is this node a token node? */
    private boolean isToken;

// CONSTRUCTORS ********************************************************************
 
    /** 
     * Constructs an interior node.
     * 
     * @param symbol    symbol number 
     * @param name      node name (useful for output)
     * @param fileName  name of the parsed file
     */
    public ParseNode(int symbol, String name, String fileName) {
        this.symbol = symbol;
        this.name = name;
        this.fileName = fileName;
        this.children = new ArrayList();
        this.parent = null;
        this.lexeme = null;
        this.lineno = -1;
        this.id = ParseNode.minFreeId++;
        this.isToken = false;
    }
 
    /** 
     * Constructs a leaf (token) node.
     * 
     * @param symbol    symbol number 
     * @param name      node name (useful for output)
     * @param fileName  name of the parsed file
     * @param lexeme    lexeme (the literal string in the parsed file) 
     * @param lineno    the lexeme's line number in the parsed file
     */
    public ParseNode(int symbol, String name, String fileName, String lexeme, int lineno) {
        this.symbol = symbol;
        this.name = name;
        this.fileName = fileName;
        this.children = Collections.EMPTY_LIST;
        this.parent = null;
        this.lexeme = lexeme;
        this.lineno = lineno;
        this.id = ParseNode.minFreeId++;
        this.isToken = true;
    } 


// GET *****************************************************************************

    /**
     * Returns this node's name.
     * 
     * @return  this node's name
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * Returns the name of the scanned file.
     * 
     * @return  the name of the scanned file
     */
    public String getFileName() {
        return this.fileName;
    }

    /**
     * Returns this node's symbol number.
     * 
     * @return  this node's symbol number
     */
    public int getSymbol() {        
        return this.symbol;
    } 

    /**
     * Returns this node's children.
     * 
     * @return  this node's children
     */
    public List getChildren() {
        return this.children;
    }

    /**
     * Returns the number of children.
     * 
     * @return  the number of children
     */
    public int getNumChildren() {
        return this.children.size();
    }

    /**
     * Returns the child node at the given index (for non-token nodes only).
     * 
     * @param index     the desired child node's index
     * @return          the child node at the given index
     * @throws UnsupportedOperationException    if this node is a token node
     */
    public ParseNode getChild(int index) {
        if (this.isToken) {
            throw new UnsupportedOperationException("Call to getChild for token node " + this.name);
        } else {
            return (ParseNode) this.children.get(index);
        }
    }

    /**
     * Returns this node's parent node.
     * 
     * @return  this node's parent node, <code>null</code> if this node
     *          is the root node 
     */
    public ParseNode getParent() {
        return this.parent;
    }

    /**
     * Returns this node's lexeme (for token nodes only).
     * 
     * @return  this node's lexeme
     * @throws UnsupportedOperationException    if this node is not a token node
     */
    public String getLexeme() {
        if (this.isToken) {
            return this.lexeme;
        } else {
            throw new UnsupportedOperationException();
        }
    }

    /**
     * Returns this node's line number (for token nodes only).
     * Note that epsilon nodes have line number -2.
     * 
     * @return  this node's line number
     * @throws UnsupportedOperationException    if this node is not a token node
     */
    public int getLineno() {
        if (this.isToken) {
            return this.lineno;
        } else {
            throw new UnsupportedOperationException();
        }
    }

    /**
     * Returns this node's line number if it is a token node,
     * and the line number of the leftmost token node reachable from
     * this node otherwise. Note that epsilon nodes have line number -2.
     * 
     * @return  a reasonable line number
     */
    public int getLinenoLeft() {
        if (this.isToken) {
            return this.lineno;
        } else {
            return this.getChild(0).getLinenoLeft();
        }
    }

    /**
     * Searches the first ancestor that has more than one child and
     * calls this ancestor's getLinenoLeft().
     * 
     * @return  a line number
     */
    /* DELME: doesn't work like that (infinite loop)
    private int getNextLinenoLeft() {
        ParseNode p = this.parent;
        while (parent != null) {
            if (p.getNumChildren() > 1) {
                ParseNode c = p.getChild(1);
                return c.getLinenoLeft();
            }
        }
        return -2;
    }
    */

    /**
     * Returns this node's ID.
     * 
     * @return  this node's ID
     */
    public int getId() {
        return this.id;
    }

    /** 
     * Returns true if this node is a token node.
     *
     * @return  <code>true</code> if this node is a token node, 
     *          <code>false</code> otherwise
     */
    public boolean isToken() {
        return this.isToken;
    }

// SET *****************************************************************************    

    /**
     * Sets this node's parent node.
     * 
     * @param parent  the parse node that shall become this node's parent
     */
    public void setParent(ParseNode parent) {
        this.parent = parent;
    }

// OTHER ***************************************************************************
    
    /**
     * Adds a node to this node's children and makes this node the 
     * given node's parent (for non-token nodes only).
     * 
     * @param child  the parse node that shall become this node's child
     * @throws UnsupportedOperationException    if this node is a token node
     */
    public ParseNode addChild(ParseNode child) {
        if (this.isToken) {
            throw new UnsupportedOperationException();
        } else {
            this.children.add(child);
            child.setParent(this);
            return child;
        }
    }
}


