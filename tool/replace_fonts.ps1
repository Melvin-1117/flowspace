# Replace GoogleFonts.inter with GoogleFonts.spaceGrotesk across all widget files
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

    # Replace GoogleFonts.inter( with GoogleFonts.spaceGrotesk(
    $content = $content -replace 'GoogleFonts\.inter\(', 'GoogleFonts.spaceGrotesk('

    # Replace GoogleFonts.interTextTheme with GoogleFonts.spaceGroteskTextTheme
    $content = $content -replace 'GoogleFonts\.interTextTheme', 'GoogleFonts.spaceGroteskTextTheme'

    if ($content -ne $original) {
        Set-Content $file.FullName $content -NoNewline
        Write-Output ("Modified: " + $file.Name)
    }
}

Write-Output "Done replacing Inter with Space Grotesk!"
