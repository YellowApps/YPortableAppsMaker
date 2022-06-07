cls
mode con cols=50 lines=20
$host.UI.RawUI.WindowTitle = "Y Portable Apps Maker"

Add-Type -AssemblyName System.Windows.Forms

$shell = New-Object -ComObject WScript.Shell
$appl = New-Object -ComObject Shell.Application
$csc = "$env:WINDIR\Microsoft.NET\Framework\" + (dir "$env:WINDIR\Microsoft.NET\Framework\v4.*").Name + "\csc.exe"
$form = New-Object System.Windows.Forms.Form
$folder = ""
$mainFile = ""
$outputFile = ""

if(-not (Test-Path $csc)){
    [System.Windows.Forms.MessageBox]::Show("ОШИБКА:`n Для запуска приложения необходим .NET Framework 4", "Y Portable Apps Maker", 0, 16) | Out-Null
    exit
}

Function Form{
    $form.Text = "Y Portable Apps Maker"
    $form.Icon = New-Object System.Drawing.Icon("yellowapps.ico")
    $form.Font = New-Object System.Drawing.Font("Arial", 16)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.MaximizeBox = $false
    $form.Width = 670
    $form.Height = 300

    $global:lbl0 = Label -x 20 -y 20 -txt "Создание приложения" -fs 16
    $global:lbl1 = Label -x 3 -y ($lbl0.Location.y + $lbl0.Height +30) -txt "1) Выберите папку с файлами вашего приложения." -fs 10
    $global:lbl2 = Label -x 3 -y ($lbl1.Location.y + $lbl1.Height +16) -txt "2) Выберите главный файл вашего приложения." -fs 10
    $global:lbl3 = Label -x 3 -y ($lbl2.Location.y + $lbl2.Height + 16) -txt "3) Выберите, куда сохранить полученный файл." -fs 10
    $global:btn0 = Button -x ($lbl1.Location.x + $lbl1.Width) -y $lbl1.Location.y -txt "Выбрать" -click {Select-Folder; $btn0.Text = $global:folder}
    $global:btn1 = Button -x ($lbl2.Location.x + $lbl2.Width) -y $lbl2.Location.y -txt "Выбрать" -click {if($global:folder -ne ""){Select-MainFile; $btn1.Text = $global:mainFile}}
    $global:btn2 = Button -x ($lbl3.Location.x + $lbl3.Width) -y $lbl3.Location.y -txt "Выбрать" -click {if($global:mainFile -ne ""){Select-OutputFile; $btn2.Text = $global:outputFile}}
    $global:btn3 = Button -x 270 -y ($lbl3.Location.y + $lbl3.Height + 16) -txt "Создать" -click {if($global:outputFile -ne ""){Create-App}}

    $form.Controls.AddRange(( $lbl0,$lbl1,$lbl2,$lbl3,$btn0,$btn1,$btn2,$btn3 ))
    $form.ShowDialog() | Out-Null
}

Function Label($x, $y, $txt, $fs){
    if(-not $fs){ $fs = 12 }

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $txt
    $lbl.Font = New-Object System.Drawing.Font("Arial", $fs)
    $lbl.Location = New-Object System.Drawing.Point($x, $y)
    $lbl.Width = 500
    $lbl.Height += $fs/2+2
    return $lbl
}

Function Button($x, $y, $txt, $fs, $click){
    if(-not $fs){ $fs = 12 }

    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $txt
    $btn.Font = New-Object System.Drawing.Font("Arial", $fs)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.Width = ($txt.Length + 4) * $fs
    $btn.Height += $fs/2+2
    $btn.Add_Click($click)

    return $btn
}

Function Select-Folder{
    $f = $appl.BrowseForFolder(0, "Выберите папку с файлами приложения", 0, 0)
    if($f -ne $null) { $global:folder = $f.Self.Path }
}

Function Select-MainFile{
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.initialDirectory = $global:folder
    $ofd.filter = "All files (*.*)| *.*"
    $ofd.ShowDialog() | Out-Null
    $global:mainFile = $ofd.filename.Split("\")[-1]
}

Function Select-OutputFile{
    $sfd = New-Object System.Windows.Forms.SaveFileDialog
    $sfd.InitialDirectory = "exe"
    $sfd.filter = "EXE (*.exe)| *.exe"
    $sfd.ShowDialog() | Out-Null
    $global:outputFile = $sfd.filename
}

Function Create-App{
    $b64s = @()
    (dir $global:folder).Name | %{
        $bytes = [System.IO.File]::ReadAllBytes("$global:folder\$_")
        $b64 = [System.Convert]::ToBase64String($bytes)
        $b64s += "`"$b64`""
    }
    $b64ss = $b64s -join ", "

    $fsp = @()
    (dir $global:folder).Name | %{
        $fsp += "`"$_`""
    }
    $fsps = $fsp -join ", "

    $cont = (Get-Content "pam.cs" -Raw) -replace "FILENAMES", $fsps -replace "BASE64_DATA", $b64ss -replace "MAIN_FILE", $global:mainFile

    Set-Content "cs\pam_$global:mainFile.cs" $cont -Force

    start $csc -ArgumentList "/nologo /out:$global:outputFile cs\pam_$global:mainFile.cs"
}

Form