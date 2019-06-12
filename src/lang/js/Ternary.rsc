module lang::js::Ternary

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;




void refactorTernary(){
	loc fileLoc = |project://rascal-js/transformsrc/ternary.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	unit = removeTernary(unit); // this will return the tree with the transformations applied.
	writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
	
}


CompilationUnit removeTernary(CompilationUnit unit) = top-down visit(unit) {
  case (Statement) `<Id nomeConst> = <Expression cond> ? <Expression e1> : <Expression e2>` : {
  		println("Encontrou tennario");
   	   //insert (Statement) `if(<Expression cond>) <Id nomeConst> = <Expression e1> else <Id nomeConst> = <Expression e2>`
   }
};

