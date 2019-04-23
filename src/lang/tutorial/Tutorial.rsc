module lang::tutorial::Tutorial
import ParseTree;

start syntax TutorialUnit = Expression;

// layout is lists of whitespace characters
layout MyLayout = [\t\n\ \r\f]*;

// identifiers are characters of lowercase alphabet letters, 
// not immediately preceded or followed by those (longest match)
// and not any of the reserved keywords
lexical Identifier = [a-z] !<< [a-z]+ !>> [a-z] \ MyKeywords;

// this defines the reserved keywords used in the definition of Identifier
keyword MyKeywords = "Bob" | "if";

// here is a recursive definition of expressions 
// using priority and associativity groups.
syntax Expression 
  = Identifier id Verb verb Adjective adj | Identifier; 

syntax Verb
	= "is" | "was"; 
 
syntax Adjective
	= "cool" | "nice" | "bad";