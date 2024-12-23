(define-constant VOTING_PERIOD 604800) ; 7 days in seconds

(define-public (initialize-voting)
  (begin
    (let ((start-time (get-block-time))
          (end-time (+ start-time VOTING_PERIOD))) ; Voting ends after 7 days
      (map-set u"voting-period" u"start-time" start-time)
      (map-set u"voting-period" u"end-time" end-time)
      (ok "Voting initialized")
    )
  )
)

(define-public (cast-vote (candidate principal))
  (begin
    (asserts! (is-voting-active?) (err "Voting period has ended"))
    (let ((voter (contract-caller)))
      (map-set u"votes" voter candidate)
      (ok "Vote cast successfully")
    )
  )
)

(define-private (is-voting-active?)
  (let ((end-time (map-get u"voting-period" u"end-time")))
    (is-less-than? (get-block-time) end-time)
  )
)

(define-public (get-votes (candidate principal))
  (ok (map-get u"votes" candidate))
)


