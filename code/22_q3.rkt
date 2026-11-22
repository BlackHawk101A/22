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

;; ---------------------------------------------------------------
;; S1.b  Preorder, postorder, and all three traversals
;; ---------------------------------------------------------------

; preorder-acc : Tree List -> List
; Returns the preorder values of tree placed in front of acc.
; Base case: the empty tree adds nothing, so the result is acc.
; Recursive step: the right subtree's values go in front of acc, the
;   left subtree's values go in front of those, and the node's value
;   is consed on last, so it ends up first (node -> left -> right).
; Not tail-recursive: cons waits for the result of the left call.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (node-value tree)
            (preorder-acc (node-left tree)
                          (preorder-acc (node-right tree) acc)))))

; postorder-acc : Tree List -> List
; Returns the postorder values of tree placed in front of acc.
; Base case: the empty tree adds nothing, so the result is acc.
; Recursive step: the node's value is consed onto acc first (so it
;   ends up after both subtrees), then the right subtree's values go
;   in front of it, then the left subtree's (left -> right -> node).
; The outer call on the left subtree is a tail call.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (node-left tree)
                     (postorder-acc (node-right tree)
                                    (cons (node-value tree) acc)))))

; print-all-traversals : Tree -> Void
; Displays the inorder, preorder and postorder lists of tree,
; one per line, each followed by a newline.
(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))

;; ---------------------------------------------------------------
;; S1.c  Height and leaf count
;; ---------------------------------------------------------------

; height : Tree -> Number
; Base case: the empty tree has height 0.
; Recursive step: a node is 1 taller than the taller of its two
;   subtrees, so a single node has height 1 + max(0, 0) = 1.
; Not tail-recursive: + and max wait for both recursive results.
(define (height tree)
  (if (null? tree)
      0
      (+ 1 (max (height (node-left tree))
                (height (node-right tree))))))

; leaf? : Tree -> Boolean
; A leaf is a non-empty node whose left and right subtrees are both ().
; The empty tree is not a leaf.
(define (leaf? tree)
  (and (pair? tree)
       (null? (node-left tree))
       (null? (node-right tree))))

; leaf-count : Tree -> Number
; Base case: the empty tree has 0 leaves; a leaf counts as 1.
; Recursive step: any other node has as many leaves as its two
;   subtrees together (the node itself is not a leaf).
; Not tail-recursive: + waits for both recursive results.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((leaf? tree) 1)
        (else (+ (leaf-count (node-left tree))
                 (leaf-count (node-right tree))))))

; print-height-and-leaves : Tree -> Void
; Displays the list (height leaf-count) of tree, then a newline.
(define (print-height-and-leaves tree)
  (display (list (height tree) (leaf-count tree)))
  (newline))
