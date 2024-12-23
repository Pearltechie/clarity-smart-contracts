(define-constant TOTAL_SUPPLY 1000000)

(define-map balances (principal) (uint))

(define-public (mint (amount uint))
  (begin
    (let ((caller (contract-caller)))
      (let ((current-balance (default-to 0 (map-get? balances caller))))
        (map-set balances caller (+ current-balance amount))
        (ok "Tokens minted successfully")
      )
    )
  )
)

(define-public (transfer (to principal) (amount uint))
  (begin
    (let ((caller (contract-caller))
          (caller-balance (default-to 0 (map-get? balances caller))))
      (asserts! (>= caller-balance amount) (err "Insufficient balance"))
      (map-set balances caller (- caller-balance amount))
      (let ((receiver-balance (default-to 0 (map-get? balances to))))
        (map-set balances to (+ receiver-balance amount))
        (ok "Transfer successful")
      )
    )
  )
)

(define-public (balance-of (account principal))
  (ok (default-to 0 (map-get? balances account)))
)
