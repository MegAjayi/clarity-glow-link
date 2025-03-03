;; Products Management Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-product-exists (err u101))
(define-constant err-empty-list (err u102))
(define-constant err-product-not-found (err u103))

;; Data Types
(define-map products
  principal
  {
    name: (string-ascii 50),
    category: (string-ascii 20),
    skin-types: (list 5 (string-ascii 20)),
    weather-suitable: (list 5 (string-ascii 20))
  }
)

;; Private Functions
(define-private (validate-lists (skin-types (list 5 (string-ascii 20))) (weather (list 5 (string-ascii 20))))
  (and (> (len skin-types) u0) (> (len weather) u0))
)

;; Public Functions
(define-public (add-product 
  (product-id principal)
  (name (string-ascii 50))
  (category (string-ascii 20))
  (skin-types (list 5 (string-ascii 20)))
  (weather (list 5 (string-ascii 20))))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-owner)
    (asserts! (is-none (map-get? products product-id)) err-product-exists)
    (asserts! (validate-lists skin-types weather) err-empty-list)
    (ok (map-set products
      product-id
      {
        name: name,
        category: category,
        skin-types: skin-types,
        weather-suitable: weather
      }
    ))
  )
)

(define-public (update-product 
  (product-id principal)
  (name (string-ascii 50))
  (category (string-ascii 20))
  (skin-types (list 5 (string-ascii 20)))
  (weather (list 5 (string-ascii 20))))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-owner)
    (asserts! (is-some (map-get? products product-id)) err-product-not-found)
    (asserts! (validate-lists skin-types weather) err-empty-list)
    (ok (map-set products
      product-id
      {
        name: name,
        category: category,
        skin-types: skin-types,
        weather-suitable: weather
      }
    ))
  )
)

;; Read Only Functions
(define-read-only (get-product (product-id principal))
  (ok (map-get? products product-id))
)
