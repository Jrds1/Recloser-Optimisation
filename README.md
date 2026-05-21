# Recloser Optimisation Desktop Prototype

This folder contains a Windows desktop app prototype for the recloser optimisation workflow.

## Download And Install

1. Unzip the file.
2. Run `Install-RecloserOptimisation.cmd`.
3. Launch `Recloser Optimisation` from the Desktop shortcut.

The installer creates the shortcut thumbnail.

## Local Run

Run it with `.\Start-RecloserOptimisationApp.cmd` in powershell

The installer copies the app to `%LOCALAPPDATA%\RecloserOptimisation` and creates a Desktop shortcut named `Recloser Optimisation`. The shortcut thumbnail is set from `assets/icon.ico`. 

## Implemented

- Native WPF desktop app shell based on the supplied dashboard reference.
- Local prototype sign-in screen and active network/project switcher.
- Prototype account gate using `config/prototype-accounts.json`; unknown account names are denied entry.
- Per-account project list with a `New Project` prompt and per-project staged import visibility.
- Navigation across dashboard, ingestion, processing, model building, map, validation, analysis, outages, reports and settings.
- Native file and folder import dialogs for staging source metadata.
- Native save dialogs for project-state JSON, import template CSV and empty feeder GeoJSON exports.
- Live tile-based map with street, satellite, terrain and elevation hillshade layers.
- Import adapter catalogue for common electrical engineering, GIS, protection, SCADA, OMS, asset and customer data platforms.

## What is intentionally not implemented yet

- File parsing.
- Data normalisation.
- Network graph construction.
- Validation rules.
- Recloser placement optimisation.
- SAIDI and SAIFI calculations.

The import adapter catalogue lives in `config/import-adapters.json` so the future parser layer can grow from the same source list used by the UI.
