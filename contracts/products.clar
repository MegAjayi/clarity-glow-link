;; Products Management Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-product-exists (err u101))

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

;; Public Functions
(define-public (add-product 
  (product-id principal)
  (name (string-ascii 50))
  (category (string-ascii 20))
  (skin-types (list 5 (string-ascii 20)))
  (weather (list 5 (string-ascii 20))))
  (if (is-eq tx-sender contract-owner)
    (if (is-some (map-get? products product-id))
      err-product-exists
      (ok (map-set products
        product-id
        {
          name: name,
          category: category,
          skin-types: skin-types,
          weather-suitable: weather
        }
      )))
    err-not-owner
  )
)

;; Read Only Functions
(define-read-only (get-product (product-id principal))
  (ok (map-get? products product-id))
)
