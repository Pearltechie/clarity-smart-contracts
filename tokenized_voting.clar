(define-token stx-token)

(define-map proposal-votes (string) (int))

(define-public (create-proposal (title string))
  (begin
    (print (concat "New proposal created: " title))
    (ok "Proposal created successfully")
  )
)

(define-public (vote (proposal-title string) (vote-weight int))
  (let (
        (existing-votes (map-get? proposal-votes proposal-title))
        (new-vote (+ (unwrap! existing-votes 0) vote-weight))
      )
    (map-set proposal-votes proposal-title new-vote)
    (print (concat "You voted with " (as-string vote-weight) " tokens"))
    (ok "Vote successful")
  )
)

(define-public (get-votes (proposal-title string))
  (let (
        (votes (map-get? proposal-votes proposal-title))
      )
    (ok (unwrap! votes 0))
  )
)
