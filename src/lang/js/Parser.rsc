module lang::js::Parser

import lang::js::ES6;
import ParseTree; 
import IO;
import util::Math;
import String;

/**
 * Parse all files within the testes directory.
 * This method is usefull for testing the Java18 grammar.
 */
void parseAllFiles(bool verbose, loc baseDir) {
  real ok = 0.0; 
  real nok = 0.0; 
  entries = listJSFiles(baseDir);  
  println(entries);
  for(loc s <- entries) {
     if(verbose) { 
        //print("[parsing file:] " + s.path);
        ;
     }
     try {
        contents = readFile(s);
    	start[CompilationUnit] cu = parse(#start[CompilationUnit], contents, allowAmbiguity=true);
        
        //if(verbose) {println("... ok");}
        ok = ok + 1.0;
     }
     //catch : {
     //   if(verbose) {
     //      print("[parsing file:] " + s.path);
     //   }
     //   println("... NOT OK "); 
     //   nok = nok + 1.0;
     //}
     catch ParseError(loc l): {
        if(verbose) {
           print("[parsing file:] " + s.path);
        }
        println("... found an error at line <l.begin.line>, column <l.begin.column> "); 
        nok = nok + 1.0;
     }
   	}
   	real res = ok / (nok + ok);
    println("[Total of JavaScript Files]: <nok + ok>");
    println("[Success Rate]: <res>");
 
}

/**
 * List all Java files from an original location. 
 */
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

