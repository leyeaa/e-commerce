param(
    [string]$Source = (Join-Path $PSScriptRoot 'report-draft.md'),
    [string]$Output = (Join-Path $PSScriptRoot 'final\ENGI9839_Course_Project_Final_Report.docx')
)

$ErrorActionPreference = 'Stop'

function Encode-Text([string]$Text) {
    $encoded = [System.Net.WebUtility]::HtmlEncode($Text.Trim())
    $encoded = [regex]::Replace($encoded, '\*\*(.+?)\*\*', '<strong>$1</strong>')
    $encoded = [regex]::Replace($encoded, '`(.+?)`', '<code>$1</code>')
    $encoded = [regex]::Replace($encoded, '\*(.+?)\*', '<em>$1</em>')
    return $encoded
}

function Is-TableSeparator([string]$Line) {
    return $Line -match '^\s*\|?[\s:\-|]+\|?\s*$'
}

function Convert-ReportMarkdown([string[]]$Lines) {
    $html = [System.Text.StringBuilder]::new()
    $paragraph = [System.Collections.Generic.List[string]]::new()
    $listState = @{ Open = $false }
    $started = $false

    function Flush-Paragraph {
        if ($paragraph.Count -gt 0) {
            $joined = ($paragraph -join ' ').Trim()
            if ($joined) {
                [void]$html.AppendLine('<p>' + (Encode-Text $joined) + '</p>')
            }
            $paragraph.Clear()
        }
    }

    function Close-List {
        if ($listState.Open) {
            [void]$html.AppendLine('</ul>')
            $listState.Open = $false
        }
    }

    $i = 0
    while ($i -lt $Lines.Count) {
        $line = $Lines[$i]

        if (-not $started) {
            if ($line -eq '## Abstract') {
                $started = $true
            }
            else {
                $i++
                continue
            }
        }

        if ($line -eq '# ENGI 9839 course project report draft' -or
            $line -like 'Working title:*' -or $line -like 'Status:*') {
            $i++
            continue
        }

        if ($line -match '^\s*\|') {
            Flush-Paragraph
            Close-List
            $rows = [System.Collections.Generic.List[object]]::new()
            while ($i -lt $Lines.Count -and $Lines[$i] -match '^\s*\|') {
                if (-not (Is-TableSeparator $Lines[$i])) {
                    $cells = $Lines[$i].Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }
                    $rows.Add($cells)
                }
                $i++
            }
            if ($rows.Count -gt 0) {
                [void]$html.AppendLine('<table>')
                for ($r = 0; $r -lt $rows.Count; $r++) {
                    [void]$html.AppendLine('<tr>')
                    $tag = if ($r -eq 0) { 'th' } else { 'td' }
                    foreach ($cell in $rows[$r]) {
                        [void]$html.AppendLine('<' + $tag + '>' + (Encode-Text $cell) + '</' + $tag + '>')
                    }
                    [void]$html.AppendLine('</tr>')
                }
                [void]$html.AppendLine('</table>')
            }
            continue
        }

        if ($line -match '^(#{2,3})\s+(.+)$') {
            Flush-Paragraph
            Close-List
            $level = if ($Matches[1].Length -eq 2) { 1 } else { 2 }
            [void]$html.AppendLine('<h' + $level + '>' + (Encode-Text $Matches[2]) + '</h' + $level + '>')
            $i++
            continue
        }

        if ($line -match '^>\s?(.*)$') {
            Flush-Paragraph
            Close-List
            $quote = [System.Collections.Generic.List[string]]::new()
            while ($i -lt $Lines.Count -and $Lines[$i] -match '^>\s?(.*)$') {
                $quote.Add($Matches[1])
                $i++
            }
            [void]$html.AppendLine('<div class=figure-placeholder><p>' + (Encode-Text ($quote -join ' ')) + '</p></div>')
            continue
        }

        if ($line -match '^\s*-\s+(.+)$') {
            Flush-Paragraph
            if (-not $listState.Open) {
                [void]$html.AppendLine('<ul>')
                $listState.Open = $true
            }
            [void]$html.AppendLine('<li>' + (Encode-Text $Matches[1]) + '</li>')
            $i++
            continue
        }

        if ([string]::IsNullOrWhiteSpace($line)) {
            Flush-Paragraph
            Close-List
            $i++
            continue
        }

        $paragraph.Add($line.Trim())
        $i++
    }

    Flush-Paragraph
    Close-List
    return $html.ToString()
}

if (-not (Test-Path -LiteralPath $Source)) {
    throw 'Report source was not found.'
}

$outputDirectory = Split-Path -Parent $Output
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
$content = Convert-ReportMarkdown (Get-Content -LiteralPath $Source -Encoding utf8)
$reportTitle = 'Comparing Human-Authored Deterministic API Tests with Schema-Driven API Fuzzing on a Django E-Commerce Application'
$reportDate = Get-Date -Format 'MMMM d, yyyy'

$style = '@page{size:letter;margin:1in}body{font-family:Times New Roman;font-size:12pt;line-height:2}p{margin:0 0 10pt;text-align:justify}h1,h2{font:bold 12pt Times New Roman;margin:16pt 0 8pt}table{border-collapse:collapse;width:100%;font-size:10pt;line-height:1.15}th,td{border:1px solid #000;padding:4pt;vertical-align:top}th{background:#e7e6e6}code{font:9pt Consolas}.title,.contents{page-break-after:always}.title p{text-align:center;margin-bottom:18pt}.report-title{font-weight:bold;text-transform:uppercase;margin-top:110pt}.contents p{text-align:left;margin-bottom:4pt}.figure-placeholder{border:1.5px dashed #666;background:#f2f2f2;padding:8pt}.figure-placeholder p{text-align:left;line-height:1.15;margin:0}'
$titleHtml = '<div class=title><p>ENGI 9839: Software Verification and Validation</p><p>Course Project Report</p><p class=report-title>' + $reportTitle + '</p><p>Olaleye Adeniyi Akinuli — Student ID: 202488212<br>Chiemerie Cletus Obijiaku — Student ID: 202492457</p><p>Instructor: Raja Abbas</p><p>' + $reportDate + '</p></div>'
$contentsHtml = '<div class=contents><p><strong>CONTENTS</strong></p><p>[[TOC]]</p></div>'
$html = '<!DOCTYPE html><html><head><meta charset=utf-8><style>' + $style + '</style></head><body>' + $titleHtml + $contentsHtml + $content + '</body></html>'
$tempHtml = Join-Path $env:TEMP ('ENGI9839-report-' + [guid]::NewGuid().ToString('N') + '.html')
[System.IO.File]::WriteAllText($tempHtml, $html, [System.Text.UTF8Encoding]::new($false))

$word = $null
$document = $null
try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0
    $document = $word.Documents.Open($tempHtml, $false, $false)
    $tocRange = $document.Content.Duplicate
    if (-not $tocRange.Find.Execute('[[TOC]]')) {
        throw 'Table-of-contents marker was not found.'
    }
    $tocRange.Text = ''
    $toc = $document.TablesOfContents.Add($tocRange, $true, 1, 2)
    $toc.Update()
    foreach ($table in $document.Tables) {
        $table.AutoFitBehavior(2)
        if ($table.Rows.Count -gt 0) {
            $table.Rows.Item(1).HeadingFormat = -1
        }
    }
    foreach ($section in $document.Sections) {
        $footer = $section.Footers.Item(1)
        $footer.Range.ParagraphFormat.Alignment = 2
        [void]$footer.Range.Fields.Add($footer.Range, -1, 'PAGE', $true)
    }
    $document.SaveAs2($Output, 16)
    $pages = $document.ComputeStatistics(2)
    $words = $document.ComputeStatistics(0)
    $document.Close($false)
    $word.Quit()
    $document = $null
    $word = $null
    [pscustomobject]@{ Output = (Resolve-Path $Output).Path; Pages = $pages; Words = $words; Bytes = (Get-Item $Output).Length } | Format-List
}
finally {
    if ($document) { $document.Close($false) }
    if ($word) { $word.Quit() }
    Remove-Item -LiteralPath $tempHtml -Force -ErrorAction SilentlyContinue
}
