function Get-SecInventory {

Add-CommentHelp -Description Get-SecInventory -Synopsis "Retrieves all computer accounts for a single domain"

$strCategory = "computer"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry("LDAP://rootdse")

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.Filter = ("(objectCategory=$strCategory)")

$colProplist = "name"
foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}

$colResults = $objSearcher.FindAll()

foreach ($objResult in $colResults)
    {$objComputer = $objResult.Properties; $objComputer.name}
    
}