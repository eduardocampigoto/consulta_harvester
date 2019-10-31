$global:theharvester="C:\theHarvester\theHarvester.py"
$global:empresa
$global:folderPath
$global:SavePattern = Get-Date -Format "yyyy-mm-dd_HH-mm"

Function GetFolder($msg)

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $selecionaPasta = New-Object System.Windows.Forms.FolderBrowserDialog
    $selecionaPasta.Description = $msg
    $selecionaPasta.rootfolder = "MyComputer"
    Write-Host $msg -ForeGroundColor yellow
    if($selecionaPasta.ShowDialog() -eq "OK")
    {
        $pasta = $selecionaPasta.SelectedPath
    }else{
        exit
    }
    clear
    return $pasta
}

Function GetFile($ext, $msg)

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null
    $selecionaArquivo = New-Object System.Windows.Forms.OpenFileDialog
    $selecionaArquivo.initialDirectory = "MyComputer"
    $selecionaArquivo.filter = " Arquivos de texto | *$ext | Todos os arquivos | *.*"
    Write-Host $msg -ForegroundColor yellow
    if($selecionaArquivo.ShowDialog() -eq "OK")
    {
        $arquivo = $selecionaArquivo.FileName
    }else{
        exit
    }
    clear
    return $arquivo
}


function ReadCompanyName(){
clear
$empresa = Read-Host "Digite o  dominio da empresa para consulta"
$global:empresa = $empresa
clear
$folderPath= GetFolder "Selecione o caminho para salvar os arquivos da consulta" 
$global:folderPath = $folderPath
cd $folderPath
if($empresa -notlike ""){
        Write-Host "Executando a consulta..." -ForegroundColor DarkCyan
        &python  $theHarvester -d "$empresa" -b all -l 20 -f "$folderPath\$empresa.html" >> "$folderPath\execucao-$global:empresa-$global:SavePattern.txt" 
        sleep 30
    }
return $folderPath
}

function ReadCompanyList(){
$listaempresas = Get-Content (GetFile 'txt' "Selecione o arquivo que contém a lista de empresas")
$folderPath= GetFolder "Selecione o caminho para salvar os arquivos da consulta"
cd $folderPath
$global:folderPath = $folderPath
foreach($empresa in $listaempresas){     
    Write-Progress -Activity "Executando consultas..." -CurrentOperation $empresa
 if($empresa -notlike ""){
             &python $theHarvester -d "$empresa" -b all -l 20 -f "$folderPath\$empresa.html" >> "$folderPath\execucao-$global:empresa-$global:SavePattern.txt"
            sleep 600
    }
}
return $folderPath
}


function GetMails($folderPath){
$extract_mails = Get-Content "$folderPath\execucao-$global:empresa-$global:SavePattern.txt"
$extract_mails -match '\w+@\w+\.\w+.\w'| Out-file "$folderPath\emails-$global:empresa-$global:SavePattern.txt"


}


function GetLinkedinUsers($folderPath){

$posLinkedin = Get-Content "$folderPath\execucao-$global:empresa-$global:SavePattern.txt"
$count = 0
foreach($a in $posLinkedin){
    if($a.Contains("Searching Linkedin")){$count = 1}
    if($a.Contains("Searching Netcraft")){$count = 0}
    if($count -ge 1){ 
        $b+=,$a
    }
}
foreach($c in $b){

    if ($c.contains($global:empresa.Substring(0,3))){
          $c | Out-File $folderPath\Linkedin-$global:empresa-$global:SavePattern.txt
    }
}

}

$operador=""
while($operador -notin 1,2,3){
clear
Write-Host "`n 1- Executar a  consulta em um domínio específico `n 2- Executar a consulta emm vários domínios `n" -ForeGroundColor yellow
$operador = Read-Host "`n Selecione a opção"
clear
}


if($operador -eq 1){
$global:folderPath = ReadCompanyName
}elseif($operador -eq 2){
$global:folderPath = ReadCompanyList
}else{
clear
exit
}



$operador=""
while($operador -notin 1,2){
clear
Write-Host "`n Extrair emails em um arquivo txt ?" -ForegroundColor Yellow
Write-Host "`n 1 - Sim  `n 2 - não " -ForeGroundColor DarkGreen
$operador = Read-Host "`n Selecione a opção"
clear
}

if($operador -eq 1){
 GetMails $global:folderPath
}else{
clear
exit
}


$operador=""
while($operador -notin 1,2){
Write-Host "`n Extrair lista de  pessoas do linkedin encontradas em um arquivo txt ?" -ForegroundColor Yellow
Write-Host "`n 1 - Sim  `n 2 - não " -ForeGroundColor DarkGreen
$operador = Read-Host "`n Selecione a opção"
clear
}

if($operador -eq 1){
 GetLinkedinUsers $global:folderPath
}else{
clear
exit
}
