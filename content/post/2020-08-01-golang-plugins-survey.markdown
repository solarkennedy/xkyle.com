---
title: "A Survey of Golang 'plugins' in 2020"
date: 2020-08-01T00:00:00-00:00
---

For the purpose of this blog post, my definition of plugin is:

> A method of extending the functionality of program without forking it

In particular, I'll be looking at methods of extending Golang (go) programs.

## Official Golang Plugins

[Official Golang Plugins](https://golang.org/pkg/plugin/) are a native way of extending go codebases without forking them.

#### How They Work

Official Golang Plugins work by compiling your plugin in a special way:

    go build -buildmode=plugin

This build mode can output a `.so` file with symbols that a "main" program can load dynamically. A quick example would look like with your plugin code:

```golang
package main

import "fmt"

var PluginInputNumber int

func KnownPluginFunction() { fmt.Printf("My custom code prints PluginInputNumber: %d\n", PluginInputNumber) }
```

And then the "main" code would load plugins and operate on known functions:

```golang
p, _ := plugin.Open("myplugin.so")
in, _ := p.Lookup("PluginInputNumber")
f, _ := p.Lookup("KnownPluginFunction")
*in.(*int) = 7
f.(func())() // prints "My custom code prints PluginInputNumber: 7"
```

#### Pros

* In the golang stdlib. Simple and sparse.
* High performance, it is just calling functions in a library using native interfaces

#### Cons

* Plugins can crash the main loop
* Linux, FreeBSD, and macOS [only](https://github.com/golang/go/issues/19282)
* Plugins and the main program must be built in the [exact same environment](https://www.reddit.com/r/golang/comments/b6h8qq/is_anyone_actually_using_go_plugins/ejkxd2k?utm_source=share&utm_medium=web2x). (same golang version, mod dependencies, go path, cgo)

#### Examples

* [Krakend](https://www.krakend.io/blog/krakend-golang-plugins/)
* [Gotify](https://gotify.net/docs/plugin-write)
* [(add more?)](https://github.com/solarkennedy/xkyle.com/edit/master/content/post/2020-08-01-golang-plugins-survey.markdown)

## Hashicorp go-plugin

[Hashicorp go-plugin](https://github.com/hashicorp/go-plugin) is the method that Hashicorp uses in many of its products to support extending them.

#### How They Work

Hashicorp go-plugin works by having the main process spawn the plugin as a separate process and communicate with it over gRPC (via http2, or a few other options). This communication usually happens over a unix socket or localhost. This is a more full-featured version of [pie](https://github.com/natefinch/pie).

#### Pros

* Writing plugins feels natural because you are talking to a golang interface
* Cross-platform and cross-language (it is "just" gRPC over a socket)
* Logging, stdout/err, and even TTYs are transparently preserved!
* Plugins can be versioned to help support backwards-compatible changes
* Plugins cannot crash the main program and can even be hot-reloaded

#### Cons

* Lower performance than dynamic library function calls (native golang plugins)

#### Examples

* [Kubernetes Auth Vault Plugin](https://github.com/hashicorp/vault-plugin-auth-kubernetes)
* Any of the Terraform [first-party providers](https://www.terraform.io/docs/providers/index.html) or [third-party providers](https://www.terraform.io/docs/providers/type/community-index.html)
* [(add more?)](https://github.com/solarkennedy/xkyle.com/edit/master/content/post/2020-08-01-golang-plugins-survey.markdown)

## Kubernetes-Scheduler-Style Plugins

The [Kubernetes Scheduler has a framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/) for writing your own plugins to the Kubernetes scheduler (but not to any other Kubernetes component at the time of this writing).

#### How They Work

These k8s plugins work by wrapping the main kubernetes scheduler binary with a special invocation:

```golang
func main() {
	command := app.NewSchedulerCommand(
		app.WithPlugin(coscheduling.Name, coscheduling.New),
		app.WithPlugin(qos.Name, qos.New),
	)
	if err := command.Execute(); err != nil {
		os.Exit(1)
    }
}
```

The resulting binary is a mono-binary of both your and the k8s code. It is kinda like the k8s code will "inherit" the functions you overwrite:

```golang
// Less is the function used by the activeQ heap algorithm to sort pods.
// It sorts pods based on their priorities. When the priorities are equal, it uses
// the Pod QoS classes to break the tie.
func (*Sort) Less(pInfo1, pInfo2 *framework.PodInfo) bool {
	p1 := pod.GetPodPriority(pInfo1.Pod)
	p2 := pod.GetPodPriority(pInfo2.Pod)
	return (p1 > p2) || (p1 == p2 && compQOS(pInfo1.Pod, pInfo2.Pod))
}
```

It is kinda a stretch to call these plugins, but it does allow you to extend Kubernetes without actually forking the codebase.

#### Pros

* Simpler interface.
* No real magic, just normal go code

#### Cons

* Nothing fancy, you have to compile the main program and your plugin together as a single binary.
* You must compile the whole binary yourself, you cannot use a pre-packaged binary and connect to it.

#### Examples

* [QOS Sorter](https://github.com/kubernetes-sigs/scheduler-plugins/tree/master/pkg/qos)
* ["PodGroup" Co-Scheduler](https://github.com/kubernetes-sigs/scheduler-plugins/tree/master/pkg/coscheduling)
* [Admiraltiy.io Multicluster-Scheduler](https://github.com/admiraltyio/multicluster-scheduler)
* [(add more?)](https://github.com/solarkennedy/xkyle.com/edit/master/content/post/2020-08-01-golang-plugins-survey.markdown)