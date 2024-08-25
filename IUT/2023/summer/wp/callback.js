const takeOrder = (customer, callback)=>{
    console.log(`Taking order for ${customer}`);
    callback(customer);
}

const processOrder = (customer, callback)=>{
    console.log(`Processing order for ${customer}`);
    setTimeout(()=>{
        console.log('cooking completed');
        console.log(`Order processed for ${customer}`);
        callback(customer);
    },3000);
}

const completeOrder = (customer)=>{
    console.log(`completed order for ${customer}`);
}

// takeOrder('customer 1', (customer)=>{
//     processOrder(customer, (customer)=>{
//         completeOrder(customer);
//     })
// })

takeOrder('customer 1',function(customer){
    processOrder(customer, function(){
        completeOrder(customer)
    })
})