library ieee;
    use ieee.std_logic_1164.all;

entity example_tb is
end entity;

architecture TestHarness of example_tb is
    -- Test Controle Component Declaration
    component TestCtrl is
        port(
            a       : out std_ulogic;
            b       : out std_ulogic;
            and_res : in std_ulogic;
            or_res  : in std_ulogic
        );
    end component;
    -- DUT Component Declaration
    component example is
        port(
            a : in std_ulogic;
            b : in std_ulogic;
            and_res : out std_ulogic;
            or_res  : out std_ulogic
        );
    end component;
    -- link signals
    signal a        : std_ulogic;
    signal b        : std_ulogic;
    signal and_res  : std_ulogic;
    signal or_res   : std_ulogic;
begin
    TestCtrl_inst : TestCtrl
        port map(
            a       => a,
            b       => b,
            and_res => and_res,
            or_res  => or_res
        );
    example_inst : example
        port map(
            a       => a,
            b       => b,
            and_res => and_res,
            or_res  => or_res
        );
end TestHarness;
