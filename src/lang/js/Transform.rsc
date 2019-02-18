module lang::js::Transform

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;

void testTransform(){
	loc fileLoc = |project://rascal-js/transformsrc/rename.js|;
	str file = readFile(fileLoc);
	//Exp e =  parse(#start[CompilationUnit], file):
	CompilationUnit cu = parse(#CompilationUnit, file);
	findFunctions(cu);
	
	// writeFile(fileLoc, cu);
	
	

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


CompilationUnit idiomatic(CompilationUnit unit) {
   //syntax VarStatement = VarModifier {VarDec ","}+ EOS ; 
   return bottom-up visit(unit) {
   		case (VarStatement) `<VarModifier vm> <VarDec vd> <EOS capeta>`:{
   		//syntax VarDec = (Id | ArrayLiteral | ObjectLiteral)  ("=" [\n]? Expression)?;
   			vd = visit(vd) {
   				case (Id) `<Id id>`:{
   					if(size("<id>") == 1){
   						println("Variavel pequena");
   						//novoNome = parse(#Id,"torres");
						//insert (Id) `<Id novoNome>`; 
   					}
   				}
   				
   				
   			}
   			insert (VarStatement) `<VarModifier vm> <VarDec vd> <EOS capeta>`;
   		}
   		
   }
}

