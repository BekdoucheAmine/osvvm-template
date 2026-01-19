architecture simpletest of testctrl is

  signal testdone : integer_barrier;
  signal testinit : integer_barrier;

begin

  controlproc : process is
  begin

    -- Initialize Barriers
    testdone <= 1;
    testinit <= 1;

    -- Initialization of test
    SetTestName("example_tb_SimpleTest");
    SetLogEnable(PASSED, TRUE);

    -- Wait for testbench initialization
    wait for 0 ns; wait for 0 ns;

    TranscriptOpen;
    SetTranscriptMirror(TRUE);

    WaitForBarrier(testinit);
    -- Clear Alerts
    ClearAlerts;

    -- Wait for test to finish
    WaitForBarrier(testdone, 50 ms);

    TranscriptClose;

    EndOfTestReports(timeout => (now >= 50 ms));
    std.env.stop;
    wait;

  end process controlproc;

  mainproc : process is

    variable expected_or  : std_logic;
    variable expected_and : std_logic;

  begin

    -- Wait for test to init
    WaitForBarrier(testinit, 50 ms);

    a <= '0';
    b <= '0';
    -- Wait for signals to propagate
    wait for 1 ns;
    -- Update expected values
    expected_and := a and b;
    expected_or  := a or b;
    -- Check outputs
    AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
    AffirmIfEqual(or_res, expected_or, "OR   : Expected = "&to_string(expected_or)&",");

    a <= '0';
    b <= '1';
    -- Wait for signals to propagate
    wait for 1 ns;
    -- Update expected values
    expected_and := a and b;
    expected_or  := a or b;
    -- Check outputs
    AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
    AffirmIfEqual(or_res, expected_or, "OR   : Expected = "&to_string(expected_or)&",");

    a <= '1';
    b <= '0';
    -- Wait for signals to propagate
    wait for 1 ns;
    -- Update expected values
    expected_and := a and b;
    expected_or  := a or b;
    -- Check outputs
    AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
    AffirmIfEqual(or_res, expected_or, "OR   : Expected = "&to_string(expected_or)&",");

    a <= '1';
    b <= '1';
    -- Wait for signals to propagate
    wait for 1 ns;
    -- Update expected values
    expected_and := a and b;
    expected_or  := a or b;
    -- Check outputs
    AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
    AffirmIfEqual(or_res, expected_or, "OR   : Expected = "&to_string(expected_or)&",");

    WaitForBarrier(testdone);
    wait;

  end process mainproc;

end architecture simpletest;

configuration example_tb_simpletest of example_tb is
    for testharness
        for testctrl_inst : testctrl
            use entity work.testctrl(simpletest);
        end for;
    end for;
end example_tb_simpletest;
