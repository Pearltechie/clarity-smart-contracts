(define-token stx-token)

(define-map campaigns (string) (tuple (int) (int) (int)))  ; (goal, total-contributed, deadline)

(define-public (create-campaign (title string) (goal int) (deadline int))
  (begin
    (if (is-none? (map-get? campaigns title))
      (begin
        (map-set campaigns title (tuple goal 0 deadline))
        (ok "Campaign created successfully"))
      (err "Campaign already exists"))
  )
)

(define-public (contribute (title string) (amount int))
  (let (
        (campaign (unwrap! (map-get? campaigns title) (err "Campaign not found")))
        (goal (get 0 campaign))
        (total-contributed (get 1 campaign))
        (deadline (get 2 campaign))
        (current-time (as-int (block-height)))
      )
    (if (<= current-time deadline)
      (begin
        (map-set campaigns title (tuple goal (+ total-contributed amount) deadline))
        (ok "Contribution successful"))
      (err "Campaign has ended"))
  )
)

(define-public (withdraw (title string))
  (let (
        (campaign (unwrap! (map-get? campaigns title) (err "Campaign not found")))
        (goal (get 0 campaign))
        (total-contributed (get 1 campaign))
        (deadline (get 2 campaign))
        (current-time (as-int (block-height)))
      )
    (if (and (> current-time deadline) (= goal total-contributed))
      (begin
        (ok "Funds withdrawn successfully"))
      (err "Goal not met or campaign still active"))
  )
)

(define-public (refund (title string))
  (let (
        (campaign (unwrap! (map-get? campaigns title) (err "Campaign not found")))
        (goal (get 0 campaign))
        (total-contributed (get 1 campaign))
        (deadline (get 2 campaign))
        (current-time (as-int (block-height)))
      )
    (if (and (> current-time deadline) (< total-contributed goal))
      (begin
        (ok "Refund successful"))
      (err "Goal met or campaign still active"))
  )
)
