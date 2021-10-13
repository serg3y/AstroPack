% Unit Tester shortcuts, calls actual functions in UnitTester.m
%
%   ut.bpush() - Runs all Unit-Tests before git push
%

% #functions (autogen)
% bpush - Call to perform tests before git push - PUSH ONLY IF ALL TESTS PASS
% diff - Call to perform tests before git push - PUSH ONLY IF ALL TESTS PASS
% test - Run all unit tests
% unitTest -
% #/functions (autogen)
%

classdef ut < handle

    methods(Static)

        function Result = test()
            % Run all unit tests
            Tester = UnitTester;
            Result = Tester.doTest();
        end

        
        function Result = bpush(Args)
            % Call to perform tests before git push - PUSH ONLY IF ALL TESTS PASS
            Result = UnitTester.beforePush();
        end

        
        function Result = diff()
            % Call to perform tests before git push - PUSH ONLY IF ALL TESTS PASS
            persistent Tester
            if isempty(Tester)
                Tester = UnitTester;
            end
           
            Result = Tester.doBeforePush();
        end

        
        function Result = unitTest()
            Result = true;
        end
        
    end
end
