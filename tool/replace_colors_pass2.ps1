# Second pass: Replace remaining hardcoded colors
$libPath = Join-Path $PSScriptRoot "..\lib"

Get-ChildItem -Path $libPath -Recurse -Filter '*.dart' | Where-Object {
    $_.FullName -notmatch '\\providers\\' -and
    $_.FullName -notmatch '\\services\\' -and
    $_.FullName -notmatch '\\models\\' -and
    $_.Name -ne 'theme.dart'
} | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $original = $content

    # 0xFF262626 → AppTheme.surfaceBorder
    $content = $content -replace 'Color\(0xFF262626\)', 'AppTheme.surfaceBorder'

    # 0xFF1D1A24 → AppTheme.surfaceCard (dark purple surface → navy card)
    $content = $content -replace 'Color\(0xFF1D1A24\)', 'AppTheme.surfaceCard'

    # 0x227C3AED (purple with 13% opacity border) → AppTheme.primaryGlow
    $content = $content -replace 'Color\(0x227C3AED\)', 'AppTheme.primaryGlow'

    # Raw hex 0xFF7C3AED (without Color wrapper, e.g. in color value int)
    $content = $content -replace '(?<!Color\()0xFF7C3AED', '0xFF006EE6'

    # Remove const from AppTheme references
    $content = $content -replace 'const AppTheme\.', 'AppTheme.'

    if ($content -ne $original) {
        Set-Content $file.FullName $content -NoNewline
        Write-Output ("Modified: " + $file.Name)
    }
}

Write-Output "Done pass 2!"
