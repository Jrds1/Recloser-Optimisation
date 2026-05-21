# GitHub Setup

This project can be published on GitHub without installing Git, npm, Visual Studio, or the .NET SDK.

## What Goes In The Repository

Upload these source files and folders to the GitHub repository:

- `README.md`
- `GITHUB_SETUP.md`
- `RecloserOptimisation.sln`
- `Install-RecloserOptimisation.cmd`
- `Install-RecloserOptimisation.ps1`
- `Start-RecloserOptimisationApp.cmd`
- `RecloserOptimisationApp.ps1`
- `src/RecloserOptimisation.App/**`
- `docs/APP_ARCHITECTURE.md`
- `docs/SDK_TROUBLESHOOTING.md`
- `config/import-adapters.json`
- `config/prototype-accounts.json`
- `assets/icon.ico`
- `assets/logo.jpg`
- `.gitignore`

Do not upload `dist/` as normal source code. The `dist` folder contains generated download packages and should be attached to a GitHub Release instead.

## Create The Repository Using The GitHub Website

1. Go to `https://github.com/new`.
2. Repository name: `recloser-optimisation`.
3. Choose `Public` or `Private`.
4. Leave `Add a README file` unticked because this folder already has one.
5. Click `Create repository`.
6. Click `uploading an existing file`.
7. Drag the files and folders listed above into the upload area.
8. Commit with a message such as `Initial desktop prototype`.

## Create The Downloadable App Release

1. In the repository, open `Releases`.
2. Click `Draft a new release`.
3. Tag version: `v0.1.0`.
4. Release title: `Recloser Optimisation Desktop Prototype v0.1.0`.
5. Attach this ZIP file as the release asset:

   `dist/RecloserOptimisation-Desktop-NoAdmin.zip`

6. Add release notes:

   ```text
   No-admin Windows desktop prototype.
   Unzip and run Install-RecloserOptimisation.cmd.
   Creates a Desktop shortcut using the ROA icon.
   Processing, validation and optimisation are not implemented yet.
   ```

7. Click `Publish release`.

## Download Link Format

After the release is published, the direct download link will look like this:

```text
https://github.com/<your-github-name>/recloser-optimisation/releases/latest/download/RecloserOptimisation-Desktop-NoAdmin.zip
```

Replace `<your-github-name>` with your GitHub username or organisation.

## What The User Does After Downloading

1. Download `RecloserOptimisation-Desktop-NoAdmin.zip`.
2. Unzip it.
3. Run `Install-RecloserOptimisation.cmd`.
4. Launch `Recloser Optimisation` from the Desktop shortcut.

Windows and browsers will not allow a ZIP download to silently install itself or create a Desktop shortcut. The user has to unzip it and deliberately run the installer script.

## Visual Studio Build Path

Once the Visual Studio app is ready to replace the script prototype:

1. Open `RecloserOptimisation.sln` in Visual Studio.
2. Set `RecloserOptimisation.App` as the startup project.
3. Run with `F5`.
4. Right-click the project and choose `Publish`.
5. Choose `FolderProfile`.
6. Zip the published folder.
7. Attach that ZIP to a GitHub Release.

The Visual Studio build produces a proper Windows `.exe`; the no-admin PowerShell package remains useful as a fallback prototype.
