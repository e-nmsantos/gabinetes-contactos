<#
.SYNOPSIS
    Diretorio Institucional dos Gabinetes - Ministerio das Financas (SEAO, SEAF, SEAP)
.DESCRIPTION
    Aplicacao nativa Windows em PowerShell (Windows Forms) com pesquisa em tempo real sem acentos,
    filtros por gabinete, separador de frota/espacos, discagem/copia de numero, envio de email e exportacao para Excel/CSV.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# Obter diretorio do script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = (Get-Location).Path }
$jsonPath = Join-Path $scriptDir "contactos.json"

if (-not (Test-Path $jsonPath)) {
    [System.Windows.Forms.MessageBox]::Show("Ficheiro de dados contactos.json nao encontrado em: $jsonPath", "Erro", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

$jsonData = Get-Content -LiteralPath $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$allContacts = @($jsonData | Where-Object { -not $_.'Tipo de Recurso' -or [string]::IsNullOrWhiteSpace($_.'Tipo de Recurso') })
$allResources = @($jsonData | Where-Object { $_.'Tipo de Recurso' -and -not [string]::IsNullOrWhiteSpace($_.'Tipo de Recurso') })

# Funcao de normalizacao de texto (remove acentos para busca inteligente)
function Normalize-Text([string]$text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return "" }
    $norm = $text.Normalize([System.Text.NormalizationForm]::FormD)
    $sb = New-Object System.Text.StringBuilder
    foreach ($c in $norm.ToCharArray()) {
        $uc = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c)
        if ($uc -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($c)
        }
    }
    return $sb.ToString().ToLower().Trim()
}

# Janela Principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ministerio das Financas - Diretorio Institucional dos Gabinetes"
$form.Size = New-Object System.Drawing.Size(1260, 780)
$form.MinimumSize = New-Object System.Drawing.Size(980, 620)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#F8FAFC")
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# 1. Header institucional
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$headerPanel.Height = 82
$headerPanel.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#0B2545")
$form.Controls.Add($headerPanel)

$lblSub = New-Object System.Windows.Forms.Label
$lblSub.Text = "GOVERNO DE PORTUGAL - MINISTERIO DAS FINANCAS"
$lblSub.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$lblSub.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#94A3B8")
$lblSub.Location = New-Object System.Drawing.Point(24, 14)
$lblSub.AutoSize = $true
$headerPanel.Controls.Add($lblSub)

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Diretorio dos Gabinetes Governamentais e Entidades (GPEARI & SG-GOV)"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 13.5, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [System.Drawing.Color]::White
$lblTitle.Location = New-Object System.Drawing.Point(24, 38)
$lblTitle.AutoSize = $true
$headerPanel.Controls.Add($lblTitle)

$logoFile = Join-Path $scriptDir "logo_governo.png"
if (Test-Path $logoFile) {
    try {
        $picLogo = New-Object System.Windows.Forms.PictureBox
        $picLogo.Image = [System.Drawing.Image]::FromFile($logoFile)
        $picLogo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $picLogo.Size = New-Object System.Drawing.Size(46, 56)
        $picLogo.Location = New-Object System.Drawing.Point(20, 13)
        $picLogo.BackColor = [System.Drawing.Color]::Transparent
        $headerPanel.Controls.Add($picLogo)
        $lblSub.Location = New-Object System.Drawing.Point(78, 14)
        $lblTitle.Location = New-Object System.Drawing.Point(78, 38)
    } catch {}
}

# Badge com contagem total no cabecalho
$lblStats = New-Object System.Windows.Forms.Label
$lblStats.Text = "$($allContacts.Count) Contactos | $($allResources.Count) Recursos"
$lblStats.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$lblStats.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#38BDF8")
$lblStats.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#133E68")
$lblStats.Padding = New-Object System.Windows.Forms.Padding(12, 6, 12, 6)
$lblStats.Location = New-Object System.Drawing.Point(1010, 24)
$lblStats.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$lblStats.AutoSize = $true
$headerPanel.Controls.Add($lblStats)

# 2. Barra de Controlos (Pesquisa + Filtros + Acoes)
$controlPanel = New-Object System.Windows.Forms.Panel
$controlPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$controlPanel.Height = 60
$controlPanel.BackColor = [System.Drawing.Color]::White
$controlPanel.Padding = New-Object System.Windows.Forms.Padding(16, 10, 16, 10)
$form.Controls.Add($controlPanel)

# Caixa de Pesquisa
$lblSearch = New-Object System.Windows.Forms.Label
$lblSearch.Text = "Pesquisar:"
$lblSearch.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$lblSearch.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#1E293B")
$lblSearch.Location = New-Object System.Drawing.Point(14, 18)
$lblSearch.AutoSize = $true
$controlPanel.Controls.Add($lblSearch)

$txtSearch = New-Object System.Windows.Forms.TextBox
$txtSearch.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$txtSearch.Location = New-Object System.Drawing.Point(90, 14)
$txtSearch.Width = 260
$controlPanel.Controls.Add($txtSearch)

# Filtros por Gabinete
$lblFiltrar = New-Object System.Windows.Forms.Label
$lblFiltrar.Text = "Gabinetes:"
$lblFiltrar.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblFiltrar.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#475569")
$lblFiltrar.Location = New-Object System.Drawing.Point(365, 18)
$lblFiltrar.AutoSize = $true
$controlPanel.Controls.Add($lblFiltrar)

$script:selectedGab = "TODOS"
$gabButtons = @{}
$gabs = @("TODOS", "MEF", "SETF", "SEAO", "SEAF", "SEAP")
$btnX = 435

foreach ($g in $gabs) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $g
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 8.2, [System.Drawing.FontStyle]::Bold)
    $btn.Location = New-Object System.Drawing.Point($btnX, 13)
    $btnW = if ($g -eq "TODOS") { 64 } else { 52 }
    $btn.Size = New-Object System.Drawing.Size($btnW, 30)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 1
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    
    $btn.Add_Click({
        param($sender, $e)
        $script:selectedGab = $sender.Text
        Update-GabButtons
        Apply-Filter
    })
    
    $controlPanel.Controls.Add($btn)
    $gabButtons[$g] = $btn
    $btnX += ($btnW + 4)
}

# Separador / Label Entidades
$lblEnt = New-Object System.Windows.Forms.Label
$lblEnt.Text = "Entidades:"
$lblEnt.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblEnt.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#475569")
$lblEnt.Location = New-Object System.Drawing.Point($btnX + 8, 18)
$lblEnt.AutoSize = $true
$controlPanel.Controls.Add($lblEnt)

$btnGpeari = New-Object System.Windows.Forms.Button
$btnGpeari.Text = "GPEARI"
$btnGpeari.Font = New-Object System.Drawing.Font("Segoe UI", 8.2, [System.Drawing.FontStyle]::Bold)
$btnGpeari.Location = New-Object System.Drawing.Point($btnX + 72, 13)
$btnGpeari.Size = New-Object System.Drawing.Size(64, 30)
$btnGpeari.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnGpeari.FlatAppearance.BorderSize = 1
$btnGpeari.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnGpeari.Add_Click({
    param($sender, $e)
    $script:selectedGab = "GPEARI"
    Update-GabButtons
    Apply-Filter
})
$controlPanel.Controls.Add($btnGpeari)
$gabButtons["GPEARI"] = $btnGpeari

$btnSggov = New-Object System.Windows.Forms.Button
$btnSggov.Text = "SG-GOV"
$btnSggov.Font = New-Object System.Drawing.Font("Segoe UI", 8.2, [System.Drawing.FontStyle]::Bold)
$btnSggov.Location = New-Object System.Drawing.Point($btnX + 140, 13)
$btnSggov.Size = New-Object System.Drawing.Size(68, 30)
$btnSggov.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSggov.FlatAppearance.BorderSize = 1
$btnSggov.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnSggov.Add_Click({
    param($sender, $e)
    $script:selectedGab = "SG-GOV"
    Update-GabButtons
    Apply-Filter
})
$controlPanel.Controls.Add($btnSggov)
$gabButtons["SG-GOV"] = $btnSggov

# Botao Exportar para Excel / CSV
$btnCsv = New-Object System.Windows.Forms.Button
$btnCsv.Text = "Exportar CSV"
$btnCsv.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$btnCsv.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#475569")
$btnCsv.ForeColor = [System.Drawing.Color]::White
$btnCsv.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnCsv.FlatAppearance.BorderSize = 0
$btnCsv.Size = New-Object System.Drawing.Size(110, 32)
$btnCsv.Location = New-Object System.Drawing.Point(860, 12)
$btnCsv.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$btnCsv.Cursor = [System.Windows.Forms.Cursors]::Hand
$controlPanel.Controls.Add($btnCsv)

# Botao Ligar / Copiar
$btnCall = New-Object System.Windows.Forms.Button
$btnCall.Text = "Ligar / Copiar"
$btnCall.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$btnCall.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#059669")
$btnCall.ForeColor = [System.Drawing.Color]::White
$btnCall.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnCall.FlatAppearance.BorderSize = 0
$btnCall.Size = New-Object System.Drawing.Size(120, 32)
$btnCall.Location = New-Object System.Drawing.Point(980, 12)
$btnCall.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$btnCall.Cursor = [System.Windows.Forms.Cursors]::Hand
$controlPanel.Controls.Add($btnCall)

# Botao Enviar Email
$btnEmail = New-Object System.Windows.Forms.Button
$btnEmail.Text = "Enviar E-mail"
$btnEmail.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$btnEmail.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#2563EB")
$btnEmail.ForeColor = [System.Drawing.Color]::White
$btnEmail.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnEmail.FlatAppearance.BorderSize = 0
$btnEmail.Size = New-Object System.Drawing.Size(120, 32)
$btnEmail.Location = New-Object System.Drawing.Point(1110, 12)
$btnEmail.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$btnEmail.Cursor = [System.Windows.Forms.Cursors]::Hand
$controlPanel.Controls.Add($btnEmail)

# 3. Separadores (TabControl: Contactos e Frota/Salas)
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = [System.Windows.Forms.DockStyle]::Fill
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$tabControl.Padding = New-Object System.Drawing.Point(14, 6)

$tabContacts = New-Object System.Windows.Forms.TabPage
$tabContacts.Text = "   Colaboradores e Gabinetes   "
$tabContacts.BackColor = [System.Drawing.Color]::White

$tabResources = New-Object System.Windows.Forms.TabPage
$tabResources.Text = "   Frota Automovel e Salas de Reuniao   "
$tabResources.BackColor = [System.Drawing.Color]::White

$tabControl.Controls.Add($tabContacts)
$tabControl.Controls.Add($tabResources)
$form.Controls.Add($tabControl)

# Ordem dos controlos
$headerPanel.BringToFront()
$controlPanel.BringToFront()
$tabControl.BringToFront()

# Tabela de Contactos (DataGridView)
$gridContacts = New-Object System.Windows.Forms.DataGridView
$gridContacts.Dock = [System.Windows.Forms.DockStyle]::Fill
$gridContacts.BackgroundColor = [System.Drawing.Color]::White
$gridContacts.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$gridContacts.AllowUserToAddRows = $false
$gridContacts.AllowUserToDeleteRows = $false
$gridContacts.ReadOnly = $true
$gridContacts.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$gridContacts.MultiSelect = $false
$gridContacts.RowHeadersVisible = $false
$gridContacts.AlternatingRowsDefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#F8FAFC")
$gridContacts.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$gridContacts.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$gridContacts.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#0F2C59")
$gridContacts.ColumnHeadersDefaultCellStyle.ForeColor = [System.Drawing.Color]::White
$gridContacts.ColumnHeadersHeight = 36
$gridContacts.EnableHeadersVisualStyles = $false
$gridContacts.RowTemplate.Height = 30
$gridContacts.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

$colDefs = @(
    @("Gabinete", "Gabinete", 75, "Center"),
    @("Area", "Area / Funcao", 110, "Center"),
    @("Cargo", "Cargo", 140, "Left"),
    @("Nome", "Nome Completo", 180, "Left"),
    @("Ramal", "Ramal VOIP", 95, "Center"),
    @("Direto", "Telefone Direto", 110, "Center"),
    @("Movel", "Telemovel", 110, "Center"),
    @("Sala", "Sala / Piso", 90, "Center"),
    @("Email", "Correio Eletronico", 190, "Left")
)

foreach ($c in $colDefs) {
    $col = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $col.Name = $c[0]
    $col.HeaderText = $c[1]
    $col.FillWeight = $c[2]
    if ($c[3] -eq "Center") {
        $col.DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
        $col.HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
    } else {
        $col.DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
    }
    [void]$gridContacts.Columns.Add($col)
}

$tabContacts.Controls.Add($gridContacts)

# Tabela de Recursos (DataGridView)
$gridResources = New-Object System.Windows.Forms.DataGridView
$gridResources.Dock = [System.Windows.Forms.DockStyle]::Fill
$gridResources.BackgroundColor = [System.Drawing.Color]::White
$gridResources.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$gridResources.AllowUserToAddRows = $false
$gridResources.AllowUserToDeleteRows = $false
$gridResources.ReadOnly = $true
$gridResources.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$gridResources.MultiSelect = $false
$gridResources.RowHeadersVisible = $false
$gridResources.AlternatingRowsDefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#F8FAFC")
$gridResources.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$gridResources.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$gridResources.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#0F2C59")
$gridResources.ColumnHeadersDefaultCellStyle.ForeColor = [System.Drawing.Color]::White
$gridResources.ColumnHeadersHeight = 36
$gridResources.EnableHeadersVisualStyles = $false
$gridResources.RowTemplate.Height = 30
$gridResources.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

$colResDefs = @(
    @("Gabinete", "Gabinete", 80, "Center"),
    @("Tipo", "Tipo", 90, "Center"),
    @("Designacao", "Designacao / Recurso", 150, "Left"),
    @("Responsavel", "Responsavel / Motorista", 170, "Left"),
    @("Contacto", "Contactos Telefonicos", 180, "Center"),
    @("Identificador", "Matricula / Sala", 130, "Center"),
    @("Detalhes", "Capacidade / Detalhes", 200, "Left")
)

foreach ($c in $colResDefs) {
    $col = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $col.Name = $c[0]
    $col.HeaderText = $c[1]
    $col.FillWeight = $c[2]
    if ($c[3] -eq "Center") {
        $col.DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
        $col.HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
    } else {
        $col.DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
    }
    [void]$gridResources.Columns.Add($col)
}

$tabResources.Controls.Add($gridResources)

# Barra de Estado Inferior
$statusStrip = New-Object System.Windows.Forms.StatusStrip
$statusStrip.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#F1F5F9")
$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusLabel.Text = "Pronto."
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusStrip.Items.Add($statusLabel)
$form.Controls.Add($statusStrip)

# Funcoes de Atualizacao e Filtragem
function Update-GabButtons {
    foreach ($k in $gabButtons.Keys) {
        $b = $gabButtons[$k]
        if ($k -eq $script:selectedGab) {
            $b.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#0B2545")
            $b.ForeColor = [System.Drawing.Color]::White
            $b.FlatAppearance.BorderColor = [System.Drawing.ColorTranslator]::FromHtml("#0B2545")
        } else {
            $b.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#E2E8F0")
            $b.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#334155")
            $b.FlatAppearance.BorderColor = [System.Drawing.ColorTranslator]::FromHtml("#CBD5E1")
        }
    }
}

function Apply-Filter {
    $q = Normalize-Text $txtSearch.Text

    # Filtrar Contactos
    $gridContacts.Rows.Clear()
    $countC = 0
    foreach ($c in $allContacts) {
        if ($script:selectedGab -eq "TODOS") {
            if ($c.Gabinete -eq "GPEARI" -or $c.Gabinete -eq "SG-GOV" -or $c.Gabinete -eq "SGGOV") { continue }
        } elseif ($script:selectedGab -eq "SG-GOV") {
            if ($c.Gabinete -ne "SG-GOV" -and $c.Gabinete -ne "SGGOV") { continue }
        } elseif ($c.Gabinete -ne $script:selectedGab) {
            continue
        }
        $n = [string]$c.Nome
        $cg = [string]$c.Cargo
        $em = [string]$c.'E-mail'
        $area = [string]$c.'Ãrea / FunÃ§Ã£o'
        if (-not $area) { $area = [string]$c.'Area / Funcao' }
        $rm = [string]$c.'Ramal Interno'
        $dr = [string]$c.'Telefone Direto'
        $mv = [string]$c.'TelemÃ³vel'
        if (-not $mv) { $mv = [string]$c.Telemovel }
        $sl = [string]$c.'Piso / Sala'
        $nt = [string]$c.Notas

        $searchLine = Normalize-Text "$n $cg $em $rm $mv $dr $sl $area $nt"
        if ($q -and (-not $searchLine.Contains($q))) {
            continue
        }

        [void]$gridContacts.Rows.Add(
            $c.Gabinete,
            $area,
            $cg,
            $n,
            $rm,
            $dr,
            $mv,
            $sl,
            $em
        )
        $countC++
    }

    # Filtrar Recursos
    $gridResources.Rows.Clear()
    $countR = 0
    foreach ($r in $allResources) {
        if ($script:selectedGab -eq "TODOS") {
            if ($r.Gabinete -eq "GPEARI" -or $r.Gabinete -eq "SG-GOV" -or $r.Gabinete -eq "SGGOV") { continue }
        } elseif ($script:selectedGab -eq "SG-GOV") {
            if ($r.Gabinete -ne "SG-GOV" -and $r.Gabinete -ne "SGGOV") { continue }
        } elseif ($r.Gabinete -ne $script:selectedGab) {
            continue
        }
        $des = [string]$r.'DesignaÃ§Ã£o / Recurso'
        if (-not $des) { $des = [string]$r.'Designacao / Recurso' }
        $resp = [string]$r.'ResponsÃ¡vel / Motorista'
        if (-not $resp) { $resp = [string]$r.'Responsavel / Motorista' }
        $ct = [string]$r.'TelemÃ³vel / Telefone'
        if (-not $ct) { $ct = [string]$r.'Telemovel / Telefone' }
        $id = [string]$r.'Identificador / MatrÃ­cula'
        if (-not $id) { $id = [string]$r.'Identificador / Matricula' }
        $dt = [string]$r.'Capacidade / Detalhes'

        $searchLine = Normalize-Text "$des $resp $ct $id $dt"
        if ($q -and (-not $searchLine.Contains($q))) {
            continue
        }

        [void]$gridResources.Rows.Add(
            $r.Gabinete,
            $r.'Tipo de Recurso',
            $des,
            $resp,
            $ct,
            $id,
            $dt
        )
        $countR++
    }

    $statusLabel.Text = "A apresentar $countC colaboradores e $countR recursos/viaturas | Filtro Gabinete: $($script:selectedGab)"
}

# Acao: Enviar Email (abre no Outlook)
$btnEmail.Add_Click({
    $targetEmail = ""
    if ($tabControl.SelectedTab -eq $tabContacts) {
        if ($gridContacts.SelectedRows.Count -gt 0) {
            $row = $gridContacts.SelectedRows[0]
            $targetEmail = [string]$row.Cells["Email"].Value
        }
    } else {
        if ($gridResources.SelectedRows.Count -gt 0) {
            $row = $gridResources.SelectedRows[0]
            $resp = [string]$row.Cells["Responsavel"].Value
            $match = $allResources | Where-Object { [string]$_.'ResponsÃ¡vel / Motorista' -eq $resp -and $_.'E-mail' }
            if ($match) { $targetEmail = [string]$match[0].'E-mail' }
        }
    }

    if ([string]::IsNullOrWhiteSpace($targetEmail) -or $targetEmail -eq "â€”" -or $targetEmail -eq "-") {
        [System.Windows.Forms.MessageBox]::Show("Selecione uma linha que contenha um endereco de e-mail valido.", "Aviso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }

    [System.Diagnostics.Process]::Start("mailto:$targetEmail") | Out-Null
})

# Acao: Fazer Chamada / Copiar Numero
$btnCall.Add_Click({
    $targetNumber = ""
    $targetName = ""

    if ($tabControl.SelectedTab -eq $tabContacts) {
        if ($gridContacts.SelectedRows.Count -gt 0) {
            $row = $gridContacts.SelectedRows[0]
            $targetName = [string]$row.Cells["Nome"].Value
            $movel = [string]$row.Cells["Movel"].Value
            $direto = [string]$row.Cells["Direto"].Value
            $ramal = [string]$row.Cells["Ramal"].Value

            if ($movel -and $movel -ne "â€”" -and $movel -ne "-") { $targetNumber = $movel }
            elseif ($direto -and $direto -ne "â€”" -and $direto -ne "-") { $targetNumber = $direto }
            elseif ($ramal -and $ramal -ne "â€”" -and $ramal -ne "-") { $targetNumber = $ramal }
        }
    } else {
        if ($gridResources.SelectedRows.Count -gt 0) {
            $row = $gridResources.SelectedRows[0]
            $targetName = [string]$row.Cells["Designacao"].Value
            $cont = [string]$row.Cells["Contacto"].Value
            if ($cont -and $cont -ne "â€”" -and $cont -ne "-") {
                $targetNumber = ($cont -split "/")[0].Trim()
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($targetNumber) -or $targetNumber -eq "â€”" -or $targetNumber -eq "-") {
        [System.Windows.Forms.MessageBox]::Show("Selecione um contacto que contenha numero de telefone ou telemovel.", "Aviso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }

    # Copiar para a area de transferencia
    $cleanNumber = $targetNumber.Replace(" ", "")
    [System.Windows.Forms.Clipboard]::SetText($cleanNumber)

    try {
        [System.Diagnostics.Process]::Start("tel:$cleanNumber") | Out-Null
    } catch { }

    $statusLabel.Text = "Numero de $targetName ($cleanNumber) copiado para a Area de Transferencia!"
})

# Acao: Exportar dados filtrados para CSV
$btnCsv.Add_Click({
    $isContacts = ($tabControl.SelectedTab -eq $tabContacts)
    $saveDlg = New-Object System.Windows.Forms.SaveFileDialog
    $saveDlg.Filter = "Ficheiro CSV (*.csv)|*.csv"
    $subType = if ($isContacts) { 'Contactos' } else { 'Recursos' }
    $saveDlg.FileName = "Diretorio_Gabinetes_${subType}_$((Get-Date).ToString('yyyyMMdd')).csv"
    
    if ($saveDlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $sb = New-Object System.Text.StringBuilder
        if ($isContacts) {
            [void]$sb.AppendLine("Gabinete;Area;Cargo;Nome;Ramal VOIP;Telefone Direto;Telemovel;Sala;Email")
            foreach ($row in $gridContacts.Rows) {
                $vals = @(
                    $row.Cells["Gabinete"].Value,
                    $row.Cells["Area"].Value,
                    $row.Cells["Cargo"].Value,
                    $row.Cells["Nome"].Value,
                    $row.Cells["Ramal"].Value,
                    $row.Cells["Direto"].Value,
                    $row.Cells["Movel"].Value,
                    $row.Cells["Sala"].Value,
                    $row.Cells["Email"].Value
                ) | ForEach-Object { "`"$_`"" }
                [void]$sb.AppendLine(($vals -join ";"))
            }
        } else {
            [void]$sb.AppendLine("Gabinete;Tipo;Designacao;Responsavel;Contacto;Matricula / Sala;Detalhes")
            foreach ($row in $gridResources.Rows) {
                $vals = @(
                    $row.Cells["Gabinete"].Value,
                    $row.Cells["Tipo"].Value,
                    $row.Cells["Designacao"].Value,
                    $row.Cells["Responsavel"].Value,
                    $row.Cells["Contacto"].Value,
                    $row.Cells["Identificador"].Value,
                    $row.Cells["Detalhes"].Value
                ) | ForEach-Object { "`"$_`"" }
                [void]$sb.AppendLine(($vals -join ";"))
            }
        }

        [System.IO.File]::WriteAllText($saveDlg.FileName, $sb.ToString(), [System.Text.Encoding]::UTF8)
        [System.Windows.Forms.MessageBox]::Show("Ficheiro exportado com sucesso para:`n$($saveDlg.FileName)", "Sucesso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

# Evento de Digitacao na Pesquisa
$txtSearch.Add_TextChanged({ Apply-Filter })

# Evento de duplo clique na linha de contactos: envia email
$gridContacts.Add_CellDoubleClick({
    param($sender, $e)
    if ($e.RowIndex -ge 0) {
        $email = [string]$gridContacts.Rows[$e.RowIndex].Cells["Email"].Value
        if ($email -and $email -ne "â€”" -and $email -ne "-") {
            [System.Diagnostics.Process]::Start("mailto:$email") | Out-Null
        }
    }
})

# Inicializacao
Update-GabButtons
Apply-Filter

# Exibir Janela
[System.Windows.Forms.Application]::Run($form)