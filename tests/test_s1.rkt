#lang racket

(require rackunit
         racket/port
         racket/runtime-path)

(define-runtime-path q3-path "../code/22_q3.rkt")

(dynamic-require q3-path #f)
(define ns (module->namespace q3-path))

(define (run-in-q3 expr)
  (eval expr ns))

(define t1
  '(4 (2 (1 () ()) (3 () ()))
      (6 (5 () ()) (7 () ()))))

(define t2
  '(1 () (2 () (3 () ()))))

(define t3
  '(a (b () ()) (c () ())))

(define t-single
  '(42 () ()))

;; S1.a: print-inorder
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-inorder ',t1))))
              "(1 2 3 4 5 6 7)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-inorder ',t2))))
              "(1 2 3)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-inorder ',t3))))
              "(b a c)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-inorder ',t-single))))
              "(42)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-inorder '()))))
              "()\n")

;; S1.b: print-all-traversals
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-all-traversals ',t1))))
              "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-all-traversals ',t2))))
              "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-all-traversals ',t3))))
              "(b a c)\n(a b c)\n(b c a)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-all-traversals ',t-single))))
              "(42)\n(42)\n(42)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-all-traversals '()))))
              "()\n()\n()\n")

;; S1.c: print-height-and-leaves
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-height-and-leaves ',t1))))
              "(3 4)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-height-and-leaves ',t2))))
              "(3 1)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-height-and-leaves ',t3))))
              "(2 2)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-height-and-leaves ',t-single))))
              "(1 1)\n")
(check-equal? (with-output-to-string (lambda () (run-in-q3 `(print-height-and-leaves '()))))
              "(0 0)\n")

(displayln "All S1 tests passed!")