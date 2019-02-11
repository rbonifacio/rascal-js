module lang::js::Transform

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;

void testTransform(){
	loc fileLoc = |project://rascal-js/test/function.js|;
	str file = readFile(fileLoc);
	//Exp e =  parse(#start[CompilationUnit], file):
	CompilationUnit cu = parse(#CompilationUnit, file);
	//cu = constUpperCase(cu);
	cu = nameToUpper(cu, "caio");
	// writeFile(fileLoc, cu);
	//println(cu);
	

}


CompilationUnit constUpperCase(CompilationUnit unit){
	str constAux;

	return bottom-up visit(unit){
		case (VarStatement) `<VarModifier vm> <VarDec vd> <EOS capeta>`:{
			visit(vm) {
				case(VarModifier) `<VarModifier varMod>`:{
					if("<varMod>" == "const"){
						visit(vd){
							case(VarDec) `<Id nomeConst> = <Expression exp>`:{
								constAux = "<nomeConst>";
								println(constAux);
							}
						
						}
					}
					 	
				}
			
			}	
		}
	}
}

CompilationUnit nameToUpper(CompilationUnit unit, str varName){
	return bottom-up visit(unit){
		case (Expression) `<Id id>`:{
			if("<id>" == varName)
				println(id);
		}
	
	}	

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

