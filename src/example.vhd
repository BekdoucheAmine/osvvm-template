library ieee;
  use ieee.std_logic_1164.all;

entity example is
  port (
    a       : in    std_ulogic;
    b       : in    std_ulogic;
    and_res : out   std_ulogic;
    or_res  : out   std_ulogic
  );
end entity example;

architecture arch of example is

begin

  and_res <= a and b;
  or_res  <= a or b;

end architecture arch;
