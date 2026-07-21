-- filename Eco-Fort/db/phoenixhexregistry_rtree.sql
-- destination Eco-Fort/db/phoenixhexregistry_rtree.sql

PRAGMA foreign_keys = ON;

-- R-tree index for spatiotemporal queries over Phoenix hex anchors.
-- We treat spatial bounds as a small box around the anchor's nominal point,
-- and temporal bounds as [yyyymmdd, yyyymmdd] for daily anchors.

CREATE VIRTUAL TABLE IF NOT EXISTS phoenixhexanchor_spatiotemporal
USING rtree(
    anchorid,          -- must match phoenixhexanchor.anchorid
    lat_min, lat_max,  -- bounding box in degrees
    lon_min, lon_max,  -- bounding box in degrees
    t_min,  t_max      -- time as integer yyyymmdd
);

-- Helper table to store parsed coordinates and timestamps
-- for anchors whose logicalname/evidencehex can be decoded.

CREATE TABLE IF NOT EXISTS phoenixhexanchor_geoaux (
    anchorid     INTEGER PRIMARY KEY,
    lat_center   REAL NOT NULL,
    lon_center   REAL NOT NULL,
    t_center     INTEGER,        -- yyyymmdd as integer, NULL for timeless
    FOREIGN KEY (anchorid) REFERENCES phoenixhexanchor(anchorid) ON DELETE CASCADE
);

-- Populate/refresh R-tree from anchors with regioncode and yyyymmdd.
-- This can be run as a migration step after inserts into phoenixhexanchor.

INSERT OR REPLACE INTO phoenixhexanchor_spatiotemporal (
    anchorid, lat_min, lat_max, lon_min, lon_max, t_min, t_max
)
SELECT
    a.anchorid,
    g.lat_center - 0.0005,  -- ~50 m box around nominal location
    g.lat_center + 0.0005,
    g.lon_center - 0.0005,
    g.lon_center + 0.0005,
    COALESCE(g.t_center, 0),
    COALESCE(g.t_center, 0)
FROM phoenixhexanchor AS a
JOIN phoenixhexanchor_geoaux AS g ON g.anchorid = a.anchorid;
