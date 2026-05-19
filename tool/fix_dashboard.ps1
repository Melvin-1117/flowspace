# Fix pulse_dashboard_screen.dart specifically
$f = Join-Path $PSScriptRoot "..\lib\features\settings\pulse_dashboard_screen.dart"
$c = Get-Content $f -Raw

$c = $c -replace 'Color\(0xFF0D0D0D\)', 'AppTheme.surfaceCard'
$c = $c -replace 'Color\(0xFF7C3AED\)', 'AppTheme.primary'
$c = $c -replace 'Color\(0xFFEF4444\)', 'AppTheme.danger'
$c = $c -replace 'Color\(0xFF10B981\)', 'AppTheme.success'
$c = $c -replace 'Color\(0xFFF59E0B\)', 'AppTheme.warning'
$c = $c -replace 'Color\(0xFF555555\)', 'AppTheme.textSecondary'
$c = $c -replace 'Color\(0xFFF0F0F0\)', 'AppTheme.textPrimary'
$c = $c -replace 'Color\(0xFF1A1A1A\)', 'AppTheme.surfaceElevated'
$c = $c -replace 'Color\(0xFF262626\)', 'AppTheme.surfaceBorder'
$c = $c -replace 'Color\(0xFF1D1A24\)', 'AppTheme.surfaceCard'
$c = $c -replace 'Color\(0xFF7A7A83\)', 'AppTheme.textMuted'
$c = $c -replace 'Color\(0xFF181818\)', 'AppTheme.surfaceElevated'
$c = $c -replace 'Color\(0xFF161616\)', 'AppTheme.surfaceElevated'
$c = $c -replace 'Color\(0xFF1F1F1F\)', 'AppTheme.surfaceHover'
$c = $c -replace 'Color\(0xFF32195A\)', 'Color(0xFF001A3D)'
$c = $c -replace 'Color\(0xFF5D2FB0\)', 'Color(0xFF003380)'
$c = $c -replace 'const AppTheme\.', 'AppTheme.'

Set-Content $f $c -NoNewline
Write-Output "Done fixing pulse_dashboard_screen.dart"
