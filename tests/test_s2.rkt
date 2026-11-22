#lang racket/base
;; Tests for S2 (code/22_q4.rkt).
;; Run from the repository root:   racket tests/22_s2_tests.rkt
;; Prints one line per failing test and a summary. Exit code is 1 on failure.
;;
;; The solution file has no `provide` (it must contain only definitions), so
;; this file instantiates the module and reaches its definitions through
;; module->namespace. Tests may use any Racket feature; only the solution
;; file is restricted to the assignment's built-ins.

(define solution-path
  (let-values ([(base name dir?)
                (split-path (variable-reference->module-source
                             (#%variable-reference)))])
    (simplify-path (build-path base 'up "code" "22_q4.rkt"))))

(dynamic-require solution-path #f)
(define ns (module->namespace solution-path))

(define (call expr) (eval expr ns))

(define passed 0)
(define failed 0)

(define (check name actual expected)
  (if (equal? actual expected)
      (set! passed (+ passed 1))
      (begin
        (set! failed (+ failed 1))
        (display "FAIL: ") (display name) (newline)
        (display "  expected: ") (write expected) (newline)
        (display "  actual:   ") (write actual) (newline))))

;; (ins x lst n) calls insert-if-short on quoted data.
(define (ins x lst n)
  (call (list 'insert-if-short (list 'quote x) (list 'quote lst) n)))

;; Feeds `input` to print-insert-result on stdin and returns what it printed.
(define (run-print input)
  (let ([out (open-output-string)])
    (parameterize ([current-input-port (open-input-string input)]
                   [current-output-port out])
      (call '(print-insert-result)))
    (get-output-string out)))

;; ---- Examples from the assignment (S2.a: stdin -> stdout) ----
(check "ex1 print" (run-print "42 ((1 2) (3 4 5) (6) ()) 3")
       "((42 1 2) (3 4 5) (42 6) (42))\n")
(check "ex2 print" (run-print "0 (((1) 2) (3) ((4 5 6) ())) 3")
       "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
(check "ex3 print" (run-print "7 () 3") "(7)\n")
(check "ex4 print" (run-print "7 () 0") "()\n")

;; ---- Examples from the assignment (S2.b / S2.c: insert-if-short) ----
(check "ex1" (ins 42 '((1 2) (3 4 5) (6) ()) 3) '((42 1 2) (3 4 5) (42 6) (42)))
(check "ex2" (ins 0 '(((1) 2) (3) ((4 5 6) ())) 3)
       '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))
(check "ex3" (ins 7 '() 3) '(7))
(check "ex4" (ins 7 '() 0) '())

;; ---- Edge cases ----
(check "empty top, n=1" (ins 7 '() 1) '(7))
(check "n=0 changes nothing" (ins 7 '(1 (2) ()) 0) '(1 (2) ()))
(check "length tested on original, not after insertion"
       (ins 9 '(1 2) 3) '(9 1 2))
(check "list of exactly n elements is untouched" (ins 9 '(1 2 3) 3) '(1 2 3))
(check "nested empty lists" (ins 'x '(() (())) 2) '((x) (x (x))))
(check "symbols as elements and as x" (ins 'z '(a (b) c) 4) '(z a (z b) c))
(check "x is a digit atom" (ins 0 '(1) 5) '(0 1))
(check "large n inserts everywhere" (ins 'q '((1) (2 (3))) 100)
       '(q (q 1) (q 2 (q 3))))

;; ---- Helpers ----
(check "my-length empty" (call '(my-length '())) 0)
(check "my-length mixed" (call '(my-length '(1 (2 3) () a))) 4)
(check "my-map empty" (call '(my-map (lambda (v) (+ v 1)) '())) '())
(check "my-map keeps order" (call '(my-map (lambda (v) (* v v)) '(1 2 3))) '(1 4 9))
(check "my-list? '()" (call '(my-list? '())) #t)
(check "my-list? pair" (call '(my-list? '(1))) #t)
(check "my-list? atom" (call '(my-list? 5)) #f)
(check "my-list? symbol" (call '(my-list? 'a)) #f)

;; ---- make-inserter (S2.c) ----
(check "make-inserter, even lengths only"
       ((call '(make-inserter 'e (lambda (k) (= k 2)))) '((1 2) (3) (4 5)))
       '((e 1 2) (3) (e 4 5)))
(check "make-inserter, always true"
       ((call '(make-inserter 0 (lambda (k) #t))) '(1 (2)))
       '(0 1 (0 2)))
(check "make-inserter, always false"
       ((call '(make-inserter 0 (lambda (k) #f))) '(1 (2)))
       '(1 (2)))

;; ---- Hidden-test sizes: nesting depth 100, 10,000 elements ----
(define (nest depth inner)
  (if (= depth 0) inner (list (nest (- depth 1) inner))))

(define deep-in (nest 100 '(1)))
(define (expected-deep depth)           ; every list has length 1 < 5
  (if (= depth 0) '(0 1) (list 0 (expected-deep (- depth 1)))))
(check "depth 100" (ins 0 deep-in 5) (expected-deep 100))

(define (iota-list k)
  (let loop ([i k] [acc '()]) (if (= i 0) acc (loop (- i 1) (cons i acc)))))
(define big (iota-list 10000))
(check "10000 elements, n=10001" (ins 'x big 10001) (cons 'x big))
(check "10000 elements, n=10000" (ins 'x big 10000) big)

(define big-nested (list big big))      ; top has 2 elements, each has 10000
(check "10000-element sublists"
       (ins 'x big-nested 3) (list 'x big big))

;; ---- Summary ----
(display passed) (display " passed, ")
(display failed) (display " failed") (newline)
(when (> failed 0) (exit 1))
