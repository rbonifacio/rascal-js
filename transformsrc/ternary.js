// Simple Case
let simple = cond1 ? exp1 : exp2
let simple2 = cond12 ? exp12 : exp22;
simple3 = cond13 ? exp13 : exp23


// New Line Case
let newline = cond1 ? 
    exp1
    : 
    exp2
let newline2 = cond12 ? exp12 : 
                        exp22
newline3 = cond13 ? exp13 
                  : exp23

// common case  -- we do not refactor this
object = {
    property: student.name ? student.name.first :  ''
}
object2 = {
    property: student.name ? 'YES' :  'NO'
}


// complex case
// export const BASE_API = (

//     process.env.NODE_ENV === 'production' ? 
//         'http://spcomapi.cnec.br/api'
//     :
//     process.env.NODE_ENV === 'homologation' ?
//         'http://hmlapidescontos.cnec.br/api'
//     :
//         'http://localhost:8888/api'
// );