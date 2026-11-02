<#
.SYNOPSIS
    Sincronizador dos Contactos a partir do ficheiro Excel
.DESCRIPTION
    Le o ficheiro Excel "Gabinetes_Profissional.xlsx" (na pasta pai ou local),
    atualiza o ficheiro "contactos.json" e regenera o "Diretorio_Gabinetes.html".
#>

param(
    [string]$ExcelPath = ""
)

$ErrorActionPreference = "Stop"

$currDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $currDir) { $currDir = (Get-Location).Path }

if (-not $ExcelPath) {
    $candidates = @(
        (Join-Path $currDir "Gabinetes_Profissional.xlsx"),
        (Join-Path (Split-Path -Parent $currDir) "Gabinetes_Profissional.xlsx"),
        "c:\Users\nuno.m.santos\Downloads\Gabinetes_Profissional.xlsx"
    )
    foreach ($cand in $candidates) {
        if (Test-Path $cand) {
            $ExcelPath = (Resolve-Path $cand).Path
            break
        }
    }
}

if (-not (Test-Path $ExcelPath)) {
    Write-Error "Ficheiro Excel 'Gabinetes_Profissional.xlsx' nao encontrado!"
    exit 1
}

Write-Host "A ler ficheiro Excel: $ExcelPath"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $wb = $excel.Workbooks.Open($ExcelPath)
    
    # 1. Sheet 1: Contactos
    $ws1 = $wb.Sheets.Item(1)
    $usedRange1 = $ws1.UsedRange
    $data1 = $usedRange1.Value2
    $rows1 = $data1.GetLength(0)
    $cols1 = $data1.GetLength(1)
    
    $contacts = @()
    $headers1 = @()
    for ($c = 1; $c -le $cols1; $c++) {
        $headers1 += [string]$data1[1, $c]
    }
    
    for ($r = 2; $r -le $rows1; $r++) {
        $item = [ordered]@{}
        $hasData = $false
        for ($c = 1; $c -le $cols1; $c++) {
            $h = $headers1[$c - 1]
            $val = [string]$data1[$r, $c]
            if ($val) { $val = $val.Trim() }
            if ($val -and $val -ne "â€”" -and $val -ne "-") { $hasData = $true }
            $item[$h] = $val
        }
        if ($hasData -and $item["Nome"]) {
            $contacts += [PSCustomObject]$item
        }
    }

    # 2. Sheet 2: Recursos
    $ws2 = $wb.Sheets.Item(2)
    $usedRange2 = $ws2.UsedRange
    $data2 = $usedRange2.Value2
    $rows2 = $data2.GetLength(0)
    $cols2 = $data2.GetLength(1)
    
    $resources = @()
    $headers2 = @()
    for ($c = 1; $c -le $cols2; $c++) {
        $headers2 += [string]$data2[1, $c]
    }
    
    for ($r = 2; $r -le $rows2; $r++) {
        $item = [ordered]@{}
        $hasData = $false
        for ($c = 1; $c -le $cols2; $c++) {
            $h = $headers2[$c - 1]
            $val = [string]$data2[$r, $c]
            if ($val) { $val = $val.Trim() }
            if ($val -and $val -ne "â€”" -and $val -ne "-") { $hasData = $true }
            $item[$h] = $val
        }
        if ($hasData -and $item["Gabinete"]) {
            $resources += [PSCustomObject]$item
        }
    }

    $wb.Close($false)
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb) | Out-Null
} finally {
    $excel.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

# Consolidar e Salvar em contactos.json
$allRecords = @($contacts) + @($resources)
$jsonPath = Join-Path $currDir "contactos.json"
$jsonStr = $allRecords | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($jsonPath, $jsonStr, [System.Text.Encoding]::UTF8)
Write-Host "Atualizado contactos.json ($($contacts.Count) contactos e $($resources.Count) recursos)"

# Atualizar Diretorio_Gabinetes.html
$htmlPath = Join-Path $currDir "Diretorio_Gabinetes.html"
if (Test-Path $htmlPath) {
    $cJson = $contacts | ConvertTo-Json -Depth 5 -Compress
    $rJson = $resources | ConvertTo-Json -Depth 5 -Compress

    $htmlContent = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)
    
    $htmlContent = [System.Text.RegularExpressions.Regex]::Replace($htmlContent, 'const contacts = \[.*?\];', "const contacts = $cJson;")
    $htmlContent = [System.Text.RegularExpressions.Regex]::Replace($htmlContent, 'const resources = \[.*?\];', "const resources = $rJson;")
    
    [System.IO.File]::WriteAllText($htmlPath, $htmlContent, [System.Text.Encoding]::UTF8)
    Write-Host "Atualizado Diretorio_Gabinetes.html com os novos dados do Excel!"
}

Write-Host "`nSincronizacao concluida com sucesso!"