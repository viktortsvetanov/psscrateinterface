#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "io.h"
#include <unistd.h>
#include "system.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include <io.h>

#define ONCHIP_MEMORY2_0_BASE 0x10004000

int main()
{

	printf("Commands:\n Y \t Enable \n N \t Disable \n");
	// Input buffer:
	char * buffer;
	char prompt;

	int bytes_read;
	int size_read = 16;
	char *string;


	while (1){

	// display prompt:
	printf("\n Enter Command: \n");

	string = (char *) malloc (size_read);
	bytes_read = getline (&string, &size_read, stdin);

	if (bytes_read == -1)

	{

	puts ("ERROR!");

	}

	else

	{

	puts ("You entered the following string: ");

	puts (string);

		if (string == 'ReadRelays(1)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004000, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004000, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(2)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004020, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004020, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(3)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004040, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004040, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(4)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004060, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004060, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(5)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004080, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004080, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(6)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004100, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004100, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(7)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004120, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004120, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(8)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004140, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004140, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(9)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004160, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004160, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(10)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004180, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004180, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(11)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004200, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004200, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(12)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004220, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004220, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(13)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004240, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004240, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(14)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004260, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004260, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(16)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004280, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004280, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(17)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004300, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004300, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(18)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004320, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004320, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(19)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004340, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004340, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(20)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004360, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004360, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(21)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004380, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004380, 12)); //prints port 1 relays
		}
		else if (string == 'ReadRelays(22)')
		{
			printf("\n Relays:");
			printf("%X",IORD_32DIRECT(0x10004400, 4)); //prints port 0 relays
			printf("%X",IORD_32DIRECT(0x10004400, 12)); //prints port 1 relays
		}
		else if (string == 'Write(1,0)')
		{
			IOWR_32DIRECT(0x1004010,0,0b01011110); // sets Module 1 Port 2
			IOWR_8DIRECT(0x10004010,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 1 turned off");
		}
		else if (string == 'Write(1,3)')
		{
			IOWR_32DIRECT(0x1004010,0,0b01011110); // sets Module 1 Port 2
			IOWR_8DIRECT(0x10004010,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 1 turned on");
		}
		else if (string == 'Write(2,0)')
		{
			IOWR_32DIRECT(0x1004030,0,0b01011101); // sets Module 2 Port 2
			IOWR_8DIRECT(0x10004030,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 2 turned off");
		}
		else if (string == 'Write(2,3)')
		{
			IOWR_32DIRECT(0x1004030,0,0b01011101); // sets Module 2 Port 2
			IOWR_8DIRECT(0x10004030,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 2 turned on");
		}
		else if (string == 'Write(3,0)')
		{
			IOWR_32DIRECT(0x1004050,0,0b01011100); // sets Module 3 Port 2
			IOWR_8DIRECT(0x10004050,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 3 turned off");
		}
		else if (string == 'Write(3,3)')
		{
			IOWR_32DIRECT(0x1004050,0,0b01011100); // sets Module 3 Port 2
			IOWR_8DIRECT(0x10004050,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 3 turned on");
		}
		else if (string == 'Write(4,0)')
		{
			IOWR_32DIRECT(0x1004070,0,0b01011011); // sets Module 4 Port 2
			IOWR_8DIRECT(0x10004070,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 4 turned off");
		}
		else if (string == 'Write(4,3)')
		{
			IOWR_32DIRECT(0x1004070,0,0b01011011); // sets Module 4 Port 2
			IOWR_8DIRECT(0x10004070,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 4 turned on");
		}
		else if (string == 'Write(5,0)')
		{
			IOWR_32DIRECT(0x1004090,0,0b01011010); // sets Module 5 Port 2
			IOWR_8DIRECT(0x10004090,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 5 turned off");
		}
		else if (string == 'Write(5,3)')
		{
			IOWR_32DIRECT(0x1004090,0,0b01011010); // sets Module 5 Port 2
			IOWR_8DIRECT(0x10004090,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 5 turned on");
		}
		else if (string == 'Write(6,0)')
		{
			IOWR_32DIRECT(0x1004110,0,0b01011001); // sets Module 6 Port 2
			IOWR_8DIRECT(0x10004110,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 6 turned off");
		}
		else if (string == 'Write(6,3)')
		{
			IOWR_32DIRECT(0x1004110,0,0b01011001); // sets Module 6 Port 2
			IOWR_8DIRECT(0x10004110,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 6 turned on");
		}
		else if (string == 'Write(7,0)')
		{
			IOWR_32DIRECT(0x1004130,0,0b01011000); // sets Module 7 Port 2
			IOWR_8DIRECT(0x10004130,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 7 turned off");
		}
		else if (string == 'Write(7,3)')
		{
			IOWR_32DIRECT(0x1004130,0,0b01011000); // sets Module 7 Port 2
			IOWR_8DIRECT(0x10004130,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 7 turned on");
		}
		else if (string == 'Write(8,0)')
		{
			IOWR_32DIRECT(0x1004150,0,0b01010111); // sets Module 8 Port 2
			IOWR_8DIRECT(0x10004150,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 8 turned off");
		}
		else if (string == 'Write(8,3)')
		{
			IOWR_32DIRECT(0x1004150,0,0b01010111); // sets Module 8 Port 2
			IOWR_8DIRECT(0x10004150,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 8 turned on");
		}
		else if (string == 'Write(9,0)')
		{
			IOWR_32DIRECT(0x1004170,0,0b01010110); // sets Module 9 Port 2
			IOWR_8DIRECT(0x10004170,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 9 turned off");
		}
		else if (string == 'Write(9,3)')
		{
			IOWR_32DIRECT(0x1004170,0,0b01010110); // sets Module 9 Port 2
			IOWR_8DIRECT(0x10004170,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 9 turned on");
		}
		else if (string == 'Write(10,0)')
		{
			IOWR_32DIRECT(0x1004190,0,0b01010101); // sets Module 10 Port 2
			IOWR_8DIRECT(0x10004190,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 10 turned off");
		}
		else if (string == 'Write(10,3)')
		{
			IOWR_32DIRECT(0x1004190,0,0b01010101); // sets Module 10 Port 2
			IOWR_8DIRECT(0x10004190,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 10 turned on");
		}
		else if (string == 'Write(11,0)')
		{
			IOWR_32DIRECT(0x1004210,0,0b01010100); // sets Module 11 Port 2
			IOWR_8DIRECT(0x10004210,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 11 turned off");
		}
		else if (string == 'Write(11,3)')
		{
			IOWR_32DIRECT(0x1004210,0,0b01010100); // sets Module 11 Port 2
			IOWR_8DIRECT(0x10004210,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 11 turned on");
		}
		else if (string == 'Write(12,0)')
		{
			IOWR_32DIRECT(0x1004230,0,0b01010011); // sets Module 12 Port 2
			IOWR_8DIRECT(0x10004230,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 12 turned off");
		}
		else if (string == 'Write(12,3)')
		{
			IOWR_32DIRECT(0x1004230,0,0b01010011); // sets Module 12 Port 2
			IOWR_8DIRECT(0x10004230,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 12 turned on");
		}
		else if (string == 'Write(13,0)')
		{
			IOWR_32DIRECT(0x1004250,0,0b01010010); // sets Module 13 Port 2
			IOWR_8DIRECT(0x10004250,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 13 turned off");
		}
		else if (string == 'Write(13,3)')
		{
			IOWR_32DIRECT(0x1004250,0,0b01010010); // sets Module 13 Port 2
			IOWR_8DIRECT(0x10004250,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 13 turned on");
		}
		else if (string == 'Write(14,0)')
		{
			IOWR_32DIRECT(0x1004270,0,0b01010001); // sets Module 14 Port 2
			IOWR_8DIRECT(0x10004270,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 14 turned off");
		}
		else if (string == 'Write(14,3)')
		{
			IOWR_32DIRECT(0x1004270,0,0b01010001); // sets Module 14 Port 2
			IOWR_8DIRECT(0x10004270,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 14 turned on");
		}
		else if (string == 'Write(15,0)')
		{
			IOWR_32DIRECT(0x1004290,0,0b01010000); // sets Module 15 Port 2
			IOWR_8DIRECT(0x10004290,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 15 turned off");
		}
		else if (string == 'Write(15,3)')
		{
			IOWR_32DIRECT(0x1004290,0,0b01010000); // sets Module 15 Port 2
			IOWR_8DIRECT(0x10004290,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 15 turned on");
		}
		else if (string == 'Write(16,0)')
		{
			IOWR_32DIRECT(0x1004310,0,0b01001111); // sets Module 16 Port 2
			IOWR_8DIRECT(0x10004310,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 16 turned off");
		}
		else if (string == 'Write(16,3)')
		{
			IOWR_32DIRECT(0x1004310,0,0b01001111); // sets Module 16 Port 2
			IOWR_8DIRECT(0x10004310,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 16 turned on");
		}
		else if (string == 'Write(17,0)')
		{
			IOWR_32DIRECT(0x1004330,0,0b01001110); // sets Module 17 Port 2
			IOWR_8DIRECT(0x10004330,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 17 turned off");
		}
		else if (string == 'Write(17,3)')
		{
			IOWR_32DIRECT(0x1004330,0,0b01001110); // sets Module 17 Port 2
			IOWR_8DIRECT(0x10004330,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 17 turned on");
		}
		else if (string == 'Write(18,0)')
		{
			IOWR_32DIRECT(0x1004350,0,0b01001101); // sets Module 18 Port 2
			IOWR_8DIRECT(0x10004350,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 18 turned off");
		}
		else if (string == 'Write(18,3)')
		{
			IOWR_32DIRECT(0x1004350,0,0b01001101); // sets Module 18 Port 2
			IOWR_8DIRECT(0x10004350,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 18 turned on");
		}
		else if (string == 'Write(19,0)')
		{
			IOWR_32DIRECT(0x1004370,0,0b01001100); // sets Module 19 Port 2
			IOWR_8DIRECT(0x10004370,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 19 turned off");
		}
		else if (string == 'Write(19,3)')
		{
			IOWR_32DIRECT(0x1004370,0,0b01001100); // sets Module 19 Port 2
			IOWR_8DIRECT(0x10004370,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 19 turned on");
		}
		else if (string == 'Write(20,0)')
		{
			IOWR_32DIRECT(0x1004390,0,0b01001011); // sets Module 20 Port 2
			IOWR_8DIRECT(0x10004390,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 20 turned off");
		}
		else if (string == 'Write(20,3)')
		{
			IOWR_32DIRECT(0x1004390,0,0b01001011); // sets Module 20 Port 2
			IOWR_8DIRECT(0x10004390,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 20 turned on");
		}
		else if (string == 'Write(21,0)')
		{
			IOWR_32DIRECT(0x1004410,0,0b01001010); // sets Module 21 Port 2
			IOWR_8DIRECT(0x10004410,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 21 turned off");
		}
		else if (string == 'Write(21,3)')
		{
			IOWR_32DIRECT(0x1004410,0,0b01001010); // sets Module 21 Port 2
			IOWR_8DIRECT(0x10004410,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 21 turned on");
		}
		else if (string == 'Write(22,0)')
		{
			IOWR_32DIRECT(0x1004430,0,0b01001001); // sets Module 22 Port 2
			IOWR_8DIRECT(0x10004430,5,0x0); // writes 0 to upper 4 bits of Port 2
			printf("\n Module 22 turned off");
		}
		else if (string == 'Write(22,3)')
		{
			IOWR_32DIRECT(0x1004430,0,0b01001001); // sets Module 22 Port 2
			IOWR_8DIRECT(0x10004430,5,0x3); // writes 11 to upper 4 bits of Port 2
			printf("\n Module 22 turned on");
		}
		else
		{
			printf("\n Command not supported. Please try again.");
		}
	}
	}

	return 0; //never reach here.
}
