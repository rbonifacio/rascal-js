// parse("#start[CompilationUnit], "true && true ? true : true ? true : false;")

//render(visParsetree(parse(#start[CompilationUnit], "true ? true : true ? true : false;")));

//parse(#Expression, "(true ? true : true) ? true : false")
//true ? true : true ? true : false;
  

// caio = (2,3)
// console.log( (caio,3 ))

return function (Constructor, protoProps, staticProps) {
    if (protoProps) defineProperties(Constructor.prototype, protoProps);
    if (staticProps) defineProperties(Constructor, staticProps);
    return Constructor;
  };