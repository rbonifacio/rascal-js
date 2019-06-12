module lang::js::Increment

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;




void refactorPostIncrement(){
	loc fileLoc = |project://rascal-js/transformsrc/increment.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	unit = removePostIncrement(unit); // this will return the tree with the transformations applied.
	writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
	
}



void refactorPreIncrement(){
	loc fileLoc = |project://rascal-js/transformsrc/increment.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	unit = removePostIncrement(unit); // this will return the tree with the transformations applied.
	writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
	
}



CompilationUnit removePostIncrement(CompilationUnit unit) = top-down visit(unit) {
  case (Expression) `<Id name>++` =>
   	   (Expression) `<Id name> = <Id name> + 1`
};

CompilationUnit removePreIncrement(CompilationUnit unit) = top-down visit(unit) {
  case (Expression) `<Id name>++` =>
   	   (Expression) `<Id name> = <Id name> + 1`
};
