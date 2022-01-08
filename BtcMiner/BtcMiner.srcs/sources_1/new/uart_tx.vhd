library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

Entity UART_TX is
Port(
       clk: in std_logic;
	   rst: in std_logic;
	   tx_basla : in std_logic;
	   tx_data : in std_logic_vector(7 downto 0);
	   out_tx : out std_logic;
	   out_tx_bitis : out std_logic
	);
end UART_TX;

architecture behavioral of UART_TX is

      -- Clk_Bit = Clk_Frekans(70 MHz) / BaudRate(115200) + 1;
   constant Clk_Bit : integer := 869; --608;
   
     type t_UART_tx is (Bosta,Basla,Gonder,Bitir,Tamam);
	 
	 signal s_UART_tx : t_UART_tx := Bosta;
	 signal clk_sayac : integer range 0 to Clk_Bit-1 := 0;
	 signal data_ind : integer range 0 to 7 := 0;
	 signal s_data : std_logic_vector(7 downto 0) := (others => '0');
	 signal s_tx : std_logic := '1';
	 signal s_tx_tamam : std_logic := '0';
	 
begin
   out_tx <= s_tx;
   out_tx_bitis <= s_tx_tamam;
   
     process(clk,rst)
	   begin
	     if rst = '1' then
		   s_UART_tx <= Bosta;
		   clk_sayac <= 0;
		   data_ind <= 0 ;
		   s_data <= (others => '0');
		   s_tx <= '1';
		   s_tx_tamam <= '0';
		   
		 elsif rising_edge(clk) then
               s_tx_tamam <= '0';
			   
       case s_UART_tx is
          when Bosta =>
			s_tx <= '1' ;
            clk_sayac <= 0;
           	data_ind <= 0;
               if tx_basla = '1' then
                s_data <= tx_data;			   
                s_UART_tx <= Basla;
		       end if;
				
          when Basla =>
		     s_tx <= '0';
		 if clk_sayac = Clk_Bit - 1 then
			  clk_sayac <= 0 ;
			  s_UART_tx <= Gonder;
   	     else
			  clk_sayac <= clk_sayac + 1 ;
		 end if;
 		  
		  When Gonder =>
		   s_tx <= s_data(data_ind);
		     if clk_sayac = Clk_Bit - 1 then
			   clk_sayac <= 0; 
			     if data_ind = 7 then
				   data_ind <= 0 ;
				   s_UART_tx <= Bitir;
				 else
				   data_ind <= data_ind + 1 ;
				 end if;
			else
		     	clk_sayac <= clk_sayac + 1 ;
			end if;
		 
		  When Bitir =>
		      s_tx <= '1';
			 if clk_sayac = Clk_Bit-1 then
			   clk_sayac <= 0 ;
			   s_UART_tx <= Tamam;
			 else
			    clk_sayac <= clk_sayac + 1 ;
			end if;
			
		When Tamam =>
		  s_tx <= '1' ;
          s_tx_tamam <= '1';
          s_UART_tx <= Bosta;
    
        When others => NULL ;
      end case;
    end if;
   end process;
end Behavioral; 