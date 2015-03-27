// We often want to execute Go code at some point in the
// future, or repeatedly at some interval. Go's built-in
// _timer_ and _ticker_ features make both of these tasks
// easy. We'll look first at timers and then
// at [tickers](tickers).

package main

import (
	"fmt"
	"time"
)

//import "reflect"

func print(msg string) {
	fmt.Println(msg)
}

func main() {

	ticker := time.NewTicker(200 * time.Millisecond)
	quit := make(chan struct{})

	done := make(chan bool)
	t1 := time.Now().UnixNano() 
	go func() {
		for {
			select {
			case <-ticker.C:
				// do stuff
				t2 := time.Now().UnixNano() 
				fmt.Printf(":%.6f\n",float64(t2 - t1)/1000000)
				fmt.Printf("%s, %d\n", time.Now().String(), t2%1000000000)

				t1 = t2
			case <-quit:
				ticker.Stop()
				return
			}
		}
	}()

	<-done

}
