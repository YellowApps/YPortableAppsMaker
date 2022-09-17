if(($args.Length -lt 3) -or ($args[0] -eq "help")){
	echo "Использование: ypamc <папка> <главный файл> <выходной файл>"
	exit
}

if(-not (Test-Path ".\pam.cs")){
	$pamt = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("dXNpbmcgU3lzdGVtOw0KdXNpbmcgU3lzdGVtLklPOw0KdXNpbmcgU3lzdGVtLlRleHQ7DQp1c2luZyBTeXN0ZW0uRGlhZ25vc3RpY3M7DQp1c2luZyBTeXN0ZW0uV2ViOw0KdXNpbmcgU3lzdGVtLkxpbnE7DQp1c2luZyBTeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYzsNCg0KbmFtZXNwYWNlIHBhbXsNCiAgY2xhc3MgcGFtew0KICAgIHN0YXRpYyB2b2lkIE1haW4oc3RyaW5nW10gYXJncyl7DQogICAgICBzdHJpbmcgbWFpbkZpbGUgPSAiTUFJTl9GSUxFIjsNCiAgICAgIHN0cmluZ1tdIGZpbGVzID0ge0ZJTEVOQU1FU307DQogICAgICBzdHJpbmdbXSBjb250ZW50cyA9IHtCQVNFNjRfREFUQX07DQogICAgICBzdHJpbmcgZGlyID0gRW52aXJvbm1lbnQuR2V0RW52aXJvbm1lbnRWYXJpYWJsZSgiYXBwZGF0YSIpICsgIlxcIiArIG1haW5GaWxlLlNwbGl0KCcuJylbMF0gKyAiXFwiOw0KDQogICAgICBDb25zb2xlLldyaXRlTGluZSgiUEFNIDIuMCIpOw0KICAgICAgQ29uc29sZS5Xcml0ZUxpbmUoIkRlc3RpbmF0aW9uOiAiK2Rpcik7DQoNCiAgICAgIGlmKCFEaXJlY3RvcnkuRXhpc3RzKGRpcikpIERpcmVjdG9yeS5DcmVhdGVEaXJlY3RvcnkoZGlyKTsNCiAgICAgIGlmKCFGaWxlLkV4aXN0cyhkaXIrbWFpbkZpbGUpKXsNCiAgICAgICAgZm9yKGludCBpID0gMDsgaSA8IGZpbGVzLkxlbmd0aDsgaSsrKXsNCiAgICAgICAgICBieXRlW10gZGF0YSA9IENvbnZlcnQuRnJvbUJhc2U2NFN0cmluZyhjb250ZW50c1tpXSk7DQoNCiAgICAgICAgICBpZihmaWxlc1tpXS5Db250YWlucygiXFwiKSl7DQogICAgICAgICAgICAgIGNoYXJbXSBzZXAgPSB7J1xcJ307DQogICAgICAgICAgICAgIHN0cmluZ1tdIGZsbiA9IGZpbGVzW2ldLlNwbGl0KHNlcCk7DQogICAgICAgICAgICAgIGlmKGZsbi5MZW5ndGggPiAxKXsNCiAgICAgICAgICAgICAgICAgIFN5c3RlbS5BcnJheS5SZXNpemUocmVmIGZsbiwgZmxuLkxlbmd0aCAtIDEpOw0KICAgICAgICAgICAgICAgICAgc3RyaW5nIGZsbnMgPSBTdHJpbmcuSm9pbigiXFwiLCBmbG4pOw0KICAgICAgICAgICAgICAgICAgRGlyZWN0b3J5LkNyZWF0ZURpcmVjdG9yeShkaXIgKyBmbG5zKTsNCiAgICAgICAgICAgICAgfQ0KICAgICAgICAgIH0NCg0KICAgICAgICAgIENvbnNvbGUuV3JpdGVMaW5lKCJFeHRyYWN0aW5nOiAiICsgZmlsZXNbaV0pOw0KICAgICAgICAgIEZpbGUuV3JpdGVBbGxCeXRlcyhkaXIgKyBmaWxlc1tpXSwgZGF0YSk7DQogICAgICAgIH0NCiAgICAgIH0NCiAgICAgIFByb2Nlc3MgcHJvYyA9IG5ldyBQcm9jZXNzKCk7DQogICAgICBwcm9jLlN0YXJ0SW5mby5Vc2VTaGVsbEV4ZWN1dGUgPSBmYWxzZTsNCiAgICAgIHByb2MuU3RhcnRJbmZvLkZpbGVOYW1lID0gImNtZC5leGUiOw0KICAgICAgcHJvYy5TdGFydEluZm8uQXJndW1lbnRzID0gIi9jIFwiY2QgL2QgIitkaXIrIiAmIHN0YXJ0ICIrbWFpbkZpbGUrIlwiIjsNCiAgICAgIHByb2MuU3RhcnRJbmZvLkNyZWF0ZU5vV2luZG93ID0gZmFsc2U7DQogICAgICBwcm9jLlN0YXJ0SW5mby5XaW5kb3dTdHlsZSA9IFByb2Nlc3NXaW5kb3dTdHlsZS5IaWRkZW47DQogICAgICBwcm9jLlN0YXJ0KCk7DQogICAgfQ0KICB9DQp9DQo="))
	Set-Content ".\pam.cs" $pamt -Force
}
if(-not (Test-Path ".\cs")){
	mkdir ".\cs" | Out-Null
}

$csc = "$env:WINDIR\Microsoft.NET\Framework\" + (dir "$env:WINDIR\Microsoft.NET\Framework\v4.*").Name + "\csc.exe"

if(-not (Test-Path $csc)){
    echo "ОШИБКА: Для запуска приложения необходим .NET Framework 4.7"
    exit
}

try{
	$folder = $args[0]
	$mainFile = $args[1]
	$outputFile = $args[2]

	$b64s = @()
	dir $folder -File -Recurse -Name | %{
		$bytes = [System.IO.File]::ReadAllBytes("$folder\$_")
		$b64 = [System.Convert]::ToBase64String($bytes)
		$b64s += "`"$b64`""
	}
	$b64ss = $b64s -join ", "

	$fsp = @()
	dir $folder -File -Recurse -Name | %{
		$d = $_.Replace("\", "\\")
		$fsp += "`"$d`""
	}
	$fsps = $fsp -join ", "

	$cont = (Get-Content "pam.cs" -Raw) -replace "FILENAMES", $fsps -replace "BASE64_DATA", $b64ss -replace "MAIN_FILE", $mainFile

	Set-Content "cs\pam_$mainFile.cs" $cont -Force

	start $csc -ArgumentList "/nologo /out:$outputFile cs\pam_$mainFile.cs" -WindowStyle Hidden

	echo "Приложение успешно создано."
	exit 0
}catch{
	echo "Ошибка создания приложения."
	exit 1
}