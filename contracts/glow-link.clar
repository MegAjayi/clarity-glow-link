;; GlowLink Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-user-exists (err u101))
(define-constant err-user-not-found (err u102))

;; Data Types
(define-map users 
  principal 
  {
    skin-type: (string-ascii 20),
    sensitivity: uint,
    created-at: uint
  }
)

(define-map routines
  principal
  {
    morning: (list 10 principal),
    evening: (list 10 principal),
    weather-condition: (string-ascii 20)
  }
)

;; Public Functions
(define-public (create-profile (skin-type (string-ascii 20)) (sensitivity uint))
  (let ((user tx-sender))
    (if (is-some (map-get? users user))
      err-user-exists
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
)

(define-public (update-routine (morning (list 10 principal)) (evening (list 10 principal)) (weather (string-ascii 20)))
  (let ((user tx-sender))
    (if (is-none (map-get? users user))
      err-user-not-found
      (ok (map-set routines
        user
        {
          morning: morning,
          evening: evening,
          weather-condition: weather
        }
      ))
    )
  )
)

;; Read Only Functions
(define-read-only (get-profile (user principal))
  (ok (map-get? users user))
)

(define-read-only (get-routine (user principal))
  (ok (map-get? routines user))
)
