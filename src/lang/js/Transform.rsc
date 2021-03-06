module lang::js::Transform

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;

public void testTransform() {
  loc fileLoc = |project://rascal-js/test/function.js|;
  str file = readFile(fileLoc);
  CompilationUnit cu = parse(#CompilationUnit, file);
  println(constUpperCase(cu));
}


public CompilationUnit constUpperCase(CompilationUnit unit) = top-down visit(unit) {
  case (VarStatement) `const <Id nomeConst> = <Expression exp> <EOS eos>` => 
       (VarStatement) `const <Id newName> = <Expression exp> <EOS eos>`
   when newName := rename(nomeConst)  
};
	
public Id rename((Id)`<Id old>`) = parse(#Id, toUpperCase("<old>")); 

