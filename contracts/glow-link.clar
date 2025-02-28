;; GlowLink Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-user-exists (err u101))
(define-constant err-user-not-found (err u102))
(define-constant err-invalid-skin-type (err u103))
(define-constant err-invalid-weather (err u104))

;; Valid values
(define-data-var valid-skin-types (list 5 (string-ascii 20)) (list "oily" "dry" "combination" "normal" "sensitive"))
(define-data-var valid-weather (list 5 (string-ascii 20)) (list "sunny" "rainy" "humid" "cold" "windy"))

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

;; Helper functions
(define-private (is-valid-skin-type (skin-type (string-ascii 20)))
  (unwrap! (index-of (var-get valid-skin-types) skin-type) false)
)

(define-private (is-valid-weather (weather (string-ascii 20)))
  (unwrap! (index-of (var-get valid-weather) weather) false)
)

;; Public Functions
(define-public (create-profile (skin-type (string-ascii 20)) (sensitivity uint))
  (let ((user tx-sender))
    (asserts! (is-valid-skin-type skin-type) err-invalid-skin-type)
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
    (asserts! (is-valid-weather weather) err-invalid-weather)
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
