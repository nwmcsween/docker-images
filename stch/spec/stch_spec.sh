Describe 'stch'
    Describe 'Environment variable substitution'
        BeforeAll ""
        Before 'export STCH_TEST="STCH_TEST"; unset _UNSET'
        After "unset STCH_TEST"
        AfterAll "rm -rf $FIXTURE/inc"
        It 'substitutes ${} with vars'
            Data '${STCH_TEST}'
            When call ./stch
            The stdout should equal STCH_TEST
            The status should be success
        End
        It 'substitutes $() for the command'
            Data '$(echo foo)'
            When call ./stch
            The stdout should equal foo
            The status should be success
        End
        It 'exits with non-zero on unset env'
            Data '${_UNSET}'
            When call ./stch
            The status should be failure
        End
        It "doesn't interp bare $ vars"
            Data '$STCH_TEST'
            When call ./stch
            The stdout should equal '$STCH_TEST'
            The status should be success
        End
    End
End
