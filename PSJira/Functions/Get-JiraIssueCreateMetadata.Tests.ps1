$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

InModuleScope PSJira {

    $ShowMockData = $false
    $ShowDebugText = $false

    Describe "Get-JiraIssueCreateMetadata" {

        if ($ShowDebugText)
        {
            Mock 'Write-Debug' {
                Write-Host "       [DEBUG] $Message" -ForegroundColor Yellow
            }
        }

        Mock Get-JiraConfigServer {
            'https://jira.example.com'
        }

        # If we don't override this in a context or test, we don't want it to
        # actually try to query a JIRA instance
        Mock Invoke-JiraMethod -ModuleName PSJira {
            if ($ShowMockData)
            {
                Write-Host "       Mocked Invoke-WebRequest" -ForegroundColor Cyan
                Write-Host "         [Uri]     $Uri" -ForegroundColor Cyan
                Write-Host "         [Method]  $Method" -ForegroundColor Cyan
            }
        }

        Context "Sanity checking" {
            $command = Get-Command -Name Get-JiraIssueCreateMetadata

            function defParam($name)
            {
                It "Has a -$name parameter" {
                    $command.Parameters.Item($name) | Should Not BeNullOrEmpty
                }
            }

            defParam 'Project'
            defParam 'IssueType'
            defParam 'Credential'
        }

        Context "Behavior testing" {

            $restResult = ConvertFrom-Json2 @'
{
  "expand": "projects",
  "projects": [
    {
      "expand": "issuetypes",
      "self": "https://jira.example.com/rest/api/2/project/10003",
      "id": "10003",
      "key": "TEST",
      "name": "Test Project",
      "issuetypes": [
        {
          "self": "https://jira.example.com/rest/api/latest/issuetype/2",
          "id": "2",
          "iconUrl": "https://jira.example.com/images/icons/issuetypes/newfeature.png",
          "name": "Test Issue Type",
          "subtask": false,
          "expand": "fields",
          "fields": {
            "summary": {
              "required": true,
              "schema": {
                "type": "string",
                "system": "summary"
              },
              "name": "Summary",
              "hasDefaultValue": false,
              "operations": [
                "set"
              ]
            },
            "issuetype": {
              "required": true,
              "schema": {
                "type": "issuetype",
                "system": "issuetype"
              },
              "name": "Issue Type",
              "hasDefaultValue": false,
              "operations": [],
              "allowedValues": [
                {
                  "self": "https://jira.example.com/rest/api/2/issuetype/2",
                  "id": "2",
                  "description": "This is a test issue type",
                  "iconUrl": "https://jira.example.com/images/icons/issuetypes/newfeature.png",
                  "name": "Test Issue Type",
                  "subtask": false
                }
              ]
            },
            "description": {
              "required": false,
              "schema": {
                "type": "string",
                "system": "description"
              },
              "name": "Description",
              "hasDefaultValue": false,
              "operations": [
                "set"
              ]
            },
            "project": {
              "required": true,
              "schema": {
                "type": "project",
                "system": "project"
              },
              "name": "Project",
              "hasDefaultValue": false,
              "operations": [
                "set"
              ],
              "allowedValues": [
                {
                  "self": "https://jira.example.com/rest/api/2/project/10003",
                  "id": "10003",
                  "key": "TEST",
                  "name": "Test Project",
                  "projectCategory": {
                    "self": "https://jira.example.com/rest/api/2/projectCategory/10000",
                    "id": "10000",
                    "description": "All Project Catagories",
                    "name": "All Project"
                  }
                }
              ]
            },
            "reporter": {
              "required": true,
              "schema": {
                "type": "user",
                "system": "reporter"
              },
              "name": "Reporter",
              "autoCompleteUrl": "https://jira.example.com/rest/api/latest/user/search?username=",
              "hasDefaultValue": false,
              "operations": [
                "set"
              ]
            },
            "assignee": {
              "required": false,
              "schema": {
                "type": "user",
                "system": "assignee"
              },
              "name": "Assignee",
              "autoCompleteUrl": "https://jira.example.com/rest/api/latest/user/assignable/search?issueKey=null&username=",
              "hasDefaultValue": false,
              "operations": [
                "set"
              ]
            },
            "priority": {
              "required": false,
              "schema": {
                "type": "priority",
                "system": "priority"
              },
              "name": "Priority",
              "hasDefaultValue": true,
              "operations": [
                "set"
              ],
              "allowedValues": [
                {
                  "self": "https://jira.example.com/rest/api/2/priority/1",
                  "iconUrl": "https://jira.example.com/images/icons/priorities/blocker.png",
                  "name": "Blocker",
                  "id": "1"
                },
                {
                  "self": "https://jira.example.com/rest/api/2/priority/2",
                  "iconUrl": "https://jira.example.com/images/icons/priorities/critical.png",
                  "name": "Critical",
                  "id": "2"
                },
                {
                  "self": "https://jira.example.com/rest/api/2/priority/3",
                  "iconUrl": "https://jira.example.com/images/icons/priorities/major.png",
                  "name": "Major",
                  "id": "3"
                },
                {
                  "self": "https://jira.example.com/rest/api/2/priority/4",
                  "iconUrl": "https://jira.example.com/images/icons/priorities/minor.png",
                  "name": "Minor",
                  "id": "4"
                },
                {
                  "self": "https://jira.example.com/rest/api/2/priority/5",
                  "iconUrl": "https://jira.example.com/images/icons/priorities/trivial.png",
                  "name": "Trivial",
                  "id": "5"
                }
              ]
            },
            "labels": {
              "required": false,
              "schema": {
                "type": "array",
                "items": "string",
                "system": "labels"
              },
              "name": "Labels",
              "autoCompleteUrl": "https://jira.example.com/rest/api/1.0/labels/suggest?query=",
              "hasDefaultValue": false,
              "operations": [
                "add",
                "set",
                "remove"
              ]
            }
          }
        }
      ]
    }
  ]
}
'@

            Mock Get-JiraProject -ModuleName PSJira {
                [PSCustomObject] @{
                    ID = 10003;
                    Name = 'Test Project';
                }
            }

            Mock Get-JiraIssueType -ModuleName PSJira {
                [PSCustomObject] @{
                    ID = 2;
                    Name = 'Test Issue Type';
                }
            }

            It "Queries Jira for metadata information about creating an issue" {
                { Get-JiraIssueCreateMetadata -Project 10003 -IssueType 2 } | Should Not Throw
                Assert-MockCalled -CommandName Invoke-JiraMethod -ModuleName PSJira -Exactly -Times 1 -Scope It -ParameterFilter {$Method -eq 'Get' -and $URI -like '*/rest/api/*/issue/createmeta?projectIds=10003&issuetypeIds=2&expand=projects.issuetypes.fields'}
            }

            It "Uses ConvertTo-JiraCreateMetaField to output CreateMetaField objects if JIRA returns data" {

                # This is a simplified version of what JIRA will give back
                Mock Invoke-JiraMethod -ModuleName PSJira {
                    @{
                        projects = @{
                            issuetypes = @{
                                fields = [PSCustomObject] @{
                                    'a' = 1;
                                    'b' = 2;
                                }
                            }
                        }
                    }
                }
                Mock ConvertTo-JiraCreateMetaField -ModuleName PSJira {}

                { Get-JiraIssueCreateMetadata -Project 10003 -IssueType 2 } | Should Not Throw
                Assert-MockCalled -CommandName Invoke-JiraMethod -ModuleName PSJira -Exactly -Times 1 -Scope It -ParameterFilter {$Method -eq 'Get' -and $URI -like '*/rest/api/*/issue/createmeta?projectIds=10003&issuetypeIds=2&expand=projects.issuetypes.fields'}

                # There are 2 example fields in our mock above, but they should
                # be passed to Convert-JiraCreateMetaField as a single object.
                # The method should only be called once.
                Assert-MockCalled -CommandName ConvertTo-JiraCreateMetaField -ModuleName PSJira -Exactly -Times 1 -Scope It
            }
        }
    }
}
