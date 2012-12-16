/*
 * JFlex specification file for PHP / generated Lexer
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
import java_cup.runtime.*;


%%

/*

FROM FLEX -> JFLEX

- a state stack has to be implemented:
  yy_push_state(state) -> pushState(state)
  yy_pop_state(state) -> popState(state)
  yy_top_state() -> topState()
- regular definitions need "=" between name and value
- "^" inside character classes ("[...]") must be escaped
- " inside character classes must be escaped
- - inside character classes must be escaped if you mean the minus character,
  and not a character range
- INITIAL -> YYINITIAL
- BEGIN(state) -> yybegin(state)
- yyless(num) -> yypushback(num)
  yyless(0) -> yypushback(yylength())
- yymore() -> more()
- yytext() -> text() (custom wrapper around yytext() so that yymore() can be simulated)
- yylength() -> length()
- yycharat() -> charat()

*/


// - state stack 
// - PHP-specific: heredoc label

%{

    private LinkedList stateStack;

    private String heredocLabel;

    private String fileName;

    // same functionality as Flex's yy_push_state
    private void pushState(int state) {
        this.stateStack.add(new Integer(this.yystate()));
        yybegin(state);
    }

    // same functionality as Flex's yy_pop_state
    private void popState() {
        yybegin(((Integer) this.stateStack.removeLast()).intValue());
    }

    // same functionality as Flex's yy_top_state
    private int topState() {
        return ((Integer) this.stateStack.getLast()).intValue();
    }

    // shorthand for constructing Symbol objects
    private Symbol symbol(int type, String name) {
        // use the Symbol's "left value" as line number
        int line = yyline + 1;
        return new Symbol(
            type, 
            line, 
            -1, 
            new ParseNode(type, name, this.fileName, text(), line));
    }

    // always call this method after constructing the lexer object
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        if (this.fileName == null) {
            throw new RuntimeException("fileName not set in lexer object");
        }
        return this.fileName;
    }
%}



%init{

    this.stateStack = new LinkedList();

%init}


%x ST_IN_SCRIPTING
%x ST_DOUBLE_QUOTES
%x ST_SINGLE_QUOTE
%x ST_BACKQUOTE
%x ST_HEREDOC
%x ST_LOOKING_FOR_PROPERTY
%x ST_LOOKING_FOR_VARNAME
%x ST_COMMENT
%x ST_ONE_LINE_COMMENT

LNUM = [0-9]+
DNUM = ([0-9]*[\.][0-9]+)|([0-9]+[\.][0-9]*)
EXPONENT_DNUM = (({LNUM}|{DNUM})[eE][+\-]?{LNUM})
HNUM = "0x"[0-9a-fA-F]+
// a few special characters are not matched by LABEL in jflex although they
// are matched by flex (e.g. in very few language files of PHPNuke 7.5); encoding problem?
LABEL = [a-zA-Z_\x7f-\xbb\xbc-\xde\xdf-\xff][a-zA-Z0-9_\x7f-\xbb\xbc-\xde\xdf-\xff]*
WHITESPACE = [ \n\r\t]+
TABS_AND_SPACES = [ \t]*
// we don't need TOKENS and ENCAPSED_TOKENS any longer since we had to split up the
// rules for them (because of CUP, which doesn't support character tokens)
// TOKENS = [;:,.\[\]()|\^&+\-/*=%!~$<>?@]
// ENCAPSED_TOKENS = [\[\]{}$]
ESCAPED_AND_WHITESPACE = [\n\t\r #'.:;,()|\^&+\-/*=%!~<>?@]+
ANY_CHAR = (.|[\n])
NEWLINE = ("\r"|"\n"|"\r\n")

// using 8bit (mimicking flex) doesn't work properly, so use unicode
%unicode
%line
%ignorecase
%cupsym PhpSymbols
%cup
%class PhpLexer
%public

%%

<ST_IN_SCRIPTING>"exit" {
    //return new Yytoken("T_EXIT", text());
    return symbol(PhpSymbols.T_EXIT, "T_EXIT");
}

<ST_IN_SCRIPTING>"die" {
    //return new Yytoken("T_EXIT", text());
    return symbol(PhpSymbols.T_EXIT, "T_EXIT");
}

<ST_IN_SCRIPTING>"old_function" {
    //return new Yytoken("T_OLD_FUNCTION", text());
    return symbol(PhpSymbols.T_OLD_FUNCTION, "T_OLD_FUNCTION");
}

<ST_IN_SCRIPTING>"function"|"cfunction" {
    //return new Yytoken("T_FUNCTION", text());
    return symbol(PhpSymbols.T_FUNCTION, "T_FUNCTION");
}

<ST_IN_SCRIPTING>"const" {
    //return new Yytoken("T_CONST", text());
    return symbol(PhpSymbols.T_CONST, "T_CONST");
}

<ST_IN_SCRIPTING>"return" {
    //return new Yytoken("T_RETURN", text());
    return symbol(PhpSymbols.T_RETURN, "T_RETURN");
}

<ST_IN_SCRIPTING>"if" {
    //return new Yytoken("T_IF", text());
    return symbol(PhpSymbols.T_IF, "T_IF");
}

<ST_IN_SCRIPTING>"elseif" {
    //return new Yytoken("T_ELSEIF", text());
    return symbol(PhpSymbols.T_ELSEIF, "T_ELSEIF");
}

<ST_IN_SCRIPTING>"endif" {
    //return new Yytoken("T_ENDIF", text());
    return symbol(PhpSymbols.T_ENDIF, "T_ENDIF");
}

<ST_IN_SCRIPTING>"else" {
    //return new Yytoken("T_ELSE", text());
    return symbol(PhpSymbols.T_ELSE, "T_ELSE");
}

<ST_IN_SCRIPTING>"while" {
    //return new Yytoken("T_WHILE", text());
    return symbol(PhpSymbols.T_WHILE, "T_WHILE");
}

<ST_IN_SCRIPTING>"endwhile" {
    //return new Yytoken("T_ENDWHILE", text());
    return symbol(PhpSymbols.T_ENDWHILE, "T_ENDWHILE");
}

<ST_IN_SCRIPTING>"do" {
    //return new Yytoken("T_DO", text());
    return symbol(PhpSymbols.T_DO, "T_DO");
}

<ST_IN_SCRIPTING>"for" {
    //return new Yytoken("T_FOR", text());
    return symbol(PhpSymbols.T_FOR, "T_FOR");
}

<ST_IN_SCRIPTING>"endfor" {
    //return new Yytoken("T_ENDFOR", text());
    return symbol(PhpSymbols.T_ENDFOR, "T_ENDFOR");
}

<ST_IN_SCRIPTING>"foreach" {
    //return new Yytoken("T_FOREACH", text());
    return symbol(PhpSymbols.T_FOREACH, "T_FOREACH");
}

<ST_IN_SCRIPTING>"endforeach" {
    //return new Yytoken("T_ENDFOREACH", text());
    return symbol(PhpSymbols.T_ENDFOREACH, "T_ENDFOREACH");
}

<ST_IN_SCRIPTING>"declare" {
    //return new Yytoken("T_DECLARE", text());
    return symbol(PhpSymbols.T_DECLARE, "T_DECLARE");
}

<ST_IN_SCRIPTING>"enddeclare" {
    //return new Yytoken("T_ENDDECLARE", text());
    return symbol(PhpSymbols.T_ENDDECLARE, "T_ENDDECLARE");
}

<ST_IN_SCRIPTING>"as" {
    //return new Yytoken("T_AS", text());
    return symbol(PhpSymbols.T_AS, "T_AS");
}

<ST_IN_SCRIPTING>"switch" {
    //return new Yytoken("T_SWITCH", text());
    return symbol(PhpSymbols.T_SWITCH, "T_SWITCH");
}

<ST_IN_SCRIPTING>"endswitch" {
    //return new Yytoken("T_ENDSWITCH", text());
    return symbol(PhpSymbols.T_ENDSWITCH, "T_ENDSWITCH");
}

<ST_IN_SCRIPTING>"case" {
    //return new Yytoken("T_CASE", text());
    return symbol(PhpSymbols.T_CASE, "T_CASE");
}

<ST_IN_SCRIPTING>"default" {
    //return new Yytoken("T_DEFAULT", text());
    return symbol(PhpSymbols.T_DEFAULT, "T_DEFAULT");
}

<ST_IN_SCRIPTING>"break" {
    //return new Yytoken("T_BREAK", text());
    return symbol(PhpSymbols.T_BREAK, "T_BREAK");
}

<ST_IN_SCRIPTING>"continue" {
    //return new Yytoken("T_CONTINUE", text());
    return symbol(PhpSymbols.T_CONTINUE, "T_CONTINUE");
}

<ST_IN_SCRIPTING>"echo" {
    //return new Yytoken("T_ECHO", text());
    return symbol(PhpSymbols.T_ECHO, "T_ECHO");
}

<ST_IN_SCRIPTING>"print" {
    //return new Yytoken("T_PRINT", text());
    return symbol(PhpSymbols.T_PRINT, "T_PRINT");
}

<ST_IN_SCRIPTING>"class" {
    //return new Yytoken("T_CLASS", text());
    return symbol(PhpSymbols.T_CLASS, "T_CLASS");
}

<ST_IN_SCRIPTING>"extends" {
    //return new Yytoken("T_EXTENDS", text());
    return symbol(PhpSymbols.T_EXTENDS, "T_EXTENDS");
}

<ST_IN_SCRIPTING,ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"->" {
	pushState(ST_LOOKING_FOR_PROPERTY);
    //return new Yytoken("T_OBJECT_OPERATOR", text());
    return symbol(PhpSymbols.T_OBJECT_OPERATOR, "T_OBJECT_OPERATOR");
}

<ST_LOOKING_FOR_PROPERTY>{LABEL} {
	popState();
    //return new Yytoken("T_STRING", text());
    return symbol(PhpSymbols.T_STRING, "T_STRING");
}

<ST_LOOKING_FOR_PROPERTY>{ANY_CHAR} {
	yypushback(length());
	popState();
}

<ST_IN_SCRIPTING>"::" {
    //return new Yytoken("T_PAAMAYIM_NEKUDOTAYIM", text());
    return symbol(PhpSymbols.T_PAAMAYIM_NEKUDOTAYIM, "T_PAAMAYIM_NEKUDOTAYIM");
}

<ST_IN_SCRIPTING>"new" {
    //return new Yytoken("T_NEW", text());
    return symbol(PhpSymbols.T_NEW, "T_NEW");
}

<ST_IN_SCRIPTING>"var" {
    //return new Yytoken("T_VAR", text());
    return symbol(PhpSymbols.T_VAR, "T_VAR");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("int"|"integer"){TABS_AND_SPACES}")" {
    //return new Yytoken("T_INT_CAST", text());
    return symbol(PhpSymbols.T_INT_CAST, "T_INT_CAST");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("real"|"double"|"float"){TABS_AND_SPACES}")" {
    //return new Yytoken("T_DOUBLE_CAST", text());
    return symbol(PhpSymbols.T_DOUBLE_CAST, "T_DOUBLE_CAST");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}"string"{TABS_AND_SPACES}")" {
    //return new Yytoken("T_STRING_CAST", text());
    return symbol(PhpSymbols.T_STRING_CAST, "T_STRING_CAST");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}"array"{TABS_AND_SPACES}")" {
    //return new Yytoken("T_ARRAY_CAST", text());
    return symbol(PhpSymbols.T_ARRAY_CAST, "T_ARRAY_CAST");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}"object"{TABS_AND_SPACES}")" {
    //return new Yytoken("T_OBJECT_CAST", text());
    return symbol(PhpSymbols.T_OBJECT_CAST, "T_OBJECT_CAST");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("bool"|"boolean"){TABS_AND_SPACES}")" {
    //return new Yytoken("T_BOOL_CAST", text());
    return symbol(PhpSymbols.T_BOOL_CAST, "T_BOOL_CAST");
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("unset"){TABS_AND_SPACES}")" {
    //return new Yytoken("T_UNSET_CAST", text());
    return symbol(PhpSymbols.T_UNSET_CAST, "T_UNSET_CAST");
}

<ST_IN_SCRIPTING>"eval" {
    //return new Yytoken("T_EVAL", text());
    return symbol(PhpSymbols.T_EVAL, "T_EVAL");
}

<ST_IN_SCRIPTING>"include" {
    //return new Yytoken("T_INCLUDE", text());
    return symbol(PhpSymbols.T_INCLUDE, "T_INCLUDE");
}

<ST_IN_SCRIPTING>"include_once" {
    //return new Yytoken("T_INCLUDE_ONCE", text());
    return symbol(PhpSymbols.T_INCLUDE_ONCE, "T_INCLUDE_ONCE");
}

<ST_IN_SCRIPTING>"require" {
    //return new Yytoken("T_REQUIRE", text());
    return symbol(PhpSymbols.T_REQUIRE, "T_REQUIRE");
}

<ST_IN_SCRIPTING>"require_once" {
    //return new Yytoken("T_REQUIRE_ONCE", text());
    return symbol(PhpSymbols.T_REQUIRE_ONCE, "T_REQUIRE_ONCE");
}

<ST_IN_SCRIPTING>"use" {
    //return new Yytoken("T_USE", text());
    return symbol(PhpSymbols.T_USE, "T_USE");
}

<ST_IN_SCRIPTING>"global" {
    //return new Yytoken("T_GLOBAL", text());
    return symbol(PhpSymbols.T_GLOBAL, "T_GLOBAL");
}

<ST_IN_SCRIPTING>"isset" {
    //return new Yytoken("T_ISSET", text());
    return symbol(PhpSymbols.T_ISSET, "T_ISSET");
}

<ST_IN_SCRIPTING>"empty" {
    //return new Yytoken("T_EMPTY", text());
    return symbol(PhpSymbols.T_EMPTY, "T_EMPTY");
}

<ST_IN_SCRIPTING>"static" {
    //return new Yytoken("T_STATIC", text());
    return symbol(PhpSymbols.T_STATIC, "T_STATIC");
}

<ST_IN_SCRIPTING>"unset" {
    //return new Yytoken("T_UNSET", text());
    return symbol(PhpSymbols.T_UNSET, "T_UNSET");
}

<ST_IN_SCRIPTING>"=>" {
    //return new Yytoken("T_DOUBLE_ARROW", text());
    return symbol(PhpSymbols.T_DOUBLE_ARROW, "T_DOUBLE_ARROW");
}

<ST_IN_SCRIPTING>"list" {
    //return new Yytoken("T_LIST", text());
    return symbol(PhpSymbols.T_LIST, "T_LIST");
}

<ST_IN_SCRIPTING>"array" {
    //return new Yytoken("T_ARRAY", text());
    return symbol(PhpSymbols.T_ARRAY, "T_ARRAY");
}

<ST_IN_SCRIPTING>"++" {
    //return new Yytoken("T_INC", text());
    return symbol(PhpSymbols.T_INC, "T_INC");
}

<ST_IN_SCRIPTING>"--" {
    //return new Yytoken("T_DEC", text());
    return symbol(PhpSymbols.T_DEC, "T_DEC");
}

<ST_IN_SCRIPTING>"===" {
    //return new Yytoken("T_IS_IDENTICAL", text());
    return symbol(PhpSymbols.T_IS_IDENTICAL, "T_IS_IDENTICAL");
}

<ST_IN_SCRIPTING>"!==" {
    //return new Yytoken("T_IS_NOT_IDENTICAL", text());
    return symbol(PhpSymbols.T_IS_NOT_IDENTICAL, "T_IS_NOT_IDENTICAL");
}

<ST_IN_SCRIPTING>"==" {
    //return new Yytoken("T_IS_EQUAL", text());
    return symbol(PhpSymbols.T_IS_EQUAL, "T_IS_EQUAL");
}

<ST_IN_SCRIPTING>"!="|"<>" {
    //return new Yytoken("T_IS_NOT_EQUAL", text());
    return symbol(PhpSymbols.T_IS_NOT_EQUAL, "T_IS_NOT_EQUAL");
}

<ST_IN_SCRIPTING>"<=" {
    //return new Yytoken("T_IS_SMALLER_OR_EQUAL", text());
    return symbol(PhpSymbols.T_IS_SMALLER_OR_EQUAL, "T_IS_SMALLER_OR_EQUAL");
}

<ST_IN_SCRIPTING>">=" {
    //return new Yytoken("T_IS_GREATER_OR_EQUAL", text());
    return symbol(PhpSymbols.T_IS_GREATER_OR_EQUAL, "T_IS_GREATER_OR_EQUAL");
}

<ST_IN_SCRIPTING>"+=" {
    //return new Yytoken("T_PLUS_EQUAL", text());
    return symbol(PhpSymbols.T_PLUS_EQUAL, "T_PLUS_EQUAL");
}

<ST_IN_SCRIPTING>"-=" {
    //return new Yytoken("T_MINUS_EQUAL", text());
    return symbol(PhpSymbols.T_MINUS_EQUAL, "T_MINUS_EQUAL");
}

<ST_IN_SCRIPTING>"*=" {
    //return new Yytoken("T_MUL_EQUAL", text());
    return symbol(PhpSymbols.T_MUL_EQUAL, "T_MUL_EQUAL");
}

<ST_IN_SCRIPTING>"/=" {
    //return new Yytoken("T_DIV_EQUAL", text());
    return symbol(PhpSymbols.T_DIV_EQUAL, "T_DIV_EQUAL");
}

<ST_IN_SCRIPTING>".=" {
    //return new Yytoken("T_CONCAT_EQUAL", text());
    return symbol(PhpSymbols.T_CONCAT_EQUAL, "T_CONCAT_EQUAL");
}

<ST_IN_SCRIPTING>"%=" {
    //return new Yytoken("T_MOD_EQUAL", text());
    return symbol(PhpSymbols.T_MOD_EQUAL, "T_MOD_EQUAL");
}

<ST_IN_SCRIPTING>"<<=" {
    //return new Yytoken("T_SL_EQUAL", text());
    return symbol(PhpSymbols.T_SL_EQUAL, "T_SL_EQUAL");
}

<ST_IN_SCRIPTING>">>=" {
    //return new Yytoken("T_SR_EQUAL", text());
    return symbol(PhpSymbols.T_SR_EQUAL, "T_SR_EQUAL");
}

<ST_IN_SCRIPTING>"&=" {
    //return new Yytoken("T_AND_EQUAL", text());
    return symbol(PhpSymbols.T_AND_EQUAL, "T_AND_EQUAL");
}

<ST_IN_SCRIPTING>"|=" {
    //return new Yytoken("T_OR_EQUAL", text());
    return symbol(PhpSymbols.T_OR_EQUAL, "T_OR_EQUAL");
}

<ST_IN_SCRIPTING>"^=" {
    //return new Yytoken("T_XOR_EQUAL", text());
    return symbol(PhpSymbols.T_XOR_EQUAL, "T_XOR_EQUAL");
}

<ST_IN_SCRIPTING>"||" {
    //return new Yytoken("T_BOOLEAN_OR", text());
    return symbol(PhpSymbols.T_BOOLEAN_OR, "T_BOOLEAN_OR");
}

<ST_IN_SCRIPTING>"&&" {
    //return new Yytoken("T_BOOLEAN_AND", text());
    return symbol(PhpSymbols.T_BOOLEAN_AND, "T_BOOLEAN_AND");
}

<ST_IN_SCRIPTING>"OR" {
    //return new Yytoken("T_LOGICAL_OR", text());
    return symbol(PhpSymbols.T_LOGICAL_OR, "T_LOGICAL_OR");
}

<ST_IN_SCRIPTING>"AND" {
    //return new Yytoken("T_LOGICAL_AND", text());
    return symbol(PhpSymbols.T_LOGICAL_AND, "T_LOGICAL_AND");
}

<ST_IN_SCRIPTING>"XOR" {
    //return new Yytoken("T_LOGICAL_XOR", text());
    return symbol(PhpSymbols.T_LOGICAL_XOR, "T_LOGICAL_XOR");
}

<ST_IN_SCRIPTING>"<<" {
    //return new Yytoken("T_SL", text());
    return symbol(PhpSymbols.T_SL, "T_SL");
}

<ST_IN_SCRIPTING>">>" {
    //return new Yytoken("T_SR", text());
    return symbol(PhpSymbols.T_SR, "T_SR");
}

// NJ: split up rule for {TOKENS} since CUP doesn't support character tokens
<ST_IN_SCRIPTING> {

    ";" { return symbol(PhpSymbols.T_SEMICOLON, "T_SEMICOLON"); }
    ":" { return symbol(PhpSymbols.T_COLON, "T_COLON"); }
    "," { return symbol(PhpSymbols.T_COMMA, "T_COMMA"); }
    "." { return symbol(PhpSymbols.T_POINT, "T_POINT"); }
    "[" { return symbol(PhpSymbols.T_OPEN_RECT_BRACES, "T_OPEN_RECT_BRACES"); }
    "]" { return symbol(PhpSymbols.T_CLOSE_RECT_BRACES, "T_CLOSE_RECT_BRACES"); }
    "(" { return symbol(PhpSymbols.T_OPEN_BRACES, "T_OPEN_BRACES"); }
    ")" { return symbol(PhpSymbols.T_CLOSE_BRACES, "T_CLOSE_BRACES"); }
    "|" { return symbol(PhpSymbols.T_BITWISE_OR, "T_BITWISE_OR"); }
    "^" { return symbol(PhpSymbols.T_BITWISE_XOR, "T_BITWISE_XOR"); }
    "&" { return symbol(PhpSymbols.T_BITWISE_AND, "T_BITWISE_AND"); }
    "+" { return symbol(PhpSymbols.T_PLUS, "T_PLUS"); }
    "-" { return symbol(PhpSymbols.T_MINUS, "T_MINUS"); }
    "/" { return symbol(PhpSymbols.T_DIV, "T_DIV"); }
    "*" { return symbol(PhpSymbols.T_MULT, "T_MULT"); }
    "=" { return symbol(PhpSymbols.T_ASSIGN, "T_ASSIGN"); }
    "%" { return symbol(PhpSymbols.T_MODULO, "T_MODULO"); }
    "!" { return symbol(PhpSymbols.T_NOT, "T_NOT"); }
    "~" { return symbol(PhpSymbols.T_BITWISE_NOT, "T_BITWISE_NOT"); }
    "$" { return symbol(PhpSymbols.T_DOLLAR, "T_DOLLAR"); }
    "<" { return symbol(PhpSymbols.T_IS_SMALLER, "T_IS_SMALLER"); }
    ">" { return symbol(PhpSymbols.T_IS_GREATER, "T_IS_GREATER"); }
    "?" { return symbol(PhpSymbols.T_QUESTION, "T_QUESTION"); }
    "@" { return symbol(PhpSymbols.T_AT, "T_AT"); }

}

<ST_IN_SCRIPTING>"{" {
	pushState(ST_IN_SCRIPTING);
    //return new Yytoken("{", text());
    return symbol(PhpSymbols.T_OPEN_CURLY_BRACES, "T_OPEN_CURLY_BRACES");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"${" {
	pushState(ST_LOOKING_FOR_VARNAME);
    //return new Yytoken("T_DOLLAR_OPEN_CURLY_BRACES", text());
    return symbol(PhpSymbols.T_DOLLAR_OPEN_CURLY_BRACES, "T_DOLLAR_OPEN_CURLY_BRACES");
}

<ST_IN_SCRIPTING>"}" {
    // TODO: could make problems
	// if (yy_start_stack_ptr) {
	//	yy_pop_state();
	// }
    
//    System.out.println("POPPING STATE!!!");
    popState();
    //return new Yytoken("}", text());
    return symbol(PhpSymbols.T_CLOSE_CURLY_BRACES, "T_CLOSE_CURLY_BRACES");
}

<ST_LOOKING_FOR_VARNAME>{LABEL} {
	popState();
	pushState(ST_IN_SCRIPTING);
    //return new Yytoken("T_STRING_VARNAME", text());
    return symbol(PhpSymbols.T_STRING_VARNAME, "T_STRING_VARNAME");
}

<ST_LOOKING_FOR_VARNAME>{ANY_CHAR} {
	yypushback(length());
	popState();
	pushState(ST_IN_SCRIPTING);
}

<ST_IN_SCRIPTING>{LNUM} {
    //return new Yytoken("T_LNUMBER", text());
    return symbol(PhpSymbols.T_LNUMBER, "T_LNUMBER");
}

<ST_IN_SCRIPTING>{HNUM} {
    //return new Yytoken("T_LNUMBER", text());
    return symbol(PhpSymbols.T_LNUMBER, "T_LNUMBER");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>{LNUM}|{HNUM} {
    //return new Yytoken("T_NUM_STRING", text());
    return symbol(PhpSymbols.T_NUM_STRING, "T_NUM_STRING");
}

<ST_IN_SCRIPTING>{DNUM}|{EXPONENT_DNUM} {
    //return new Yytoken("T_DNUMBER", text());
    return symbol(PhpSymbols.T_DNUMBER, "T_DNUMBER");
}

<ST_IN_SCRIPTING>"__CLASS__" {
    //return new Yytoken("T_CLASS_C", text());
    return symbol(PhpSymbols.T_CLASS_C, "T_CLASS_C");
}

<ST_IN_SCRIPTING>"__FUNCTION__" {
    //return new Yytoken("T_FUNC_C", text());
    return symbol(PhpSymbols.T_FUNC_C, "T_FUNC_C");
}

<ST_IN_SCRIPTING>"__LINE__" {
    //return new Yytoken("T_LINE", text());
    return symbol(PhpSymbols.T_LINE, "T_LINE");
}

<ST_IN_SCRIPTING>"__FILE__" {
    //return new Yytoken("T_FILE", text());
    return symbol(PhpSymbols.T_FILE, "T_FILE");
}

// <YYINITIAL>(([^<]|"<"[^?%s<]){1,400})|"<s"|"<" {
<YYINITIAL>(([^<]|"<"[^?%s<])*)|"<s"|"<" {
    // NJ: replaced {1,400} by * (because it's faster)
    //return new Yytoken("T_INLINE_HTML", text());
    return symbol(PhpSymbols.T_INLINE_HTML, "T_INLINE_HTML");
}

<YYINITIAL>"<?"|"<script"{WHITESPACE}+"language"{WHITESPACE}*"="{WHITESPACE}*("php"|"\"php\""|"\'php\'"){WHITESPACE}*">" {
    yybegin(ST_IN_SCRIPTING);
}

<YYINITIAL>"<%="|"<?=" {
    yybegin(ST_IN_SCRIPTING);
    //return new Yytoken("T_ECHO", text());
    return symbol(PhpSymbols.T_ECHO, "T_ECHO");
}

<YYINITIAL>"<%" {
    yybegin(ST_IN_SCRIPTING);
}

<YYINITIAL>"<?php"([ \t]|{NEWLINE}) {
	yybegin(ST_IN_SCRIPTING);
}

<YYINITIAL>"<?php_track_vars?>"{NEWLINE}? {
    //return new Yytoken("T_INLINE_HTML", text());
    return symbol(PhpSymbols.T_INLINE_HTML, "T_INLINE_HTML");
}

<ST_IN_SCRIPTING,ST_DOUBLE_QUOTES,ST_HEREDOC,ST_BACKQUOTE>"$"{LABEL} {
    //return new Yytoken("T_VARIABLE", text());
    return symbol(PhpSymbols.T_VARIABLE, "T_VARIABLE");
}


<ST_IN_SCRIPTING>{LABEL} {
    //return new Yytoken("T_STRING", text());
    return symbol(PhpSymbols.T_STRING, "T_STRING");
}


<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>{LABEL} {
    //return new Yytoken("T_STRING", text());
    return symbol(PhpSymbols.T_STRING, "T_STRING");
}

<ST_IN_SCRIPTING>{WHITESPACE} {
    // don't return this token, since the parser has no rule for it;
    // in the orignal PHP sources, this filtering is not performed inside
    // the lexer, but by a function that is located between the parser and
    // the lexer (this function has the name zendlex())
	// return T_WHITESPACE;
}

<ST_IN_SCRIPTING>"#"|"//" {
	yybegin(ST_ONE_LINE_COMMENT);
	more();
}

<ST_ONE_LINE_COMMENT>"?"|"%"|">" {
	more();
}

<ST_ONE_LINE_COMMENT>[^\n\r?%>]+ {
	more();
}

<ST_ONE_LINE_COMMENT>{NEWLINE} {
	yybegin(ST_IN_SCRIPTING);
}

<ST_ONE_LINE_COMMENT>"?>"|"%>" {
    // yypushback(length() - 2);
    yypushback(2);
    yybegin(ST_IN_SCRIPTING);
}

<ST_IN_SCRIPTING>"/*" {
	yybegin(ST_COMMENT);
	more();
}

<ST_COMMENT>[^*]+ {
	more();
}

<ST_COMMENT>"*/" {
	yybegin(ST_IN_SCRIPTING);
}

<ST_COMMENT>"*" {
	more();
}

<ST_IN_SCRIPTING>("?>"|"</script"{WHITESPACE}*">"){NEWLINE}? {
	yybegin(YYINITIAL);
    //return new Yytoken(";", text());
    return symbol(PhpSymbols.T_SEMICOLON, "T_SEMICOLON");
}


<ST_IN_SCRIPTING>"%>"{NEWLINE}? {
    yybegin(YYINITIAL);
    //return new Yytoken(";", text());
    return symbol(PhpSymbols.T_SEMICOLON, "T_SEMICOLON");
}

<ST_IN_SCRIPTING>([\"]([^$\"\\]|("\\".))*[\"]) {
    //return new Yytoken("T_CONSTANT_ENCAPSED_STRING", text());
    return symbol(PhpSymbols.T_CONSTANT_ENCAPSED_STRING, "T_CONSTANT_ENCAPSED_STRING");
}

<ST_IN_SCRIPTING>([']([^'\\]|("\\".))*[']) {
    //return new Yytoken("T_CONSTANT_ENCAPSED_STRING", text());
    return symbol(PhpSymbols.T_CONSTANT_ENCAPSED_STRING, "T_CONSTANT_ENCAPSED_STRING");
}

<ST_IN_SCRIPTING>[\"] {
	yybegin(ST_DOUBLE_QUOTES);
    //return new Yytoken("\"", text());
    return symbol(PhpSymbols.T_DOUBLE_QUOTE, "T_DOUBLE_QUOTE");
}

<ST_IN_SCRIPTING>"<<<"{TABS_AND_SPACES}{LABEL}{NEWLINE} {
    // start of heredoc

    // determine heredoc label and save it for later use
    this.heredocLabel = text().substring(3).trim();

    yybegin(ST_HEREDOC);
    //return new Yytoken("T_START_HEREDOC", text());
    return symbol(PhpSymbols.T_START_HEREDOC, "T_START_HEREDOC");
}

<ST_IN_SCRIPTING>[`] {
	yybegin(ST_BACKQUOTE);
    //return new Yytoken("`", text());
    return symbol(PhpSymbols.T_BACKTICK, "T_BACKTICK");
}


<ST_IN_SCRIPTING>['] {
	yybegin(ST_SINGLE_QUOTE);
    //return new Yytoken("'", text());
    return symbol(PhpSymbols.T_SINGLE_QUOTE, "T_SINGLE_QUOTE");
}

<ST_HEREDOC>^{LABEL}(";")?{NEWLINE} {
    // possible end of heredoc (depending on label)

    // determine supposed end label (and if there is a semicolon or not)
    String supposedLabel = text().trim();
    boolean semicolon = false;
    if (supposedLabel.charAt(supposedLabel.length() - 1) == ';') {
        semicolon = true;
        supposedLabel = supposedLabel.substring(0, supposedLabel.length() - 1);
    }

    if (supposedLabel.equals(this.heredocLabel)) {
        // the end label matches the start label

        if (semicolon) {
            yypushback(length() - supposedLabel.length());
        }
       
		yybegin(ST_IN_SCRIPTING);
    //return new Yytoken("T_END_HEREDOC", text());
    return symbol(PhpSymbols.T_END_HEREDOC, "T_END_HEREDOC");

    } else {
        // the end label doesn't match the start label
    //return new Yytoken("T_STRING", text());
    return symbol(PhpSymbols.T_STRING, "T_STRING");
    }

}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>{ESCAPED_AND_WHITESPACE} {
    //return new Yytoken("T_ENCAPSED_AND_WHITESPACE", text());
    return symbol(PhpSymbols.T_ENCAPSED_AND_WHITESPACE, "T_ENCAPSED_AND_WHITESPACE");
}

<ST_SINGLE_QUOTE>([^'\\]|\\[^'\\])+ {
    //return new Yytoken("T_ENCAPSED_AND_WHITESPACE", text());
    return symbol(PhpSymbols.T_ENCAPSED_AND_WHITESPACE, "T_ENCAPSED_AND_WHITESPACE");
}


<ST_DOUBLE_QUOTES>[`]+ {
    //return new Yytoken("T_ENCAPSED_AND_WHITESPACE", text());
    return symbol(PhpSymbols.T_ENCAPSED_AND_WHITESPACE, "T_ENCAPSED_AND_WHITESPACE");
}


<ST_BACKQUOTE>[\"]+ {
    //return new Yytoken("T_ENCAPSED_AND_WHITESPACE", text());
    return symbol(PhpSymbols.T_ENCAPSED_AND_WHITESPACE, "T_ENCAPSED_AND_WHITESPACE");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"$"[^a-zA-Z_\x7f-\xbb\xbc-\xde\xdf-\xff{] {
	if (length() == 2) {
		yypushback(1);
	}
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

// NJ: split up rule for {ENCAPSED_TOKENS} since CUP doesn't support character tokens
<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC> {

    "[" { return symbol(PhpSymbols.T_OPEN_RECT_BRACES, "T_OPEN_RECT_BRACES"); }
    "]" { return symbol(PhpSymbols.T_CLOSE_RECT_BRACES, "T_CLOSE_RECT_BRACES"); }
    "{" { return symbol(PhpSymbols.T_OPEN_CURLY_BRACES, "T_OPEN_CURLY_BRACES"); }
    "}" { return symbol(PhpSymbols.T_CLOSE_CURLY_BRACES, "T_CLOSE_CURLY_BRACES"); }
    "$" { return symbol(PhpSymbols.T_DOLLAR, "T_DOLLAR"); }

}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"{$" {
	pushState(ST_IN_SCRIPTING);
	yypushback(1);
    //return new Yytoken("T_CURLY_OPEN", text());
    return symbol(PhpSymbols.T_CURLY_OPEN, "T_CURLY_OPEN");
}

<ST_SINGLE_QUOTE>"\\'" {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_SINGLE_QUOTE>"\\\\" {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_DOUBLE_QUOTES>"\\\"" {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_BACKQUOTE>"\\`" {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"\\"[0-7]{1,3} {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"\\x"[0-9A-Fa-f]{1,2} {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"\\"{ANY_CHAR} {
    //return new Yytoken("T_CHARACTER", text());
    return symbol(PhpSymbols.T_CHARACTER, "T_CHARACTER");
}

<ST_HEREDOC>[\"'`]+ {
    //return new Yytoken("T_ENCAPSED_AND_WHITESPACE", text());
    return symbol(PhpSymbols.T_ENCAPSED_AND_WHITESPACE, "T_ENCAPSED_AND_WHITESPACE");
}

<ST_DOUBLE_QUOTES>[\"] {
    yybegin(ST_IN_SCRIPTING);
    //return new Yytoken("\"", text());
    return symbol(PhpSymbols.T_DOUBLE_QUOTE, "T_DOUBLE_QUOTE");
}

<ST_BACKQUOTE>[`] {
    yybegin(ST_IN_SCRIPTING);
    //return new Yytoken("`", text());
    return symbol(PhpSymbols.T_BACKTICK, "T_BACKTICK");
}

<ST_SINGLE_QUOTE>['] {
    yybegin(ST_IN_SCRIPTING);
    //return new Yytoken("'", text());
    return symbol(PhpSymbols.T_SINGLE_QUOTE, "T_SINGLE_QUOTE");
}

<ST_DOUBLE_QUOTES,ST_BACKQUOTE,YYINITIAL,ST_IN_SCRIPTING,ST_LOOKING_FOR_PROPERTY><<EOF>> {
    return null;
}

<ST_COMMENT><<EOF>> {
    System.err.println("EOF inside comment!");
    return null;
}

<ST_IN_SCRIPTING,YYINITIAL,ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_SINGLE_QUOTE,ST_HEREDOC>{ANY_CHAR} {
    System.err.println("read ANY_CHAR at wrong place:");
    System.err.println("line " + yyline + ", column " + yycolumn);
    System.err.println("character: " + text());
    return null;
}


