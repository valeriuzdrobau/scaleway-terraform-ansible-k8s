package main

import (
	"fmt"
	"go/build"
	"io/ioutil"
	"os"
	"os/exec"
)

func getTerraformPath() string {
	argsWithoutProg := os.Args[1:]
	if len(argsWithoutProg) == 0 {
		panic("Invalid argument. Need a terraform path")
	} else if len(argsWithoutProg) > 1 {
		panic("Too much arguments")
	}

	if _, err := os.Stat(argsWithoutProg[0]); os.IsNotExist(err) {
		panic("the terraform path in argument does not exist")
	}

	return argsWithoutProg[0]
}

func getGoPath() string {
	gopath := os.Getenv("GOPATH")
	if gopath == "" {
		gopath = build.Default.GOPATH
	}
	return gopath
}

func getInventoryString() string {
	gopath := getGoPath()

	filepath := fmt.Sprintf("%v/bin/terraform-inventory", gopath)
	cmd := exec.Command(filepath, "-inventory")
	cmd.Dir = getTerraformPath()

	out, err := cmd.Output()
	if err != nil {
		panic(err)
	}
	return string(out)
}

func main() {
	inventoryStr := getInventoryString()
	inventoryStr += `[k8s-cluster:children]
kube-node
kube-master`

	d1 := []byte(inventoryStr)
	err := ioutil.WriteFile("hosts.ini", d1, 0644)
	if err != nil {
		panic(err)
	}

	fmt.Println(inventoryStr)

}
