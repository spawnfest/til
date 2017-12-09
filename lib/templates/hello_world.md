---
title: Hello, World!
date: 2017-12-09
tags:
- hello-world
- tilhub
---

This is the beginning of an awesome new habit for me!

I'll be sharing all the things that I learn over the years through this medium.
Hopefully, this will serve as a useful resource to one of you folks!

Here is a y combinator in clojure for your reading pleasure.

```clojure
(defn Y [f]
  ((fn [x] (x x))
   (fn [x]
     (f (fn [& args]
          (apply (x x) args))))))

(def fac
     (fn [f]
       (fn [n]
         (if (zero? n) 1 (* n (f (dec n)))))))

(def fib
     (fn [f]
       (fn [n]
         (condp = n
           0 0
           1 1
           (+ (f (dec n))
              (f (dec (dec n))))))))
```

The source for this is https://rosettacode.org/wiki/Y_combinator#Clojure

