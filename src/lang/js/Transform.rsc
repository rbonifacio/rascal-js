module lang::js::Transform

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;

void testTransform(){
	loc fileLoc = |project://rascal-js/transformsrc/rename.js|;
	str file = readFile(fileLoc);
	CompilationUnit cu = parse(#CompilationUnit, file);
	findFunctions(cu);
	
	// writeFile(fileLoc, cu);
	
	
	println(constUpperCase(cu));
}
// visita 	 de funcao
// verificar const
// varrer codigo se uma const é redeclarado, se aparecer como parametro, nao aplicar o refatoramento
// uma varregadora para procurar repeticao e outra pra transformacao
// fazer renames com diferetnes graus e flexibilizar ao andar
// introducao de arrow function


// returns a function tree
list[FunctionDeclarationStatement] getFunctionsWithConst(list[FunctionDeclarationStatement] functionList){
	for(func <- functionList) {
		top-down visit(func){
			case (VarStatement) `const <Id id> = <Expression exp> <EOS endOfStatement>`:{
				println("<id>");
				// do something here
			}
		}
	}
	
	return functionList;
}

list[FunctionDeclarationStatement] findFunctions(CompilationUnit unit){
	list[FunctionDeclarationStatement] functionList = [];
	top-down visit(unit){
		// descobrir como imprimir a arvore do case
		case(FunctionDeclarationStatement)  `<FunctionDeclarationStatement fd>`:{
			functionList+= fd;
			
			
		}
	
	}
	for(func <- functionList) {
    	println(func); 
  	}
	return functionList;
}


CompilationUnit nameToUpper(CompilationUnit unit, str varName){
	unit = bottom-up visit(unit){
	    // aparentemente pega apenas o Id direto dentro da expression
	    case (Expression) `<Id id>`:{
			if("<id>" == varName){
				newUpperName = parse(#Id, toUpperCase(varName));
				insert (Expression) `<Id newUpperName>`; 
				
				
			}
		}
		
	
	}	
	return unit;
}
CompilationUnit constUpperCase(CompilationUnit unit) = top-down visit(unit){
		case (VarStatement) `const <Id nomeConst> = <Expression exp> <EOS eos>` => 
		     (VarStatement) `const <Id newName> = <Expression exp> <EOS eos>`
		  when newName := rename(nomeConst)  
};
	

Id rename((Id)`<Id old>`) = parse(#Id, toUpperCase("<old>")); 

