# Bulk color replacement script for FlowSpace theme redesign
# Only modifies widget/screen files — skips providers, services, models, and theme.dart

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

    # Purple → Disney Blue (primary)
    $content = $content -replace 'Color\(0xFF7C3AED\)', 'AppTheme.primary'
    $content = $content -replace 'Color\(0xFF8B5CF6\)', 'AppTheme.primary'
    $content = $content -replace 'Color\(0xFFC084FC\)', 'AppTheme.primaryLight'
    $content = $content -replace 'Color\(0xFF6D28D9\)', 'AppTheme.primaryDark'
    $content = $content -replace 'Color\(0xFF9D5EF0\)', 'AppTheme.primaryLight'

    # Surfaces
    $content = $content -replace 'Color\(0xFF0D0D0D\)', 'AppTheme.surfaceCard'
    $content = $content -replace 'Color\(0xFF13101A\)', 'AppTheme.surfaceCard'
    $content = $content -replace 'Color\(0xFF121212\)', 'AppTheme.surfaceCard'
    $content = $content -replace 'Color\(0xFF1A1A1A\)', 'AppTheme.surfaceElevated'
    $content = $content -replace 'Color\(0xFF2A2438\)', 'AppTheme.surfaceBorder'
    $content = $content -replace 'Color\(0xFF2A2A2A\)', 'AppTheme.surfaceBorder'
    $content = $content -replace 'Color\(0xFF09090B\)', 'AppTheme.background'

    # Text
    $content = $content -replace 'Color\(0xFFF0F0F0\)', 'AppTheme.textPrimary'
    $content = $content -replace 'Color\(0xFF555555\)', 'AppTheme.textSecondary'
    $content = $content -replace 'Color\(0xFFB0B0B0\)', 'AppTheme.textSecondary'
    $content = $content -replace 'Color\(0xFF7A7A83\)', 'AppTheme.textMuted'

    # Semantic
    $content = $content -replace 'Color\(0xFFEF4444\)', 'AppTheme.danger'
    $content = $content -replace 'Color\(0xFF10B981\)', 'AppTheme.success'
    $content = $content -replace 'Color\(0xFF2DD4BF\)', 'AppTheme.success'
    $content = $content -replace 'Color\(0xFFF59E0B\)', 'AppTheme.warning'
    $content = $content -replace 'Color\(0xFF06B6D4\)', 'AppTheme.accent'

    # Remove const from AppTheme references (AppTheme.X is not const-constructable)
    $content = $content -replace 'const AppTheme\.', 'AppTheme.'

    if ($content -ne $original) {
        Set-Content $file.FullName $content -NoNewline
        Write-Output ("Modified: " + $file.Name)
    }
}

Write-Output "Done!"
