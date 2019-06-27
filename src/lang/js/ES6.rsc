module lang::js::ES6

start syntax CompilationUnit = Statement+;

syntax ImportDeclaration
	= "import" ImportClause FromClause EOS
	| "import" ModuleSpecifier EOS;
	
syntax ImportClause
  = Id
  | String
  | NameSpaceImport
  | NamedImports
  | Id "," NameSpaceImport
  | Id "," NamedImports
  ;

syntax NameSpaceImport
  = "*" "as" Id
  ;

syntax NamedImports
  = "{" "}"
  | "{" ImportsList "}"
  | "{" ImportsList "," "}"
  ;

syntax ImportsList
  = [\n]* ImportSpecifier [\n]*  
  | ImportsList "," [\n]* ImportSpecifier [\n]*  
  ;

syntax ImportSpecifier
  = Id
  | Id "as" Id
  ;

syntax ModuleSpecifier
  = String
  ;

syntax FromClause
  = "from" ModuleSpecifier
  ;

syntax ExportDeclaration
   = "export" "*" FromClause EOS
   | "export" "default"? ExportClause FromClause EOS
   | "export" "default"? ExportClause EOS
   | "export" "default"? VarStatement
   | "export" "default"? FunctionDeclarationStatement
   | "export" "default"? ClassDeclarationStatement
   | "export" "default"? Id EOS;
   //| "export" "default" HoistableDeclaration[Default];
   // | "export" "default" Id EOS;
   // | "export" "default" [lookahead ∉ { function, class }] AssignmentExpression[In] ;

syntax ExportClause
  = "{" "}"
  | "{" [\n]? ExportsList [\n]? "}"
  | "{" ExportsList "," "}"
  ;

syntax ExportsList
  = [\n]* ExportSpecifier [\n]*
  | ExportsList "," [\n]* ExportSpecifier [\n]*
  ;

syntax ExportSpecifier
  = Id 
  | Id "as" Id
  ;


syntax Statement 
  = importDecl: ImportDeclaration importDecl 
  | exportDecl: ExportDeclaration exportDecl
  | block: Block block
  | VarStatement  
  | empty: EmptyStatement empty
  | ExpressionStatement
  | IfStatement
  | IterationStatement
  | ContinueStatement
  | BreakStatement
  | ReturnStatement
  | WithStatement
  | LabelledStatement
  | SwitchStatement
  | ThrowStatement
  | TryStatement
  | DebuggerStatement
  | FunctionDeclarationStatement
  | ClassDeclarationStatement
  
  ;

syntax Block = "{" Statement+ "}" EOS ;
syntax BlockWithoutEOS = "{" Statement+ "}";
 

syntax VarStatement = VarModifier {VarDec ","}+ EOS ;

syntax EmptyStatement = ";" | [\n] ;

syntax ExpressionStatement = Expression!function  EOS;


syntax IfStatement = "if" "(" Expression ")" [\n]* Statement!empty ("else" [\n]* Statement!empty)?;

//TODO: missing several "for statement" options
syntax IterationStatement = "do" [\n]* Statement!empty "while" "(" Expression ")" EOS
                          | "while" "(" Expression ")" [\n]* Statement!empty     
                          | "for" "(" Expression? ";" Expression? ";" Expression? ")" [\n]* Statement!empty
                          | "for" "(" VarModifier {VarDec ","}+ ";" Expression? ";" Expression? ")" [\n]* Statement!empty
                          | "for" "(" VarModifier VarDec ("in" | "of") Expression  ")" [\n]*Statement!empty
                          ; 

syntax ContinueStatement = "continue" !>> [\n\r] Id EOS
                         | "continue" EOS 
                         ; 
                       
syntax BreakStatement = "break" !>> [\n\r] Id EOS
                      | "break" EOS 
                      ;     
                                            
syntax ReturnStatement = "return" !>> [\n\r] Expression EOS 
                       | "return" EOS ; 
                       
syntax WithStatement = "with" "(" Expression ")" Statement ;   

syntax LabelledStatement = Id ":" Statement ;     

syntax SwitchStatement = "switch" "(" Expression ")" CaseBlock ; 

syntax CaseBlock = "{" [\n]* CaseClause+ "}" ;   

syntax CaseClause = "case" Expression ":" Statement*  
                  | "default" ":" Statement* ;    
                  
syntax ThrowStatement = "throw" !>> [\n\r] Expression EOS ; 

syntax TryStatement = "try" BlockWithoutEOS CatchClause FinallyClause?
                    | "try" BlockWithoutEOS FinallyClause? 
                    ;
                    
syntax CatchClause = "catch" "(" Id ")" BlockWithoutEOS ; 

syntax FinallyClause = "finally" BlockWithoutEOS ; 

syntax DebuggerStatement = "debugger" EOS ; 

/* 
 * function declaration statement
 */ 
syntax FunctionDeclarationStatement = "function" Id FormalArgs FunctionBody ;  

syntax FormalArgs = "(" FormalArgList ")" ; 

syntax FormalArgList = {FormalArg ","}* ("," LastFormalArg) ? 
                     | ArrayLiteral 
                     | ObjectLiteral ; 

syntax FormalArg = Id ("=" Expression)? ;

syntax LastFormalArg = "..." Id ;   

syntax FunctionBody = [\n]* "{" Statement* "}" ; 

/* 
 * class declaration statement
 */ 

syntax ClassDeclarationStatement = "class" Id ClassTail ; 

syntax ClassTail = ("extends" Expression)? ClassBody ; 

syntax ClassBody = [\n]* "{" ClassElement* "}"  ;

syntax ClassElement = "static"? MethodDefinition 
                    | EOS ;
                    
syntax MethodDefinition = PropertyName FormalArgs FunctionBody 
						| "get" PropertyName FormalArgs FunctionBody 
						| "set" PropertyName FormalArgs FunctionBody 
						;

syntax PropertyName = Id
					| String
					| Numeric 
					| "[" [\n]* Expression [\n]* "]" ;
					
syntax IdName = Reserved 
			  | Id 
			  ; 					
											
                              
syntax VarDec = (Id | ArrayLiteral | ObjectLiteral)  ("=" [\n]? Expression)?;

/*
 * Array Literal 
 */ 
syntax ArrayLiteral = "[" [\n]*  ElementList? [\n]* "]"  ; 

syntax ElementList = Expression
                   | Expression "," [\n]? ElementList!last 
                   | last: Expression "," [\n]? LastElementList  
                   | LastElementList 
                   | empty: "," [\n]? ElementList? ; 
                   
syntax LastElementList = "..." Id ;                    

/*
 * Object Literal 
 */ 
 
 syntax ObjectMerging = "{" [\n]* ObjectMergingList [\n]* "}";
 
 syntax ObjectMergingList =   "..." ObjectMergeOptions 
 							| "..." ObjectMergeOptions "," OPTIONALNEWLINE ObjectMergingList;
 
 syntax ObjectMergeOptions = Expression
 ;
 
 syntax ObjectLiteral = "{" [\n]* PropertyAssignmentList? [\n]*"}" ;
 
 syntax PropertyAssignmentList = PropertyAssignment ","?  
                               | PropertyAssignment "," [\n]* PropertyAssignmentList
                               ;
 
 syntax PropertyAssignment = PropertyName (":" | "=") Expression 
 						   | "[" Expression "]" ":" Expression
 						   | "..."? Id
						   | MethodDefinition
						   ;
						   

/* 
 * Expression
 */ 
syntax Expression = "this"
				  | "super"
				  | Id  
                  | Literal
                  | ArrayLiteral
                  //| ObjectMerging
                  | ObjectLiteral
                  > arrowExpression: ArrowParameters "=\>" [\n]*  Expression 
                  > arrowParameter: ArrowParameters "=\>" [\n]* BlockWithoutEOS
                  | "(" ExpressionSequence ")"   
				  | function: "function" Id? FormalArgs FunctionBody  
//				  | "class" Id? ClassTail 
				  > Expression "[" [\n]* ExpressionSequence [\n]* "]" 
				  | "new" Expression 
				  > Expression Arguments 
				  | Expression [\n]* "." IdName 
				  | callInterpolation: Expression func [\u0060] BackTickStringChar* params [\u0060]
				  > Expression !>> [\n\r] "++" 
				  | Expression !>> [\n\r] "--" 
				  > "delete" Expression
				  | "void" Expression
				  | "typeof" Expression
				  | "++" Expression
				  | "--" Expression
				  | "+" !>> [+=] Expression
				  | "-" !>> [\-=] Expression
				  | "~" Expression 
				  | "!" !>> [=] Expression
				  > left ( Expression "*" !>> [*=] [\n]? Expression 
				         | Expression "/" !>> [/=] [\n]? Expression 
				         | Expression "%" !>> [%=] [\n]? Expression) 
				  > left ( Expression "+" !>> [+=] [\n]?  Expression 
				         | Expression "-" !>> [\-=] [\n]? Expression) 
				  > left ( Expression "\<\<" [\n]?  Expression 
				         | Expression "\>\>" !>> [\>]  [\n]? Expression 
				         | Expression "\>\>\>" [\n]? Expression)
				  > non-assoc ( Expression "\<" [\n]? Expression
				              | Expression "\>" [\n]? Expression 
				              | Expression "\<=" [\n]? Expression 
				              | Expression "\>=" [\n]? Expression 
				              | Expression "instanceof" [\n]? Expression 
				              | Expression "in" [\n]? Expression) 
				  > right ( Expression "===" [\n]? Expression 
				          | Expression "!==" [\n]? Expression 
				          | Expression "==" !>> [=] [\n]? Expression 
				          | Expression "!=" !>> [=] [\n]? Expression) 
				  > right binAnd: Expression lhs "&" !>> [&=] [\n]? Expression rhs
  				  > right binXor: Expression lhs "^" !>> [=] [\n]? Expression rhs
  				  > right binOr: Expression lhs "|" !>> [|=] [\n]? Expression rhs
  				  > left and: Expression lhs "&&" [\n]? Expression rhs
  				  > left or: Expression lhs "||" [\n]? Expression rhs
  			      > Expression!cond cond OPTIONALNEWLINE "?" OPTIONALNEWLINE Expression!cond then OPTIONALNEWLINE ":" OPTIONALNEWLINE Expression elseExp 
   			      > right ( assign: Expression lhs "=" !>> ("\>" | "=" | "==") [\n]? Expression rhs
				          | assignMul: Expression lhs "*=" [\n]? Expression rhs
				          | assignDiv: Expression lhs "/=" [\n]? Expression rhs
				          | assignRem: Expression lhs "%=" [\n]? Expression rhs
				          | assignAdd: Expression lhs "+=" [\n]? Expression rhs
				          | assignSub: Expression lhs "-=" [\n]? Expression rhs
				          | assignShl: Expression lhs "\<\<=" [\n]? Expression rhs
				          | assignShr: Expression lhs "\>\>=" [\n]? Expression rhs
				          | assignShrr: Expression lhs "\>\>\>=" [\n]? Expression rhs
				          | assignBinAnd: Expression lhs "&=" [\n]? Expression rhs
				          | assignBinXor: Expression lhs "^=" [\n]? Expression rhs
				          | assignBinOr: Expression lhs "|=" [\n]? Expression rhs );
				  
syntax ExpressionSequence =  { Expression "," }+;    

syntax ArrowParameters = Id | FormalArgs ; 

syntax ArrowFunctionBody = Expression | FunctionBody ; 

syntax Arguments = "(" [\n]* ArgumentList? [\n]* ")" ; 

syntax ArgumentList = Expression 
                    | Expression "," [\n]? ArgumentList!last 
                    | last: Expression "," [\n]? LastArgument
                    | LastArgument
                    ;


syntax LastArgument = "..." Id ; 

syntax VarModifier = "var"
                   | "const"
                   | "let"
                   ; 
                   
syntax EOS = ";" | [\n];
           
syntax OPTIONALNEWLINE = [\n]?;

syntax Literal
 = null: "null"
 | boolean: Boolean bool
 | numeric: Numeric num
 | string: String str
 | regexp: RegularExpression regexp
 ;

syntax Boolean
  = t: "true"
  | f: "false"
  ;

syntax Numeric
  = decimal: [a-zA-Z$_0-9] !<< Decimal decimal
  | hexadecimal: [a-zA-Z$_0-9] !<< HexInteger hexInt
  ;

lexical TemplateCharacters
  = TemplateCharacter TemplateCharacters
  | TemplateCharacter;

lexical TemplateCharacter
  // $ [lookahead diff from {] TODO ASK PROFESSOR ABOUT LOOKAHEAD
   = [\\] EscapeSequence
  | LineContinuation
  | LineTerminatorSequence
  | SourceCharacter \ NotTemplateCharacter
  | ([\a00] | ![\n \a0D \" \\])+ \ NotTemplateCharacter;

lexical SourceCharacter
  = unicodeEscape: "\\" [u]+ [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f];

lexical NotTemplateCharacter
  = [\u0060]
  | [\\] 
  | "$" 
  | LineTerminator;

lexical LineContinuation
  = [\\] LineTerminatorSequence;

lexical LineTerminator =
  [\n] 
  | EndOfFile !>> ![] 
  | [\a0D] [\n] 
  | CarriageReturn !>> [\n] 
  ;

lexical CarriageReturn =
  [\a0D] 
  ;

lexical EndOfFile =
  
  ;

//TODO ASK PROFESSOR ABOUT DIFFERENCES
lexical LineTerminatorSequence =
  [\n] 
  | EndOfFile !>> ![] 
  | [\a0D] [\n] 
  | CarriageReturn !>> [\n] 
  ;

lexical Decimal
  = DecimalInteger [.] [0-9]* ExponentPart?
  | [.] [0-9]+ ExponentPart?
  | DecimalInteger ExponentPart?
  ;

lexical DecimalInteger
  = [0]
  | [1-9][0-9]*
  !>> [0-9]
  ;

lexical ExponentPart
  = [eE] SignedInteger
  ;

lexical SignedInteger
  = [+\-]? [0-9]+ !>> [0-9]
  ;

lexical HexInteger
  = [0] [Xx] [0-9a-fA-F]+ !>> [a-zA-Z_]
  ;

lexical String
  = [\"] DoubleStringChar* [\"]
  | [\'] SingleStringChar* [\']
  | [\u0060] BackTickStringChar* [\u0060]
  ;

lexical BackTickStringChar
  = ![\u0060]
  | [\\] EscapeSequence
  ;
lexical DoubleStringChar
  = ![\"\\\n]
  | [\\] EscapeSequence
  ;

lexical SingleStringChar
  = ![\'\\\n]
  | [\\] EscapeSequence
  ;



lexical EscapeSequence
  = CharacterEscapeSequence
  | [0] !>> [0-9]
  | HexEscapeSequence
  | UnicodeEscapeSequence
  ;

lexical CharacterEscapeSequence
  = SingleEscapeCharacter
  | NonEscapeCharacter
  ;

lexical SingleEscapeCharacter
  = [\'\"\\bfnrtv]
  ;

lexical NonEscapeCharacter
  // SourceCharacter but not one of EscapeCharacter or LineTerminator
  = ![\n\'\"\\bfnrtv0-9xu]
  ;

lexical EscapeCharacter
  = SingleEscapeCharacter
  | [0-9]
  | [xu]
  ;


  
lexical HexDigit
  = [a-fA-F0-9]
  ;

lexical HexEscapeSequence
  = [x] HexDigit HexDigit
  ;

lexical UnicodeEscapeSequence
  = "u" HexDigit HexDigit HexDigit HexDigit
  ;

lexical RegularExpression
  = [/] RegularExpressionBody [/] RegularExpressionFlags
  ;

lexical RegularExpressionBody
  = RegularExpressionFirstChar RegularExpressionChar*
  ;

lexical RegularExpressionFirstChar
  = ![*/\[\n\\]
  | RegularExpressionBackslashSequence
  | RegularExpressionClass
  ;

lexical RegularExpressionChar
  = ![/\[\n\\]
  | RegularExpressionBackslashSequence
  | RegularExpressionClass
  ;

lexical RegularExpressionBackslashSequence
  = [\\] ![\n]
  ;

lexical RegularExpressionClass
  = [\[] RegularExpressionClassChar* [\]]
  ;

lexical RegularExpressionClassChar
  = ![\n\]\\]
  | RegularExpressionBackslashSequence
  ;

lexical RegularExpressionFlags
  = [a-zA-Z]* !>> [a-zA-Z]
  ;

lexical Whitespace
  = [\ \t]
  ;

lexical Blanks = Whitespace | [\n] ;

lexical Comment
  = @category="Comment" "/*" CommentChar* "*/"
  | @category="Comment" "//" ![\n]*  $
  ;

lexical CommentChar
  = ![*]
  | [*] !>> [/]
  ;


lexical LAYOUT
  = Whitespace
  | Comment
  ;

layout LAYOUTLIST
  = LAYOUT*
  !>> [\ \t]
  !>> "/*"
  !>> "//" ;


lexical Id 
  = ([a-zA-Z$_0-9] !<< [$_a-zA-Z] [a-zA-Z$_0-9]* !>> [a-zA-Z$_0-9]) \ Reserved
  ;
  
keyword Reserved =
    | "break" | "do" | "in" | "typeof" | "case"
    | "else" | "instanceof" | "var" |  "catch" | "export"  
    | "new" | "void" | "class" | "extends"   | "return"  
    | "while" | "const" | "finally"  | "super" | "with"  
    | "continue" |"for" | "switch" | "yield" | "debugger"  
    | "function" | "this" | "default"  | "if" |  "throw"  
    | "delete" | "import"  | "try"
    // Future
    | "enum" | "await" | "implements" |  "package" | "protected"  
    | "interface" | "private" | "public"
    // Literal
    | "null" | "true" | "false";  