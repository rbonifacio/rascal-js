module lang::js::Transform

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;

// visita de funcao OK

// verificar const OK

// Varrer codigo se uma const é redeclarado, se aparecer como parametro, nao aplicar o refatoramento
	// desnecessario, visto que caso redeclarado deve ser substituido da mesma maneira,  e não aparenta ser problema
	// caso passado como parametro.


// Varredura para procurar repeticao e outra pra transformacao OK

// Fazer renames com diferetnes graus e flexibilizar ao andar
	// GRAU 1 : encontrar const dentro de funcoes
	// Limitacoes: Nenhuma até agora
	
	// GRAU 2: encontrar const no aspecto global, e susbstituir em casos não utilizados externamente.
	// Limitações: Verificar export da variavel ou classe mae, pois isso indicara que será usado em outro arquivo
	
	// GRAU 3: substituir todo tipo de const, e procurar o uso delas em outros arquivos
	// Limitaçoes: nenhuma.


// introducao de arrow function




void testTransform(){
	loc fileLoc = |project://rascal-js/transformsrc/rename.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	unit = renameConstInFuctions(unit); // this will return the tree with the transformations applied.
	writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
	
}


CompilationUnit renameConstInFuctions(CompilationUnit unit){
	list[str] variableNames = [];
	unit = top-down visit(unit){
		case(FunctionDeclarationStatement)  `<FunctionDeclarationStatement fd>` :{
			fd = visit(fd){
				// here we use top down search to find the declaration first, and then find where the variables
				// are being used.
				
				// TODO: check case with multiple consts, although not used much: const var1 = 1, var2 = 2 
				case (VarStatement) `const <Id nomeConst> = <Expression exp> <EOS eos>` :{
						variableNames+= "<nomeConst>";
						newName = rename(nomeConst);
						insert (VarStatement) `const <Id newName> = <Expression exp> <EOS eos>`;
					}
				case (Expression) `<Id nomeConst>`:{
					if(indexOf(variableNames, "<nomeConst>") != -1){
						newName = rename(nomeConst);
						insert (Expression) `<Id newName>`;
					}
				
				}					
			}
			
			// TODO , ask professor the need of this second insert.
			insert (FunctionDeclarationStatement) `<FunctionDeclarationStatement fd>`;
		}
	
	}
	println(unit);
	return unit;
} 

// returns a function tree
list[FunctionDeclarationStatement] getFunctionsWithConst(list[FunctionDeclarationStatement] functionList){
	list[FunctionDeclarationStatement] constList = [];
	for(func <- functionList) {
		top-down visit(func){
			case (VarStatement) `const <Id nomeConst> = <Expression exp> <EOS eos>`:{
				constList+= func;
			}
		}
	}
	
	return functionList;
}

list[FunctionDeclarationStatement] findFunctions(CompilationUnit unit){
	list[FunctionDeclarationStatement] functionList = [];
	top-down visit(unit){
		case(FunctionDeclarationStatement)  `<FunctionDeclarationStatement fd>`:{
			functionList+= fd;
		}
	
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

