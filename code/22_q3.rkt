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

;; inorder-list : tree -> list
;; Returns the values of tree in inorder (left, node, right) using
;; right-to-left accumulator passing so no list concatenation is needed.
(define (inorder-list tree)
  (let loop ((t tree) (acc '()))
    (if (null? t)
        acc
        (loop (node-left t)
              (cons (node-val t)
                    (loop (node-right t) acc))))))

;; print-inorder : tree -> void
;; Prints the inorder traversal list of tree on one line followed by a newline.
(define (print-inorder tree)
  (display (inorder-list tree))
  (newline))