module lang::js::AtomCounter

import lang::js::ES6;
import ParseTree;
import String;
import IO;

int countTernaryOperator(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression exp) `<Expression cond> <NewLines nl1> ? <NewLines nl2> <Expression exp1> <NewLines nl3> : <NewLines nl4> <Expression exp2>` : {
			total = total + 1;
			//print(cond); println(exp1);
		}
		
	};
	return total;

}

int countCommaOperator(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `<Expression exp> = ( <ExpressionSequence seq> )` : {
			if(contains(unparse(seq),",")){
				total = total + 1;
				println(unparse(exp) + "= (" + unparse(seq) + ")" );
			}
		}
		case (ReturnStatement) `return (  <ExpressionSequence seq> ) <EOS eos>` : {
			if(contains(unparse(seq),",")){
				total = total + 1;
				println("return (" + unparse(seq) + ")" );
			}
		}
		
	};
	return total;

}

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
  print(entries);
  int postIncrementCount = 0;
  int preIncrementCount = 0;
  int ternaryCount = 0;  
  int commaCount = 0;  
  for(loc s <- entries) {
	try {
		
        contents = readFile(s);
    	start[CompilationUnit] unit = parse(#start[CompilationUnit], contents, allowAmbiguity=true);
    	
  		//postIncrementCount+= countPostIncrement(unit);
  		//preIncrementCount+= countPreIncrement(unit);
  		commaCount+= countCommaOperator(unit);
  		
		//print("Count in " + s.path); println(countTernaryOperator(unit));
		//ternaryCount+= countTernaryOperator(unit);

        
        
     }
      catch ParseError(loc l): {
	     	
        	println("Ambuguidade?"); 
	        
	     }
  }
    		
  print("Pre Increment Count: "); println(preIncrementCount);
  print("Post Increment Count: "); println(postIncrementCount);
  print("Ternary Operator Count: "); println(ternaryCount);
  print("Comma Operator Count: "); println(commaCount);
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
