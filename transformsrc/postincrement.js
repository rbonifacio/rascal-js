console.log(++idade)
// refatoraria para
idade = idade + 1
console.log(idade)

// no entanto, veja por exemplo caso estivesse dentro de um if
if(temQueIncrementar)
    console.log(++idade)
// teria que transformar o if nesse caso também para ter chaves
