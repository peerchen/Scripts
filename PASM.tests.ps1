﻿Import-Module $PSScriptRoot\..\Communary.PASM.psd1 -Force

InModuleScope 'Communary.PASM' {
    Describe 'Approximate String Matching algorithms' {
        It 'Overlap Coefficient' {
            [decimal](Get-OverlapCoefficient 'Pennsylvania' 'Pencilvaneya') | Should BeExactly ([decimal]0.666666666666667)
        }

        It 'Longest Common Substring' {
            Get-LongestCommonSubstring Pennsylvania Pencilvaneya | Should Be 'lvan'
        }

        It 'Longest Common Subsequence' {
            (Get-LongestCommonSubsequence Pennsylvania Pencilvaneya) -join '' | Should Be 'penlvana'
        }

        It 'Hamming Distance' {
            Get-HammingDistance Pennsylvania Pencilvaneya | Should Be 8
        }

        It 'Ratcliff/Obershelp Similarity' {
            [decimal](Get-RatcliffObershelpSimilarity Pennsylvania Pencilvaneya) | Should BeExactly ([decimal]0.666666666666667)
        }

        It 'Jaccard Index' {
            [decimal](Get-JaccardIndex Pennsylvania Pencilvaneya) | Should BeExactly ([decimal]0.8)
        }

        It 'Jaccard Distance' {
            [decimal](Get-JaccardDistance Pennsylvania Pencilvaneya) | Should BeExactly ([decimal]0.2)
        }

        It 'Sorensen-Dice Coefficient' {
            [decimal](Get-SorensenDiceCoefficient Pennsylvania Pencilvaneya) | Should BeExactly ([decimal]0.454545454545454)
        }

        It 'Sorensen-Dice Distance' {
            [decimal](Get-SorensenDiceDistance Pennsylvania Pencilvaneya) | Should BeExactly ([decimal]0.545454545454545)
        }

        It 'Jaro Distance' {
            [decimal](Get-JaroWinklerDistance Pennsylvania Pencilvaneya -OnlyCalculateJaroDistance) | Should Be ([decimal]0.740740740740741)
        }

        It 'Jaro-Winkler Distance' {
            [decimal](Get-JaroWinklerDistance Pennsylvania Pencilvaneya) | Should Be ([decimal]0.818518518518519)
        }

        It 'Levenshtein Distance' {
            Get-LevenshteinDistance Pennsylvania Pencilvaneya | Should BeExactly 5
        }

        It 'Soundex' {
            Compare-Soundex 'Jon' 'John' | Should Be $true
            Get-Soundex 'John' | Should Be 'J500'
        }
    }

    Describe 'Select Functions' {
        It 'Select-FuzzySearch without scores' {
            $countries = Import-Csv $PSScriptRoot\countries.csv | Select-Object -ExpandProperty Name
            $countries | Select-FuzzyString 'norw' -CalculateScore:$false | Should Be 'Norway'
            ($countries | Select-FuzzyString 'kingd' -CalculateScore:$false).Count | Should Be 2
        }

        It 'Select-FuzzySearch with scores' {
            $countries = Import-Csv $PSScriptRoot\countries.csv | Select-Object -ExpandProperty Name
            ($countries | Select-FuzzyString 'norw').Result| Should Be 'Norway'
            ($countries | Select-FuzzyString 'norw').Score| Should Be 392
        }

        It 'Select-SoundexSearch' {
            $names = Get-Content $PSScriptRoot\names.txt
            ($names | Select-SoundexString 'Jon').Count | Should Be 4
        }

        It 'Select-ApproximateSearch' {
            $countries = Import-Csv $PSScriptRoot\countries.csv | Select-Object -ExpandProperty Name
            $countries | Select-ApproximateString 'georigi' -Tolerance Strong | Should Be 'Georgia'
        }
    }

    Describe 'Misc' {
        It 'Get-CommonPrefix' {
            Get-CommonPrefix 'Card' 'Cartoon' | Should Be 'car'
            Get-CommonPrefix 'Card' 'Cartoon' -CaseSensitive | Should Be 'Car'
        }

        It 'Get-CommonSuffix' {
            Get-CommonSuffix 'Morning' 'Lasting' | Should Be 'ing'
            Get-CommonSuffix 'Morning' 'Lasting' -CaseSensitive | Should Be 'ing'
        }

        It 'Get-FuzzyMatchScore' {
            Get-FuzzyMatchScore 'Microsoft Corporation' 'soft' | Should Be 332
            Get-FuzzyMatchScore 'Microsoft Corporation' 'Microsoft' | Should Be 801
            Get-FuzzyMatchScore 'Microsoft Corporation' 'Microsoft Corporation' | Should Be 2100
        }
    }
}