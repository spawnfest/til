---
title: Hello, World!
tags:
- hello-world
- tilhub
---

This is the beginning of an awesome new habit for me!

I'll be sharing all the things that I learn over the years through this medium.
Hopefully, this will serve as a useful resource to one of you folks!

Here is a y combinator in erlang for your reading pleasure.

```erlang
Y = fun(M) -> (fun(X) -> X(X) end)(fun (F) -> M(fun(A) -> (F(F))(A) end) end) end.

Fac = fun (F) ->
          fun (0) -> 1;
              (N) -> N * F(N-1)
          end
      end.
Fib = fun(F) ->
          fun(0) -> 0;
             (1) -> 1;
             (N) -> F(N-1) + F(N-2)
          end
      end.
(Y(Fac))(5). %% 120
(Y(Fib))(8). %% 21
```

The source for this is [https://rosettacode.org/wiki/Y_combinator#Erlang](https://rosettacode.org/wiki/Y_combinator#Erlang)

