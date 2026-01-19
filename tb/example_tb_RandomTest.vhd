architecture randomtest of testctrl is

  signal testdone : integer_barrier;
  signal testinit : integer_barrier;

begin

  controlproc : process is
  begin

    -- Initialize Barriers
    testdone <= 1;
    testinit <= 1;

    -- Initialization of test
    SetTestName("example_tb_RandomTest");
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

    variable arv          : randomptype;
    variable brv          : randomptype;
    variable acounts      : integer_vector(0 to 1);
    variable bcounts      : integer_vector(0 to 1);
    variable expected_or  : std_logic;
    variable expected_and : std_logic;

  begin

    aRV.InitSeed(arv'instance_name);
    bRV.InitSeed(brv'instance_name);

    acounts :=
    (
      0 => 10,
      1 => 10
    );

    bcounts :=
    (
      0 => 10,
      1 => 10
    );

    -- Wait for test to init
    WaitForBarrier(testinit, 50 ms);

    simulationloop : loop

      -- Generate random inputs
      if (aRV.DistInt(acounts) = 0) then
        a <= '0';
        -- Updates counter
        acounts(0) := aCounts(0) - 1;
      else
        a <= '1';
        -- Updates counter
        acounts(1) := aCounts(1) - 1;
      end if;

      if (bRV.DistInt(bcounts) = 0) then
        b <= '0';
        -- Updates counter
        bcounts(0) := bCounts(0) - 1;
      else
        a <= '1';
        -- Updates counter
        bcounts(1) := bCounts(1) - 1;
      end if;

      -- wait for signals to propagate
      wait for 1 ns;
      -- Update expected values
      expected_and := a and b;
      expected_or  := a or b;
      -- Check outputs
      AffirmIfEqual(and_res, expected_and, "AND  : Expected = "&to_string(expected_and)&",");
      AffirmIfEqual(or_res, expected_or, "OR   : Expected = "&to_string(expected_or)&",");

      -- Exit loop if condition is met
      exit when acounts = (0, 0) and bcounts = (0, 0);

    end loop simulationloop;

    WaitForBarrier(testdone);
    wait;

  end process mainproc;

end architecture randomtest;

configuration example_tb_RandomTest of example_tb is
    for TestHarness
        for TestCtrl_inst : TestCtrl
            use entity work.TestCtrl(RandomTest);
        end for;
    end for;
end example_tb_RandomTest;
