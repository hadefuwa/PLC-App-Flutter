# GitHub Releases Guide

This repository uses GitHub Releases to distribute APK files instead of storing them in the git repository. This keeps the repository lightweight and avoids GitHub's file size warnings.

## Why GitHub Releases?

- **Repository Size**: APK files are large (50-60 MB each) and storing them in git history bloats the repository
- **GitHub Limits**: GitHub recommends files under 50 MB, and files over 100 MB are blocked
- **Better Distribution**: GitHub Releases provides a clean interface for downloading specific versions
- **Version Management**: Easy to attach release notes and manage different versions

## Creating a New Release

### Method 1: Using GitHub Web Interface

1. **Navigate to Releases**
   - Go to your repository on GitHub
   - Click on the "Releases" tab (or go to `https://github.com/YOUR_USERNAME/YOUR_REPO/releases`)

2. **Draft a New Release**
   - Click "Draft a new release" button

3. **Fill in Release Details**
   - **Tag version**: Create a new tag (e.g., `v1.0.9`) or select an existing tag
   - **Release title**: Descriptive title (e.g., `Smart Factory v1.0.9`)
   - **Description**: Add release notes describing changes, fixes, or new features
   - Example:
     ```
     ## What's New
     - Fixed PLC communication issues
     - Improved UI performance
     - Added new 3D model viewer features
     ```

4. **Upload APK Files**
   - In the "Attach binaries" section, drag and drop your APK file(s)
   - Or click "Attach binaries by dropping them here or selecting them"
   - Upload the APK from your `releases/` folder (e.g., `smart-factory-v1.0.9.apk`)

5. **Publish**
   - Click "Publish release" to make it public
   - Or save as draft if you want to review it first

### Method 2: Using GitHub CLI (gh)

If you have GitHub CLI installed:

```bash
# Create a release with an APK file
gh release create v1.0.9 \
  --title "Smart Factory v1.0.9" \
  --notes "## What's New
- Fixed PLC communication issues
- Improved UI performance" \
  releases/smart-factory-v1.0.9.apk
```

## Workflow After Building APK

1. **Build the APK**
   ```bash
   scripts\build-apk.bat
   # or
   scripts\build-apk.ps1
   ```

2. **APK is saved to** `releases/smart-factory-v1.0.X.apk`

3. **Create GitHub Release**
   - Follow the steps above to create a release
   - Upload the APK file from the `releases/` folder

4. **Share the Release**
   - Users can download the APK directly from the GitHub Releases page
   - Link format: `https://github.com/YOUR_USERNAME/YOUR_REPO/releases/tag/v1.0.X`

## Best Practices

- **Version Tagging**: Use semantic versioning (e.g., `v1.0.9`, `v1.1.0`, `v2.0.0`)
- **Release Notes**: Always include release notes describing what changed
- **File Naming**: Keep consistent naming (e.g., `smart-factory-v1.0.9.apk`)
- **Multiple Files**: You can attach multiple files (APK, changelog, etc.) to a single release
- **Pre-releases**: Use "Set as a pre-release" for beta/alpha versions

## Downloading Releases

Users can download APK files from:
- The Releases page: `https://github.com/YOUR_USERNAME/YOUR_REPO/releases`
- Direct download link: `https://github.com/YOUR_USERNAME/YOUR_REPO/releases/download/v1.0.X/smart-factory-v1.0.X.apk`

## Troubleshooting

- **File too large**: GitHub allows files up to 2 GB for releases (much larger than the 50 MB git limit)
- **Can't find releases folder**: Make sure you've built the APK first using the build script
- **Tag already exists**: Delete the old tag/release or use a new version number

## Additional Resources

- [GitHub Releases Documentation](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
- [Semantic Versioning](https://semver.org/)

