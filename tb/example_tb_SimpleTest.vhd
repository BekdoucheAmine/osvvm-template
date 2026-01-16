architecture SimpleTest of TestCtrl is
    signal TestDone         : integer_barrier := 1;
    signal TestInit         : integer_barrier := 1;
begin
    ControlProc : process
    begin
        -- Initialization of test
        SetTestName("example_tb_SimpleTest");
        SetLogEnable(PASSED, TRUE);

        -- Wait for testbench initialization
        wait for 0 ns; wait for 0 ns;
        TranscriptOpen;
        SetTranscriptMirror(TRUE);

        WaitForBarrier(TestInit);
        -- Clear Alerts
        ClearAlerts;

        -- Wait for test to finish
        WaitForBarrier(TestDone, 50 ms);

        TranscriptClose;
        
        EndOfTestReports(TimeOut => (now >= 50 ms));
        std.env.stop;
        wait;
    end process ControlProc;
 
    MainProc : process
        variable expected_or    : std_logic;
        variable expected_and   : std_logic;
    begin
        -- Wait for test to init
        WaitForBarrier(TestInit, 50 ms);

        a <= '0';
        b <= '0';
        expected_and    := a and b;
        expected_or     := a or b;
        -- Wait for signals to propagate
        wait for 1 ns;
        -- Check outputs
        AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
        AffirmIfEqual(or_res , expected_or , "OR   : Expected = "&to_string(expected_or)&",");

        a <= '0';
        b <= '1';
        expected_and    := a and b;
        expected_or     := a or b;
        -- Wait for signals to propagate
        wait for 1 ns;
        -- Check outputs
        AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
        AffirmIfEqual(or_res , expected_or , "OR   : Expected = "&to_string(expected_or)&",");

        a <= '1';
        b <= '0';
        expected_and    := a and b;
        expected_or     := a or b;
        -- Wait for signals to propagate
        wait for 1 ns;
        -- Check outputs
        AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
        AffirmIfEqual(or_res , expected_or , "OR   : Expected = "&to_string(expected_or)&",");

        a <= '1';
        b <= '1';
        expected_and    := a and b;
        expected_or     := a or b;
        -- Wait for signals to propagate
        wait for 1 ns;
        -- Check outputs
        AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
        AffirmIfEqual(or_res , expected_or , "OR   : Expected = "&to_string(expected_or)&",");

        WaitForBarrier(TestDone);
        wait ;
    end process MainProc; 
end SimpleTest;

configuration example_tb_SimpleTest of example_tb is
    for TestHarness
        for TestCtrl_inst : TestCtrl
            use entity work.TestCtrl(SimpleTest);
        end for;
    end for;
end example_tb_SimpleTest;
