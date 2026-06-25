-- filename db_effective_action_contract.sql
-- destination Eco-Fort/db/db_effective_action_contract.sql
-- repo-target github.com/mk-bluebird/Eco-Fort

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS effective_action_contract_2026v1 (
  contractid          TEXT PRIMARY KEY,
  requestid           TEXT NOT NULL
                        REFERENCES governed_action_request_2026v1(requestid)
                        ON DELETE RESTRICT,
  identityid          TEXT NOT NULL,
  actionkind          TEXT NOT NULL CHECK (
                         actionkind IN (
                           'IMAGE_RENDER',
                           'CODEGEN',
                           'SCHEDULE_RUN',
                           'DATA_EXPORT',
                           'OTHER'
                         )
                       ),
  lane                TEXT NOT NULL CHECK (
                         lane IN ('RESEARCH', 'EXPPROD', 'PROD')
                       ),
  kerband             TEXT NOT NULL CHECK (
                         kerband IN ('SAFE', 'GUARDED', 'BLOCKED')
                       ),
  rohrisk             REAL NOT NULL CHECK (rohrisk >= 0.0 AND rohrisk <= 1.0),
  ecoimpactclass      TEXT NOT NULL CHECK (
                         ecoimpactclass IN ('NEUTRAL', 'RESTORATIVE', 'NEGATIVE')
                       ),
  payloadcomplete     TEXT NOT NULL,
  contenthashhex      TEXT NOT NULL,
  rohanchorhex        TEXT NOT NULL,
  vtresidual          REAL NOT NULL CHECK (
                         vtresidual >= 0.0 AND vtresidual <= 1.0
                       ),
  topologyrisk        REAL NOT NULL CHECK (
                         topologyrisk >= 0.0 AND topologyrisk <= 1.0
                       ),
  decisionverdict     TEXT NOT NULL CHECK (
                         decisionverdict IN (
                           'APPROVED',
                           'REJECTED_LANE',
                           'REJECTED_KER',
                           'REJECTED_NEURORIGHTS',
                           'REJECTED_BLACKLIST',
                           'REJECTED_ECO',
                           'REJECTED_TOPOLOGY'
                         )
                       ),
  decisionexplanation TEXT NOT NULL,
  issuedby            TEXT NOT NULL,
  issuedutc           TEXT NOT NULL,
  created_unix_ms     INTEGER NOT NULL DEFAULT (
                         CAST(STRFTIME('%s', 'now') AS INTEGER) * 1000
                       )
);

CREATE INDEX IF NOT EXISTS idx_eac_request
  ON effective_action_contract_2026v1 (requestid, created_unix_ms);

CREATE INDEX IF NOT EXISTS idx_eac_identity
  ON effective_action_contract_2026v1 (identityid, created_unix_ms);

CREATE INDEX IF NOT EXISTS idx_eac_lane_verdict
  ON effective_action_contract_2026v1 (lane, decisionverdict, created_unix_ms);

CREATE TRIGGER IF NOT EXISTS trg_eac_2026v1_insert
BEFORE INSERT ON effective_action_contract_2026v1
FOR EACH ROW
BEGIN
  -- Enforce 0x-prefixed, 64-nybble hex for contenthashhex and rohanchorhex.
  SELECT
    CASE
      WHEN NEW.contenthashhex NOT LIKE '0x%' OR
           LENGTH(NEW.contenthashhex) != 66 THEN
        RAISE(ABORT, 'contenthashhex must be 0x-prefixed 64-nybble hex')
    END;

  SELECT
    CASE
      WHEN NEW.rohanchorhex NOT LIKE '0x%' OR
           LENGTH(NEW.rohanchorhex) != 66 THEN
        RAISE(ABORT, 'rohanchorhex must be 0x-prefixed 64-nybble hex')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_eac_2026v1_update
BEFORE UPDATE ON effective_action_contract_2026v1
FOR EACH ROW
BEGIN
  -- Effective contracts are append-only; no updates allowed.
  SELECT
    RAISE(ABORT, 'UPDATE not allowed on effective_action_contract_2026v1');
END;
