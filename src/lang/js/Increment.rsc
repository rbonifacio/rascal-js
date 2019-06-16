module lang::js::Increment

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;




public tuple[int, start[CompilationUnit]] refactorTernary(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `<Expression cond> <OPTIONALNEWLINE nl1> ? <Expression exp1> <OPTIONALNEWLINE nl2> : <OPTIONALNEWLINE nl3><Expression exp2>` : {
			total = total + 1;
		}
	};
	return <total, unit>;

}



public tuple[int, start[CompilationUnit]] refactorPostIncrement(start[CompilationUnit] unit){
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


public tuple[int, start[CompilationUnit]] refactorPreIncrement(start[CompilationUnit] unit){
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




void runRefactorPostIncrement(loc baseDir){
	//|project://rascal-js/projects/bootstrap-4-dev/js/src|
	entries = listJSFiles(baseDir);
	int totalInProject = 0;
	int filesChecked = 0;
	int filesFailed = 0;
	for(loc s <- entries) {
		try {
	        contents = readFile(s);
	    	start[CompilationUnit] unit = parse(#start[CompilationUnit], contents);
	        filesChecked = filesChecked + 1;
	        tuple[int count , start[CompilationUnit] refactoredUnit] postIncrement = refactorPostIncrement(unit);
	        tuple[int count , start[CompilationUnit] refactoredUnit] ternary = refactorTernary(unit);
	        println("[parsing file:] " + s.path);
			print("Post Increment Count: ");
			println(postIncrement.count);
			print("Ternary Count: ");
			println(ternary.count);
			totalInProject  = totalInProject + postIncrement.count; 
	     }
	     catch ParseError(loc l): {
	     	print("[parsing file:] " + s.path);
        	println("... found an error at line <l.begin.line>, column <l.begin.column> "); 
	        filesFailed = filesFailed + 1;
	     }
	     
	};
	print("Files Parsed: ");
	println(filesChecked);
	print("Files Failed to Parse: ");
	println(filesFailed);
	print("Post Increment Count TOTAL: ");
	println(totalInProject);
	
	
	
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



list[loc] listJSFiles(loc location) {
  res = [];
  list[loc] allFiles = location.ls;
       
  for(loc l <- allFiles) {
    if(isDirectory(l)) {
      res = res + (listJSFiles(l));
    }
    else {
      if(l.extension == "js") {
         res = l + res;
      };
    };
  };
  return res; 
}