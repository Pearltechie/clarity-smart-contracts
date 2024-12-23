(define-token stx-token)

(define-map trades (string) (tuple (principal) (string) (int) (bool)))  ; (buyer, asset, price, confirmed)

(define-public (create-trade (trade-id string) (asset string) (price int) (seller principal))
  (begin
    (if (is-none? (map-get? trades trade-id))
      (begin
        (map-set trades trade-id (tuple seller asset price false))
        (ok "Trade created successfully"))
      (err "Trade ID already exists"))
  )
)

(define-public (start-trade (trade-id string) (amount int))
  (let (
        (trade (unwrap! (map-get? trades trade-id) (err "Trade not found")))
        (seller (get 0 trade))
        (asset (get 1 trade))
        (price (get 2 trade))
        (confirmed (get 3 trade))
      )
    (if (and (not confirmed) (= price amount))
      (begin
        (ok "Trade started, waiting for buyer's confirmation"))
      (err "Invalid amount or trade already confirmed"))
  )
)

(define-public (confirm-receipt (trade-id string))
  (let (
        (trade (unwrap! (map-get? trades trade-id) (err "Trade not found")))
        (seller (get 0 trade))
        (asset (get 1 trade))
        (price (get 2 trade))
        (confirmed (get 3 trade))
      )
    (if (not confirmed)
      (begin
        (map-set trades trade-id (tuple seller asset price true))
        (ok "Trade confirmed, payment released to seller"))
      (err "Trade already confirmed"))
  )
)

(define-public (refund (trade-id string))
  (let (
        (trade (unwrap! (map-get? trades trade-id) (err "Trade not found")))
        (seller (get 0 trade))
        (asset (get 1 trade))
        (price (get 2 trade))
        (confirmed (get 3 trade))
      )
    (if (and (not confirmed) (> (as-int (block-height)) (+ (as-int (block-height)) 100)))
      (begin
        (map-set trades trade-id (tuple seller asset price true))
        (ok "Refund successful"))
      (err "Trade confirmed or refund period expired"))
  )
)
