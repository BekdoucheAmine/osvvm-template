architecture RandomTest of TestCtrl is
    signal TestDone         : integer_barrier := 1;
    signal TestInit         : integer_barrier := 1;
begin
    ControlProc : process
    begin
        -- Initialization of test
        SetTestName("example_tb_RandomTest");
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
        variable aRV            : RandomPType;
        variable bRV            : RandomPType;
        variable aCounts        : integer_vector(0 to 1);
        variable bCounts        : integer_vector(0 to 1);
        variable expected_or    : std_logic;
        variable expected_and   : std_logic;
    begin
        aRV.InitSeed(aRV'instance_name);
        bRV.InitSeed(bRV'instance_name);

        aCounts     := (0 => 10,
                        1 => 10);

        bCounts     := (0 => 10,
                        1 => 10);

        -- Wait for test to init
        WaitForBarrier(TestInit, 50 ms);

        SimulationLoop : loop
            -- Generate random inputs
            if aRV.DistInt(aCounts) = 0 then
                a <= '0';
                -- Updates counter
                aCounts(0) := aCounts(0)-1;
            else
                a <= '1';
                -- Updates counter
                aCounts(1) := aCounts(1)-1;
            end if;

            if bRV.DistInt(bCounts) = 0 then
                b <= '0';
                -- Updates counter
                bCounts(0) := bCounts(0)-1;
            else
                a <= '1';
                -- Updates counter
                bCounts(1) := bCounts(1)-1;
            end if;

            expected_and    := a and b;
            expected_or     := a or b;

            -- wait for signals to propagate
            wait for 1 ns;

            -- Check outputs
            AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
            AffirmIfEqual(or_res , expected_or , "OR   : Expected = "&to_string(expected_or)&",");


            -- Exit loop if condition is met
            exit when aCounts = (0, 0) and bCounts = (0, 0);
        end loop SimulationLoop ;
        
        WaitForBarrier(TestDone);
        wait;
    end process MainProc; 
end RandomTest;

configuration example_tb_RandomTest of example_tb is
    for TestHarness
        for TestCtrl_inst : TestCtrl
            use entity work.TestCtrl(RandomTest);
        end for;
    end for;
end example_tb_RandomTest;
