// Simple Case
let simple = cond1 ? exp1 : exp2
let simple2 = cond12 ? exp12 : exp22;
if(cond13)  {
	simple3 = exp13;
}  else  {
	simple3 = exp23;
}

// New Line Case
let newline = cond1 ? 
    exp1
    : 
    exp2
let newline2 = cond12 ? exp12 : 
                        exp22
if(cond13)  {
	newline3 = exp13;
}  else  {
	newline3 = exp23;
}
// common case  -- we do not refactor this
object = {
    property: student.name ? student.name.first :  ''
}
object2 = {
    property: student.name ? 'YES' :  'NO'
}


// complex case
export const BASE_API = (
    caio
);
