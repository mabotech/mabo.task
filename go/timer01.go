// We often want to execute Go code at some point in the
// future, or repeatedly at some interval. Go's built-in
// _timer_ and _ticker_ features make both of these tasks
// easy. We'll look first at timers and then
// at [tickers](tickers).

package main

import "time"
import "fmt"
import "reflect"

func print(msg string) {
	fmt.Println(msg)
}

func main() {

	// Timers represent a single event in the future. You
	// tell the timer how long you want to wait, and it
	// provides a channel that will be notified at that
	// time. This timer will wait 2 seconds.
	
	timer1 := time.NewTimer(time.Second * 2)

	// The `<-timer1.C` blocks on the timer's channel `C`
	// until it sends a value indicating that the timer
	// expired.
 
		t1 := time.Now().UnixNano()
		fmt.Println(t1)

		<-timer1.C
		fmt.Println("Timer 1 expired")
		print("hi")
		t := time.Now().Unix()
		fmt.Println(t)

		t2 := time.Now().UnixNano()
		fmt.Println(t2)
		print("diff")
		  fmt.Println( float64( t2-t1)/1000000000)

 fmt.Println("type:%s",  reflect.TypeOf(t1))
	// If you just wanted to wait, you could have used
	// `time.Sleep`. One reason a timer may be useful is
	// that you can cancel the timer before it expires.
	// Here's an example of that.
	timer2 := time.NewTimer(time.Second)
	go func() {
		<-timer2.C
		fmt.Println("Timer 2 expired")
		t := time.Now().UnixNano()
		fmt.Println("type:%s",  reflect.TypeOf(t))
		fmt.Println(t)
	}()



ticker := time.NewTicker(5 * time.Second)
quit := make(chan struct{})
go func() {
    for {
       select {
        case <- ticker.C:
            // do stuff
			print("t\n")
        case <- quit:
            ticker.Stop()
            return
        }
    }
 }()
 
 
	/*
		stop2 := timer2.Stop()
		if stop2 {
			fmt.Println("Timer 2 stopped")
			t := time.Now().UnixNano()
		fmt.Println(t)
		}
	*/
}
