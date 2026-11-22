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


;; preorder-list : tree -> list
;; Returns the values of tree in preorder (node, left, right) using
;; right-to-left accumulator passing.
(define (preorder-list tree)
  (let loop ((t tree) (acc '()))
    (if (null? t)
        acc
        (cons (node-val t)
              (loop (node-left t)
                    (loop (node-right t) acc))))))

;; postorder-list : tree -> list
;; Returns the values of tree in postorder (left, right, node) using
;; right-to-left accumulator passing.
(define (postorder-list tree)
  (let loop ((t tree) (acc '()))
    (if (null? t)
        acc
        (loop (node-left t)
              (loop (node-right t)
                    (cons (node-val t) acc))))))

;; print-all-traversals : tree -> void
;; Prints the inorder, preorder, and postorder traversal lists of tree on three lines.
(define (print-all-traversals tree)
  (display (inorder-list tree))
  (newline)
  (display (preorder-list tree))
  (newline)
  (display (postorder-list tree))
  (newline))


;; tree-height : tree -> integer
;; Returns the height of tree (0 for empty tree, 1 + max height of children otherwise).
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (node-left tree))
                (tree-height (node-right tree))))))

;; leaf-count : tree -> integer
;; Returns the number of leaves in tree tail-recursively using a worklist accumulator.
(define (leaf-count tree)
  (let loop ((stack (if (null? tree) '() (list tree)))
             (acc 0))
    (if (null? stack)
        acc
        (let* ((curr (car stack))
               (rest (cdr stack))
               (left (node-left curr))
               (right (node-right curr)))
          (cond ((and (null? left) (null? right))
                 (loop rest (+ acc 1)))
                ((null? left)
                 (loop (cons right rest) acc))
                ((null? right)
                 (loop (cons left rest) acc))
                (else
                 (loop (cons left (cons right rest)) acc)))))))

;; print-height-and-leaves : tree -> void
;; Prints the list (height leaf-count) on one line followed by a newline.
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (leaf-count tree)))
  (newline))