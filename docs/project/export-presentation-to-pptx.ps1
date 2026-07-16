param(
    [string]$OutputPath = (Join-Path $PSScriptRoot "final\ENGI9839_Course_Project_Presentation.pptx"),
    [string]$PreviewDirectory = (Join-Path $PSScriptRoot "final\presentation-preview")
)

$ErrorActionPreference = "Stop"

function Rgb([int]$r, [int]$g, [int]$b) {
    return $r + (256 * $g) + (65536 * $b)
}

$navy = Rgb 15 31 54
$navy2 = Rgb 25 48 77
$teal = Rgb 35 166 154
$orange = Rgb 239 139 61
$cream = Rgb 247 246 242
$white = Rgb 255 255 255
$ink = Rgb 34 45 57
$muted = Rgb 103 116 130
$light = Rgb 226 232 238
$green = Rgb 57 145 101
$red = Rgb 194 72 68

$ppLayoutBlank = 12
$ppSaveAsOpenXMLPresentation = 24
$ppPlaceholderBody = 2
$msoFalse = 0
$msoTrue = -1
$msoTextOrientationHorizontal = 1
$msoShapeRectangle = 1
$msoShapeRoundedRectangle = 5
$msoShapeChevron = 52
$msoShapeOval = 9
$msoConnectorStraight = 1
$ppAlignLeft = 1
$ppAlignCenter = 2
$ppAlignRight = 3
$ppAnchorMiddle = 3

function Add-TextBox {
    param($Slide, [float]$Left, [float]$Top, [float]$Width, [float]$Height,
          [string]$Text, [float]$Size = 20, [int]$Color = $ink,
          [bool]$Bold = $false, [int]$Align = $ppAlignLeft,
          [string]$Font = "Aptos", [float]$Margin = 3)
    $shape = $Slide.Shapes.AddTextbox($msoTextOrientationHorizontal, $Left, $Top, $Width, $Height)
    $shape.TextFrame.MarginLeft = $Margin
    $shape.TextFrame.MarginRight = $Margin
    $shape.TextFrame.MarginTop = $Margin
    $shape.TextFrame.MarginBottom = $Margin
    $shape.TextFrame.WordWrap = $msoTrue
    $shape.TextFrame.TextRange.Text = $Text
    $shape.TextFrame.TextRange.Font.Name = $Font
    $shape.TextFrame.TextRange.Font.Size = $Size
    $shape.TextFrame.TextRange.Font.Bold = $(if ($Bold) { $msoTrue } else { $msoFalse })
    $shape.TextFrame.TextRange.Font.Color.RGB = $Color
    $shape.TextFrame.TextRange.ParagraphFormat.Alignment = $Align
    return $shape
}

function Add-Box {
    param($Slide, [float]$Left, [float]$Top, [float]$Width, [float]$Height,
          [int]$Fill, [float]$Radius = 0, [int]$Line = -1)
    $kind = $(if ($Radius -gt 0) { $msoShapeRoundedRectangle } else { $msoShapeRectangle })
    $shape = $Slide.Shapes.AddShape($kind, $Left, $Top, $Width, $Height)
    $shape.Fill.ForeColor.RGB = $Fill
    $shape.Fill.Solid()
    if ($Line -lt 0) {
        $shape.Line.Visible = $msoFalse
    } else {
        $shape.Line.Visible = $msoTrue
        $shape.Line.ForeColor.RGB = $Line
        $shape.Line.Weight = 1
    }
    return $shape
}

function Add-Circle {
    param($Slide, [float]$Left, [float]$Top, [float]$Diameter, [int]$Fill,
          [string]$Text, [int]$TextColor = $white, [float]$TextSize = 20)
    $shape = $Slide.Shapes.AddShape($msoShapeOval, $Left, $Top, $Diameter, $Diameter)
    $shape.Fill.ForeColor.RGB = $Fill
    $shape.Fill.Solid()
    $shape.Line.Visible = $msoFalse
    $shape.TextFrame.VerticalAnchor = $ppAnchorMiddle
    $shape.TextFrame.TextRange.Text = $Text
    $shape.TextFrame.TextRange.Font.Name = "Aptos Display"
    $shape.TextFrame.TextRange.Font.Size = $TextSize
    $shape.TextFrame.TextRange.Font.Bold = $msoTrue
    $shape.TextFrame.TextRange.Font.Color.RGB = $TextColor
    $shape.TextFrame.TextRange.ParagraphFormat.Alignment = $ppAlignCenter
    return $shape
}

function Set-Background {
    param($Slide, [int]$Color = $cream)
    $Slide.FollowMasterBackground = $msoFalse
    $Slide.Background.Fill.ForeColor.RGB = $Color
    $Slide.Background.Fill.Solid()
}

function Add-Header {
    param($Slide, [string]$Kicker, [string]$Title, [int]$Number)
    Add-TextBox $Slide 46 24 760 22 $Kicker.ToUpperInvariant() 11 $teal $true | Out-Null
    Add-TextBox $Slide 46 49 820 55 $Title 29 $navy $true 1 "Aptos Display" | Out-Null
    Add-TextBox $Slide 878 27 35 20 ("{0:D2}" -f $Number) 11 $muted $true $ppAlignRight | Out-Null
    $line = $Slide.Shapes.AddLine(46, 110, 914, 110)
    $line.Line.ForeColor.RGB = $light
    $line.Line.Weight = 1
}

function Add-Footer {
    param($Slide, [string]$Text = "ENGI 9839 · Software Verification and Validation")
    Add-TextBox $Slide 46 516 868 14 $Text 8 $muted $false | Out-Null
}

function Add-Notes {
    param($Slide, [string]$Text)
    $notes = $Slide.NotesPage
    foreach ($shape in $notes.Shapes) {
        try {
            if ($shape.Type -eq 14 -and $shape.PlaceholderFormat.Type -eq $ppPlaceholderBody) {
                $shape.TextFrame.TextRange.Text = $Text
                return
            }
        } catch {}
    }
}

function Add-BulletList {
    param($Slide, [float]$Left, [float]$Top, [float]$Width, [float]$Height,
          [string[]]$Items, [float]$Size = 18, [int]$Color = $ink,
          [int]$BulletColor = $teal)
    $y = $Top
    foreach ($item in $Items) {
        Add-Circle $Slide $Left ($y + 6) 7 $BulletColor "" | Out-Null
        Add-TextBox $Slide ($Left + 18) $y ($Width - 18) 48 $item $Size $Color $false | Out-Null
        $y += 52
    }
}

function Add-MetricCard {
    param($Slide, [float]$Left, [float]$Top, [float]$Width, [string]$Value,
          [string]$Label, [int]$Accent)
    Add-Box $Slide $Left $Top $Width 118 $white 8 $light | Out-Null
    Add-Box $Slide $Left $Top 7 118 $Accent 8 | Out-Null
    Add-TextBox $Slide ($Left + 21) ($Top + 16) ($Width - 32) 45 $Value 30 $navy $true 1 "Aptos Display" | Out-Null
    Add-TextBox $Slide ($Left + 21) ($Top + 67) ($Width - 32) 35 $Label 12 $muted $false | Out-Null
}

$powerPoint = $null
$presentation = $null
try {
    $outputDirectory = Split-Path -Parent $OutputPath
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
    New-Item -ItemType Directory -Force -Path $PreviewDirectory | Out-Null

    $powerPoint = New-Object -ComObject PowerPoint.Application
    $powerPoint.Visible = $msoTrue
    $presentation = $powerPoint.Presentations.Add()
    $presentation.PageSetup.SlideWidth = 960
    $presentation.PageSetup.SlideHeight = 540

    # Slide 1
    $s = $presentation.Slides.Add(1, $ppLayoutBlank)
    Set-Background $s $navy
    Add-Box $s 0 0 13 540 $teal | Out-Null
    Add-TextBox $s 56 48 320 20 "ENGI 9839 COURSE PROJECT" 11 $teal $true | Out-Null
    Add-TextBox $s 56 98 830 112 "Manual API Tests vs.`nSchema-Driven API Fuzzing" 34 $white $true 1 "Aptos Display" | Out-Null
    Add-TextBox $s 58 231 660 38 "A Django/PostgreSQL e-commerce case study" 20 (Rgb 203 216 230) $false | Out-Null
    Add-Box $s 58 302 844 1 $navy2 | Out-Null
    Add-TextBox $s 58 326 490 74 "Can generated input volume replace`ntargeted business-state oracles?" 23 $white $true | Out-Null
    Add-Box $s 693 324 209 83 $navy2 8 | Out-Null
    Add-TextBox $s 711 340 175 20 "FORMAL SCOPE" 10 $orange $true | Out-Null
    Add-TextBox $s 711 365 181 28 "2 authenticated endpoints" 14 $white $true | Out-Null
    Add-TextBox $s 58 466 650 30 "Olaleye Adeniyi Akinuli  ·  Chiemerie Cletus Obijiaku" 14 (Rgb 203 216 230) $false | Out-Null
    Add-TextBox $s 854 474 48 20 "01" 11 $teal $true $ppAlignRight | Out-Null
    Add-Notes $s "We compared human-authored deterministic API tests with Schemathesis fuzzing on cart update and order creation. Exploratory testing was a separate required system-level activity. Our question was not which technique wins universally, but how they differ in defects, coverage, effort, and fault type on this case."

    # Slide 2
    $s = $presentation.Slides.Add(2, $ppLayoutBlank)
    Set-Background $s
    Add-Header $s "Method" "A controlled comparison on one frozen baseline" 2
    $cols = @(
        @{ X=46; Accent=$teal; Num="01"; Title="Human-authored"; Sub="20 pytest cases"; Lines=@("Database-state oracles", "Ownership and rollback", "Deterministic execution") },
        @{ X=343; Accent=$orange; Num="02"; Title="Schema-driven"; Sub="3,252 generated cases"; Lines=@("Three fixed seeds", "OpenAPI 3.0.3", "Per-case state reset") },
        @{ X=640; Accent=$navy2; Num="03"; Title="Exploratory"; Sub="Two 90-minute sessions"; Lines=@("Chartered journeys", "Journals and debriefs", "Reported separately") }
    )
    foreach ($c in $cols) {
        Add-Box $s $c.X 145 274 302 $white 9 $light | Out-Null
        Add-Circle $s ($c.X + 20) 165 39 $c.Accent $c.Num $white 13 | Out-Null
        Add-TextBox $s ($c.X + 20) 219 234 30 $c.Title 19 $navy $true | Out-Null
        Add-TextBox $s ($c.X + 20) 254 234 27 $c.Sub 13 $c.Accent $true | Out-Null
        $yy = 305
        foreach ($line in $c.Lines) {
            Add-Circle $s ($c.X + 21) ($yy + 6) 6 $c.Accent "" | Out-Null
            Add-TextBox $s ($c.X + 37) $yy 210 32 $line 14 $ink $false | Out-Null
            $yy += 42
        }
    }
    Add-TextBox $s 48 465 865 28 "Fairness rule: count unique root causes—not requests, checks, or repeated symptoms [1], [2]." 14 $navy $true $ppAlignCenter | Out-Null
    Add-Footer $s
    Add-Notes $s "Both formal techniques targeted the same two endpoints and baseline. The human-authored suite deliberately checked ownership, mutation after rejection, persistence, totals, and rollback. Schemathesis generated positive, negative, coverage, and fuzz inputs and checked response properties. Known defects were tagged K and excluded from novel counts. This avoided claiming repeated symptoms as separate defects."

    # Slide 3
    $s = $presentation.Slides.Add(3, $ppLayoutBlank)
    Set-Background $s
    Add-Header $s "Results" "Generated volume did not translate into more root causes" 3
    Add-MetricCard $s 46 145 252 "20" "Human-authored cases" $teal
    Add-MetricCard $s 354 145 252 "3,252" "Schemathesis cases" $orange
    Add-MetricCard $s 662 145 252 "0 / 0" "Novel roots: manual / fuzzing" $navy2

    Add-Box $s 46 291 868 174 $white 8 $light | Out-Null
    Add-TextBox $s 69 308 190 22 "COMPARABLE OUTCOME" 10 $muted $true | Out-Null
    Add-TextBox $s 69 343 295 46 "8 known root causes" 25 $teal $true 1 "Aptos Display" | Out-Null
    Add-TextBox $s 69 390 295 30 "reproduced by the targeted suite" 13 $muted | Out-Null
    Add-TextBox $s 440 343 250 46 "3 known root causes" 25 $orange $true 1 "Aptos Display" | Out-Null
    Add-TextBox $s 440 390 250 30 "reproduced by Schemathesis" 13 $muted | Out-Null
    Add-Box $s 728 320 155 112 $navy 8 | Out-Null
    Add-TextBox $s 742 335 127 35 "64.5%" 27 $white $true $ppAlignCenter "Aptos Display" | Out-Null
    Add-TextBox $s 742 373 127 40 "manual comparable`ncoverage" 11 (Rgb 203 216 230) $false $ppAlignCenter | Out-Null
    Add-TextBox $s 48 478 865 23 "Duration: 2.88 s test time (8.769 s runner) vs. 552.58 s fuzzing." 12 $muted $false $ppAlignCenter | Out-Null
    Add-Footer $s
    Add-Notes $s "The 3,252 generated cases produced nine failing cases and fifteen raw failed checks, but these reduced to only K-002, K-004, and K-009. The human-authored suite reproduced K-001 through K-007 and K-009. One expected manual failure passed and led us to reject K-008 as a duplicate misclassification, which is an important validity result rather than a product success claim."

    # Slide 4
    $s = $presentation.Slides.Add(4, $ppLayoutBlank)
    Set-Background $s
    Add-Header $s "Interpretation" "The techniques observed different kinds of evidence" 4
    Add-Box $s 46 145 414 294 $white 9 $light | Out-Null
    Add-Box $s 500 145 414 294 $white 9 $light | Out-Null
    Add-Box $s 46 145 414 10 $teal 8 | Out-Null
    Add-Box $s 500 145 414 10 $orange 8 | Out-Null
    Add-TextBox $s 70 174 355 30 "Human-authored strengths" 20 $navy $true | Out-Null
    Add-BulletList $s 72 224 350 180 @("Cross-user ownership", "State mutation after rejection", "Missing persistence", "Transaction rollback") 16 $ink $teal
    Add-TextBox $s 70 410 355 20 "ROOTS: K-001 to K-007, K-009" 11 $teal $true | Out-Null
    Add-TextBox $s 524 174 355 30 "Schemathesis strengths" 20 $navy $true | Out-Null
    Add-BulletList $s 526 224 350 180 @("High-volume malformed input", "Repeatability across seeds", "Contract and status violations", "Broad input-space exploration") 16 $ink $orange
    Add-TextBox $s 524 410 355 20 "ROOTS: K-002, K-004, K-009" 11 $orange $true | Out-Null
    Add-Box $s 46 461 868 39 $navy 6 | Out-Null
    Add-TextBox $s 62 469 836 23 "Generated volume ≠ defect count [2]    ·    Coverage supports—not proves—effectiveness [5]" 13 $white $true $ppAlignCenter | Out-Null
    Add-Footer $s
    Add-Notes $s "The human-authored advantage came from deeper application-specific oracles, not from manual execution—the tests themselves ran automatically. Schemathesis reduced case-by-case input design and repeatedly exposed input-validation failures, but response-level black-box checks could not directly detect missing database fields or partial transactions."

    # Slide 5
    $s = $presentation.Slides.Add(5, $ppLayoutBlank)
    Set-Background $s
    Add-Header $s "Exploratory testing" "The complete user journey exposed three additional root causes" 5
    Add-MetricCard $s 46 143 202 "180 min" "Two chartered sessions" $navy2
    Add-MetricCard $s 264 143 202 "3" "Novel root causes" $teal
    Add-MetricCard $s 482 143 202 "2" "Known roots reproduced" $orange
    Add-MetricCard $s 700 143 214 "17 digits" "Phone number accepted" $red

    Add-Box $s 46 289 420 173 $white 8 $light | Out-Null
    Add-TextBox $s 68 308 372 23 "WHAT THE JOURNEY REVEALED" 10 $muted $true | Out-Null
    Add-BulletList $s 70 343 365 110 @("No cart refetch after login", "Empty image-source warning", "Missing checkout validation") 15 $ink $teal
    Add-Box $s 500 289 414 173 $navy 8 | Out-Null
    Add-TextBox $s 523 310 365 20 "MOST CONFUSING BEHAVIOUR" 10 $orange $true | Out-Null
    Add-TextBox $s 523 346 360 37 "'Order failed'" 27 $white $true 1 "Aptos Display" | Out-Null
    Add-TextBox $s 523 391 360 43 "An expired session appeared to be an address error." 15 (Rgb 203 216 230) $false | Out-Null
    Add-TextBox $s 48 478 865 22 "Charters, journals, and debriefs controlled exploratory coverage risk [3], [4]." 12 $muted $false $ppAlignCenter | Out-Null
    Add-Footer $s
    Add-Notes $s "Exploration followed the complete frontend journey and therefore found issues outside the two-operation formal scope: no cart refetch after login, misleading expired-authentication handling, and empty image-source warnings. E-02 added no new root cause, but showed that long and whitespace checkout values reproduced missing validation. Retrying the punctuation-rich address after login proved that punctuation was not the cause of the earlier 401 failure."

    # Slide 6
    $s = $presentation.Slides.Add(6, $ppLayoutBlank)
    Set-Background $s
    Add-Header $s "Answer and recommendation" "Use the techniques together—not as interchangeable substitutes" 6
    Add-Box $s 46 145 868 82 $navy 8 | Out-Null
    Add-TextBox $s 65 165 830 42 "Targeted business-state oracles + generated contract exploration + exploratory journeys" 22 $white $true $ppAlignCenter "Aptos Display" | Out-Null
    $recs = @(
        @{ X=46; N="1"; T="Pair the oracles"; D="Keep generated input breadth, then add explicit persistence, ownership, and rollback checks."; C=$teal },
        @{ X=343; N="2"; T="Explore lifecycles"; D="Use timeboxed journeys to expose authentication, navigation, and user-feedback failures."; C=$orange },
        @{ X=640; N="3"; T="Compare fairly"; D="Deduplicate root causes and never equate request volume with defects."; C=$navy2 }
    )
    foreach ($r in $recs) {
        Add-Circle $s $r.X 262 35 $r.C $r.N $white 15 | Out-Null
        Add-TextBox $s ($r.X + 48) 263 220 26 $r.T 17 $navy $true | Out-Null
        Add-TextBox $s $r.X 309 267 88 $r.D 14 $ink $false | Out-Null
    }
    Add-Box $s 46 405 868 43 (Rgb 235 238 241) 7 | Out-Null
    Add-TextBox $s 60 414 840 26 "CHALLENGES: state isolation | schema/harness correction | aborted-run recovery | K-008 reclassification" 11 $navy $true $ppAlignCenter | Out-Null
    Add-Box $s 46 456 868 43 (Rgb 239 241 243) 7 | Out-Null
    Add-TextBox $s 60 465 840 26 "LIMITS: one application | two endpoints | one fuzzer | one exploratory tester | incomplete formal-effort records" 10.5 $muted $false $ppAlignCenter | Out-Null
    Add-Footer $s
    Add-Notes $s "For this case, 20 targeted tests expressed more defect-revealing backend oracles than thousands of generated cases, while fuzzing provided systematic input breadth and repeatability. Exploratory testing added user-visible findings but had broader scope, so it is reported separately rather than declared the winner. These results cannot support a general ranking. The work also involved genuine challenges: isolating destructive state, correcting schema and harness inaccuracies, preserving and repeating an aborted fuzz run, rejecting K-008 after an unexpected pass, and distinguishing expired JWTs from address validation. Prospective formal-effort logs remain a limitation."

    # Slide 7
    $s = $presentation.Slides.Add(7, $ppLayoutBlank)
    Set-Background $s $navy
    Add-TextBox $s 56 46 800 20 "CONCLUSION" 11 $teal $true | Out-Null
    Add-TextBox $s 56 88 815 75 "Breadth and depth answer`ndifferent testing questions." 32 $white $true 1 "Aptos Display" | Out-Null
    $takeaways = @(
        @{ Y=224; C=$teal; T="Human-designed oracles"; D="revealed deeper data-integrity and transaction faults." },
        @{ Y=304; C=$orange; T="Schema-driven fuzzing"; D="efficiently exercised contract-invalid inputs at scale." },
        @{ Y=384; C=(Rgb 124 155 195); T="Exploratory testing"; D="exposed authentication and frontend lifecycle behaviour." }
    )
    foreach ($t in $takeaways) {
        Add-Circle $s 58 ($t.Y + 3) 13 $t.C "" | Out-Null
        Add-TextBox $s 86 $t.Y 265 31 $t.T 17 $white $true | Out-Null
        Add-TextBox $s 349 $t.Y 505 42 $t.D 17 (Rgb 203 216 230) $false | Out-Null
    }
    Add-TextBox $s 57 488 430 25 "Next: more endpoints, tools, testers, and mutation analysis" 12 $teal $true | Out-Null
    Add-TextBox $s 724 476 177 38 "Questions?" 25 $white $true $ppAlignRight "Aptos Display" | Out-Null
    Add-Notes $s "Human-designed oracles found deeper data-integrity and transaction faults. Schemathesis efficiently exercised the contract-invalid input surface. Exploratory testing exposed authentication and frontend lifecycle behavior. Future work should add more endpoints and tools, independent testers, mutation testing, and post-baseline regression fixes."

    # Slide 8
    $s = $presentation.Slides.Add(8, $ppLayoutBlank)
    Set-Background $s
    Add-Header $s "Sources" "IEEE bibliography" 8
    $refsLeft = @(
        "[1] Z. Hatfield-Dodds and D. Dygalo, 'Deriving semantics-aware fuzzers from Web API schemas,' in 2022 IEEE/ACM ICSE Companion, 2022, pp. 345–346. doi: 10.1109/ICSE-Companion55297.2022.9793781.",
        "[2] H. Sartaj, S. Ali, and J. M. Gjøby, 'REST API testing in DevOps: A study on an evolving healthcare IoT application,' ACM Trans. Softw. Eng. Methodol., vol. 35, no. 6, pp. 1–46, 2026. doi: 10.1145/3765744.",
        "[3] J. Itkonen and K. Rautiainen, 'Exploratory testing: A multiple case study,' in 2005 Int. Symp. Empirical Software Engineering, 2005, pp. 84–93. doi: 10.1109/ISESE.2005.1541817."
    )
    $refsRight = @(
        "[4] J. Itkonen, M. V. Mäntylä, and C. Lassenius, 'Defect detection efficiency: Test case based vs. exploratory testing,' in First Int. Symp. Empirical Software Engineering and Measurement, 2007, pp. 61–70. doi: 10.1109/ESEM.2007.56.",
        "[5] L. Inozemtseva and R. Holmes, 'Coverage is not strongly correlated with test suite effectiveness,' in Proc. 36th Int. Conf. Software Engineering, 2014, pp. 435–445. doi: 10.1145/2568225.2568271."
    )
    Add-Box $s 46 140 414 330 $white 8 $light | Out-Null
    Add-Box $s 500 140 414 330 $white 8 $light | Out-Null
    $y = 160
    foreach ($ref in $refsLeft) {
        Add-TextBox $s 66 $y 374 82 $ref 11 $ink $false | Out-Null
        $y += 100
    }
    $y = 160
    foreach ($ref in $refsRight) {
        Add-TextBox $s 520 $y 374 115 $ref 11 $ink $false | Out-Null
        $y += 145
    }
    Add-TextBox $s 48 487 865 22 "The accompanying literature summary provides a source-by-source discussion." 11 $muted $false $ppAlignCenter | Out-Null
    Add-Footer $s

    foreach ($slide in $presentation.Slides) {
        $slide.SlideShowTransition.AdvanceOnTime = $msoFalse
        $slide.SlideShowTransition.AdvanceOnClick = $msoTrue
    }

    $presentation.SaveAs($OutputPath, $ppSaveAsOpenXMLPresentation)
    $presentation.Export($PreviewDirectory, "PNG", 1600, 900)
    $presentation.Save()

    $slideCount = $presentation.Slides.Count
    $notesCount = 0
    foreach ($slide in $presentation.Slides) {
        foreach ($shape in $slide.NotesPage.Shapes) {
            try {
                if ($shape.Type -eq 14 -and $shape.PlaceholderFormat.Type -eq $ppPlaceholderBody -and $shape.TextFrame.TextRange.Text.Trim().Length -gt 0) {
                    $notesCount++
                    break
                }
            } catch {}
        }
    }
    Write-Output "Created: $OutputPath"
    Write-Output "Slides: $slideCount"
    Write-Output "Slides with speaker notes: $notesCount"
    Write-Output "Preview directory: $PreviewDirectory"
}
finally {
    if ($presentation -ne $null) {
        try { $presentation.Close() } catch {}
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($presentation)
    }
    if ($powerPoint -ne $null) {
        try { $powerPoint.Quit() } catch {}
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($powerPoint)
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
