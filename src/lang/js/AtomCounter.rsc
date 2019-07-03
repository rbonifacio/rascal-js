module lang::js::AtomCounter

import lang::js::ES6;
import ParseTree;
import String;
import IO;

bool hasArithSymbol(str string){
	if(contains(string," + ") || contains(string," - ") || contains(string," * ") || contains(string," / ")
		|| contains(string,"++") || contains(string,"--")
	)
		return true;
	return false;

}
bool hasLogicSymbol(str string){
	if(contains(string,"&&") || contains(string,"||")  
	|| contains(string,"!=") || contains(string,"==")
	)
		return true;
	return false;

}


int countOmitted(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case(IfStatement) `if(<NewLines nl1> <Expression cond> <NewLines nl2>) <NewLines nl3> <ExpressionStatement exp>` : {
			total = total + 1;
		}
		case(IfStatement) `if(<NewLines nl1>  <Expression cond> <NewLines nl2>) <NewLines nl3> <IterationStatement exp>` : {
			total = total + 1;
		}
		case(IfStatement) `if(<NewLines nl1> <Expression cond> <NewLines nl2>) <NewLines nl3> <ContinueStatement exp>` : {
			total = total + 1;
		}
		case(IfStatement) `if(<NewLines nl1> <Expression cond> <NewLines nl2>) <NewLines nl3> <BreakStatement exp>` : {
			total = total + 1;
		}
		case(IfStatement) `if(<NewLines nl1> <Expression cond> <NewLines nl2>) <NewLines nl3> <ReturnStatement exp>` : {
			total = total + 1;
		}
		case(IfStatement) `if(<NewLines nl1> <Expression cond> <NewLines nl2>) <NewLines nl3> <ThrowStatement exp>` : {
			total = total + 1;
		}
		case(IfStatement) `if(<NewLines nl1> <Expression cond> <NewLines nl2>) <NewLines nl3> <TryStatement exp>` : {
			total = total + 1;
		}
	
	}
	return total;
}

int countAssignment(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `<Expression exp1> = <Expression exp2> = <Expression exp3>` : {
			total = total + 1;
		}
		case (Expression) `<Expression exp1> = <Expression exp2> = <Expression exp3> =  <Expression exp4>` : {
			total = total + 1;
		}
		case (Expression) `<Expression exp1> = <Expression exp2> = <Expression exp3> =  <Expression exp4> =  <Expression exp5>` : {
			total = total + 1;
		}
		
	
	};
	return total;

}


int countArithmethic(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (IfStatement) `if ( <NewLines nl1> <Expression cond> <NewLines nl2> ) <NewLines nl3> <Statement stm>` : {
			condition = unparse(cond);
			if(hasArithSymbol(condition) && !hasLogicSymbol(condition)){
				total = total + 1;
			};
			
		}
	
	};
	return total;

}
// (return[\n].*[a-z0-9{])
//int countAutomaticSemiColon(start[CompilationUnit] unit){
//	int total = 0;
//	unit = top-down visit(unit){
//		case (ReturnAtom) `<ReturnAtom ra>` : {
//			
//			println("rato");
//			
//		}
//	
//	};
//	return total;
//
//}

// (.*\?.*:.*)
//int countTernaryOperator(start[CompilationUnit] unit){
//	int total = 0;
//	unit = top-down visit(unit){
//		case (Expression exp) `<Expression cond> <NewLines nl1> ? <NewLines nl2> <Expression exp1> <NewLines nl3> : <NewLines nl4> <Expression exp2>` : {
//			total = total + 1;
//			//print(cond); println(exp1);
//		}
//		
//	};
//	return total;
//
//}

int countCommaOperator(start[CompilationUnit] unit){
	int total = 0;
	unit = top-down visit(unit){
		case (Expression) `<Expression exp> = ( <ExpressionSequence seq> )` : {
			if(contains(unparse(seq),",")){
				total = total + 1;
				
			}
		}
		case (ReturnStatement) `return (  <ExpressionSequence seq> ) <EOS eos>` : {
			if(contains(unparse(seq),",")){
				total = total + 1;
				
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
  int autoSemiCount = 0;  
  int arithmeticCount = 0;
  int assignmentCount = 0;
  int omittedCount = 0;
  int tempCount = 0;
  
  for(loc s <- entries) {
	try {
		
        contents = readFile(s);
    	start[CompilationUnit] unit = parse(#start[CompilationUnit], contents, allowAmbiguity=true);
    	
  		postIncrementCount+= countPostIncrement(unit);
  		preIncrementCount+= countPreIncrement(unit);
  		commaCount+= countCommaOperator(unit);
  		//autoSemiCount+= countAutomaticSemiColon(unit);
  		arithmeticCount+= countArithmethic(unit);
  		assignmentCount+= countAssignment(unit);
  		omittedCount+= countOmitted(unit);
  		

        
        
     }
      catch ParseError(loc l): {
      		print("[parsing file:] " + s.path);
	     	println("... found an error at line <l.begin.line>, column <l.begin.column> ");
        	 
	        
	     }
  }
    		
  println("");
  print("Pre Increment Count: "); println(preIncrementCount);
  print("Post Increment Count: "); println(postIncrementCount);
  print("Comma Operator Count: "); println(commaCount);
  print("Arith Count: "); println(arithmeticCount);
  print("Assignment Count: "); println(assignmentCount);
  print("Omitted Count: "); println(omittedCount);
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
