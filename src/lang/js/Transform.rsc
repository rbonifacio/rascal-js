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
	// OBS: Verificar export da variavel ou classe mae, pois isso indicara que será usado em outro arquivo
	
	// GRAU 3: substituir todo tipo de const, e procurar o uso delas em outros arquivos
	// Limitaçoes: Dificuldade


// introducao de arrow function

// DECIDED
// 2 - confusion atom, tranformar por exemplo operador ternario em ifs, biblioteca rascal para detectar atomos de confusao.
	// 2.1 comprender os atomos de JS 6 semanas
	// (6 semanas) 2.2 atomos de confusao em C sao mesmo em atomos de confusao JS , detectecao e validacao e transformacao

// quarta semana q vem 6/03: 	
// escrever o que aprendeu e o tutorial sobre rascal, como é relacionado com o que ja fizemos.
// e decidir qual frente vamos atacar.



void rename(){
	loc fileLoc = |project://rascal-js/transformsrc/rename.js|;
	str file = readFile(fileLoc);
	CompilationUnit unit = parse(#CompilationUnit, file);
	unit = renameConstInFuctions(unit); // this will return the tree with the transformations applied.
	writeFile(fileLoc, unit); // this will overwrite the file with the transformation. 
	
}


CompilationUnit renameConstInFuctions(CompilationUnit unit){
	unit = top-down visit(unit){
		case(FunctionDeclarationStatement)  `<FunctionDeclarationStatement fd>` :{
			map[str,int] decls = countDeclarations(fd);
			fd = visit(fd){
				// here we use top down search to find the declaration first, and then find where the variables
				// are being used.
				case (VarStatement) `const <Id nomeConst> = <Expression exp> <EOS eos>` => 
					 (VarStatement) `const <Id newName> = <Expression exp> <EOS eos>`
					 when decls["<nomeConst>"] == 1,
					 	  newName := rename(nomeConst)
				case (Expression) `<Id nomeConst>`:{
					if("<nomeConst>" in decls && decls["<nomeConst>"] == 1){
						newName = rename(nomeConst);
						insert (Expression) `<Id newName>`;
					}
				
				}  
									
			}
			insert (FunctionDeclarationStatement) `<FunctionDeclarationStatement fd>`;
		}
	
	}
	return unit;
} 


map[str,int] countDeclarations(FunctionDeclarationStatement fd){
	map[str,int] res = ();
	top-down visit(fd){
		case (VarStatement) `const <Id nomeConst> = <Expression exp> <EOS eos>` :{
			str aux = "<nomeConst>";
			if(aux in res){
				res[aux] = res[aux]+1; 
			}
			else{
				res[aux] = 1;
			}
		}
	}
	return res;
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

