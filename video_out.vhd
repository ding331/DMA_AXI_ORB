LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY vga_controller IS
	GENERIC(
	    h_pixels	:	INTEGER := 800;		--horiztonal display width in pixels
	    h_fp	 	:	INTEGER := 56;		--horiztonal front porch width in pixels
		h_pulse 	:	INTEGER := 120;    	--horiztonal sync pulse width in pixels
		h_bp	 	:	INTEGER := 64;		--horiztonal back porch width in pixels		
        h_pol	    :	STD_LOGIC := '1';		--horizontal sync pulse polarity (1 = positive, 0 = negative)
		v_pixels	:	INTEGER := 600;		--vertical display width in rows
		v_fp	 	:	INTEGER := 37;			--vertical front porch width in rows
		v_pulse 	:	INTEGER := 6;			--vertical sync pulse width in rows
		v_bp	 	:	INTEGER := 23;			--vertical back porch width in rows	
		v_pol	    :	STD_LOGIC := '1');	--vertical sync pulse polarity (1 = positive, 0 = negative)
	PORT(
        clock	:	IN	STD_LOGIC;	--pixel clock at frequency of VGA mode being used
		rst		    :	IN	STD_LOGIC;	--active low asycnchronous reset
		h_sync		:	OUT	STD_LOGIC;	--horiztonal sync pulse
		v_sync		:	OUT	STD_LOGIC;	--vertical sync pulse        
        display     :   OUT STD_LOGIC
        -- col           :   OUT INTEGER;
        -- row           :   OUT INTEGER
		);  
END vga_controller;

ARCHITECTURE behavior OF vga_controller IS            
	CONSTANT	h_period	:	INTEGER := h_pixels + h_fp + h_pulse + h_bp ;  --total number of pixel clocks in a row
	CONSTANT	v_period	:	INTEGER := v_pixels + v_fp + v_pulse + v_bp ;  --total number of rows in column
    signal h_count	:	INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
    signal v_count	:	INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)

    signal clk_cnt :std_logic_vector(2 downto 0);
	signal pixel_clk :std_logic;
BEGIN

	clk_divide: process(clock)
	begin	
		if(rst = '1') then
			clk_cnt <= "001";
		else if (clock'event and clock = '1') then
			clk_cnt <= clk_cnt + 1;
		end if;
	end process;
	pixel_clk <= clk_cnt(0);

	PROCESS(pixel_clk, rst)BEGIN
		IF(rst = '0') THEN	       	--reset asserted
			h_count <= 0;				--reset horizontal counter
			v_count <= 0;				--reset vertical counter
			h_sync <= NOT h_pol;		--deassert horizontal sync
			v_sync <= NOT v_pol;		--deassert vertical sync
            display<='0';
            -- col<=0; row<=0;		
		ELSIF(pixel_clk='1' and pixel_clk'event) THEN		
			--counters
			IF(h_count < h_period - 1) THEN		--horizontal counter (pixels)
				h_count <= h_count + 1;
			ELSE
				h_count <= 0;
			end if;
			IF(v_count < v_period - 1) THEN	--veritcal counter (rows)
				v_count <= v_count + 1;
			ELSE
				v_count <= 0;
			END IF;
		END IF;

			--horizontal sync signal
			IF(h_count < h_pixels + h_fp OR h_count >= h_pixels + h_fp + h_pulse) THEN
				h_sync <= NOT h_pol;		--deassert horiztonal sync pulse     (H_POL=0)
			ELSE
				h_sync <= h_pol;			--assert horiztonal sync pulse
			END IF;
			
			--vertical sync signal
			IF(v_count < v_pixels + v_fp OR v_count >= v_pixels + v_fp + v_pulse) THEN
				v_sync <= NOT v_pol;		--deassert vertical sync pulse    (V_POL=1)
			ELSE
				v_sync <= v_pol;			--assert vertical sync pulse
			END IF;
			
			--set display enable output
			IF(h_count < h_pixels AND v_count < v_pixels) THEN  	--display time
				if (( (h_count+200)**2 + (v_count+200)**2 ) <= 100) then
			    -- col<=h_count;
			    -- row<=v_count;
                display<='1';
				end if;
			ELSE													--blanking time
                display<='0';
			END IF;
			
	END PROCESS;
	
END behavior;
