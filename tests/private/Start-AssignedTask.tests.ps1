$script:ModuleName = 'PembrokePSwman'

Describe "Start-AssignedTask function for $moduleName" {
    It "Should not throw" {
        Mock -CommandName 'Test-Connection' -MockWith {
            $true
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        {Start-AssignedTask -RestServer dummyServer} | Should -not -Throw
        Assert-MockCalled -CommandName 'Test-Connection' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 1 -Exactly
    }
    It "Should Throw if the Rest Server cannot be reached.." {
        Mock -CommandName 'Test-Connection' -MockWith {
            $false
        }
        {Start-AssignedTask -RestServer dummyServer} | Should -Throw
        Assert-MockCalled -CommandName 'Test-Connection' -Times 2 -Exactly
    }
    It "Should Throw if the Return is not valid." {
        Mock -CommandName 'Test-Connection' -MockWith {
            $true
        }
        Mock -CommandName 'Write-Output' -MockWith { 
            Throw "Some failure to be udpated."
        }
        {Start-AssignedTask -RestServer dummyServer} | Should -Throw
        Assert-MockCalled -CommandName 'Test-Connection' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
    }
    It "Should Return false if -whatif is used." {
        Mock -CommandName 'Test-Connection' -MockWith {
            $true
        }
        Start-AssignedTask -RestServer dummyServer -whatif| Should be $false
    }
}