$libPath = Join-Path $PSScriptRoot "..\lib"

Get-ChildItem -Path $libPath -Recurse -Filter '*.dart' | Where-Object {
    $_.FullName -notmatch '\\providers\\' -and
    $_.FullName -notmatch '\\services\\' -and
    $_.FullName -notmatch '\\models\\' -and
    $_.Name -ne 'theme.dart' -and
    $_.Name -ne 'pulse_theme.dart'
} | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $original = $content

    $content = $content -replace 'Color\(0xFF000000\)', 'AppTheme.background'
    $content = $content -replace 'Color\(0xFFE48E83\)', 'AppTheme.danger'
    $content = $content -replace 'Color\(0xFF151515\)', 'AppTheme.surfaceElevated'
    $content = $content -replace 'Color\(0xFF0A0A0E\)', 'AppTheme.surfaceCard'
    $content = $content -replace 'Color\(0xFF111116\)', 'AppTheme.surfaceCard'
    $content = $content -replace 'Color\(0xFF141414\)', 'AppTheme.surfaceElevated'
    $content = $content -replace 'Color\(0xFF1A1D27\)', 'AppTheme.surfaceElevated'
    $content = $content -replace 'Color\(0xFF8F8F99\)', 'AppTheme.textMuted'
    $content = $content -replace 'Color\(0xFFB2B2B7\)', 'AppTheme.textSecondary'
    $content = $content -replace 'Color\(0xFF2A2A2A\)', 'AppTheme.surfaceBorder'
    $content = $content -replace 'Color\(0xFF6B7280\)', 'AppTheme.textMuted'
    $content = $content -replace 'Color\(0xFF9CA3AF\)', 'AppTheme.textSecondary'
    $content = $content -replace 'Color\(0xFF4C1D95\)', 'AppTheme.primaryDark'
    $content = $content -replace 'Color\(0xFF2D1B69\)', 'AppTheme.primarySubtle'
    $content = $content -replace 'Color\(0xFFEF4444\)', 'AppTheme.danger'
    $content = $content -replace 'Color\(0xFFDC2626\)', 'AppTheme.danger'
    $content = $content -replace '(?<!Color\()0xFFEF4444', '0xFFFF3B5C'
    
    $content = $content -replace 'const AppTheme\.', 'AppTheme.'

    if ($content -ne $original) {
        Set-Content $file.FullName $content -NoNewline
        Write-Output ("Modified: " + $file.Name)
    }
}
