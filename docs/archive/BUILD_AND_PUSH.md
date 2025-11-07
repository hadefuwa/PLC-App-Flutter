# Build and Release Workflow

## Step 1: Build the APK
```bash
scripts\build-apk.bat
```
or
```powershell
scripts\build-apk.ps1
```

The APK will be built and copied to the `releases/` folder.

## Step 2: Create GitHub Release

**Option A: Using GitHub Web Interface**
1. Go to your repository on GitHub
2. Click "Releases" → "Draft a new release"
3. Create a new tag (e.g., `v1.0.9`)
4. Upload the APK from `releases/` folder
5. Add release notes and publish

**Option B: Using GitHub CLI**
```bash
gh release create v1.0.9 --title "Smart Factory v1.0.9" --notes "Release notes here" releases/smart-factory-v1.0.9.apk
```

## Step 3: Push Code Changes (if any)
```bash
scripts\git-push.bat
```
or
```powershell
scripts\git-push.ps1
```

**Note**: APK files are no longer committed to git. They are distributed via GitHub Releases instead.

See [GITHUB_RELEASES.md](GITHUB_RELEASES.md) for detailed instructions.
