package main

import "github.com/Marck/transfer.sh/cmd"

func main() {
	app := cmd.New()
	app.RunAndExitOnError()
}
