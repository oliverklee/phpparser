/*
 * ParseTree.java
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
 * Tree constructed by the parser.
 * 
 * @author  Nenad Jovanovic
 * @version July 14, 2005
 */
public final class ParseTree
implements Serializable {

    /** root node of the parse tree */
    private final ParseNode root;

// CONSTRUCTORS ********************************************************************

    /**
     * Constructs a parse tree for the given root node.
     * 
     * @param root  the root node for the parse tree
     */
    public ParseTree(ParseNode root) {
        this.root = root;
    } 

// GET *****************************************************************************
    
    /**
     * Returns this parse tree's root node.
     * 
     * @return  this parse tree's root node
     */
    public ParseNode getRoot() {
        return this.root;
    } 
    
// OTHER ***************************************************************************
    
    /**
     * Returns an <code>Iterator</code> over the leaf parse nodes of this parse tree
     * 
     * @return      an <code>Iterator</code> over the leaf parse nodes
     */
    public Iterator leafIterator() {
        LinkedList list = new LinkedList();
        this.leafIteratorHelper(list, this.root);
        return list.iterator();
    }


    /**
     * Helper method for <code>leafIterator</code>.
     * 
     * @param list  the list to which to add leaf nodes
     * @param node  root node of the tree for which the leaf nodes shall be
     *              added to the given list
     */
    private void leafIteratorHelper(List list, ParseNode node) {
        // if we've reached a leaf
        if (node.isToken()) {
            list.add(node);
            return;
        }
        // handle successors
        for (Iterator iter = node.getChildren().iterator(); iter.hasNext(); ) {
            ParseNode child = (ParseNode) iter.next();
            leafIteratorHelper(list, child);
        }
    }
}

