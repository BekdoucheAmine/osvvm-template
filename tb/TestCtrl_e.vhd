library ieee;
    use ieee.std_logic_1164.all;


-- Import OSVVM packages
library osvvm; 
    context osvvm.OsvvmContext;


-- Test Entity Declaration
entity TestCtrl is
    port(
        a       : out std_ulogic;
        b       : out std_ulogic;
        and_res : in std_ulogic;
        or_res  : in std_ulogic
    );
end TestCtrl;