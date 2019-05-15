----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Baldasseroni Eva
-- 
-- Create Date: 06.04.2018 16:34:08
-- Design Name: 
-- Module Name: project_reti_logiche - Progetto
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package define is
    constant address_0 : std_logic_vector(15 downto 0);
    constant address_1 : std_logic_vector(15 downto 0);
    constant address_2 : std_logic_vector(15 downto 0);
    constant num_0 : std_logic_vector(7 downto 0);
    constant num_1 : std_logic_vector(7 downto 0);
    constant num_255 : std_logic_vector(7 downto 0);
 end package;
 
 package body define is
    constant address_0 : std_logic_vector(15 downto 0) := "0000000000000000";
    constant address_1 : std_logic_vector(15 downto 0) := "0000000000000001";
    constant address_2 : std_logic_vector(15 downto 0) := "0000000000000010";
    constant num_0 : std_logic_vector(7 downto 0) := "00000000";
    constant num_1 : std_logic_vector(7 downto 0) := "00000001";
    constant num_255 : std_logic_vector(7 downto 0) := "11111111";
 end package body define;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.define.all;

entity project_reti_logiche is 
port (
   i_clk : in std_logic;
   i_start : in std_logic; 
   i_rst : in std_logic;
   i_data : in std_logic_vector(7 downto 0);
   o_address : out std_logic_vector(15 downto 0); 
   o_done : out std_logic; 
   o_en  : out std_logic; 
   o_we : out std_logic;
   o_data : out std_logic_vector (7 downto 0)
); 
end project_reti_logiche;


architecture Progetto of project_reti_logiche is

component leggi_e_salva is
port(
    dato_in : in std_logic_vector(7 downto 0);
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_finito : in std_logic;
    zero : out std_logic;
    soglia : out std_logic_vector(7 downto 0);
    n_righe : out std_logic_vector(7 downto 0);
    n_colonne : out std_logic_vector(7 downto 0);
    x : out std_logic_vector(7 downto 0);
    lettura : out std_logic;
    o_en  : out std_logic;
    o_address : out std_logic_vector(15 downto 0)); 
end component;

component posizione_attuale is
port(
   n_colonne : in std_logic_vector(7 downto 0);
   n_righe : in std_logic_vector(7 downto 0);
   i_clk : in std_logic;
   i_rst : in std_logic;
   lettura : in std_logic;
   carica : in std_logic;
   zero : in std_logic;
   n_colonna_x : out std_logic_vector(7 downto 0);
   n_riga_x : out std_logic_vector(7 downto 0);
   finito : out std_logic);
end component;

component analisi_x is
port(
    i_clk : in std_logic;
    i_rst : in std_logic;
    x : in std_logic_vector(7 downto 0);
    n_colonna_x : in std_logic_vector(7 downto 0);
    n_riga_x : in std_logic_vector(7 downto 0);
    soglia : in std_logic_vector(7 downto 0);
    lettura : in std_logic;
    finito : in std_logic;
    n_col_iniz : out std_logic_vector(7 downto 0);
    n_col_fin : out std_logic_vector(7 downto 0);
    n_rig_iniz : out std_logic_vector(7 downto 0);
    n_rig_fin : out std_logic_vector(7 downto 0));
end component;

component calcolo_risultato is
port(
    n_col_iniz : in std_logic_vector(7 downto 0);
    n_col_fin : in std_logic_vector(7 downto 0);
    n_rig_iniz : in std_logic_vector(7 downto 0);
    n_rig_fin : in std_logic_vector(7 downto 0);
    i_clk : in std_logic;
    i_rst : in std_logic;
    finito : in std_logic;
    zero : in std_logic;
    carica : out std_logic;
    res : out std_logic_vector(15 downto 0));
end component;

component caricamento_risultato is
port(
    i_clk : in std_logic;
    i_rst : in std_logic;
    carica : in std_logic;
    res : in std_logic_vector(15 downto 0);
    o_address : out std_logic_vector(15 downto 0); 
    o_done : out std_logic; 
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0));
end component;
    

signal soglia : std_logic_vector(7 downto 0);
signal n_righe : std_logic_vector(7 downto 0);
signal n_colonne : std_logic_vector(7 downto 0);

signal n_riga_x : std_logic_vector(7 downto 0);
signal n_colonna_x : std_logic_vector(7 downto 0);
signal x : std_logic_vector(7 downto 0);

signal n_col_iniz : std_logic_vector(7 downto 0);
signal n_col_fin : std_logic_vector(7 downto 0);
signal n_rig_iniz : std_logic_vector(7 downto 0);
signal n_rig_fin : std_logic_vector(7 downto 0);

signal o_address_lettura : std_logic_vector(15 downto 0);
signal o_address_res : std_logic_vector(15 downto 0);

signal lettura : std_logic;
signal finito : std_logic;
signal carica : std_logic;
signal zero : std_logic;

signal res : std_logic_vector(15 downto 0);


begin

o_address <= o_address_lettura when (carica = '0') else o_address_res;

LEGGI: leggi_e_salva
port map(
    dato_in => i_data,
    i_start => i_start,
    i_clk => i_clk,
    i_rst => i_rst,
    i_finito => finito,
    zero => zero,
    soglia => soglia,
    n_righe => n_righe,
    n_colonne => n_colonne,
    x => x,
    lettura => lettura,
    o_en => o_en,
    o_address => o_address_lettura 
);

POSIZIONE: posizione_attuale
port map(
   n_colonne => n_colonne,
   n_righe => n_righe,
   i_clk => i_clk,
   carica => carica,
   i_rst => i_rst,
   lettura => lettura,
   zero => zero,
   n_colonna_x => n_colonna_x,
   n_riga_x => n_riga_x,
   finito => finito 
);

ANALIZZA_INPUT:  analisi_x
port map(
    i_clk => i_clk,
    i_rst => i_rst,
    x => x,
    n_colonna_x => n_colonna_x,
    n_riga_x => n_riga_x,
    soglia => soglia,
    lettura => lettura,
    finito => finito,
    n_col_iniz => n_col_iniz,
    n_col_fin => n_col_fin,
    n_rig_iniz => n_rig_iniz,
    n_rig_fin => n_rig_fin
    );
    
CALCOLO_RIS: calcolo_risultato
port map(
    n_col_iniz => n_col_iniz,
    n_col_fin => n_col_fin,
    n_rig_iniz => n_rig_iniz,
    n_rig_fin => n_rig_fin,
    i_clk => i_clk,
    i_rst => i_rst,
    zero => zero,
    finito => finito,
    carica => carica,
    res => res
);

CARICA_RIS: caricamento_risultato
port map(
    i_clk => i_clk,
    i_rst => i_rst,
    carica => carica,
    res => res,
    o_address => o_address_res,
    o_done => o_done,
    o_we => o_we,
    o_data => o_data
);

end Progetto;

-------------------------------------------------------
------------------LEGGI_E_SALVA------------------------
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.define.all;

entity leggi_e_salva is
port(
    dato_in : in std_logic_vector(7 downto 0);
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_finito : in std_logic;
    zero : out std_logic;
    soglia : out std_logic_vector(7 downto 0);
    n_righe : out std_logic_vector(7 downto 0);
    n_colonne : out std_logic_vector(7 downto 0);
    x : out std_logic_vector(7 downto 0);
    lettura : out std_logic;
    o_en  : out std_logic;
    o_address : out std_logic_vector(15 downto 0)
);
end leggi_e_salva;

architecture Behavioral of leggi_e_salva is

signal stato : std_logic_vector(2 downto 0);
signal address_next : std_logic_vector(15 downto 0);

begin

o_address <= address_next;

process(i_clk)
begin
if i_clk'event and i_clk = '0' then

    --RESET
    if i_rst = '1' then
        stato <="000";
        address_next <= address_2;
        lettura <= '0';
        zero <= '0';
        o_en <= '0';
        soglia <= num_1;
        n_righe <= num_1;
        n_colonne <= num_1;
        x <= num_0;

    --START
    elsif i_start = '1' then
        if stato = "000" then
            stato <= "001";
            o_en <= '1';
        end if;
   
   -- !FINITO
   elsif i_finito = '0' then
        --salvo N_COLONNE
        if stato = "001" then
            n_colonne <= dato_in;
            address_next <= address_next + 1;
            if dato_in = num_0 then
                stato <= "111";
            else
                stato <= "010";
            end if;
        --salvo N_RIGHE
        elsif stato = "010" then
            n_righe <= dato_in;
            address_next <= address_next + 1;
            if dato_in = num_0 then
                stato <= "111";
             else
                stato <= "011";
             end if;
        --salvo SOGLIA
        elsif stato = "011" then   
            soglia <= dato_in;
            address_next <= address_next + 1;
            stato <= "100";
        --salvo i dati su X a ogni giro di clock
        elsif stato = "100" then
            lettura <= '1';
            x <= dato_in;
            address_next <= address_next + 1;
        elsif stato = "111" then
            zero <= '1';
        end if;
    end if;

end if;

end process i_clk;

end Behavioral;


-------------------------------------------------------
------------------POSIZIONE_ATTUALE--------------------
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.define.all;

entity posizione_attuale is
port(
    i_clk : in std_logic;
    i_rst : in std_logic;
    lettura : in std_logic;
    carica : in std_logic;
    zero : in std_logic;
    n_righe : in std_logic_vector(7 downto 0);
    n_colonne : in std_logic_vector(7 downto 0);
    n_colonna_x : out std_logic_vector(7 downto 0);
    n_riga_x : out std_logic_vector(7 downto 0);
    finito : out std_logic
);
end posizione_attuale;

architecture Behavioral of posizione_attuale is

signal n_colonna_prec : std_logic_vector(7 downto 0);
signal n_riga_prec : std_logic_vector(7 downto 0);

begin

n_colonna_x <= n_colonna_prec;
n_riga_x <= n_riga_prec;

process(i_clk)
begin
if i_clk'event and i_clk = '0' then

    --RESET
    if i_rst = '1' then
        n_colonna_prec <= num_1;
        n_riga_prec <= num_1;
        finito <= '0';

    --LETTURA & !ZERO
    elsif lettura = '1' and zero = '0' then
        if n_colonna_prec < n_colonne then
            n_colonna_prec <= n_colonna_prec + 1;
        else
            if n_riga_prec < n_righe then
                n_riga_prec <= n_riga_prec + 1;
                n_colonna_prec <= num_1;
            else
                finito <= '1';
            end if;
        end if;
     elsif zero = '1' then
        finito <= '1';
    end if;
    
    --CARICA
    if carica = '1' then
        finito <= '0';
    end if;

end if;

end process i_clk;

end Behavioral;


-------------------------------------------------------
---------------------ANALISI_X-------------------------
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.define.all;

entity analisi_x is
port(
    i_clk : in std_logic;
    i_rst : in std_logic;
    x : in std_logic_vector(7 downto 0);
    n_colonna_x : in std_logic_vector(7 downto 0);
    n_riga_x : in std_logic_vector(7 downto 0);
    soglia : in std_logic_vector(7 downto 0);
    lettura : in std_logic;
    finito : in std_logic;
    n_col_iniz : out std_logic_vector(7 downto 0);
    n_col_fin : out std_logic_vector(7 downto 0);
    n_rig_iniz : out std_logic_vector(7 downto 0);
    n_rig_fin : out std_logic_vector(7 downto 0)
);
end analisi_x;

architecture Behavioral of analisi_x is

signal n_col_iniz_prec : std_logic_vector(7 downto 0);
signal n_col_fin_prec : std_logic_vector(7 downto 0);
signal n_rig_iniz_prec : std_logic_vector(7 downto 0);
signal n_rig_fin_prec : std_logic_vector(7 downto 0);
signal trovato : std_logic;

begin

n_col_iniz <= n_col_iniz_prec;
n_col_fin <= n_col_fin_prec;
n_rig_iniz <= n_rig_iniz_prec;
n_rig_fin <= n_rig_fin_prec;

process(i_clk)
begin
if i_clk'event and i_clk = '0' then

    --RESET
    if i_rst = '1' then
        n_col_iniz_prec <= num_0;
        n_col_fin_prec <= num_0;
        n_rig_iniz_prec <= num_0;
        n_rig_fin_prec <= num_0;
        trovato <= '0';

    --LETTURA && !FINITO
    elsif lettura = '1' and finito = '0' then
        if x >= soglia then
            --Se non avevo ancora trovato x>=soglia prima, lo imposto come punto iniziale dell'area...
            if trovato = '0' then
                n_col_iniz_prec <= n_colonna_x;
                n_rig_iniz_prec <= n_riga_x;
                n_col_fin_prec <= n_colonna_x;
                n_rig_fin_prec <= n_riga_x;
                trovato <= '1';
            --...poi allargo l'area a dovere
            else
                if n_colonna_x < n_col_iniz_prec then
                    n_col_iniz_prec <= n_colonna_x;
                end if;
                if n_colonna_x > n_col_fin_prec then
                    n_col_fin_prec <= n_colonna_x;
                end if;
                if n_riga_x > n_rig_fin_prec then
                    n_rig_fin_prec <= n_riga_x;
                end if;
                --Non considero il caso n_riga_x < n_riga_iniz_prec perchè per come ci
                --sono forniti i dati, questa espressione non sarà mai vera
            end if;        
        end if;
    end if;

end if;

end process i_clk;

end Behavioral;



-------------------------------------------------------
----------------CALCOLO_RISULTATO----------------------
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.define.all;

entity calcolo_risultato is
port(
    n_col_iniz : in std_logic_vector(7 downto 0);
    n_col_fin : in std_logic_vector(7 downto 0);
    n_rig_iniz : in std_logic_vector(7 downto 0);
    n_rig_fin : in std_logic_vector(7 downto 0);
    i_rst : in std_logic;
    i_clk : in std_logic;
    finito : in std_logic;
    zero : in std_logic;
    carica : out std_logic;
    res : out std_logic_vector(15 downto 0)
);
end calcolo_risultato;

architecture Behavioral of calcolo_risultato is

signal lato_col : std_logic_vector(7 downto 0);
signal lato_rig : std_logic_vector(7 downto 0);

begin


process(i_clk)
begin
if i_clk'event and i_clk = '0' then

    --RESET
    if i_rst = '1' then
        lato_col <= num_0;
        lato_rig <= num_0;
        res <= address_0;
        carica <= '0';

    --FINITO
    elsif finito = '1' then
        if n_col_iniz /= num_0 then
            lato_col <= n_col_fin - n_col_iniz + num_1;
            lato_rig <= n_rig_fin - n_rig_iniz + num_1;
            res <= lato_col * lato_rig;
        end if;
        carica <= '1';
    --ZERO
    elsif zero = '1' then
        carica <= '1';
    end if;

end if;

end process i_clk;

end Behavioral;


-------------------------------------------------------
-----------------CARICA_RISULTATO----------------------
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.define.all;

entity caricamento_risultato is
port(
    i_clk : in std_logic;
    i_rst : in std_logic;
    carica : in std_logic;
    res : in std_logic_vector(15 downto 0);
    o_address : out std_logic_vector(15 downto 0); 
    o_done : out std_logic; 
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0)
);
end caricamento_risultato;

architecture Behavioral of caricamento_risultato is

signal higher : std_logic_vector(15 downto 8);
signal lower : std_logic_vector(7 downto 0);
signal stato : std_logic_vector(2 downto 0);

begin


process(i_clk)
begin

higher <= res(15 downto 8);
lower <= res(7 downto 0);

if i_clk'event and i_clk = '0' then

    --RESET
    if i_rst = '1' then
        o_we <= '0';
        o_done <= '0';
        o_data <= num_0;
        stato <= "000";
        o_address <= address_0;

    --CARICA
    elsif  carica = '1' then
        --aspetta elaborazione RES
        if stato = "000" then
            o_address <= address_0;
            stato <= "001";
        --carica LOWER
        elsif stato = "001" then
            o_we <= '1';
            o_data <= lower;
            stato <= "010";
        elsif stato = "010" then
            stato <= "011";
        --carica HIGHER
        elsif stato = "011" then
            o_address <= address_1;
            o_data <= higher;
            stato <= "100";
        elsif stato = "100" then
            stato <= "101";
        --segnala DONE
        elsif stato = "101" then
            o_done <= '1';
            stato <= "110";
        --abbassa DONE
        elsif stato = "110" then
        o_done <= '0';
        end if;
    end if;

end if;

end process i_clk;

end Behavioral;