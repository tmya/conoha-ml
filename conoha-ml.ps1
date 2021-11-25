# SPDX-License-Identifier: MIT
# Copyright (C) 2021 Akio Tomita

#=============================================================
# v 1.0 2021/11/25
#=============================================================

#=============================================================
# Include Config
#=============================================================
[string]$ConfigFilePath = ".\config.ps1"
. $ConfigFilePath

#=============================================================
# Settings (may not be change this config.)
#=============================================================
[string]$CNH_TOOL_EXE_FULL = Join-Path $PSScriptRoot $CNH_TOOL_EXE

#=============================================================
# MainProcess
#=============================================================
#Join path.
#[string]$CurrentSignageFilePath = Join-Path $PSScriptRoot $CurrentSignageFile
function MainProcess($argv)
{
    if(Test-Path $LOG_FILE)
    {
        Remove-Item -Path $LOG_FILE   
    }

    if( !(Test-Path $CNH_TOOL_EXE) -and !(Test-Path $CNH_TOOL_FILE) )
    {
        Invoke-WebRequest -Uri $CNH_TOOL_URL -OutFile $CNH_TOOL_FILE
    }
    if(Test-Path $CNH_TOOL_FILE)
    {
        if( -not (Test-Path $CNH_TOOL_EXE))
        {
            Expand-Archive -Force -Path $CNH_TOOL_FILE -DestinationPath $PSScriptRoot
        }
    }

    switch($argv)
    {
        "auto"
        {
            Start-Process -FilePath $CNH_TOOL_EXE_FULL -ArgumentList "list", $CommandlineArgs -NoNewWindow -RedirectStandardOutput $LOG_FILE -wait
            If(-Not (Get-Content $LOG_FILE | Select-String -SimpleMatch (Split-Path $ML_ISO_URL -Leaf) -Quiet) )
            {
                #ダウンロード
                Write-Host "ダウンロードの要求を行いました。"
                Start-Process -FilePath $CNH_TOOL_EXE_FULL -ArgumentList "download", "-i", $ML_ISO_URL, $CommandlineArgs -NoNewWindow -RedirectStandardError $LOG_FILE -wait
                If(-Not (Get-Content $LOG_FILE | Select-String -SimpleMatch "Download request was accepted." -Quiet) )
                {
                    Write-Host "ダウンロードできませんでした。", $LOG_FILE, "の中身と", $ConfigFilePath, "の設定を確認してください。"
                    exit
                }

                While( -Not (Get-Content $LOG_FILE | Select-String -SimpleMatch (Split-Path $ML_ISO_URL -Leaf) -Quiet) )
                {
                    Write-Host -NoNewline "."
                    Start-Sleep 3
                    Start-Process -FilePath $CNH_TOOL_EXE_FULL -ArgumentList "list", $CommandlineArgs -NoNewWindow -RedirectStandardOutput $LOG_FILE -wait
                }
                Write-Host "ダウンロードが完了しました。"
            }
            Else
            {
                Write-Host "すでにダウンロード済みです。"
            }

            #isoを挿入
            Write-Host "VPSにISOをマウントする機能を起動します。対象のマシンがシャットダウンしていないとエラーが発生します。"
            $insert = $CNH_TOOL_EXE_FULL + " insert" + $CommandlineArgs
            Invoke-Expression $insert
        }
        "eject"
        {
            Write-Host "ISOをイジェクトします。"
            $eject = $CNH_TOOL_EXE_FULL + " eject" + $CommandlineArgs
            Invoke-Expression $eject
        }
        default
        {
            Write-Host "batファイルから起動するか、引数を指定してください。"
        }
    }
}

MainProcess($args[0])
