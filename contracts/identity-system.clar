;; Decentralized Identity & Credential Verification System
;; A comprehensive platform for self-sovereign identity management, verifiable credentials, and reputation systems

;; =============================================================================
;; CONSTANTS & ERROR CODES
;; =============================================================================

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u1001))
(define-constant ERR_INVALID_INPUT (err u1002))
(define-constant ERR_IDENTITY_NOT_FOUND (err u1003))
(define-constant ERR_IDENTITY_ALREADY_EXISTS (err u1004))
(define-constant ERR_CREDENTIAL_NOT_FOUND (err u1005))
(define-constant ERR_CREDENTIAL_EXPIRED (err u1006))
(define-constant ERR_CREDENTIAL_REVOKED (err u1007))
(define-constant ERR_ISSUER_NOT_AUTHORIZED (err u1008))
(define-constant ERR_VERIFIER_NOT_AUTHORIZED (err u1009))
(define-constant ERR_INVALID_PROOF (err u1010))
(define-constant ERR_REPUTATION_TOO_LOW (err u1011))
(define-constant ERR_TRUST_RELATIONSHIP_EXISTS (err u1012))
(define-constant ERR_PRIVACY_VIOLATION (err u1013))
(define-constant ERR_CREDENTIAL_SCHEMA_INVALID (err u1014))
(define-constant ERR_DELEGATION_NOT_FOUND (err u1015))

;; Identity Status Constants
(define-constant STATUS_ACTIVE "active")
(define-constant STATUS_SUSPENDED "suspended")
(define-constant STATUS_REVOKED "revoked")

;; Credential Status Constants
(define-constant CRED_STATUS_VALID "valid")
(define-constant CRED_STATUS_EXPIRED "expired")
(define-constant CRED_STATUS_REVOKED "revoked")
(define-constant CRED_STATUS_SUSPENDED "suspended")

;; Credential Types
(define-constant CRED_TYPE_EDUCATION "education")
(define-constant CRED_TYPE_EMPLOYMENT "employment")
(define-constant CRED_TYPE_IDENTITY "identity")
(define-constant CRED_TYPE_FINANCIAL "financial")
(define-constant CRED_TYPE_HEALTH "health")

;; Reputation Constants
(define-constant MIN_REPUTATION_SCORE u0)
(define-constant MAX_REPUTATION_SCORE u1000)
(define-constant DEFAULT_REPUTATION u500)
(define-constant VERIFICATION_REWARD 10)
(define-constant FRAUD_PENALTY 50)

;; Privacy Levels
(define-constant PRIVACY_PUBLIC u0)
(define-constant PRIVACY_SELECTIVE u1)
(define-constant PRIVACY_PRIVATE u2)
(define-constant PRIVACY_ANONYMOUS u3)

;; =============================================================================
;; DATA VARIABLES
;; =============================================================================

(define-data-var next-identity-id uint u1)
(define-data-var next-credential-id uint u1)
(define-data-var next-verification-id uint u1)
(define-data-var next-trust-id uint u1)
(define-data-var total-identities uint u0)
(define-data-var total-credentials uint u0)
(define-data-var total-verifications uint u0)
(define-data-var platform-fee-pool uint u0)

;; =============================================================================
;; DATA MAPS
;; =============================================================================

;; Decentralized Identity Registry
(define-map identities principal {
    identity-id: uint,
    did: (string-ascii 100), ;; Decentralized Identifier
    public-key: (string-ascii 66), ;; Compressed public key
    status: (string-ascii 20),
    reputation-score: uint,
    total-credentials: uint,
    total-verifications: uint,
    privacy-level: uint,
    metadata-hash: (string-ascii 64),
    created-at: uint,
    updated-at: uint,
    recovery-addresses: (list 5 principal),
    delegation-count: uint
})

;; Identity to ID mapping
(define-map identity-ids uint principal)

;; Verifiable Credentials
(define-map credentials uint {
    holder: principal,
    issuer: principal,
    credential-type: (string-ascii 20),
    schema-id: (string-ascii 50),
    credential-data-hash: (string-ascii 64),
    signature: (string-ascii 132), ;; Digital signature
    status: (string-ascii 20),
    issued-at: uint,
    expires-at: (optional uint),
    revoked-at: (optional uint),
    verification-count: uint,
    privacy-level: uint,
    selective-disclosure: bool
})

;; Credential Schemas
(define-map credential-schemas (string-ascii 50) {
    schema-name: (string-ascii 100),
    issuer: principal,
    schema-version: (string-ascii 10),
    required-fields: (string-ascii 500),
    verification-rules: (string-ascii 500),
    privacy-requirements: uint,
    created-at: uint,
    active: bool
})

;; Authorized Credential Issuers
(define-map authorized-issuers principal {
    issuer-name: (string-ascii 100),
    issuer-type: (string-ascii 30), ;; government, education, employer, etc.
    authorization-level: uint, ;; 1-10 scale
    credentials-issued: uint,
    reputation-score: uint,
    public-key: (string-ascii 66),
    contact-info: (string-ascii 200),
    authorized-at: uint,
    expires-at: (optional uint),
    active: bool
})

;; Verification Records
(define-map verifications uint {
    credential-id: uint,
    verifier: principal,
    verification-result: bool,
    verification-method: (string-ascii 30),
    proof-data: (string-ascii 200),
    verification-date: uint,
    privacy-preserved: bool,
    trust-score: uint
})

;; Trust Relationships
(define-map trust-relationships uint {
    trustor: principal, ;; Who is giving trust
    trustee: principal, ;; Who is receiving trust
    trust-level: uint, ;; 1-100 scale
    trust-category: (string-ascii 30), ;; professional, personal, academic
    established-at: uint,
    last-updated: uint,
    endorsements: uint,
    active: bool
})

;; Trust Network Edges
(define-map trust-edges {
    from: principal,
    to: principal
} {
    trust-id: uint,
    weight: uint,
    bidirectional: bool
})

;; Reputation History
(define-map reputation-events uint {
    identity: principal,
    event-type: (string-ascii 30), ;; verification, endorsement, fraud, etc.
    reputation-change: int, ;; can be negative
    event-data: (string-ascii 200),
    timestamp: uint,
    verified: bool
})

;; Identity Delegations
(define-map delegations uint {
    delegator: principal,
    delegate: principal,
    permissions: (string-ascii 200), ;; JSON list of permissions
    expires-at: uint,
    created-at: uint,
    active: bool,
    usage-count: uint
})

;; Privacy Controls
(define-map privacy-settings principal {
    default-privacy-level: uint,
    selective-disclosure-enabled: bool,
    anonymous-verification-allowed: bool,
    data-retention-period: uint, ;; in blocks
    consent-requirements: (string-ascii 200),
    audit-log-enabled: bool
})

;; Credential Presentations
(define-map presentations uint {
    presenter: principal,
    verifier: principal,
    credential-ids: (list 10 uint),
    disclosed-attributes: (string-ascii 500),
    presentation-proof: (string-ascii 200),
    presentation-date: uint,
    privacy-preserved: bool,
    verification-result: (optional bool)
})

;; Zero-Knowledge Proofs
(define-map zk-proofs uint {
    prover: principal,
    proof-type: (string-ascii 30), ;; range, membership, equality, etc.
    proof-data: (string-ascii 300),
    verification-key: (string-ascii 100),
    public-inputs: (string-ascii 200),
    created-at: uint,
    verified: bool
})

;; Audit Logs
(define-map audit-logs uint {
    identity: principal,
    action: (string-ascii 50),
    resource-type: (string-ascii 30),
    resource-id: uint,
    timestamp: uint,
    ip-hash: (optional (string-ascii 64)),
    user-agent-hash: (optional (string-ascii 64)),
    success: bool
})

;; =============================================================================
;; HELPER FUNCTIONS (needed by main functions)
;; =============================================================================

;; Log audit event
(define-private (log-audit-event
    (identity principal)
    (action (string-ascii 50))
    (resource-type (string-ascii 30))
    (resource-id uint)
    (success bool))
    (let ((audit-id (var-get next-verification-id)))
        (map-set audit-logs audit-id {
            identity: identity,
            action: action,
            resource-type: resource-type,
            resource-id: resource-id,
            timestamp: stacks-block-height,
            ip-hash: none,
            user-agent-hash: none,
            success: success
        })
        (var-set next-verification-id (+ audit-id u1))
        (ok true)))

;; Update reputation score (simplified for compilation)
(define-private (update-reputation (identity principal) (score-change int) (event-type (string-ascii 30)))
    (let ((current-identity (unwrap! (map-get? identities identity) ERR_IDENTITY_NOT_FOUND)))
        (let ((current-score (get reputation-score current-identity))
              (new-score (if (>= score-change 0)
                           (+ current-score (to-uint score-change))
                           (if (> current-score (to-uint (- score-change)))
                               (- current-score (to-uint (- score-change)))
                               MIN_REPUTATION_SCORE))))
            
            ;; Update identity reputation
            (map-set identities identity
                (merge current-identity {
                    reputation-score: new-score,
                    updated-at: stacks-block-height
                }))
            
            (ok new-score))))

;; =============================================================================
;; IDENTITY MANAGEMENT FUNCTIONS
;; =============================================================================

;; Create new decentralized identity
(define-public (create-identity
    (did (string-ascii 100))
    (public-key (string-ascii 66))
    (privacy-level uint)
    (metadata-hash (string-ascii 64))
    (recovery-addresses (list 5 principal)))
    (let ((identity-id (var-get next-identity-id)))
        (asserts! (is-none (map-get? identities tx-sender)) ERR_IDENTITY_ALREADY_EXISTS)
        (asserts! (> (len did) u0) ERR_INVALID_INPUT)
        (asserts! (> (len public-key) u0) ERR_INVALID_INPUT)
        (asserts! (<= privacy-level PRIVACY_ANONYMOUS) ERR_INVALID_INPUT)
        
        ;; Create identity record
        (map-set identities tx-sender {
            identity-id: identity-id,
            did: did,
            public-key: public-key,
            status: STATUS_ACTIVE,
            reputation-score: DEFAULT_REPUTATION,
            total-credentials: u0,
            total-verifications: u0,
            privacy-level: privacy-level,
            metadata-hash: metadata-hash,
            created-at: stacks-block-height,
            updated-at: stacks-block-height,
            recovery-addresses: recovery-addresses,
            delegation-count: u0
        })
        
        ;; Map identity ID to principal
        (map-set identity-ids identity-id tx-sender)
        
        ;; Initialize privacy settings
        (map-set privacy-settings tx-sender {
            default-privacy-level: privacy-level,
            selective-disclosure-enabled: true,
            anonymous-verification-allowed: (>= privacy-level PRIVACY_PRIVATE),
            data-retention-period: u52560, ;; ~1 year in blocks
            consent-requirements: "explicit-consent",
            audit-log-enabled: true
        })
        
        ;; Update global counters
        (var-set next-identity-id (+ identity-id u1))
        (var-set total-identities (+ (var-get total-identities) u1))
        
        ;; Log audit event
        (unwrap-panic (log-audit-event tx-sender "create-identity" "identity" identity-id true))
        
        (ok identity-id)))

;; Update identity metadata
(define-public (update-identity
    (new-metadata-hash (string-ascii 64))
    (new-privacy-level (optional uint)))
    (let ((identity (unwrap! (map-get? identities tx-sender) ERR_IDENTITY_NOT_FOUND)))
        (asserts! (is-eq (get status identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        
        (map-set identities tx-sender
            (merge identity {
                metadata-hash: new-metadata-hash,
                privacy-level: (default-to (get privacy-level identity) new-privacy-level),
                updated-at: stacks-block-height
            }))
        
        (unwrap-panic (log-audit-event tx-sender "update-identity" "identity" (get identity-id identity) true))
        (ok true)))

;; Suspend identity (admin only)
(define-public (suspend-identity (identity-principal principal))
    (let ((identity (unwrap! (map-get? identities identity-principal) ERR_IDENTITY_NOT_FOUND)))
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
        
        (map-set identities identity-principal
            (merge identity {
                status: STATUS_SUSPENDED,
                updated-at: stacks-block-height
            }))
        
        (unwrap-panic (log-audit-event identity-principal "suspend-identity" "identity" (get identity-id identity) true))
        (ok true)))

;; =============================================================================
;; CREDENTIAL MANAGEMENT FUNCTIONS
;; =============================================================================

;; Issue verifiable credential
(define-public (issue-credential
    (holder principal)
    (credential-type (string-ascii 20))
    (schema-id (string-ascii 50))
    (credential-data-hash (string-ascii 64))
    (signature (string-ascii 132))
    (expires-at (optional uint))
    (privacy-level uint))
    (let ((credential-id (var-get next-credential-id))
          (issuer-info (unwrap! (map-get? authorized-issuers tx-sender) ERR_ISSUER_NOT_AUTHORIZED))
          (holder-identity (unwrap! (map-get? identities holder) ERR_IDENTITY_NOT_FOUND))
          (schema (unwrap! (map-get? credential-schemas schema-id) ERR_CREDENTIAL_SCHEMA_INVALID)))
        
        (asserts! (get active issuer-info) ERR_ISSUER_NOT_AUTHORIZED)
        (asserts! (get active schema) ERR_CREDENTIAL_SCHEMA_INVALID)
        (asserts! (is-eq (get status holder-identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        (asserts! (<= privacy-level PRIVACY_ANONYMOUS) ERR_INVALID_INPUT)
        
        ;; Create credential
        (map-set credentials credential-id {
            holder: holder,
            issuer: tx-sender,
            credential-type: credential-type,
            schema-id: schema-id,
            credential-data-hash: credential-data-hash,
            signature: signature,
            status: CRED_STATUS_VALID,
            issued-at: stacks-block-height,
            expires-at: expires-at,
            revoked-at: none,
            verification-count: u0,
            privacy-level: privacy-level,
            selective-disclosure: (>= privacy-level PRIVACY_SELECTIVE)
        })
        
        ;; Update issuer stats
        (map-set authorized-issuers tx-sender
            (merge issuer-info {
                credentials-issued: (+ (get credentials-issued issuer-info) u1)
            }))
        
        ;; Update holder stats
        (map-set identities holder
            (merge holder-identity {
                total-credentials: (+ (get total-credentials holder-identity) u1),
                updated-at: stacks-block-height
            }))
        
        ;; Update global counter
        (var-set next-credential-id (+ credential-id u1))
        (var-set total-credentials (+ (var-get total-credentials) u1))
        
        ;; Log audit event
        (unwrap-panic (log-audit-event holder "issue-credential" "credential" credential-id true))
        
        (ok credential-id)))

;; Verify credential
(define-public (verify-credential
    (credential-id uint)
    (verification-method (string-ascii 30))
    (proof-data (string-ascii 200)))
    (let ((credential (unwrap! (map-get? credentials credential-id) ERR_CREDENTIAL_NOT_FOUND))
          (verification-id (var-get next-verification-id))
          (verifier-identity (unwrap! (map-get? identities tx-sender) ERR_IDENTITY_NOT_FOUND)))
        
        (asserts! (is-eq (get status verifier-identity) STATUS_ACTIVE) ERR_VERIFIER_NOT_AUTHORIZED)
        (asserts! (is-eq (get status credential) CRED_STATUS_VALID) ERR_CREDENTIAL_REVOKED)
        
        ;; Check expiration
        (asserts! (match (get expires-at credential)
                         expiry (< stacks-block-height expiry)
                         true) ERR_CREDENTIAL_EXPIRED)
        
        ;; Perform verification (simplified)
        (let ((verification-result (is-valid-proof proof-data (get signature credential))))
            
            ;; Record verification
            (map-set verifications verification-id {
                credential-id: credential-id,
                verifier: tx-sender,
                verification-result: verification-result,
                verification-method: verification-method,
                proof-data: proof-data,
                verification-date: stacks-block-height,
                privacy-preserved: (get selective-disclosure credential),
                trust-score: (calculate-trust-score tx-sender (get holder credential))
            })
            
            ;; Update credential verification count
            (map-set credentials credential-id
                (merge credential {
                    verification-count: (+ (get verification-count credential) u1)
                }))
            
            ;; Update verifier reputation if successful
            (if verification-result
                (unwrap-panic (update-reputation tx-sender VERIFICATION_REWARD "successful-verification"))
                (unwrap-panic (update-reputation tx-sender (- VERIFICATION_REWARD) "failed-verification")))
            
            ;; Update holder reputation
            (if verification-result
                (unwrap-panic (update-reputation (get holder credential) VERIFICATION_REWARD "credential-verified"))
                (unwrap-panic (update-reputation (get holder credential) (- FRAUD_PENALTY) "credential-fraud")))
            
            (var-set next-verification-id (+ verification-id u1))
            (var-set total-verifications (+ (var-get total-verifications) u1))
            
            ;; Log audit event
            (unwrap-panic (log-audit-event (get holder credential) "verify-credential" "credential" credential-id verification-result))
            
            (ok verification-result))))

;; Revoke credential
(define-public (revoke-credential (credential-id uint) (reason (string-ascii 100)))
    (let ((credential (unwrap! (map-get? credentials credential-id) ERR_CREDENTIAL_NOT_FOUND)))
        (asserts! (or (is-eq (get issuer credential) tx-sender)
                      (is-eq (get holder credential) tx-sender)) ERR_NOT_AUTHORIZED)
        (asserts! (is-eq (get status credential) CRED_STATUS_VALID) ERR_CREDENTIAL_REVOKED)
        
        (map-set credentials credential-id
            (merge credential {
                status: CRED_STATUS_REVOKED,
                revoked-at: (some stacks-block-height)
            }))
        
        ;; Log audit event
        (unwrap-panic (log-audit-event (get holder credential) "revoke-credential" "credential" credential-id true))
        
        (ok true)))

;; =============================================================================
;; TRUST & REPUTATION FUNCTIONS
;; =============================================================================

;; Establish trust relationship
(define-public (establish-trust
    (trustee principal)
    (trust-level uint)
    (trust-category (string-ascii 30)))
    (let ((trust-id (var-get next-trust-id))
          (trustor-identity (unwrap! (map-get? identities tx-sender) ERR_IDENTITY_NOT_FOUND))
          (trustee-identity (unwrap! (map-get? identities trustee) ERR_IDENTITY_NOT_FOUND)))
        
        (asserts! (is-eq (get status trustor-identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        (asserts! (is-eq (get status trustee-identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        (asserts! (and (>= trust-level u1) (<= trust-level u100)) ERR_INVALID_INPUT)
        (asserts! (not (is-eq tx-sender trustee)) ERR_INVALID_INPUT)
        
        ;; Check if relationship already exists
        (asserts! (is-none (map-get? trust-edges { from: tx-sender, to: trustee })) ERR_TRUST_RELATIONSHIP_EXISTS)
        
        ;; Create trust relationship
        (map-set trust-relationships trust-id {
            trustor: tx-sender,
            trustee: trustee,
            trust-level: trust-level,
            trust-category: trust-category,
            established-at: stacks-block-height,
            last-updated: stacks-block-height,
            endorsements: u0,
            active: true
        })
        
        ;; Create trust edge
        (map-set trust-edges
            { from: tx-sender, to: trustee }
            {
                trust-id: trust-id,
                weight: trust-level,
                bidirectional: false
            })
        
        (var-set next-trust-id (+ trust-id u1))
        
        ;; Update reputation scores
        (unwrap-panic (update-reputation trustee (to-int (/ trust-level u10)) "trust-received"))
        
        (ok trust-id)))


;; =============================================================================
;; PRIVACY & ZERO-KNOWLEDGE FUNCTIONS
;; =============================================================================

;; Create zero-knowledge proof presentation
(define-public (create-zk-proof
    (proof-type (string-ascii 30))
    (proof-data (string-ascii 300))
    (verification-key (string-ascii 100))
    (public-inputs (string-ascii 200)))
    (let ((proof-id (var-get next-verification-id))
          (identity (unwrap! (map-get? identities tx-sender) ERR_IDENTITY_NOT_FOUND)))
        
        (asserts! (is-eq (get status identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        
        ;; Create ZK proof record
        (map-set zk-proofs proof-id {
            prover: tx-sender,
            proof-type: proof-type,
            proof-data: proof-data,
            verification-key: verification-key,
            public-inputs: public-inputs,
            created-at: stacks-block-height,
            verified: false
        })
        
        (var-set next-verification-id (+ proof-id u1))
        
        (ok proof-id)))

;; Verify zero-knowledge proof
(define-public (verify-zk-proof (proof-id uint))
    (let ((zk-proof (unwrap! (map-get? zk-proofs proof-id) ERR_INVALID_PROOF)))
        ;; Simplified ZK verification - in production would use proper cryptographic verification
        (let ((verification-result (is-valid-zk-proof (get proof-data zk-proof) (get verification-key zk-proof))))
            
            ;; Update proof verification status
            (map-set zk-proofs proof-id
                (merge zk-proof { verified: verification-result }))
            
            ;; Update prover reputation
            (if verification-result
                (unwrap-panic (update-reputation (get prover zk-proof) VERIFICATION_REWARD "zk-proof-verified"))
                (unwrap-panic (update-reputation (get prover zk-proof) (- FRAUD_PENALTY) "zk-proof-invalid")))
            
            (ok verification-result))))

;; =============================================================================
;; AUTHORIZATION & DELEGATION FUNCTIONS
;; =============================================================================

;; Authorize credential issuer
(define-public (authorize-issuer
    (issuer principal)
    (issuer-name (string-ascii 100))
    (issuer-type (string-ascii 30))
    (authorization-level uint)
    (public-key (string-ascii 66))
    (expires-at (optional uint)))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
        (asserts! (and (>= authorization-level u1) (<= authorization-level u10)) ERR_INVALID_INPUT)
        
        (map-set authorized-issuers issuer {
            issuer-name: issuer-name,
            issuer-type: issuer-type,
            authorization-level: authorization-level,
            credentials-issued: u0,
            reputation-score: DEFAULT_REPUTATION,
            public-key: public-key,
            contact-info: "",
            authorized-at: stacks-block-height,
            expires-at: expires-at,
            active: true
        })
        
        (ok true)))

;; Create identity delegation
(define-public (create-delegation
    (delegate principal)
    (permissions (string-ascii 200))
    (expires-at uint))
    (let ((delegation-id (var-get next-verification-id))
          (delegator-identity (unwrap! (map-get? identities tx-sender) ERR_IDENTITY_NOT_FOUND))
          (delegate-identity (unwrap! (map-get? identities delegate) ERR_IDENTITY_NOT_FOUND)))
        
        (asserts! (is-eq (get status delegator-identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        (asserts! (is-eq (get status delegate-identity) STATUS_ACTIVE) ERR_NOT_AUTHORIZED)
        (asserts! (> expires-at stacks-block-height) ERR_INVALID_INPUT)
        
        (map-set delegations delegation-id {
            delegator: tx-sender,
            delegate: delegate,
            permissions: permissions,
            expires-at: expires-at,
            created-at: stacks-block-height,
            active: true,
            usage-count: u0
        })
        
        ;; Update delegator's delegation count
        (map-set identities tx-sender
            (merge delegator-identity {
                delegation-count: (+ (get delegation-count delegator-identity) u1)
            }))
        
        (var-set next-verification-id (+ delegation-id u1))
        
        (ok delegation-id)))

;; =============================================================================
;; HELPER FUNCTIONS
;; =============================================================================

;; Validate proof signature (simplified)
(define-private (is-valid-proof (proof-data (string-ascii 200)) (signature (string-ascii 132)))
    ;; Simplified validation - in production would use proper cryptographic verification
    (> (len proof-data) u10))

;; Validate zero-knowledge proof (simplified)
(define-private (is-valid-zk-proof (proof-data (string-ascii 300)) (verification-key (string-ascii 100)))
    ;; Simplified validation - in production would use proper ZK verification libraries
    (and (> (len proof-data) u20) (> (len verification-key) u10)))

;; Calculate trust score between two identities
(define-private (calculate-trust-score (identity-a principal) (identity-b principal))
    ;; Simplified trust calculation - in production would analyze trust network paths
    (match (map-get? trust-edges { from: identity-a, to: identity-b })
        edge (get weight edge)
        u50)) ;; Default trust score


;; =============================================================================
;; READ-ONLY FUNCTIONS
;; =============================================================================

;; Get identity details
(define-read-only (get-identity (identity-principal principal))
    (map-get? identities identity-principal))

;; Get credential details
(define-read-only (get-credential (credential-id uint))
    (map-get? credentials credential-id))

;; Get verification record
(define-read-only (get-verification (verification-id uint))
    (map-get? verifications verification-id))

;; Get trust relationship
(define-read-only (get-trust-relationship (trust-id uint))
    (map-get? trust-relationships trust-id))

;; Get authorized issuer info
(define-read-only (get-authorized-issuer (issuer principal))
    (map-get? authorized-issuers issuer))

;; Get platform statistics
(define-read-only (get-platform-stats)
    {
        total-identities: (var-get total-identities),
        total-credentials: (var-get total-credentials),
        total-verifications: (var-get total-verifications),
        platform-fee-pool: (var-get platform-fee-pool)
    })

;; Get identity reputation history
(define-read-only (get-reputation-history (identity-principal principal))
    ;; Simplified - in production would return filtered reputation events
    (match (map-get? identities identity-principal)
        identity (some (get reputation-score identity))
        none))

;; Check credential validity
(define-read-only (is-credential-valid (credential-id uint))
    (match (map-get? credentials credential-id)
        credential
        (and 
            (is-eq (get status credential) CRED_STATUS_VALID)
            (match (get expires-at credential)
                expiry (< stacks-block-height expiry)
                true))
        false))

;; Get trust network connections
(define-read-only (get-trust-connections (identity-principal principal))
    ;; Simplified - would return list of trust relationships
    (match (map-get? identities identity-principal)
        identity (some (get reputation-score identity))
        none))

;; Get privacy settings
(define-read-only (get-privacy-settings (identity-principal principal))
    (map-get? privacy-settings identity-principal))

;; Get delegation details
(define-read-only (get-delegation (delegation-id uint))
    (map-get? delegations delegation-id))
