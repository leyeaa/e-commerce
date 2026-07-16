param(
    [string]$Source = (Join-Path $PSScriptRoot 'presentation-literature-summary.md'),
    [string]$Output = (Join-Path (Join-Path $PSScriptRoot 'final') 'ENGI9839_Presentation_Literature_Summary.docx')
)

$ErrorActionPreference = 'Stop'

function Encode([string]$value) {
    return [System.Net.WebUtility]::HtmlEncode($value)
}

function Inline-Markup([string]$value) {
    $encoded = Encode $value
    $pattern = [char]92 + '*([^*]+)' + [char]92 + '*'
    return [regex]::Replace($encoded, $pattern, '<em>$1</em>')
}

function Convert-Summary([string[]]$lines) {
    $html = [Text.StringBuilder]::new()
    $paragraph = [Collections.Generic.List[string]]::new()
    $firstHeadingSkipped = $false

    function Flush-Paragraph {
        if ($paragraph.Count -gt 0) {
            $joined = ($paragraph -join ' ').Trim()
            [void]$html.AppendLine('<p>' + (Inline-Markup $joined) + '</p>')
            $paragraph.Clear()
        }
    }

    foreach ($line in $lines) {
        if ($line -match '^# (.+)$') {
            Flush-Paragraph
            if (-not $firstHeadingSkipped) {
                $firstHeadingSkipped = $true
            }
            continue
        }
        if ($line -match '^## (.+)$') {
            Flush-Paragraph
            [void]$html.AppendLine('<h1>' + (Encode $Matches[1]) + '</h1>')
            continue
        }
        if ([string]::IsNullOrWhiteSpace($line)) {
            Flush-Paragraph
            continue
        }
        $paragraph.Add($line.Trim())
    }
    Flush-Paragraph
    return $html.ToString()
}

if (-not (Test-Path -LiteralPath $Source)) {
    throw 'Literature summary source was not found.'
}

$outputDirectory = Split-Path -Parent $Output
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$content = Convert-Summary (Get-Content -LiteralPath $Source -Encoding utf8)
$date = Get-Date -Format 'MMMM d, yyyy'

$style = '@page{size:letter;margin:1in}body{font-family:Times New Roman;font-size:12pt;line-height:2}p{margin:0 0 10pt;text-align:justify}h1{font:bold 12pt Times New Roman;margin:16pt 0 8pt}.title{page-break-after:always}.title p{text-align:center;margin-bottom:18pt}.main-title{font-weight:bold;text-transform:uppercase;margin-top:120pt}em{font-style:italic}'
$title = '<div class=title><p>ENGI 9839: Software Verification and Validation</p><p>Course Project</p><p class=main-title>Presentation Literature Summary</p><p>Comparing Human-Authored Deterministic API Tests with Schema-Driven API Fuzzing on a Django E-Commerce Application</p><p>Olaleye Adeniyi Akinuli - Student ID: 202488212<br>Chiemerie Cletus Obijiaku - Student ID: 202492457</p><p>Instructor: Raja Abbas</p><p>' + $date + '</p></div>'
$html = '<!DOCTYPE html><html><head><meta charset=utf-8><style>' + $style + '</style></head><body>' + $title + $content + '</body></html>'
$temp = Join-Path $env:TEMP ('ENGI9839-lit-' + [guid]::NewGuid().ToString('N') + '.html')
[IO.File]::WriteAllText($temp, $html, [Text.UTF8Encoding]::new($false))

$word = $null
$document = $null
try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0
    $document = $word.Documents.Open($temp, $false, $false)

    foreach ($section in $document.Sections) {
        $footer = $section.Footers.Item(1)
        $footer.Range.ParagraphFormat.Alignment = 2
        [void]$footer.Range.Fields.Add($footer.Range, -1, 'PAGE', $true)
    }

    $document.SaveAs2($Output, 16)
    $pages = $document.ComputeStatistics(2)
    $words = $document.ComputeStatistics(0)
    $document.Close($false)
    $document = $null

    [pscustomobject]@{
        Output = $Output
        Pages = $pages
        Words = $words
        Bytes = (Get-Item -LiteralPath $Output).Length
    }
}
finally {
    if ($document -ne $null) {
        try { $document.Close($false) } catch {}
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($document)
    }
    if ($word -ne $null) {
        try { $word.Quit() } catch {}
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($word)
    }
    Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}