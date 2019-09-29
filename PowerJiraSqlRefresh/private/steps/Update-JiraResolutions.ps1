function Update-JiraResolutions {
    [CmdletBinding()]
    param (
        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=0)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=3)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Resolutions"
        $tableName = "tbl_stg_Jira_Resolution"
        $resolutions = @()
    }
    
    process {
        Write-Verbose "Getting Resolutions"
        $resolutions += (Invoke-JiraGetResolutions) | Read-JiraResolution -RefreshId $RefreshId
    }
    
    end {
        Write-Verbose "Writing Resolutions to staging table"
        $resolutions | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}