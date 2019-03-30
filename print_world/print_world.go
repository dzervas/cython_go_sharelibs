package main

import "C"
import (
        "fmt"
)

//export Hello
func Hello() {
	fmt.Println("World!")
}

func main() {}
