$lines = Get-Content 'index.html'
for ($i=0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'function\s+(\w+)') {
        Write-Output (($i+1).ToString() + ': ' + $Matches[1])
    }
}
