-- filename db_governed_action_request.sql
-- destination Eco-Fort/db/db_governed_action_request.sql
-- repo-target github.com/mk-bluebird/Eco-Fort

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS governed_action_request_2026v1 (
  requestid            TEXT PRIMARY KEY,
  identityid           TEXT NOT NULL,
  soicref              TEXT NOT NULL,
  agentorigin          TEXT NOT NULL,
  actionkind           TEXT NOT NULL CHECK (
                           actionkind IN (
                             'IMAGE_RENDER',
                             'CODEGEN',
                             'SCHEDULE_RUN',
                             'DATA_EXPORT',
                             'OTHER'
                           )
                         ),
  payloadschemaid      TEXT NOT NULL,
  payloadpartial       TEXT NOT NULL,
  payloadpartialhash   TEXT NOT NULL,
  schemahash           TEXT NOT NULL,
  consentflags         TEXT NOT NULL,
  neurorightsref       TEXT NOT NULL,
  blacklistref         TEXT NOT NULL,
  laneintent           TEXT NOT NULL CHECK (
                           laneintent IN ('RESEARCH', 'EXPPROD', 'PROD')
                         ),
  evidencehex          TEXT NOT NULL,
  signinghex           TEXT NOT NULL,
  createdutc           TEXT NOT NULL,
  created_unix_ms      INTEGER NOT NULL DEFAULT (
                           CAST(STRFTIME('%s', 'now') AS INTEGER) * 1000
                         ),
  active               INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1))
);

CREATE INDEX IF NOT EXISTS idx_gar_identity
  ON governed_action_request_2026v1 (identityid, created_unix_ms);

CREATE INDEX IF NOT EXISTS idx_gar_agent
  ON governed_action_request_2026v1 (agentorigin, created_unix_ms);

CREATE INDEX IF NOT EXISTS idx_gar_laneintent
  ON governed_action_request_2026v1 (laneintent, created_unix_ms);

CREATE TRIGGER IF NOT EXISTS trg_gar_2026v1_insert
BEFORE INSERT ON governed_action_request_2026v1
FOR EACH ROW
BEGIN
  -- Enforce 0x-prefixed, 64-nybble hex for payloadpartialhash and schemahash.
  SELECT
    CASE
      WHEN NEW.payloadpartialhash NOT LIKE '0x%' OR
           LENGTH(NEW.payloadpartialhash) != 66 THEN
        RAISE(ABORT, 'payloadpartialhash must be 0x-prefixed 64-nybble hex')
    END;

  SELECT
    CASE
      WHEN NEW.schemahash NOT LIKE '0x%' OR
           LENGTH(NEW.schemahash) != 66 THEN
        RAISE(ABORT, 'schemahash must be 0x-prefixed 64-nybble hex')
    END;

  -- Enforce 0x-prefixed, 64-nybble hex for evidencehex.
  SELECT
    CASE
      WHEN NEW.evidencehex NOT LIKE '0x%' OR
           LENGTH(NEW.evidencehex) != 66 THEN
        RAISE(ABORT, 'evidencehex must be 0x-prefixed 64-nybble hex')
    END;

  -- Enforce 0x-prefixed signing hex with minimum length.
  SELECT
    CASE
      WHEN NEW.signinghex NOT LIKE '0x%' OR
           LENGTH(NEW.signinghex) < 66 THEN
        RAISE(ABORT, 'signinghex must be 0x-prefixed hex of sufficient length')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_gar_2026v1_update
BEFORE UPDATE ON governed_action_request_2026v1
FOR EACH ROW
BEGIN
  -- Prevent changes to identity binding and cryptographic commitments.
  SELECT
    CASE
      WHEN NEW.identityid != OLD.identityid OR
           NEW.evidencehex != OLD.evidencehex OR
           NEW.signinghex != OLD.signinghex THEN
        RAISE(ABORT, 'identityid, evidencehex, and signinghex are immutable')
    END;

  -- Prevent requestid changes.
  SELECT
    CASE
      WHEN NEW.requestid != OLD.requestid THEN
        RAISE(ABORT, 'requestid is immutable')
    END;
END;
