
let config = {size: 3, isActive: false};
const _config = config.isActive === true ? config : {size: 10};
console.log(_config.size);

// revisado OK , similar bootstrap 

// 10