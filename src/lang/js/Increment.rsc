module lang::js::Increment

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;




public tuple[int, CompilationUnit] refactorPostIncrement(CompilationUnit unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `<Id name>++` : {
			total = total + 1;
		}
		case (Expression) `<Id name>--` : {
			total = total + 1;
		}
	};
	return <total, unit>;

}


public tuple[int, CompilationUnit] refactorPreIncrement(CompilationUnit unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `++<Id name>` : {
			total = total + 1;
		}
		case (Expression) `--<Id name>` : {
			total = total + 1;
		}
	};
	return <total, unit>;

}



void runRefactorPostIncrement(){
	loc fileLoc = |project://rascal-js/transformsrc/postincrement.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	tuple[int count , CompilationUnit refactoredUnit] postIncrement = refactorPostIncrement(unit);
	print("Post Increment Count: ");
	println(postIncrement.count);
	//unit = removePostIncrement(unit); // this will return the tree with the transformations applied.
	//writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
}
void runRefactorPreIncrement(){
	loc fileLoc = |project://rascal-js/transformsrc/postincrement.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	tuple[int count , CompilationUnit refactoredUnit] preIncrement = refactorPreIncrement(unit);
	print("Pre Increment Count: ");
	println(preIncrement.count);
	//unit = removePostIncrement(unit); // this will return the tree with the transformations applied.
	//writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
}

