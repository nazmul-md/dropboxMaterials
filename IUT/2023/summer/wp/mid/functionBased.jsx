import { useEffect } from "react";
import { useState } from "react";

export default function MyComponent () {
    const [count, setCount] = useState(0);
    // const [text, setText] = useState('');
    const [date, setDate] = useState(new Date());

    const addClick = () => {
        setCount((prevCount)=>prevCount+1)
    };

    const tick = ()=>{
        console.log('clock ticking')
        setDate(new Date());
    }

    useEffect(()=>{
        console.log('calling useEffect');
        document.title = `Clicked ${count} times`;
    }, [count]) // , [count]

    useEffect(()=>{
        console.log('starting timer');
        const interval = setInterval(tick, 1000);

        return () =>{
            console.log("Component unmounted");
            clearInterval(interval);
        }
    },[])

    return (
        <div>
            {/* <input type="text" value={text} onChange = {(e)=>setText(e.target.value)} /> */}
            <p>Time: {date.toLocaleTimeString()}</p>
            <p>
                <button type="button" onClick={addClick}>
                    Click
                </button>
            </p>
        </div>
    );
}