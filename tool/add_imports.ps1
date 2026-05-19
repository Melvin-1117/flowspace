# Add AppTheme import to all files that reference AppTheme but don't import it
$libPath = Join-Path $PSScriptRoot "..\lib"

Get-ChildItem -Path $libPath -Recurse -Filter '*.dart' | Where-Object {
    $_.Name -ne 'theme.dart'
} | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw

    # Skip if doesn't use AppTheme
    if ($content -notmatch 'AppTheme\.') { return }

    # Skip if already imports theme.dart
    if ($content -match "import.*theme\.dart") { return }

    # Calculate relative path from file to lib/app/theme.dart
    $fileDir = $file.DirectoryName
    $themePath = Join-Path $libPath "app\theme.dart"

    # Get relative path
    $relFileDir = $fileDir.Replace((Resolve-Path $libPath).Path, '').TrimStart('\')
    $depth = ($relFileDir -split '\\').Count
    if ([string]::IsNullOrEmpty($relFileDir)) { $depth = 0 }

    $prefix = '../' * $depth
    $importPath = "${prefix}app/theme.dart"

    # For files directly in lib/
    if ($depth -eq 0) {
        $importPath = "app/theme.dart"
    }

    $importLine = "import '$importPath';"

    # Insert after last existing import
    if ($content -match "(?ms)^(.*)(import [^\r\n]+;\r?\n)") {
        # Find the position after the last import statement
        $lines = $content -split "`n"
        $lastImportIndex = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^import ") {
                $lastImportIndex = $i
            }
        }
        if ($lastImportIndex -ge 0) {
            $linesList = [System.Collections.ArrayList]::new($lines)
            $linesList.Insert($lastImportIndex + 1, $importLine)
            $newContent = $linesList -join "`n"
            Set-Content $file.FullName $newContent -NoNewline
            Write-Output ("Added import: " + $file.Name)
        }
    }
}

Write-Output "Done adding imports!"
