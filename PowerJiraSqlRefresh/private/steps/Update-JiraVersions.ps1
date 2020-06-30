function Update-JiraVersions {
    [CmdletBinding()]
    param (
        # The list of project keys for which to retrieve versions
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [string[]]
        $ProjectKeys,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=4)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Versions"
        $tableName = "tbl_stg_Jira_Version"
        $versions = @()

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        foreach($key in $ProjectKeys) {
            Write-Verbose "Getting Versions for Project Key $key"
            $versions += Invoke-JiraGetProjectVersions $key | Read-JiraVersion -RefreshId $RefreshId
        }
    }
    
    end {
        Write-AtlassianData @sqlConnSplat -Data $versions -TableName $tableName
    }
}