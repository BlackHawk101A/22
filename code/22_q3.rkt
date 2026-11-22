#lang racket

;; node-val : non-empty-tree -> value
;; Returns the root value stored in a non-empty binary tree node (value left right).
(define (node-val tree)
  (car tree))

;; node-left : non-empty-tree -> tree
;; Returns the left subtree of a non-empty binary tree node.
(define (node-left tree)
  (cadr tree))

;; node-right : non-empty-tree -> tree
;; Returns the right subtree of a non-empty binary tree node.
(define (node-right tree)
  (caddr tree))

;; my-reverse : list -> list
;; Reverses a list tail-recursively using an accumulator.
(define (my-reverse lst)
  (let loop ((rem lst) (acc '()))
    (if (null? rem)
        acc
        (loop (cdr rem) (cons (car rem) acc)))))

;; my-append : list list -> list
;; Concatenates xs and ys tail-recursively by reversing xs onto ys.
(define (my-append xs ys)
  (let loop ((rev-xs (my-reverse xs)) (acc ys))
    (if (null? rev-xs)
        acc
        (loop (cdr rev-xs) (cons (car rev-xs) acc)))))

