module lang::js::AtomCounter

import lang::js::ES6;
import ParseTree;
import String;
import IO;

int countPostIncrement(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `<Id name>++` : {
			total = total + 1;
		}
		case (Expression) `<Id name>--` : {
			total = total + 1;
		}
	};
	return total;

}


int countPreIncrement(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `++<Id name>` : {
			total = total + 1;
		}
		case (Expression) `--<Id name>` : {
			total = total + 1;
		}
	};
	return total;

}

void countAtoms(bool verbose, loc baseDir) {
  entries = listJSFiles(baseDir);
  
  int postIncrementCount = 0;
  int preIncrementCount = 0;  
  for(loc s <- entries) {
	try {
        contents = readFile(s);
    	start[CompilationUnit] unit = parse(#start[CompilationUnit], contents, allowAmbiguity=true);
  		postIncrementCount+= countPostIncrement(unit);
  		preIncrementCount+= countPreIncrement(unit);

        
        
     }
     catch : {
        println("Rat\n");
     }  
  }
    		
  print("Pre Increment Count: "); println(preIncrementCount);
  print("Post Increment Count: "); println(postIncrementCount);
}


list[loc] listJSFiles(loc location) {
  res = [];
  list[loc] allFiles = location.ls;
       
  for(loc l <- allFiles) {
    if(isDirectory(l)) {
      res = res + (listJSFiles(l));
    }
    else {
      if(l.extension == "js" && !contains(l.path,".min")) {
         res = l + res;
      };
    };
  };
  return res; 
}
