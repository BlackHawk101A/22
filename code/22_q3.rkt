#lang racket/base

;; S1: Binary Tree Traversals
;; A tree is either () or a three-element list (value left right).

;; ---------------------------------------------------------------
;; Tree accessors
;; ---------------------------------------------------------------

; node-value : Tree -> Value
; The first element of a non-empty node (value left right).
(define (node-value tree) (car tree))

; node-left : Tree -> Tree
; The second element of a non-empty node: its left subtree.
(define (node-left tree) (cadr tree))

; node-right : Tree -> Tree
; The third element of a non-empty node: its right subtree.
(define (node-right tree) (caddr tree))

;; ---------------------------------------------------------------
;; S1.a  Inorder traversal
;; ---------------------------------------------------------------

; inorder-acc : Tree List -> List
; Returns the inorder values of tree placed in front of acc.
; Base case: the empty tree adds nothing, so the result is acc.
; Recursive step: first put the right subtree's values in front of acc,
;   then cons the node's value in front of those, then put the left
;   subtree's values in front of everything. Because cons always adds
;   to the front, working right -> node -> left leaves the final list
;   in left -> node -> right order, so no append or reverse is needed.
; The outer call on the left subtree is a tail call; the inner call on
;   the right subtree is not (its result is still needed by cons).
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (node-left tree)
                   (cons (node-value tree)
                         (inorder-acc (node-right tree) acc)))))

; print-inorder : Tree -> Void
; Displays the inorder list of tree on one line, then a newline.
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))
