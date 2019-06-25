----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2019 15:54:48
-- Design Name: 
-- Module Name: CLZ - 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Allows to count the number of zeros until the first one and starts at the MSB
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity CLZ is	
    Generic (
		n : integer :=16
	);
    Port ( 
		x : in 	std_logic_vector ((n-2) downto 0);
		zer : out STD_LOGIC_VECTOR (4 downto 0)
         );
end CLZ;

architecture Count_Leading_Zeros of CLZ is

-- **********************************************
-- *************Signals************* 
signal count : integer range 0 to 64; 
signal zeros : std_logic_vector((n-2) downto 0); 

type Etat is (st0,st1);
signal State : Etat;

-- **********************************************
	
begin

process(x,count)
begin

	count <= 0;
	zeros <= (others => '0');
	
	Case State is 
	When st0 => 
		--Count zeros 
		If x(n-2-count) = '0' AND n-2-count > 0 Then 
			Count <= Count + 1;
		--Detecting first '1'
		Elsif (x(n-2-count) = '1' OR n-2-count < 0) Then 
			zer <= std_logic_vector(to_unsigned(count,5));	
			State <= st1;
		End If;
	When st1 =>
		Count <= 0;
		State <= st0;
	End Case;
	
end process;

end Count_Leading_Zeros;
