[string]$CNH_USERNAME = ""    # API > API���[�U�[ > ���[�U�[��
[string]$CNH_PASSWORD = ""    # API > API���[�U�[ > �p�X���[�h
[string]$CNH_TENANT_NAME = "" # API > API��� > �e�i���g��� > �e�i���g��
[string]$CNH_REGION_NAME = "" # API > API��� > �G���h�|�C���g > ���낢�����ł钆�ɉE�̂����ꂩ�𔭌������炻�̒l �� "tyo1" "tyo2" "sin1" "sjc1"

[string]$ML_ISO_URL = "https://repo.dist.miraclelinux.net/miraclelinux/isos/8.4-released/x86_64/MIRACLELINUX-8.4-rtm-x86_64.iso"

[string]$CNH_TOOL_URL = "https://github.com/hironobu-s/conoha-iso/releases/download/current/conoha-iso.amd64.zip"
[string]$CNH_TOOL_FILE = Split-Path $CNH_TOOL_URL -Leaf
[string]$CNH_TOOL_EXE = "conoha-iso.exe"
[string]$CommandlineArgs = " -u " + $CNH_USERNAME + " -p " + $CNH_PASSWORD + " -n " + $CNH_TENANT_NAME + " -r " + $CNH_REGION_NAME
[string]$LOG_FILE = "log.txt"
