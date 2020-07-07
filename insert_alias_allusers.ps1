# Inserindo alias a usuários do office365 usando como base o domínio atual.
# Isto é útil para quando se adquiri um novo domínio e deseja fazer com que todos os usuários possam receber os e-mails através deste novo domínio.
# Este script deve ser executado em PowerShell com privilégios de Administrador.

# Obtendo credenciais com poder para realizar alterações em sua conta do Office365.
$credentials = Get-Credential
Write-Output "Getting the Exchange Online cmdlets"

# Abrindo uma nova sessão utilizando suas credenciais.
$Session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-ConfigurationName Microsoft.Exchange -Credential $credentials `
-Authentication Basic -AllowRedirection
Import-PSSession $Session

# Obtendo todos os usuários que possuem como e-mail principal o domínio específicado.
$users = Get-Mailbox | Where-Object{$_.PrimarySMTPAddress -match "@seudominiodemail.com.br"}

# Adicionando o novo alias a todos os usuários encontrados anteriomente com o "@seudominiodeemail.com.br"
foreach($user in $users){
    Write-Host "Adding Alias $($user.alias)@seunovodominiodeemail.com.br"
    Set-Mailbox $user.PrimarySmtpAddress -EmailAddresses @{add="$($user.Alias)@seunovodominiodeemail.com.br"}
}