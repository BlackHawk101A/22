#lang racket/base
;; Tests for S1 (code/22_q3.rkt). Run with: raco test tests/test_s1.rkt
;; The solution file has no provide, so we load it and look its
;; functions up in its module namespace.

(require rackunit
         racket/port
         racket/runtime-path)

(define-runtime-path solution "../code/22_q3.rkt")
(dynamic-require solution #f)
(define ns (module->namespace solution))
(define (get name) (eval name ns))

(define print-inorder           (get 'print-inorder))
(define print-all-traversals    (get 'print-all-traversals))
(define print-height-and-leaves (get 'print-height-and-leaves))

;; Runs (f tree) and returns everything it printed as one string.
(define (output-of f tree)
  (with-output-to-string (lambda () (f tree))))

;; ---------------------------------------------------------------
;; Trees from the spec
;; ---------------------------------------------------------------
(define t1 '(4 (2 (1 () ()) (3 () ()))
               (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

;; ---------------------------------------------------------------
;; Spec examples
;; ---------------------------------------------------------------
(test-case "S1.a inorder - spec examples"
  (check-equal? (output-of print-inorder t1) "(1 2 3 4 5 6 7)\n")
  (check-equal? (output-of print-inorder '()) "()\n"))

(test-case "S1.b all traversals - spec examples"
  (check-equal? (output-of print-all-traversals t1)
                "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
  (check-equal? (output-of print-all-traversals t2)
                "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
  (check-equal? (output-of print-all-traversals t3)
                "(b a c)\n(a b c)\n(b c a)\n")
  (check-equal? (output-of print-all-traversals '())
                "()\n()\n()\n"))

(test-case "S1.c height and leaves - spec examples"
  (check-equal? (output-of print-height-and-leaves t1) "(3 4)\n")
  (check-equal? (output-of print-height-and-leaves t2) "(3 1)\n")
  (check-equal? (output-of print-height-and-leaves t3) "(2 2)\n")
  (check-equal? (output-of print-height-and-leaves '()) "(0 0)\n"))

;; ---------------------------------------------------------------
;; Edge cases
;; ---------------------------------------------------------------
(test-case "single node: height 1, one leaf, all traversals equal"
  (check-equal? (output-of print-all-traversals '(5 () ()))
                "(5)\n(5)\n(5)\n")
  (check-equal? (output-of print-height-and-leaves '(5 () ())) "(1 1)\n"))

(test-case "left-only chain (mirror of t2)"
  (define left-chain '(3 (2 (1 () ()) ()) ()))
  (check-equal? (output-of print-all-traversals left-chain)
                "(1 2 3)\n(3 2 1)\n(1 2 3)\n")
  (check-equal? (output-of print-height-and-leaves left-chain) "(3 1)\n"))

(test-case "node with one child is not a leaf"
  (check-equal? (output-of print-height-and-leaves '(1 (2 () ()) ()))
                "(2 1)\n"))

(test-case "unbalanced mixed tree with symbols"
  ;;        m
  ;;       / \
  ;;      f   t
  ;;       \
  ;;        h
  (define t '(m (f () (h () ())) (t () ())))
  (check-equal? (output-of print-all-traversals t)
                "(f h m t)\n(m f h t)\n(h f t m)\n")
  (check-equal? (output-of print-height-and-leaves t) "(3 2)\n"))

;; Builds a right-leaning chain 1 -> 2 -> ... -> n (test helper only).
(define (right-chain i n)
  (if (> i n) '() (list i '() (right-chain (+ i 1) n))))

(test-case "deep chain (depth 1000) does not overflow"
  (define deep (right-chain 1 1000))
  (check-equal? (output-of print-height-and-leaves deep) "(1000 1)\n")
  (check-equal? (output-of print-inorder (right-chain 1 5))
                "(1 2 3 4 5)\n"))
