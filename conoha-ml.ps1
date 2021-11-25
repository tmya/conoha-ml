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
                #�_�E�����[�h
                Write-Host "�_�E�����[�h�̗v�����s���܂����B"
                Start-Process -FilePath $CNH_TOOL_EXE_FULL -ArgumentList "download", "-i", $ML_ISO_URL, $CommandlineArgs -NoNewWindow -RedirectStandardError $LOG_FILE -wait
                If(-Not (Get-Content $LOG_FILE | Select-String -SimpleMatch "Download request was accepted." -Quiet) )
                {
                    Write-Host "�_�E�����[�h�ł��܂���ł����B", $LOG_FILE, "�̒��g��", $ConfigFilePath, "�̐ݒ���m�F���Ă��������B"
                    exit
                }

                While( -Not (Get-Content $LOG_FILE | Select-String -SimpleMatch (Split-Path $ML_ISO_URL -Leaf) -Quiet) )
                {
                    Write-Host -NoNewline "."
                    Start-Sleep 3
                    Start-Process -FilePath $CNH_TOOL_EXE_FULL -ArgumentList "list", $CommandlineArgs -NoNewWindow -RedirectStandardOutput $LOG_FILE -wait
                }
                Write-Host "�_�E�����[�h���������܂����B"
            }
            Else
            {
                Write-Host "���łɃ_�E�����[�h�ς݂ł��B"
            }

            #iso��}��
            Write-Host "VPS��ISO���}�E���g����@�\���N�����܂��B�Ώۂ̃}�V�����V���b�g�_�E�����Ă��Ȃ��ƃG���[���������܂��B"
            $insert = $CNH_TOOL_EXE_FULL + " insert" + $CommandlineArgs
            Invoke-Expression $insert
        }
        "eject"
        {
            Write-Host "ISO���C�W�F�N�g���܂��B"
            $eject = $CNH_TOOL_EXE_FULL + " eject" + $CommandlineArgs
            Invoke-Expression $eject
        }
        default
        {
            Write-Host "bat�t�@�C������N�����邩�A�������w�肵�Ă��������B"
        }
    }
}

MainProcess($args[0])
