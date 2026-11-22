#lang racket/base

;; ---------------------------------------------------------------
;; S2: Conditionally insert into a nested list
;; Only the built-ins allowed by the assignment are used.
;; ---------------------------------------------------------------

;; Signature: (my-length lst) -> integer
;; Recursive reading: the length of '() is 0; the length of a
;; non-empty list is one more than the length of its cdr. The loop
;; carries the count in an accumulator.
;; Tail-recursive: yes. The recursive call (loop ...) is the last
;; thing done in each branch, so nothing waits on its result.
(define (my-length lst)
  (let loop ((rest lst) (count 0))
    (if (null? rest)
        count
        (loop (cdr rest) (+ count 1)))))

;; Signature: (my-map f lst) -> list
;; Recursive reading: mapping f over '() gives '(); mapping f over a
;; non-empty list is (f first) consed onto the map over the rest.
;; Tail-recursive: no. The cons is applied after the recursive call
;; returns. Racket grows its continuation on the heap, so lists of
;; 10,000 elements and nesting of depth 100 are safe.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst)) (my-map f (cdr lst)))))

;; Signature: (my-list? e) -> boolean
;; Recursive reading: not recursive. A list is '() or a pair. Every
;; other element is an atom (there are no dotted pairs).
;; Tail-recursive: not applicable (no recursion).
(define (my-list? e)
  (or (null? e) (pair? e)))

;; Signature: (make-inserter x len-ok?) -> (list -> list)
;; Recursive reading: returns insert-all. insert-all of a list first
;; rebuilds every element (sublists via insert-all, atoms unchanged),
;; then conses x onto the front if len-ok? accepts the length of the
;; ORIGINAL list, so insertions never affect the length test.
;; Tail-recursive: no. The recursion happens inside my-map and the
;; results are combined with cons afterwards.
(define (make-inserter x len-ok?)
  (letrec ((insert-all
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (e)
                               (if (my-list? e) (insert-all e) e))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert-all))

;; Signature: (insert-if-short x lst n) -> list
;; Recursive reading: build an inserter that accepts lengths < n and
;; apply it to lst.
;; Tail-recursive: not applicable (delegates to make-inserter).
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (k) (< k n))) lst))

;; Signature: (print-insert-result) -> prints one line
;; Recursive reading: not recursive. Read x, lst, n in that order
;; from standard input, then display the result and a newline.
;; let* guarantees the reading order.
;; Tail-recursive: not applicable (no recursion).
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
