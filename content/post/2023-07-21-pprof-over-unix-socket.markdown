---
title: "Using golang's pprof over a Unix Socket"
date: 2023-07-21T00:00:00-00:00
---

## Python Manhole

When working with a complex python daemon, I really appreciated the [`python-manhole`](https://github.com/ionelmc/python-manhole) library.
This tool allows you to listen on a Unix domain socket, and serve a REPL, get stack traces, and more.

From the README, it is as simple as this:

Install it:

    pip install manhole

Add it to your python code somewhere in the start sequence:

```python
import manhole
...
def main():
    manhole.install() # this will start the daemon thread
    ...
    # and now you start your app, eg: server.serve_forever()
```

And then connect to it:

```
$ nc -U /tmp/manhole-1234

Python 2.7.3 (default, Apr 10 2013, 06:20:15)
[GCC 4.6.3] on linux2
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> dir()
['__builtins__', 'dump_stacktraces', 'os', 'socket', 'sys', 'traceback']
>>> print 'foobar'
foobar
```

On a live system this can be a godsend.
It doesn't require running a webserver, and it can be as secure as normal unix file permissions on the server.

Is there anything like this for Golang?

## Golang Cannula

No.
Fundamentally golang is a compiled language, you won't be able to exactly get a REPL.

Using the [delve](https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_attach.md) debugger, you can debug a golang process in real time, but I would not recommend this for production systems.

Golang's [`pprof`](https://go.dev/blog/pprof) tool is the standard way to get stack traces, flame graphs, heap dumps, and more from a running golang process.
But it requires a webserver ([instructions](https://pkg.go.dev/net/http/pprof#pkg-overview)).
What if we don't want a webserver?

[Cannulla](https://github.com/retailnext/cannula) is a library, sorta like `python-manhole`, which exposes a pprof server as a Unix socket.

### Getting Started With Cannula

You can load Cannula like this:

```go
package main

import (
    github.com/retailnext/cannula
)

func main() {
    path := "/tmp/pprof-cannula.sock"
    go canulla.Start(path)
    ...
}
```

The Cannula library itself is small enough to be able to vendor yourself and customize to your needs.
For example you could add the PID into the path to make it unique for each process, making it easier to pick the right socket.

Once started, you can use curl to access it directly:

    curl --unix-socket /tmp/pprof-cannula.sock 'http:/debug/pprof/goroutine?debug=1'

But it would be also nice to use the native `go tool pprof` command.
To that, just start `socat` to proxy to the socket:

    socat TCP-LISTEN:1337,reuseaddr,fork UNIX-CONNECT:/tmp/pprof-cannula.sock
    go tool pprof  http://127.0.0.1:1337/debug/pprof/heap

Because we are only exposing a socket, the permissions of that `.sock` file are all we need to worry about.
There is no risk of us exposing `/debug` to the world.

## Conclusion

Having `pprof` enabled on a production golang process can be extremly valuable.
Just like `python-manhole` or Java JMX, you never know when you are going to need to attach to a live process and see what is using up all the ram.

But I don't really like running webservers to host this data, so I'll be adding `cannula` to all my golang projects to get the benefits of `pprof` without having to exposing a port or dealing with the default golang http Mux.