﻿function New-InternalPDFText {
    [CmdletBinding()]
    param(
        [string[]] $Text,
        [ValidateScript( { & $Script:PDFFontValidationList } )][string[]] $Font,
        #[string[]] $FontFamily,
        [ValidateScript( { & $Script:PDFColorValidation } )][string[]] $FontColor,
        [nullable[bool][]] $FontBold,
        [int] $FontSize,
        [ValidateScript( { & $Script:PDFColorValidation } )][string[]] $BackgroundColor,
        [string] $TextAlignment,
        [nullable[float]] $MarginTop,
        [nullable[float]] $MarginBottom,
        [nullable[float]] $MarginLeft,
        [nullable[float]] $MarginRight
    )

    $Paragraph = [iText.Layout.Element.Paragraph]::New()

    if ($FontBold) {
        [Array] $FontBold = $FontBold
        $DefaultBold = $FontBold[0]
    }
    if ($FontColor) {
        [Array] $FontColor = $FontColor
        $DefaultColor = $FontColor[0]
    }
    if ($Font) {
        [Array] $Font = $Font
        $DefaultFont = $Font[0]
    }

    for ($i = 0; $i -lt $Text.Count; $i++) {
        [iText.Layout.Element.Text] $PDFText = $Text[$i]

        if ($FontBold) {
            if ($null -ne $FontBold[$i]) {
                if ($FontBold[$i]) {
                    $PDFText = $PDFText.SetBold()
                }
            } else {
                if ($DefaultBold) {
                    $PDFText = $PDFText.SetBold()
                }
            }
        }
        if ($FontColor) {
            if ($null -ne $FontColor[$i]) {
                if ($FontColor[$i]) {
                    $ConvertedColor = Get-PDFConstantColor -Color $FontColor[$i]
                    $PDFText = $PDFText.SetFontColor($ConvertedColor)
                }
            } else {
                if ($DefaultColor) {
                    $ConvertedColor = Get-PDFConstantColor -Color $DefaultColor
                    $PDFText = $PDFText.SetFontColor($ConvertedColor)
                }
            }
        }
        if ($BackgroundColor) {
            if ($null -ne $BackgroundColor[$i]) {
                if ($BackgroundColor[$i]) {
                    $ConvertedColor = Get-PDFConstantColor -Color $BackgroundColor[$i]
                    $PDFText = $PDFText.SetBackgroundColor($ConvertedColor)
                }
            }
        }
        if ($FontSize) {
            $PDFText = $PDFText.SetFontSize($FontSize)
        }
        if ($Font) {
            if ($null -ne $Font[$i]) {
                if ($Font[$i]) {
                    #$ConvertedFont = Get-PDFConstantFont -Font $Font[$i]
                    #$ApplyFont = [iText.Kernel.Font.PdfFontFactory]::CreateFont($ConvertedFont, [iText.IO.Font.PdfEncodings]::IDENTITY_H, $false)
                    #$ApplyFont = [iText.Kernel.Font.PdfFontFactory]::CreateFont('TIMES_ROMAN', [iText.IO.Font.PdfEncodings]::IDENTITY_H, $false)
                    #$PDFText = $PDFText.SetFont($ApplyFont)
                    $ApplyFont = Get-InternalPDFFont -Font $Font[$i]
                    $PDFText = $PDFText.SetFont($ApplyFont)
                }
            } else {
                if ($DefaultColor) {
                    # $ConvertedFont = Get-PDFConstantFont -Font $DefaultFont
                    # $ApplyFont = [iText.Kernel.Font.PdfFontFactory]::CreateFont($ConvertedFont, [iText.IO.Font.PdfEncodings]::IDENTITY_H, $false)
                    # $PDFText = $PDFText.SetFont($ApplyFont)
                    $ApplyFont = Get-InternalPDFFont -Font $DefaultFont
                    $PDFText = $PDFText.SetFont($ApplyFont)
                }
            }
        } else {
            if ($Script:DefaultFont) {
                $PDFText = $PDFText.SetFont($Script:DefaultFont)
            }
        }
        $null = $Paragraph.Add($PDFText)
    }
    if ($TextAlignment) {
        $ConvertedTextAlignment = Get-PDFConstantTextAlignment -TextAlignment $TextAlignment
        $null = $Paragraph.SetTextAlignment($ConvertedTextAlignment)
    }
    $null = $Paragraph.SetMarginTop($MarginTop)
    $null = $Paragraph.SetMarginBottom($MarginBottom)
    if ($MarginLeft) {
        $null = $Paragraph.SetMarginLeft($MarginLeft)
    }
    if ($MarginRight) {
        $null = $Paragraph.SetMarginRight($MarginRight)
    }
    $Paragraph
}