const hasMeeting = false;

const meeting = new Promise((resolve, reject)=>{
    if(!hasMeeting) {
        const meetingDetails = {
            name:"Technical Meeting",
            location: 'Google Meet',
            time: '10:00 AM'
        }
        resolve(meetingDetails);
    } else {
        reject(new Error('Meeting has already scheduled!'));
    }
});

const addToCalendar = (meetingDetails)=>{
    const calendar = `${meetingDetails.name} has been scheduled on ${meetingDetails.location} at ${meetingDetails.time}`;
    return Promise.resolve(calendar);
}

meeting
    .then(addToCalendar)
    .then((res)=>{
        console.log(res);
    })
    .catch((err)=>{
        console.log(err.message);
    })
console.log('fks')