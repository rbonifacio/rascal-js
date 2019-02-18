const doNotDetect = 7;
example(doNotDetect);

function example(variable){
    const detect = 3;
    if(detect){
        console.log(detect);
    }
    const object = { detect: 7};
    console.log(object.detect);

    // this code should print 3 and then 7
}


function example2(variable){
    const detect = 4;
    if(detect){
        console.log(detect);
    }
    const object = { detect: 7};
    console.log(object.detect);

    // this code should print 3 and then 7
}