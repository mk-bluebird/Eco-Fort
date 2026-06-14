# Eco-Fort: The Canonical Schema & Evidence Spine of the EcoNet Constellation

[![Role Band](https://img.shields.io/badge/Role-Spine-1565c0)](https://github.com/mk-bluebird/EcoNet)
[![License](https://img.shields.io/badge/License-Apache--2.0%20OR%20MIT-green)](./LICENSE)
[![Language](https://img.shields.io/badge/Language-Rust%20%26%20SQLite-orange)](https://www.rust-lang.org/)
[![Ecosafety](https://img.shields.io/badge/Ecosafety-Frozen%20Grammar-blue)](https://github.com/mk-bluebird/EcoNet)

**Eco-Fort** is the centralized, authoritative repository of data schemas, validation rules, and reference implementations for the EcoNet constellation. It serves as the canonical home for all `qpudatashards`, ALN schema definitions, and the SQLite constellation discovery spine. 

By providing a machine-readable, strictly validated foundation, Eco-Fort ensures that all ecological restoration, energy optimization, and carbon-negative workloads across the constellation operate within a frozen, verifiable ecosafety grammar.

---

## 🏛️ Core Responsibilities

1. **QPU Shard Repository**: Hosts the definitive collection of evidence shards (ALN, CSV, and simulation artifacts) for hydrological buffering, material kinetics, biodiversity corridors, and global river plastic tracking.
2. **Constellation Index Spine**: Maintains the SQLite schemas (`eco_constellation_index.sql`, `qpu_shard_catalog_schema.sql`) that allow AI agents and orchestration tools to discover, query, and wire code across the entire ecosystem.
3. **Schema & Validation**: Defines the canonical `EcoNetSchemaShard2026v2.aln` and provides `csvlint`-like validation tools to ensure all incoming data strictly adheres to frozen grammar rules.
4. **Agent Wiring Map**: Serves as the primary source of truth for coding agents, dictating where new files belong, how they should be structured, and which schemas govern them.

---

## 📂 Repository Structure

```text
Eco-Fort/
├── db/                          # SQLite constellation index schemas
│   ├── eco_constellation_index.sql       # Master repo and role-band registry
│   ├── qpu_shard_catalog_schema.sql      # Machine-readable wiring map for shards
│   ├── qpu_shard_tags_schema.sql         # High-granularity semantic tagging
│   ├── lane_status_shard_schema.sql      # Virta-Sys lane governance records
│   └── corridor_definition_schema.sql    # Lyapunov risk coordinate bands
├── qpudatashards/               # Canonical evidence and schema shards
│   ├── particles/               # ALN/CSV shards (e.g., PhoenixMarCyboquaticKER, GlobalRiverPlastic)
│   └── schemas/                 # Reference ALN schema definitions
├── doc/                         # Agent-facing specifications and API guides
│   ├── QpuShardCatalogSpec2026v1.md      # How to discover and wire shards
│   └── ShardsQueryAPI2026v1.md           # Internal Virta-Sys querying guide
├── tools/                       # Validation and indexing utilities
│   └── shard-indexer/           # Rust CLI to populate qpu_shard_catalog
├── Cargo.toml                   # Workspace configuration for Rust tools
└── README.md                    # This file
```

---

## 🚀 Getting Started

### Prerequisites
- Rust (Latest Stable)
- SQLite3
- Access to the EcoNet constellation index DB (e.g., `constellation.db`)

### 1. Initialize the Constellation Index
To set up the discovery spine, apply the core schemas to your local SQLite database:

```bash
sqlite3 constellation.db < db/eco_constellation_index.sql
sqlite3 constellation.db < db/qpu_shard_catalog_schema.sql
sqlite3 constellation.db < db/corridor_definition_schema.sql
```

### 2. Index Existing QPU Shards
Use the provided Rust tool to scan the `qpudatashards/particles` directory, compute content hashes, and populate the catalog with semantic wiring hints for AI agents:

```bash
cd tools/shard-indexer
cargo run -- --repo-root ../../ --db-path ../../constellation.db --repo-name EcoNet
```

### 3. Validate a New Shard
Before committing a new ALN or CSV shard, ensure it aligns with the frozen grammar. Agents should query the `qpu_shard_catalog` to find the `schema_ref` for their target domain, then validate column names, types, and KER metrics against that schema.

---

## 🤖 For AI Agents & Coding Assistants

If you are an AI agent tasked with generating code, creating new shards, or modifying ecosystem logic, **read this first**:

1. **Query the Catalog First**: Never guess file paths or naming conventions. Query `qpu_shard_catalog` to find existing shards matching your `primary_plane` and `region`.
2. **Respect `schema_ref`**: When generating a new shard, use the `schema_ref` from a similar existing shard to ensure column names and data types perfectly match the governing ALN schema.
3. **Non-Actuating Guarantee**: Eco-Fort is strictly **read-only and diagnostic**. Do not generate or suggest code that opens valves, controls motors, or routes physical power. All actuation logic is gated by the `EcoNet` and `ecological-orchestrator` repos.
4. **Update the Catalog**: If you create a new shard file, you must also ensure a corresponding entry is added to `qpu_shard_catalog` (either by running `shard-indexer` or explicitly inserting the metadata).

---

## 🌐 Constellation Integration

Eco-Fort does not operate in isolation. It is the foundational spine that other repositories depend on:

- **EcoNet**: Provides the core Lyapunov/KER math (`ker_residual.rs`) and ALN grammar. Eco-Fort stores the schemas and evidence that this math evaluates.
- **Virta-Sys**: Acts as the governance headquarters. It queries Eco-Fort’s `qpu_shard_catalog` and `lane_status_shard` tables to make authoritative, non-actuating decisions about workload placement and lane promotion.
- **ecological-orchestrator**: Consumes the validated shards and governance verdicts from Eco-Fort and Virta-Sys to safely schedule and execute physical-domain workloads.

---

## 🛡️ Governance & Safety Invariants

All artifacts in Eco-Fort are bound by the following strict invariants:

- **Frozen Grammar**: No schema or corridor definition may be altered in a way that weakens safety bounds. Tightening corridors is permitted; loosening them requires a sovereign-improvement ledger entry proving monotonic K/E/R improvement.
- **One Role-Band**: Eco-Fort is strictly a **SPINE** repository. It contains no `ENGINE` or `APP` actuation code.
- **Cryptographic Provenance**: All critical shards include `evidencehex` and `signingdid` fields, ensuring that data lineage is cryptographically verifiable and tamper-evident.

---

## 🤝 Contributing

Contributions to Eco-Fort must adhere to the EcoNet Governance Contract:

1. **New Shards**: Must include a valid `schema_ref` pointing to an existing ALN schema.
2. **Schema Changes**: Require a new version tag (e.g., `2026v2` to `2026v3`) and must pass the `shard-indexer` validation suite.
3. **CI Checks**: All PRs must pass the constellation linting checks, ensuring no blacklisted terms, no actuation paths, and strict adherence to the `NonActuatingWorkload` trait where applicable.

---

## ⚖️ License

Licensed under either of:
* Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
* MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

---
*Eco-Fort: Ensuring that every piece of data, schema, and evidence in the constellation remains structurally sound, ecologically restorative, and mathematically verifiable.*
