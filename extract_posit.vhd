	----------------------------------------------------------------------------------
-- Engineer: BARBILLON Emilien
-- 
-- Create Date: 24.05.2019 15:54:48
-- Design Name: 
-- Module Name: extract_Posit
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 

--  Posit extraction of Sign bit, regime bits, exponent bits and fraction bits 
--
-- Based on "Deep Positron: A Deep Neural Network Using the Posit Number System" - 
--			Zachariah Carmichaelx, Hamed F. Langroudix, Char Khazanovx, Jeffrey Lilliex,
--			John L. Gustafson, Dhireesha Kudithipudix
--			Neuromorphic AI Lab, Rochester Institute of Technology, NY, USA
--			National University of Singapore, Singapore

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
use std.textio.all;

entity extract_posit is

    GENERIC ( 
				n : integer := 8;
				es : integer := 1
    );
    Port ( 
			in_p : in STD_LOGIC_VECTOR ((n-1) downto 0);
			sign : out STD_LOGIC;
			exp : out STD_LOGIC_VECTOR ((es-1) downto 0);
			reg : out STD_LOGIC_VECTOR (4 downto 0);
			fract : out STD_LOGIC_VECTOR ((n-es-3) downto 0);
			zero : out std_logic;
			NaR : out std_logic
         );
end extract_posit;


architecture arch of extract_posit is

-- **********************************************
-- *************Signals************* 
signal tows : std_logic_vector ((n-2) downto 0);
signal inv : std_logic_vector ((n-2) downto 0);
signal zc : std_logic_vector(4 downto 0) ;
signal zc_shifting : std_logic_vector(4 downto 0) ;
signal tmp : std_logic_vector ((n-1) downto 0);
signal tmp_reg_shift : std_logic_vector((n-1) downto 0);
signal shift_exp :  std_logic_vector(4 downto 0) ;
signal tmp_exp: STD_LOGIC_VECTOR((es-1) downto 0);
signal z : std_logic_vector(n-1 downto 0);



-- *************Components*************
--CountLeadingZeros
Component CLZ is 
	generic (
				n : integer
	);
	Port ( 
			x : in std_logic_vector (n-2 downto 0);
			zer : out STD_LOGIC_VECTOR (4 downto 0)
         );
End Component;

--Shifter
Component barrelShifterLR is 
	GENERIC ( 
				N : integer ;
				LOG_N : integer
    );
	Port ( 
			x: in std_logic_vector((n-1) downto 0);
			lr: in std_logic;--1=left,0=right
			shiftAm: in std_logic_vector(4 downto 0);
			shX: out std_logic_vector((n-1) downto 0)
         );
End Component;

-- **********************************************

begin

-- Check if the posit is 0 or Not a Real 
z <= (others => '0');
zero <= '1' when in_p(n-1 downto 0) = z(n-1 downto 0) else
			'0';
		
NaR <= '1' when in_p = ('1' & z(n-2 downto 0)) else
			'0';

--Sign bit extraction 
sign <= in_p(n-1);

-- If the sign bit is '1' => 2's complement of (n-1) remainig bits 
tows <= in_p(n - 2 downto 0) when in_p(n-1) = '0' else
		std_logic_vector(	unsigned(NOT(in_p(n-2 downto 0))) + 1 ) when in_p(n-1) = '1';
		
--If regime is sequence of '1', invertion of tows => allows to use juste one module for count leading and find the value of regime bits
inv <= tows when tows(n-2) = '0' else 
			NOT(tows)when tows(n-2) = '1';

--Count Leading Zeros ==> Retrune number of zeros 
CountLeadingZeros : CLZ  generic map(n)
				port map (inv, zc);

--Shift regime bits 
tmp_reg_shift <= "000" & tows(n-4 downto 0);

zc_shifting <= std_logic_vector(	unsigned(zc)	-1) ;

ShiftRegime : barrelShifterLR generic map(n,5)
				port map (x => tmp_reg_shift ,lr => '1',shiftAm => zc_shifting , shX => tmp );

--Exponent extraction 		
tmp_exp <=  (others =>'0') when (es = 0) else
			tmp(n-4 downto (n-es-3));


--Shift exponent if the coded posit use an exponent size < es		
shift_exp <= std_logic_vector(es - (n-	(unsigned(zc)	+2)))  when  n-(unsigned(zc)+2)< es else 
				(others => '0');
		
ShiftExp : barrelShifterLR generic map(es,5)
			port map (x => tmp_exp ,lr => '0',shiftAm => shift_exp , shX => exp );
		
--Compute value of regime 
-- if sequence of 0 regime = - (nbr of zeros) 
-- if sequence of 1 regime = (nbr of zeros) -1 
reg <= std_logic_vector(0-signed(zc)) when tows(n-2) = '0' else 
			std_logic_vector(signed(zc)-1) when tows(n-2) = '1';

--Fraction extraction
-- Add the hidden bit '1'as MSB
fract <= '1' &  tmp( (n-es-4) downto 0);

end arch;
