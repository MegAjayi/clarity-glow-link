;; GlowLink Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-user-exists (err u101))
(define-constant err-user-not-found (err u102))
(define-constant err-invalid-skin-type (err u103))
(define-constant err-invalid-weather (err u104))
(define-constant err-invalid-sensitivity (err u105))
(define-constant max-sensitivity u10)

;; [Previous constants and data vars remain the same...]

;; Helper functions
(define-private (validate-sensitivity (sensitivity uint))
  (<= sensitivity max-sensitivity)
)

;; [Previous helper functions remain the same...]

;; Public Functions
(define-public (create-profile (skin-type (string-ascii 20)) (sensitivity uint))
  (let ((user tx-sender))
    (asserts! (is-valid-skin-type skin-type) err-invalid-skin-type)
    (asserts! (validate-sensitivity sensitivity) err-invalid-sensitivity)
    (asserts! (is-none (map-get? users user)) err-user-exists)
    (ok (map-set users 
      user 
      {
        skin-type: skin-type,
        sensitivity: sensitivity,
        created-at: block-height
      }
    ))
  )
)

;; [Rest of the contract remains the same...]
